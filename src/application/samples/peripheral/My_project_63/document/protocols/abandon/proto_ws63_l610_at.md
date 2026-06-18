# 协议文档 3：WS63 → ESP32 → 广和通 L610 (AT 透传)

> 物理层：UART 串口
> 传输层：AT 指令（3GPP TS 27.007）
> 应用层：4G 上云 / 短信 / HTTP

## 1. 连接拓扑

```
┌──────────┐  UART JSON  ┌──────────┐  UART AT  ┌──────────┐
│  WS63    │────────────►│  ESP32   │──────────►│  L610    │
│  主控     │  透传指令    │  中转     │  AT 指令   │  4G模块   │
└──────────┘             └──────────┘           └──────────┘
```

- WS63 是业务主控，决定何时发 AT 指令
- ESP32 是透传中转，不解析 AT 内容，直接转发
- L610 是 4G 通信模块，执行 AT 指令

## 2. 透传方案

### 2.1 WS63 → ESP32 (JSON 透传指令)

WS63 通过 UART 发送特殊格式的 JSON 命令，ESP32 识别后透传给 L610。

```json
{"cmd":"at_passthrough","seq":1,"data":{"at":"AT+CIPSTART=\"TCP\",\"broker.emqx.io\",1883"}}
```

ESP32 收到 `cmd=at_passthrough` 后：
1. 提取 `data.at` 字符串
2. 直接通过 UART2 发送给 L610
3. 不解析 AT 内容

### 2.2 ESP32 → WS63 (AT 响应透传)

ESP32 收到 L610 的 AT 响应后，包装为 JSON 回传给 WS63。

```json
{"cmd":"at_response","seq":1,"code":0,"data":{"raw":"OK\r\n"}}
```

或错误响应：

```json
{"cmd":"at_response","seq":1,"code":-1,"data":{"raw":"ERROR\r\n"}}
```

### 2.3 ESP32 → WS63 (URC 主动上报)

L610 的 URC（Unsolicited Result Code）由 ESP32 主动转发给 WS63。

```json
{"cmd":"at_urc","seq":0,"data":{"raw":"+CIPRXGET: 1,5\r\n"}}
```

## 3. ESP32 透传实现要求

ESP32 端需要实现以下逻辑：

### 3.1 串口分配

| UART | 连接对象 | 波特率 | 用途 |
|------|----------|--------|------|
| UART0 | USB 调试 | 115200 | 日志输出 |
| UART1 | WS63 | 115200 | JSON 命令交互 |
| UART2 | L610 | 115200 | AT 指令收发 |

### 3.2 透传逻辑

```
UART1 收到 JSON → 解析 cmd 字段
  ├─ cmd == "at_passthrough" → 提取 data.at → 通过 UART2 发送给 L610
  └─ cmd == 其他 → 处理触摸屏业务（已有逻辑）

UART2 收到数据 → 包装为 JSON → 通过 UART1 发送给 WS63
  ├─ 以 "OK" 或 "ERROR" 开头 → {"cmd":"at_response","seq":0,"code":0/−1,"data":{"raw":"..."}}
  └─ 以 "+" 开头 → {"cmd":"at_urc","seq":0,"data":{"raw":"..."}}
```

## 4. 常用 AT 指令参考

### 4.1 网络注册

```
AT+CEREG?                    // 查询网络注册状态
+CEREG: 0,1                  // 已注册本地网络

AT+CSQ                       // 查询信号质量
+CSQ: 20,99                  // RSSI=20, BER=99
```

### 4.2 TCP 连接

```
AT+CIPSTART="TCP","broker.emqx.io",1883
CONNECT OK                   // 连接成功

AT+CIPSEND=5                 // 发送 5 字节
>                            // 等待输入
hello                        // 发送数据
SEND OK

AT+CIPCLOSE                  // 关闭连接
CLOSE OK
```

### 4.3 HTTP 请求

```
AT+HTTPACTION=0              // GET 请求
+HTTPACTION: 0,200,1234      // 状态码 200, 数据长度 1234

AT+HTTPREAD                  // 读取响应数据
```

## 5. WS63 端集成方案

### 5.1 命令发送路径

```
WS63 business_logic
  → 构造 AT 指令字符串
  → 封装为 JSON: {"cmd":"at_passthrough","seq":N,"data":{"at":"AT+..."}}
  → uart_vision_send_json() 发送
```

### 5.2 响应接收路径

```
WS63 uart_vision
  → 收到 JSON: {"cmd":"at_response",...}
  → 分发给 business_logic
  → 解析 data.raw，判断 OK/ERROR
```

### 5.3 超时机制

- AT 指令发送后等待响应超时：10 秒
- 超时后重试一次
- 连续 3 次超时标记 L610 为离线

## 6. 注意事项

- L610 的 AT 指令以 `\r\n` 结尾
- L610 的响应以 `\r\n` 结尾
- URC 可能在任何时候出现，ESP32 需要异步转发
- AT 指令和响应之间可能有延迟，WS63 端需要异步等待
- 透传数据量大时注意 UART 缓冲区溢出
