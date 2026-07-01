# MQTT 联调对接确认回复

---

## 一、连接信息确认

| 配置项 | 值 | 状态 |
|--------|-----|------|
| Broker 地址 | `h13f6185.ala.cn-hangzhou.emqxsl.cn` | ✅ 已配置 |
| 端口 | `8883`（SSL） | ✅ 已配置 |
| 用户名 | `111222qy` | ✅ 已配置 |
| 密码 | `huang19771128` | ✅ 已配置 |
| Client ID | `ws63_gateway` | ✅ 已定义 |

---

## 二、待确认事项回复

### Q1: 你使用的 Client ID 是什么？

**A:** `ws63_gateway`

> 说明：每个 WS63 网关设备使用唯一的 Client ID。后续多设备部署时会加后缀区分（如 `ws63_gateway_001`）。

---

### Q2: WS63 发送的 JSON 格式是否与本文档一致？

**A:** ✅ 一致

当前代码实现的格式：
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

- 顶层 key：`tag_XXX` 格式 ✅
- value：数组 `[{...}]` ✅
- 字段名：`tag_id`、`zone`、`item`、`qty`、`status`、`battery` ✅
- `tag_id` 类型：Integer（不加引号）✅

---

### Q3: status 字段值是否只上报 0/2/3？

**A:** ⚠️ 需要确认

当前代码的 status 映射：

| WS63 内部状态 | 上报值 | 含义 |
|--------------|--------|------|
| `BIZ_TAG_IDLE` | 0 | 空闲/未配网 |
| `BIZ_TAG_BOUND` | 2 | 已绑定（在线） |
| `BIZ_TAG_ONLINE` | 2 | 在线 |
| `BIZ_TAG_OFFLINE` | 3 | 离线 |

**确认：不上报 status=1，只上报 0/2/3。** ✅

---

### Q4: 上报频率是多少？

**A:** 事件驱动 + 定时上报

| 场景 | 频率 | 说明 |
|------|------|------|
| 标签状态变化 | 立即上报 | 数量变化、寻物状态变化时立即上报 |
| 正常状态 | 每 30 秒一次 | 心跳上报，保持在线状态 |
| 新设备上线 | 上报 1 次 | status=0 或 2 |
| 电量变化 | 低频率 | 每 5 分钟一次 |

> 说明：当前代码通过 `biz_handle_sle_adv()` 在扫描到标签时立即上报，心跳周期 30 秒。

---

### Q5: 你订阅 `v1/gateway/rpc/+` 后能收到后端下发的消息吗？

**A:** ✅ 已配置订阅

当前代码订阅的主题：
```c
#define CS_THINGSKIT_GATEWAY_RPC_SUB "v1/gateway/rpc/+"
```

支持接收的命令：

| method | 含义 | 处理方式 |
|--------|------|---------|
| `find` | 寻物 | 开启蜂鸣器+LED，15 秒后自动关闭 |
| `update_qty` | 更新数量 | 更新本地库存数量 |
| `unbind` | 解绑标签 | 清除 tag_id，回到未配网状态 |

---

## 三、联调测试步骤

### 第 1 步：WS63 连接 EMQX Cloud

1. WS63 通过串口屏配置 WiFi
2. MQTT 自动连接到 EMQX Cloud
3. 日志确认：`[WS63_CLOUD] mqtt connected uri=ssl://h13f6185.ala.cn-hangzhou.emqxsl.cn:8883`

### 第 2 步：WS63 上报数据

1. BS21E 标签广播 → WS63 扫描
2. 数据同步到 biz_map
3. MQTT 上报到 `v1/gateway/telemetry`

### 第 3 步：后端下发命令

1. 后端发送 `find` 命令到 `v1/gateway/rpc/{requestId}`
2. WS63 收到后开启蜂鸣器
3. 15 秒后自动关闭

---

## 四、技术约束

| 约束 | 说明 |
|------|------|
| JSON 格式 | 必须严格匹配，key 是 `tag_XXX`，value 是数组 |
| tag_id 类型 | Integer，不加引号 |
| status 值 | 只上报 0/2/3，不传 1 |
| SSL | 端口 8883，需要开启 SSL/TLS |
| QoS | 建议设为 1（至少一次投递） |
| Client ID | 唯一，不能和后端重复 |

---

## 五、待办事项

- [ ] 测试 WS63 连接 EMQX Cloud
- [ ] 验证数据上报格式
- [ ] 验证后端下发命令接收
- [ ] 确认 status 映射正确
- [ ] 确认上报频率符合要求

---

## 六、联系方式

如有问题随时沟通！

---

**确认人：** WS63 网关开发  
**确认日期：** 2026-06-24  
**文档版本：** v1.0
