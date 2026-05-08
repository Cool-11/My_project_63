# uart_vision 模块文档

## 模块作用

提供 WS63 与外部上位机（串口助手/PC工具）之间的 UART JSON 通信能力。是系统与用户交互的**唯一命令入口和响应出口**。

## 模块说明

### 通信参数

| 参数 | 值 |
|------|----|
| UART总线 | UART1 |
| 波特率 | 115200 |
| TX引脚 | GPIO17 |
| RX引脚 | GPIO18 |
| 数据格式 | 8N1 |

### JSON协议格式

**请求帧（上位机→WS63）**：
```json
{"cmd":"命令名","seq":1,"data":{...}}
```

**响应帧（WS63→上位机）**：
```json
{"cmd":"命令名","seq":1,"code":0,"msg":"ok","data":{...}}
```

| 字段 | 类型 | 说明 |
|------|------|------|
| `cmd` | string | 命令名称 |
| `seq` | number | 序列号，请求响应配对 |
| `data` | object | 命令参数/返回数据 |
| `code` | number | 响应码：0=成功，负数=失败 |
| `msg` | string | 响应描述 |

### 核心API

| 函数 | 功能 |
|------|------|
| `uart_vision_init()` | 初始化UART、注册中断回调 |
| `uart_vision_send_json()` | 发送JSON响应帧到上位机 |
| `uart_vision_register_cmd_handler()` | 注册命令处理回调 |
| `uart_vision_poll()` | 轮询处理接收数据（主循环调用） |

### 内部机制

- **环形缓冲区**：512字节，中断接收→缓冲→poll时解析
- **行缓冲**：以 `\n` 为分隔符，最大行长度256字节
- **JSON解析**：使用cJSON库解析请求帧，提取 `cmd`/`seq`/`data`
- **命令分发**：解析完成后调用注册的 `uv_cmd_handler_t` 回调

### 支持的命令列表

| 命令 | 方向 | 说明 |
|------|------|------|
| `inbound` | 上位机→WS63 | 标签入库 |
| `inventory` | 上位机→WS63 | 触发盘点 |
| `find` | 上位机→WS63 | 查找标签 |
| `outbound` | 上位机→WS63 | 标签出库 |
| `list` | 上位机→WS63 | 列出所有标签 |
| `update_qty` | 上位机→WS63 | 更新数量 |
| `wifi_connect` | 上位机→WS63 | 连接WiFi热点 |
| `wifi_status` | 上位机→WS63 | 查询WiFi状态 |
| `mqtt_connect` | 上位机→WS63 | 连接MQTT服务器 |
| `mqtt_disconnect` | 上位机→WS63 | 断开MQTT |
| `mqtt_status` | 上位机→WS63 | 查询MQTT状态 |
| `mqtt_publish` | 上位机→WS63 | 手动发布MQTT消息 |

## 模块定位

```
┌─────────────┐
│   上位机/串口助手   │  外部：发送JSON命令
├─────────────┤
│  uart_vision   │  外设层：UART收发+JSON解析（本模块）
├─────────────┤
│business_logic  │  业务层：处理命令、返回响应
└─────────────┘
```

- **依赖**：UART驱动、cJSON库
- **被依赖**：`business_logic`（注册命令处理回调）
- **不依赖**：`cloud_storage`、`sle_network`、`shared_protocol`

## 重点约束

1. **中断上下文限制**：UART接收中断中只做环形缓冲区写入，禁止解析JSON或调用业务函数
2. **单行最大长度**：256字节，超长行被丢弃（防止缓冲区溢出）
3. **JSON格式严格**：必须以 `{` 开头、`\n` 结尾，否则无法解析
4. **seq配对**：响应帧的 `seq` 必须与请求帧一致，上位机依赖此字段做请求-响应匹配
5. **非线程安全**：`send_json` 和 `poll` 在同一主循环线程中调用，无需加锁
6. **波特率固定**：115200，修改需同步更新上位机配置

## 日志要求

| 前缀 | 级别 | 场景 |
|------|------|------|
| `[WS63_UART]` | INFO | 收到完整命令行、发送响应 |
| `[WS63_UART]` | ERROR | JSON解析失败、行过长、UART读写异常 |
| `[WS63_UART]` | DEBUG | 原始接收数据 |

## 审查清单

- [ ] 中断回调中是否只有缓冲区写入操作
- [ ] 环形缓冲区满时是否丢弃新数据而非覆盖
- [ ] 行长度超过 `UV_LINE_MAX` 时是否安全丢弃
- [ ] `send_json` 是否处理了cJSON构造失败的情况
- [ ] UART初始化参数是否与硬件引脚配置一致
- [ ] JSON字段名是否与文档一致（`cmd`/`seq`/`data`/`code`/`msg`）

## 验证思路

1. **基础收发**：串口助手发送 `{"cmd":"list","seq":1,"data":{}}\n`，验证收到响应
2. **格式错误**：发送非JSON字符串，验证不崩溃且日志打印解析失败
3. **超长行**：发送超过256字节的行，验证被安全丢弃
4. **连续发送**：快速连续发送10条命令，验证全部正确响应（seq配对）
5. **WiFi配置**：发送 `{"cmd":"wifi_connect","seq":1,"data":{"ssid":"test","psk":"12345678"}}\n`，验证连接
6. **MQTT配置**：发送 `{"cmd":"mqtt_connect","seq":1,"data":{"uri":"mqtt://IP:1883","client_id":"cid","username":"token","password":"pwd"}}\n`，验证连接
