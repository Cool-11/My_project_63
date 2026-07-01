# 星觅智物 — WS63 网关 MQTT 命令协议文档（Web 端下发）

> 版本：v1.0  
> 日期：2026-07-01  
> 作者：嵌入式端  
> 状态：待确认

---

## 一、概述

本文档定义了 **Web 前端** 通过 MQTT 向 **WS63 网关** 下发控制命令的协议格式。

- **命令下发主题**：`v1/gateway/rpc/{requestId}`
- **响应上报主题**：`v1/gateway/telemetry`（与设备状态上报共用）
- **消息队列**：WS63 内部有 8 条消息缓冲区，事件驱动处理，不丢消息
- **QoS**：建议 QoS 1（至少一次投递）

---

## 二、请求格式（Web 端 → WS63）

### 2.1 通用结构

```json
{
  "id": "req-20260701-001",
  "method": "find",
  "params": {
    "tag_id": 1
  }
}
```

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `id` | String | 是 | 请求唯一标识，用于关联响应。建议格式：`req-日期-序号` |
| `method` | String | 是 | 命令类型，见下方命令表 |
| `params` | Object | 否 | 命令参数，不同 method 参数不同 |

### 2.2 支持的命令列表

| method | 功能 | params 必填字段 | 说明 |
|--------|------|----------------|------|
| `find` | 寻物 | `tag_id` | 连接标签 → 蜂鸣 5 秒 |
| `inventory` | 盘点 | 无 | 查询当前连接标签的库存 |
| `alert` | 非法操作警告 | `tag_id`, `level` | 触发声光报警 |
| `restock` | 低库存提醒 | `tag_id`, `threshold`, `current_qty` | 补货阈值通知 |

---

## 三、响应格式（WS63 → Web 端）

### 3.1 通用结构

主题：`v1/gateway/telemetry`

```json
{
  "type": "ack",
  "id": "req-20260701-001",
  "code": 0,
  "msg": "find initiated, connecting to tag",
  "data": null
}
```

| 字段 | 类型 | 说明 |
|------|------|------|
| `type` | String | 固定为 `"ack"`，区分于设备状态上报 |
| `id` | String | 与请求的 `id` 一一对应 |
| `code` | Integer | 状态码：0=成功，负数=失败 |
| `msg` | String | 人类可读描述 |
| `data` | Object/null | 可选，返回数据 |

### 3.2 状态码定义

| code | 含义 |
|------|------|
| `0` | 成功 |
| `-1` | 参数缺失或格式错误 |
| `-2` | 参数值无效 |
| `-3` | 标签未注册/不存在 |
| `-4` | 设备忙（有其他 pending 操作） |
| `-5` | SLE 连接失败 |
| `-99` | 未知 method |

---

## 四、各命令详细说明

### 4.1 find — 寻物

**请求：**
```json
{
  "id": "req-20260701-001",
  "method": "find",
  "params": {
    "tag_id": 1
  }
}
```

**执行流程：**
1. 检查 tag_id 是否在注册表中
2. 发起 SLE 连接（异步）
3. SSAP 就绪后发送 FIND 命令
4. BS21E 标签蜂鸣 5 秒

**成功响应：**
```json
{
  "type": "ack",
  "id": "req-20260701-001",
  "code": 0,
  "msg": "find initiated, connecting to tag"
}
```

**失败响应（标签不存在）：**
```json
{
  "type": "ack",
  "id": "req-20260701-001",
  "code": -3,
  "msg": "tag not registered"
}
```

**失败响应（设备忙）：**
```json
{
  "type": "ack",
  "id": "req-20260701-001",
  "code": -4,
  "msg": "busy, pending operation active"
}
```

---

### 4.2 inventory — 盘点

**请求：**
```json
{
  "id": "req-20260701-002",
  "method": "inventory",
  "params": {}
}
```

**执行流程：**
1. 检查 SLE 是否已连接
2. 发送 SSAP_CMD_INVENTORY 查询
3. 等待标签响应（异步）

