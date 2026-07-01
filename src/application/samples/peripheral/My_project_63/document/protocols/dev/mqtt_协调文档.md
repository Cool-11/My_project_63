# 星觅智物 MQTT 联调对接文档

---

## 一、MQTT 连接信息

| 配置项 | 值 |
|--------|-----|
| Broker 地址 | `h13f6185.ala.cn-hangzhou.emqxsl.cn` |
| 端口 | `8883`（SSL 加密） |
| 用户名 | `111222qy` |
| 密码 | `huang19771128` |
| Client ID | 需要你定义，但必须和后端不同（后端已自动加 UUID 后缀，不会冲突） |

---

## 二、主题（Topic）约定

### 2.1 设备→后端（你发布，我订阅）

| 主题 | 用途 |
|------|------|
| `v1/gateway/telemetry` | 网关子设备数据上报（ThingsKit 网关模式） |

### 2.2 后端→设备（我发布，你订阅）

| 主题 | 用途 |
|------|------|
| `v1/gateway/rpc/+` | 接收后端下发的命令（寻物、更新数量等） |

> 注意：后端每次下发命令会生成唯一的 requestId，主题格式为 `v1/gateway/rpc/{requestId}`，所以你订阅时必须用通配符 `+`。

---

## 三、上报数据格式（你发给我）

### 3.1 标准上报格式（ThingsKit 网关模式）

主题：`v1/gateway/telemetry`

```json
{
  "tag_001": [
    {
      "tag_id": 1,
      "zone": "A",
      "item": "Type-C Cable",
      "qty": 50,
      "status": 2,
      "battery": 95
    }
  ]
}
```

### 3.2 格式说明

- 顶层 key 是**设备标识**，格式为 `tag_XXX`（`tag_001`、`tag_002`...）
- value 是一个**数组**，可以包含多条资产数据
- 同一条消息可以上报多个设备的数据

### 3.3 字段说明

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `tag_id` | Integer | 是 | 标签短 ID（1-50），WS63 分配 |
| `zone` | String | 否 | 存放区域（"A"、"B"、"C"...） |
| `item` | String | 否 | 物品名称（"Type-C Cable"、"USB Hub"...） |
| `qty` | Integer | 否 | 当前库存数量 |
| `status` | Integer | 否 | 状态码（见下方） |
| `battery` | Integer | 否 | 电量百分比（0-100） |

### 3.4 status 状态码定义

| 值 | 含义 | 说明 |
|----|------|------|
| `0` | 空闲/未配网 | 标签尚未完成配网 |
| `2` | 在线 | 标签正常工作（空闲、寻物中、使用中均上报 2） |
| `3` | 离线 | 超时未扫描到标签 |

> 后端根据 `qty` 值自动推导业务状态：qty>0 为正常，qty=0 为缺货。

### 3.5 上报示例

**单设备正常上报：**
```json
{
  "tag_001": [
    {
      "tag_id": 1,
      "zone": "A",
      "item": "Type-C Cable",
      "qty": 48,
      "status": 2,
      "battery": 85
    }
  ]
}
```

**多设备同时上报：**
```json
{
  "tag_001": [
    {
      "tag_id": 1,
      "zone": "A",
      "item": "Type-C Cable",
      "qty": 45,
      "status": 2,
      "battery": 90
    }
  ],
  "tag_002": [
    {
      "tag_id": 2,
      "zone": "B",
      "item": "USB Hub",
      "qty": 28,
      "status": 2,
      "battery": 75
    }
  ]
}
```

**设备离线：**
```json
{
  "tag_001": [
    {
      "tag_id": 1,
      "status": 3
    }
  ]
}
```

---

## 四、下发命令格式（我发给你）

### 4.1 命令消息结构

主题：`v1/gateway/rpc/{requestId}`

```json
{
  "from": "server",
  "tag_id": 1,
  "method": "find",
  "params": {}
}
```

### 4.2 命令类型

