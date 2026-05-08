# cloud_storage 模块文档

## 模块作用

提供 WiFi STA 连接、MQTT 客户端通信、离线缓存和 NV 持久化能力。是系统与 ThingsKit 云平台交互的**唯一上云通道**。

## 模块说明

### WiFi STA 管理

| API | 功能 |
|-----|------|
| `cs_wifi_connect(ssid, psk)` | 连接指定WiFi热点 |
| `cs_wifi_disconnect()` | 断开WiFi连接 |
| `cs_wifi_get_state()` | 获取当前WiFi状态 |
| `cs_wifi_is_got_ip()` | 是否已获取IP地址 |
| `cs_wifi_register_state_cb()` | 注册WiFi状态变更回调 |
| `cs_wifi_config_save_nv()` | WiFi配置持久化到NV（Key=0x5003） |
| `cs_wifi_config_load_nv()` | 从NV加载WiFi配置 |

**WiFi状态机**：
```
IDLE → CONNECTING → CONNECTED → GOT_IP
                                  ↓
                            DISCONNECTED
```

### MQTT 客户端

| API | 功能 |
|-----|------|
| `cs_mqtt_connect(config)` | 连接MQTT服务器，自动订阅RPC主题 |
| `cs_mqtt_disconnect()` | 断开MQTT连接 |
| `cs_mqtt_get_state()` | 获取当前MQTT状态 |
| `cs_mqtt_is_connected()` | 是否已连接 |
| `cs_mqtt_publish(topic, payload, len)` | 发布消息到指定主题 |
| `cs_mqtt_publish_telemetry(payload, len)` | 发布遥测数据到ThingsKit（固定主题） |
| `cs_mqtt_register_state_cb()` | 注册MQTT状态变更回调 |
| `cs_mqtt_register_msg_cb()` | 注册MQTT消息接收回调 |
| `cs_mqtt_config_save_nv()` | MQTT配置持久化到NV（Key=0x5002） |
| `cs_mqtt_config_load_nv()` | 从NV加载MQTT配置 |

**MQTT状态机**：
```
IDLE → CONNECTING → CONNECTED
                        ↓
                   DISCONNECTED / FAILED
```

### ThingsKit 主题配置

| 方向 | 主题常量 | 实际值 | 说明 |
|------|----------|--------|------|
| 设备上报 | `CS_THINGSKIT_TELEMETRY_TOPIC` | `v1/devices/me/telemetry` | 遥测数据上报 |
| 服务端下发 | `CS_THINGSKIT_RPC_SUB_TOPIC` | `v1/devices/me/rpc/request/+` | RPC命令订阅 |

### 离线缓存

| API | 功能 |
|-----|------|
| `cs_cache_push(topic, payload, len)` | 缓存一条消息（FIFO，最多16条） |
| `cs_cache_count()` | 当前缓存条数 |
| `cs_cache_flush()` | MQTT重连后自动发送所有缓存 |

- 缓存满时**丢弃最旧**消息（FIFO淘汰）
- 单条payload最大512字节
- MQTT连接成功后自动调用 `cs_cache_flush()`

### NV持久化Key分配

| Key | 用途 | 数据结构 |
|-----|------|----------|
| 0x5002 | MQTT配置 | `cs_mqtt_config_t` (320字节) |
| 0x5003 | WiFi配置 | `cs_wifi_config_t` (98字节) |

### 凭证配置方式

WiFi和MQTT的连接凭证**不在代码中硬编码**，通过UART命令动态配置：

**WiFi配置**：
```json
{"cmd":"wifi_connect","seq":1,"data":{"ssid":"热点名","psk":"密码"}}
```

**MQTT配置**：
```json
{"cmd":"mqtt_connect","seq":2,"data":{"uri":"mqtt://服务器IP:1883","client_id":"客户端ID","username":"设备TOKEN","password":"设备密码"}}
```

配置成功后自动保存到NV，**掉电不丢失，开机自动加载连接**。

## 模块定位

```
┌─────────────┐
│   app/main     │  桥接层：注册回调，连接 biz ↔ cloud
├─────────────┤
│ cloud_storage  │  基础设施层：WiFi/MQTT/缓存（本模块）
├─────────────┤
│  WiFi SDK      │  硬件驱动：wifi_sta_*
│  lwIP          │  网络栈：DHCP/TCP
│  Paho MQTT     │  MQTT协议：MQTTClient_*
└─────────────┘
```

- **依赖**：WiFi SDK、lwIP、Paho MQTT、NV存储
- **被依赖**：`app/main`（桥接层调用，不直接被 business_logic 调用）
- **不依赖**：`business_logic`、`sle_network`、`uart_vision`、`shared_protocol`

## 重点约束

1. **MQTT连接前置条件**：必须先 `cs_wifi_is_got_ip() == true`，否则连接会被拒绝
2. **DHCP异步获取**：WiFi连接后需等待DHCP分配IP，由 `cloud_storage_poll()` 轮询检测
3. **MQTT yield必须周期调用**：`cloud_storage_poll()` 中调用 `MQTTClient_yield()` 处理心跳和消息
4. **离线缓存是兜底机制**：MQTT断线时消息进入缓存，重连后自动补发，业务层无需感知
5. **WiFi断线联动MQTT**：WiFi断开时自动将MQTT状态置为 `DISCONNECTED`
6. **安全函数**：所有字符串拷贝使用 `strncpy_s`，内存拷贝使用 `memcpy_s`
7. **ThingsKit主题不可修改**：`v1/devices/me/telemetry` 和 `v1/devices/me/rpc/request/+` 是ThingsKit协议规定的，不可自定义

## 日志要求

| 前缀 | 级别 | 场景 |
|------|------|------|
| `[WS63_CLOUD]` | INFO | WiFi连接/断开、IP获取、MQTT连接/断开、缓存操作 |
| `[WS63_CLOUD]` | ERROR | WiFi使能失败、DHCP失败、MQTT连接失败、发布失败 |
| `[WS63_CLOUD]` | DEBUG | NV读写结果、DHCP轮询状态 |

## 审查清单

- [ ] MQTT连接前是否检查WiFi GOT_IP状态
- [ ] WiFi断开时是否联动MQTT状态清理
- [ ] `cloud_storage_poll()` 是否在主循环中周期调用
- [ ] 缓存满时是否正确淘汰最旧消息
- [ ] NV Key是否与其他模块冲突（0x5002/0x5003）
- [ ] `strncpy_s`/`memcpy_s` 返回值是否全部检查
- [ ] MQTT连接后是否自动订阅 `v1/devices/me/rpc/request/+`
- [ ] 遥测发布是否使用 `cs_mqtt_publish_telemetry()` 而非硬编码主题
- [ ] MQTT消息回调中是否有阻塞操作

## 验证思路

1. **WiFi连接**：UART发送 `wifi_connect` 命令，观察日志打印 `GOT_IP`
2. **MQTT连接**：UART发送 `mqtt_connect` 命令，观察日志打印 `subscribed topic=v1/devices/me/rpc/request/+`
3. **遥测上报**：触发盘点后，在ThingsKit控制台验证收到 `v1/devices/me/telemetry` 主题的JSON数据
4. **RPC下发**：从ThingsKit控制台发送RPC命令，验证 `mqtt_msg_cb` 被触发
5. **离线缓存**：断开WiFi后触发盘点，观察日志打印 `caching`，重连后观察 `cache flushed`
6. **NV持久化**：配置WiFi/MQTT后断电重启，验证自动加载配置并连接
7. **DHCP超时**：连接不存在热点，验证不会死循环，状态变为 `DISCONNECTED`