**成功响应：**
```json
{
  "type": "ack",
  "id": "req-20260701-002",
  "code": 0,
  "msg": "inventory started"
}
```

**失败响应（未连接）：**
```json
{
  "type": "ack",
  "id": "req-20260701-002",
  "code": -1,
  "msg": "sle not connected"
}
```

**注意：** 盘点结果会通过正常的设备状态上报通道返回，格式为：
```json
{
  "tag_001": [
    {
      "tag_id": 1,
      "zone": "A1",
      "item": "Type-C Cable",
      "qty": 48,
      "status": 2,
      "battery": 85
    }
  ]
}
```

---

### 4.3 alert — 非法操作警告

**请求：**
```json
{
  "id": "req-20260701-003",
  "method": "alert",
  "params": {
    "tag_id": 1,
    "level": "high"
  }
}
```

| params 字段 | 类型 | 必填 | 说明 |
|-------------|------|------|------|
| `tag_id` | Integer | 否 | 目标标签 ID，不填则全局警告 |
| `level` | String | 否 | 警告级别：`"low"`, `"normal"`, `"high"`，默认 `"normal"` |

**执行流程：**
1. 如果指定了 tag_id，连接该标签并触发蜂鸣
2. 通知串口屏显示警告信息

**成功响应：**
```json
{
  "type": "ack",
  "id": "req-20260701-003",
  "code": 0,
  "msg": "alert triggered"
}
```

---

### 4.4 restock — 低库存阈值提醒

**请求：**
```json
{
  "id": "req-20260701-004",
  "method": "restock",
  "params": {
    "tag_id": 1,
    "threshold": 10,
    "current_qty": 5
  }
}
```

| params 字段 | 类型 | 必填 | 说明 |
|-------------|------|------|------|
| `tag_id` | Integer | 是 | 目标标签 ID |
| `threshold` | Integer | 否 | 补货阈值（默认 10） |
| `current_qty` | Integer | 否 | 当前数量（同步更新本地） |

**执行流程：**
1. 检查 tag_id 是否在注册表中
2. 如果传了 current_qty，同步更新本地 biz_map
3. 通知串口屏显示补货提醒

**成功响应：**
```json
{
  "type": "ack",
  "id": "req-20260701-004",
  "code": 0,
  "msg": "restock alert received",
  "data": {
    "tag_id": 1,
    "item": "Type-C Cable",
    "zone": "A1",
    "qty": 5,
    "threshold": 10
  }
}
```

---

## 五、设备状态上报（定时/事件触发）

除了命令响应外，WS63 会定期上报设备状态到 `v1/gateway/telemetry`，格式不变：

```json
{
  "tag_001": [
    {
      "tag_id": 1,
      "zone": "A1",
      "item": "Type-C Cable",
      "qty": 48,
      "status": 2,
      "battery": 85
    }
  ]
}
```

**如何区分上报和响应：**
- 响应（ACK）包含 `"type": "ack"` 字段
- 状态上报没有 `type` 字段，key 是 `tag_XXX` 格式

---

## 六、完整交互时序

### 6.1 寻物流程

```
Web 前端                        EMQX Cloud                    WS63 网关                 BS21E 标签
   │                               │                            │                        │
   │ publish v1/gateway/rpc/xxx    │                            │                        │
   │ {"id":"req-001","method":"find","params":{"tag_id":1}}     │                        │
   │ ─────────────────────────────>│                            │                        │
   │                               │ deliver                    │                        │
   │                               │ ──────────────────────────>│                        │
   │                               │                            │                        │
   │                               │                    入队 → 事件标志 → 出队解析       │
   │                               │                    → 查 biz_map                    │
   │                               │                    → sle_network_connect_by_tag(1)  │
   │                               │                    → SLE CONNECT ─────────────────>│
   │                               │                    → SSAP DISCOVER                 │
   │                               │                    → SSAP FIND ──────────────────>│
   │                               │                            │                   蜂鸣 5 秒
   │                               │                            │                        │
   │                               │ publish v1/gateway/telemetry│                        │
   │                               │ {"type":"ack","id":"req-001","code":0,"msg":"find initiated"}
   │ <─────────────────────────────│<───────────────────────────│                        │
   │                               │                            │                        │
   │  Web 端显示"寻物已触发"        │                            │                        │
```