| method | 含义 | params 示例 | 你的动作 |
|--------|------|------------|---------|
| `find` | 寻物 | `{}` | 开启蜂鸣器+LED，15 秒后自动关闭 |
| `update_qty` | 更新数量 | `{"qty": 50}` | 更新本地库存数量 |
| `unbind` | 解绑标签 | `{}` | 清除 tag_id，回到未配网状态 |

### 4.3 你必须解析的字段

- `from`：固定为 `"server"`，表示这是后端下发的命令（用于避免回环）
- `tag_id`：操作的目标标签 ID
- `method`：命令类型
- `params`：命令参数（JSON 对象）

---

## 五、上报频率建议

| 场景 | 建议频率 | 说明 |
|------|---------|------|
| 正常状态 | 每 30 秒一次 | 后端 60 秒无上报会标记为离线 |
| 状态变化时 | 立即上报 | 数量变化、寻物状态变化时 |
| 新设备上线 | 上报 1 次 | status=0 或 2 |
| 电量变化 | 低频率 | 每 5 分钟一次即可 |

---

## 六、联调测试步骤

### 第 1 步：MQTTX 模拟测试

你用 MQTTX 连接 EMQX Cloud，模拟 WS63 上报：

1. 连接 MQTTX（Broker: `mqtts://h13f6185.ala.cn-hangzhou.emqxsl.cn:8883`，用户名/密码同上）
2. 订阅：`v1/gateway/rpc/+`（监听后端命令）
3. 发布到：`v1/gateway/telemetry`，内容为上方的网关模式格式

### 第 2 步：验证后端收到

我查看后端日志确认收到你的消息：

```
[MQTT] received topic=v1/gateway/telemetry payload={"tag_001":[{...}]}
[MQTT] gateway telemetry processed device=tag_001 tag_id=1
```

### 第 3 步：验证命令下发

我调用 API（如寻物），你在 MQTTX 中确认收到：

```
{"from":"server","tag_id":1,"method":"find","params":{}}
```

### 第 4 步：真机联调

双方确认格式匹配后，WS63 网关用真实数据测试。

---

## 七、注意事项

1. **JSON 格式必须严格匹配** — 网关模式的 key 是 `tag_001`，value 必须是数组 `[{...}]`
2. **tag_id 类型是 Integer** — 不是 String，不要加引号
3. **`from` 字段必须在下发命令中** — 后端用它过滤自己发出的命令，避免回环
4. **MQTT 连接使用 SSL** — 端口是 8883 不是 1883，需要开启 SSL/TLS
5. **QoS 建议设为 1** — 至少一次投递，不丢消息
6. **Client ID 不能和后端相同** — 否则会互相踢掉连接
7. **status 上报值只有 0/2/3** — 不要传 1，后端不处理 status=1

---

## 八、常见问题

| 问题 | 可能原因 | 解决方案 |
|------|---------|---------|
| 后端收不到消息 | Topic 不对 | 确认发布主题是 `v1/gateway/telemetry` |
| 后端收到但报错 | JSON 格式不匹配 | 确认 key 是 `tag_XXX`，value 是数组 |
| MQTTX 连接失败 | SSL 未开启 | MQTTX 中勾选 SSL/TLS |
| 收不到后端命令 | 未订阅正确主题 | 确认订阅了 `v1/gateway/rpc/+` |
| 同时在线的设备被踢掉 | Client ID 重复 | 确保每个设备用唯一的 Client ID |
| 后端未创建资产 | tag_id 不匹配 | 确认 tag_id 是整数且未重复 |

---

## 九、待确认事项

请回复以下确认：

- [ ] 你使用的 Client ID 是什么？
- [ ] WS63 发送的 JSON 格式是否与本文档一致？
- [ ] status 字段值是否只上报 0/2/3？
- [ ] 上报频率是多少？
- [ ] 你订阅 `v1/gateway/rpc/+` 后能收到后端下发的消息吗？

---

如有问题随时沟通！
