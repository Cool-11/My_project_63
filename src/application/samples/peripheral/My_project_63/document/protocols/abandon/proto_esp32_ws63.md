# 协议文档 2：ESP32 ↔ WS63 (UART JSON)

> 物理层：UART 串口
> 传输层：JSON 文本行
> 应用层：命令/响应协议

## 1. 连接拓扑

```
┌──────────┐   UART (115200)   ┌──────────┐
│  ESP32   │◄─────────────────►│  WS63    │
│ 触摸屏UI  │   TX/RX 交叉连接   │  网关     │
└──────────┘                   └──────────┘
```

接线：
- ESP32 TX → WS63 RX (GPIO16)
- ESP32 RX → WS63 TX (GPIO15)
- 共地

## 2. 串口参数

| 参数 | 值 |
|------|-----|
| 波特率 | 115200 |
| 数据位 | 8 |
| 停止位 | 1 |
| 校验位 | 无 |
| 流控 | 无 |

## 3. JSON 协议格式

### 3.1 请求 (ESP32 → WS63)

```json
{"cmd":"<命令名>","seq":<序列号>,"data":{...}}\n
```

- `cmd`：命令名称（字符串）
- `seq`：序列号（整数，用于匹配请求和响应）
- `data`：命令参数（JSON 对象，可为空 `{}`）
- 以 `\n` 结尾

### 3.2 响应 (WS63 → ESP32)

```json
{"cmd":"<命令名>","seq":<序列号>,"code":<状态码>,"msg":"<消息>","data":{...}}\r\n
```

- `code`：0=成功，负数=失败
- `msg`：人类可读的状态消息
- `data`：响应数据（可为 null）
- 以 `\r\n` 结尾

## 4. 命令清单

### 4.1 仓库业务命令

#### inbound（入库）

将 BS21E 标签绑定到仓库系统。

```
请求: {"cmd":"inbound","seq":1,"data":{"zone":"A1","item":"Type-C"}}
成功: {"cmd":"inbound","seq":1,"code":0,"msg":"ok","data":{"tag_id":5}}
失败: {"cmd":"inbound","seq":1,"code":-1,"msg":"sle not ready","data":null}
```

流程：分配 tag_id → 发送 BIND_TAG(0x20) → 等待 BS21E 回复 0xA0/0xAF → 超时 5 秒回滚

#### inventory（盘点）

请求所有已连接标签上报当前数据。

```
请求: {"cmd":"inventory","seq":2,"data":{}}
成功: {"cmd":"inventory","seq":2,"code":0,"msg":"ok","data":{"count":3,"tags":[{"tag_id":1,"zone":"A1","item":"Type-C","qty":50,"status":2,"battery":95},...]}}
```

流程：发送 INVENTORY(0x02) → 等待 0x82 回复 → 更新映射表 → 回复全量数据

#### find（寻物）

按 tag_id 或 item 名称查找标签位置，并触发蜂鸣器。

```
请求: {"cmd":"find","seq":3,"data":{"tag_id":1}}
成功: {"cmd":"find","seq":3,"code":0,"msg":"ok","data":{"tag_id":1,"zone":"A1","item":"Type-C"}}

请求: {"cmd":"find","seq":4,"data":{"item":"螺丝"}}
成功: {"cmd":"find","seq":4,"code":0,"msg":"ok","data":{"tag_id":2,"zone":"B3","item":"螺丝"}}
```

#### outbound（出库）

从仓库系统移除标签。

```
请求: {"cmd":"outbound","seq":5,"data":{"tag_id":1}}
成功: {"cmd":"outbound","seq":5,"code":0,"msg":"ok","data":{"tag_id":1}}
```

#### list（列表）

查询所有已入库标签。

```
请求: {"cmd":"list","seq":6,"data":{}}
成功: {"cmd":"list","seq":6,"code":0,"msg":"ok","data":{"count":3,"tags":[...]}}
```

#### update_qty（更新数量）

更新指定标签的库存数量。

```
请求: {"cmd":"update_qty","seq":7,"data":{"tag_id":1,"qty":100}}
成功: {"cmd":"update_qty","seq":7,"code":0,"msg":"ok","data":{"tag_id":1,"qty":100}}
```

### 4.2 WiFi 命令

#### wifi_connect

```
请求: {"cmd":"wifi_connect","seq":10,"data":{"ssid":"MyWiFi","psk":"password123"}}
成功: {"cmd":"wifi_connect","seq":10,"code":0,"msg":"connecting","data":null}
```

#### wifi_status

```
请求: {"cmd":"wifi_status","seq":11,"data":{}}
成功: {"cmd":"wifi_status","seq":11,"code":0,"msg":"ok","data":{"wifi_state":5}}
```

wifi_state 值：0=IDLE, 1=SCANNING, 2=SCAN_DONE, 3=CONNECTING, 4=CONNECTED, 5=GOT_IP, 6=DISCONNECTED

### 4.3 MQTT 命令

#### mqtt_connect

```
请求: {"cmd":"mqtt_connect","seq":20,"data":{"uri":"tcp://broker.emqx.io:1883","client_id":"ws63_001","username":"user","password":"pass"}}
成功: {"cmd":"mqtt_connect","seq":20,"code":0,"msg":"ok","data":null}
```

#### mqtt_disconnect

```
请求: {"cmd":"mqtt_disconnect","seq":21,"data":{}}
成功: {"cmd":"mqtt_disconnect","seq":21,"code":0,"msg":"ok","data":null}
```

#### mqtt_status

```
请求: {"cmd":"mqtt_status","seq":22,"data":{}}
成功: {"cmd":"mqtt_status","seq":22,"code":0,"msg":"ok","data":{"mqtt_state":2,"cache_count":0}}
```

mqtt_state 值：0=IDLE, 1=CONNECTING, 2=CONNECTED, 3=DISCONNECTED, 4=FAILED

#### mqtt_publish

```
请求: {"cmd":"mqtt_publish","seq":23,"data":{"topic":"ws63/test","payload":{"temp":25,"humi":60}}}
成功: {"cmd":"mqtt_publish","seq":23,"code":0,"msg":"ok","data":null}
```

## 5. 错误码

| code | 含义 |
|------|------|
| 0 | 成功 |
| -1 | SLE 未就绪 / 通用失败 |
| -2 | JSON 解析失败 |
| -3 | 标签未找到 / 映射表满 |
| -4 | SLE 发送失败 |
| -5 | 绑定失败 / 超时 |
| -10 | Pending 超时 |
| -99 | 未知命令 |

## 6. 注意事项

- WS63 环形缓冲区 512 字节，单行最大 256 字节
- 超过 100ms 未收到换行符的不完整数据会被丢弃
- ESP32 发送时必须以 `\n` 结尾
- WS63 响应以 `\r\n` 结尾