### 6.2 盘点流程

```
Web 前端                        EMQX Cloud                    WS63 网关                 BS21E 标签
   │                               │                            │                        │
   │ publish v1/gateway/rpc/xxx    │                            │                        │
   │ {"id":"req-002","method":"inventory","params":{}}          │                        │
   │ ─────────────────────────────>│ ──────────────────────────>│                        │
   │                               │                    → SSAP INVENTORY ─────────────>│
   │                               │                            │                        │
   │                               │ publish v1/gateway/telemetry│                        │
   │                               │ {"type":"ack","id":"req-002","code":0,"msg":"inventory started"}
   │ <─────────────────────────────│<───────────────────────────│                        │
   │                               │                            │                        │
   │                               │ publish v1/gateway/telemetry│                        │
   │                               │ {"tag_001":[{"tag_id":1,"qty":48,"status":2,...}]}  │
   │ <─────────────────────────────│<───────────────────────────│<───────────────────────│
   │                               │                            │                        │
   │  Web 端更新库存数据            │                            │                        │
```

---

## 七、注意事项

1. **`id` 必填** — Web 端每次请求必须带唯一 `id`，否则无法关联响应
2. **`method` 大小写敏感** — 必须是小写：`find`, `inventory`, `alert`, `restock`
3. **`tag_id` 是整数** — 不是字符串，不要加引号
4. **ACK 延迟** — `find` 命令的 ACK 是立即返回的（表示"已开始连接"），实际蜂鸣可能有 1-3 秒延迟
5. **并发限制** — WS63 同一时间只能处理一个 pending 操作，如果设备忙会返回 `code: -4`
6. **消息缓冲** — WS63 有 8 条消息队列，超出会丢弃最旧的消息
7. **区分 ACK 和上报** — 响应包含 `"type": "ack"`，状态上报没有此字段

---

## 八、Web 端实现建议

### 8.1 发送命令

```javascript
function sendCommand(method, params) {
  const id = `req-${Date.now()}-${Math.random().toString(36).substr(2, 5)}`;
  const payload = {
    id: id,
    method: method,
    params: params
  };
  mqttClient.publish('v1/gateway/rpc/' + id, JSON.stringify(payload));
  return id;  // 用于匹配响应
}
```

### 8.2 接收响应

```javascript
mqttClient.subscribe('v1/gateway/telemetry');

mqttClient.on('message', (topic, message) => {
  const data = JSON.parse(message.toString());

  // 区分 ACK 响应和状态上报
  if (data.type === 'ack') {
    console.log(`[${data.id}] code=${data.code} msg=${data.msg}`);
    // 根据 data.id 关联到对应的请求
  } else {
    // 状态上报：{"tag_001": [...]}
    console.log('设备状态更新:', data);
  }
});
```

### 8.3 使用示例

```javascript
// 寻物
const findId = sendCommand('find', { tag_id: 1 });

// 盘点
const invId = sendCommand('inventory', {});

// 非法操作警告
const alertId = sendCommand('alert', { tag_id: 1, level: 'high' });

// 低库存提醒
const restockId = sendCommand('restock', {
  tag_id: 1,
  threshold: 10,
  current_qty: 5
});
```

---

## 九、待确认事项

请 Web 端同事确认：

- [ ] `id` 的生成规则是否需要统一格式？
- [ ] 是否需要 `get_assets`（获取全量资产列表）命令？
- [ ] `alert` 命令的 `level` 值是否满足需求？是否需要更多级别？
- [ ] 响应是否需要区分"命令已接收"和"命令执行完成"两阶段 ACK？
- [ ] 是否需要超时机制（命令发出后多久没响应算失败）？

---

如有问题随时沟通！
