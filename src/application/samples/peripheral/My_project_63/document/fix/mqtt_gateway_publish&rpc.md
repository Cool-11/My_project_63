# ThingsKit 网关模式上云改造

> 日期: 2026-05-23
> 功能: MQTT 网关发布 + RPC 订阅
> 涉及文件: cloud_storage.h, cloud_storage.c, business_logic.c, main.c

---

## 背景

原方案使用 ThingsKit 直连设备模式，topic 为 `v1/devices/me/telemetry`，数据格式为
`{"tag_update":{...}}`。改为网关模式后，WS63 作为网关设备管理多个 BS21E 子设备，
使用 `v1/gateway/telemetry` 发布，`v1/gateway/rpc` 接收 RPC 下发。

---

## 改动清单

### 1. cloud_storage.h — 新增网关 topic 宏

```c
#define CS_THINGSKIT_GATEWAY_TELEMETRY    "v1/gateway/telemetry"
#define CS_THINGSKIT_GATEWAY_RPC_SUB      "v1/gateway/rpc"
```



### 2. cloud_storage.h — 新增函数声明

```c
int cs_mqtt_publish_gateway(const char *payload, uint16_t len);
int cs_mqtt_subscribe_gateway(void);
```

### 3. cloud_storage.c — 实现 cs_mqtt_publish_gateway

发布到 `v1/gateway/telemetry`，内部调用 `cs_mqtt_publish()`，逻辑与
`cs_mqtt_publish_telemetry` 完全一致，仅 topic 不同。

```c
int cs_mqtt_publish_gateway(const char *payload, uint16_t len)
{
    return cs_mqtt_publish(CS_THINGSKIT_GATEWAY_TELEMETRY, payload, len);
}
```

### 4. cloud_storage.c — 实现 cs_mqtt_subscribe_gateway

独立订阅网关 RPC topic，供外部按需调用。

```c
int cs_mqtt_subscribe_gateway(void)
{
    if (!cs_mqtt_is_connected() || g_cs_mqtt_client == NULL) return -1;
    int rc = MQTTClient_subscribe(g_cs_mqtt_client,
        CS_THINGSKIT_GATEWAY_RPC_SUB, 1);
    return (rc == MQTTCLIENT_SUCCESS) ? 0 : -2;
}
```

### 5. cloud_storage.c — cs_mqtt_connect 连接后自动订阅网关 topic

在原有 `v1/devices/me/rpc/request/+` 订阅之后，追加：

```c
MQTTClient_subscribe(g_cs_mqtt_client, CS_THINGSKIT_GATEWAY_RPC_SUB, 1);
```

### 6. business_logic.c — biz_publish_tag_update 格式改造

**旧格式**（直连设备）：
```json
{"tag_update":{"tag_id":1,"zone":"A1","item":"Type-C","qty":50,"status":1,"battery":95}}
```

**新格式**（网关子设备）：
```json
{"tag_001":[{"tag_id":1,"zone":"A1","item":"Type-C","qty":50,"status":1,"battery":95}]}
```

改动：删除 `cJSON_AddItemToObject(root, "tag_update", tag)`，改为创建数组 + 动态 key：

```c
cJSON *arr = cJSON_CreateArray();
cJSON_AddItemToArray(arr, tag);
char key[16];
snprintf(key, sizeof(key), "tag_%03u", (unsigned int)entry->tag_id);
cJSON_AddItemToObject(root, key, arr);
```

子设备命名规则：`tag_%03u`，范围 tag_001 ~ tag_032。

### 7. main.c — my63_cloud_publish_cb 改用网关发布

```c
// 旧
int ret = cs_mqtt_publish_telemetry(payload, len);
// 新
int ret = cs_mqtt_publish_gateway(payload, len);
```

---

## API 依赖

全部基于当前 SDK 自带的 Paho MQTT C 客户端库：

| API | 头文件 | 用途 |
|-----|--------|------|
| `MQTTClient_subscribe()` | MQTTClient.h | 订阅 topic |
| `MQTTClient_publishMessage()` | MQTTClient.h | 发布消息 |
| `MQTTClient_waitForCompletion()` | MQTTClient.h | QoS1 等待确认 |
| `snprintf()` | stdio.h | 格式化子设备 key |

无新增外部依赖。

---

## 数据流

```
business_logic                         cloud_storage
     │                                      │
     │  biz_publish_tag_update()            │
     │  {"tag_001":[{...}]}                 │
     │                                      │
     │ ──biz_cloud_publish(cb)──────────→ cs_mqtt_publish_gateway()
     │                                      │
     │                                      │ MQTTClient_publishMessage()
     │                                      │ topic = "v1/gateway/telemetry"
     │                                      ▼
     │                                  ThingsKit 网关
     │                                      │
     │                                      │ RPC 下发
     │                                      │ topic = "v1/gateway/rpc"
     │                                      ▼
     │                              cs_mqtt_msg_arrived()
     │                                      │
     │ ◄──g_cs_mqtt_msg_cb─────────────────│
```

---

## 待清理项

| 项目 | 说明 |
|------|------|
| `CS_THINGSKIT_TELEMETRY_TOPIC` 宏 | 直连 topic，网关模式不再需要 |
| `CS_THINGSKIT_RPC_SUB_TOPIC` 宏 | 直连 RPC topic，网关模式不再需要 |
| `cs_mqtt_publish_telemetry()` 函数 | 已被 `cs_mqtt_publish_gateway()` 替代 |
| `cs_mqtt_connect()` 中旧 topic 订阅 | 应替换为仅订阅网关 topic |
