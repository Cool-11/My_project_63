# 协议文档 4：串口屏 → WS63 → ESP32 (JSON 透传)

> 物理层：UART 串口
> 传输层：JSON 文本行
> 应用层：触摸屏 UI 交互

## 1. 连接拓扑

```
┌──────────┐  UART JSON  ┌──────────┐  UART JSON  ┌──────────┐
│ 串口屏    │────────────►│  WS63    │────────────►│  ESP32   │
│ 触摸屏UI  │  用户操作    │  主控网关  │  透传/处理   │  辅助处理  │
└──────────┘             └──────────┘             └──────────┘
```

**当前架构**：串口屏直接接在 WS63 的 UART1 上（GPIO15/GPIO16）。

- 串口屏是用户交互界面，发送 JSON 命令
- WS63 是主控，处理所有业务逻辑
- ESP32 接收 WS63 的结果，负责显示更新和 4G 透传

## 2. 串口屏 → WS63 (命令输入)

串口屏通过 UART 发送 JSON 命令，WS63 接收并处理。

### 2.1 基本格式

```json
{"cmd":"<命令>","seq":<序号>,"data":{...}}\n
```

### 2.2 支持的命令

| 命令 | 参数 | 说明 |
|------|------|------|
| `inbound` | zone, item | 入库绑定 |
| `inventory` | 无 | 盘点所有标签 |
| `find` | tag_id 或 item | 寻物 |
| `outbound` | tag_id | 出库 |
| `list` | 无 | 查看所有标签 |
| `update_qty` | tag_id, qty | 更新数量 |
| `wifi_connect` | ssid, psk | 连接 WiFi |
| `wifi_status` | 无 | 查询 WiFi 状态 |
| `mqtt_connect` | uri, client_id, username, password | 连接 MQTT |
| `mqtt_disconnect` | 无 | 断开 MQTT |
| `mqtt_status` | 无 | 查询 MQTT 状态 |
| `mqtt_publish` | topic, payload | 发布 MQTT 消息 |

### 2.3 示例

```
// 入库操作
发送: {"cmd":"inbound","seq":1,"data":{"zone":"A1","item":"Type-C连接器"}}
接收: {"cmd":"inbound","seq":1,"code":0,"msg":"ok","data":{"tag_id":5}}

// 盘点操作
发送: {"cmd":"inventory","seq":2,"data":{}}
接收: {"cmd":"inventory","seq":2,"code":0,"msg":"ok","data":{"count":3,"tags":[...]}}
```

## 3. WS63 → ESP32 (结果转发)

WS63 处理完命令后，将结果同时回复给串口屏，并可选择性转发给 ESP32。

### 3.1 转发场景

| 场景 | 是否转发 | 说明 |
|------|----------|------|
| 标签数据变化 | ✅ 转发 | inventory/update_qty 后同步到 ESP32 |
| WiFi/MQTT 状态 | ❌ 不转发 | 仅回复串口屏 |
| 入库/出库 | ✅ 转发 | 标签列表变化 |
| 寻物 | ❌ 不转发 | 仅回复串口屏 |

### 3.2 转发格式

WS63 通过 UART 发送给 ESP32 的数据格式与串口屏相同：

```json
{"cmd":"tag_sync","seq":0,"data":{"action":"inbound","tag_id":5,"zone":"A1","item":"Type-C"}}
```

```json
{"cmd":"tag_sync","seq":0,"data":{"action":"inventory","tags":[...]}}
```

## 4. ESP32 → WS63 (反向命令)

ESP32 也可以通过 UART 发送 JSON 命令给 WS63，格式与串口屏相同。

典型场景：
- ESP32 触摸屏上的按钮操作
- ESP32 定时触发的自动盘点
- ESP32 收到 MQTT 下发命令后转发给 WS63

## 5. 串口屏开发建议

### 5.1 界面布局

```
┌─────────────────────────────┐
│  智能仓储管理系统            │
├─────────────────────────────┤
│  WiFi: [已连接]  MQTT: [在线]│
├─────────────────────────────┤
│  [入库]  [盘点]  [寻物]      │
│  [出库]  [列表]  [设置]      │
├─────────────────────────────┤
│  标签列表:                   │
│  #1 A1 Type-C  50个 95%     │
│  #2 B3 螺丝    200个 80%    │
│  #3 A2 电阻    1000个 90%   │
└─────────────────────────────┘
```

### 5.2 操作流程

**入库**：
1. 用户点击 [入库]
2. 弹出输入框：区域、货物名称
3. 确认后发送 `{"cmd":"inbound","seq":N,"data":{"zone":"A1","item":"Type-C"}}`
4. 等待响应，显示结果

**盘点**：
1. 用户点击 [盘点]
2. 发送 `{"cmd":"inventory","seq":N,"data":{}}`
3. 等待响应，更新标签列表

**寻物**：
1. 用户点击标签列表中的某项
2. 发送 `{"cmd":"find","seq":N,"data":{"tag_id":1}}`
3. 显示标签位置，BS21E 蜂鸣器响

## 6. 注意事项

- 串口屏和 ESP32 共用 WS63 的同一个 UART 接口时，需要协议层区分
- 当前架构下串口屏独占 WS63 的 UART1，ESP32 通过另一个 UART 连接
- JSON 命令必须以 `\n` 结尾
- 响应以 `\r\n` 结尾
- 单条命令最大 256 字节
