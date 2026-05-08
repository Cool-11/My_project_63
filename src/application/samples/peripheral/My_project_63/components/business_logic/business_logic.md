# business_logic 模块文档

## 模块作用

实现仓库管理核心业务逻辑：标签入库、盘点、查找、出库、数量更新。是系统的**业务核心**，协调 UART 命令、SLE 通信和云端上报。

## 模块说明

### 标签数据模型

```c
typedef struct {
    uint16_t tag_id;           // 标签唯一ID（自增分配）
    uint8_t  mac[6];           // BS21E MAC地址
    char     zone[8];          // 库区编号
    char     item[16];         // 物品名称
    uint16_t qty;              // 库存数量
    biz_tag_status_t status;   // 标签状态
    uint8_t  battery;          // 电量百分比
} biz_tag_entry_t;
```

**标签状态机**：
```
IDLE → BOUND → ONLINE
                ↓
              OFFLINE
```

| 状态 | 值 | 含义 |
|------|----|------|
| `BIZ_TAG_IDLE` | 0 | 已分配但未绑定 |
| `BIZ_TAG_BOUND` | 1 | 已绑定BS21E |
| `BIZ_TAG_ONLINE` | 2 | 在线（盘点响应正常） |
| `BIZ_TAG_OFFLINE` | 3 | 离线（盘点响应异常） |

### 标签映射表

- 最大容量：32个标签（`BIZ_TAG_MAX`）
- NV持久化Key：0x5001
- `tag_id` 自增分配，NV加载时恢复 `next_tag_id`

### 核心API

| 函数 | 功能 |
|------|------|
| `business_logic_init()` | 初始化：加载NV、注册回调 |
| `business_logic_poll()` | 轮询：超时检测（主循环调用） |
| `biz_map_find_by_tag()` | 按tag_id查找标签 |
| `biz_map_find_by_mac()` | 按MAC地址查找标签 |
| `biz_map_alloc()` | 分配新标签条目 |
| `biz_map_remove()` | 删除标签条目 |
| `biz_map_save_nv()` | 标签映射表持久化 |
| `biz_map_load_nv()` | 从NV加载标签映射表 |

### 回调注册API

| 函数 | 回调类型 | 用途 |
|------|----------|------|
| `business_logic_register_uart_cb()` | `biz_notify_uart_t` | UART响应发送 |
| `business_logic_register_cloud_cb()` | `biz_cloud_publish_t` | 云端遥测上报 |
| `business_logic_register_wifi_cmd_cb()` | `biz_wifi_cmd_t` | WiFi操作代理 |
| `business_logic_register_mqtt_cmd_cb()` | `biz_mqtt_cmd_handler_t` | MQTT操作代理 |

### 命令处理流程

```
UART命令 → biz_uart_cmd_handler() → biz_cmd_xxx()
                ↓                        ↓
          解析cmd+seq+data        执行业务逻辑
                                        ↓
                              ┌─────────┼─────────┐
                              ↓         ↓         ↓
                         UART回复   SLE命令   云端上报
                        (uart_cb) (sle_api) (cloud_cb)
```

### 待处理操作超时机制

- 单一 pending 槽位，记录当前等待SLE响应的命令
- 超时时间：5000ms（`BIZ_PENDING_TIMEOUT_MS`）
- 超时后：inbound命令回滚（删除已分配的tag），其他命令仅回复超时
- `business_logic_poll()` 中检测超时

### 自动云端上报

以下场景自动通过 `biz_cloud_publish_t` 回调上报遥测数据到 ThingsKit：

| 场景 | 上报内容 |
|------|----------|
| 盘点响应 | `{"tag_update":{tag_id,zone,item,qty,status,battery}}` |
| 标签绑定成功 | `{"tag_update":{tag_id,zone,item,qty,status,battery}}` |
| 数量更新 | `{"tag_update":{tag_id,zone,item,qty,status,battery}}` |

## 模块定位

```
┌─────────────┐
│   app/main     │  桥接层：注册回调，biz不直接依赖cloud
├─────────────┤
│business_logic  │  业务层：命令处理+数据管理（本模块）
├─────────────┤
│ uart_vision    │  外设层：UART收发
│ sle_network    │  外设层：SLE通信
│ cloud_storage  │  基础设施层：通过回调间接使用
└─────────────┘
```

- **依赖**：`uart_vision`（注册命令回调）、`sle_network`（发送SLE命令）、`shared_protocol`（命令码常量）
- **不直接依赖**：`cloud_storage`（通过回调解耦）
- **被依赖**：`app/main`（注册回调、调用poll）

### 关键设计：回调解耦

`business_logic` **不 include `cloud_storage.h`**，所有跨层操作通过回调：

| 回调 | 注册方 | 实际调用 |
|------|--------|----------|
| `biz_cloud_publish_t` | main.c | → `cs_mqtt_publish_telemetry()` |
| `biz_wifi_cmd_t` | main.c | → `cs_wifi_connect()` + NV保存 |
| `biz_mqtt_cmd_handler_t` | main.c | → `cs_mqtt_connect()` + NV保存 |

## 重点约束

1. **禁止直接依赖 cloud_storage**：`business_logic.c` 不得 `#include "cloud_storage.h"`，所有上云操作通过回调
2. **单一pending限制**：同时只能有一个命令等待SLE响应，新命令会覆盖旧pending（旧命令超时后才会被清理）
3. **NV写入时机**：每次标签数据变更后立即 `biz_map_save_nv()`，防止掉电丢失
4. **cJSON内存管理**：所有 `cJSON_PrintUnformatted` 返回的字符串必须 `cJSON_free()` 释放
5. **安全函数**：字符串拷贝使用 `strncpy_s`，返回值必须检查
6. **空指针检查**：所有 `cJSON_GetObjectItem` 返回值使用前必须检查 `!= NULL` 和 `cJSON_IsString/IsNumber`
7. **tag_id自增不回收**：删除标签后 tag_id 不复用，next_tag_id 只增不减

## 日志要求

| 前缀 | 级别 | 场景 |
|------|------|------|
| `[WS63_BIZ]` | INFO | 命令接收、标签分配/删除、pending设置/完成、回调注册 |
| `[WS63_BIZ]` | ERROR | JSON解析失败、SLE未就绪、标签未找到、map满、超时 |
| `[WS63_BIZ]` | DEBUG | 标签数据详情、SLE通知内容 |

## 审查清单

- [ ] 是否存在 `#include "cloud_storage.h"`（禁止）
- [ ] 所有 cJSON 对象是否正确释放（`cJSON_Delete`）
- [ ] 所有 `cJSON_PrintUnformatted` 返回值是否 `cJSON_free`
- [ ] `strncpy_s` 返回值是否检查
- [ ] `cJSON_GetObjectItem` 返回值是否做 NULL + 类型检查
- [ ] 标签数据变更后是否调用 `biz_map_save_nv()`
- [ ] pending超时后 inbound 是否回滚（删除已分配tag）
- [ ] SLE命令发送前是否检查 `is_ssap_ready()`
- [ ] WiFi/MQTT命令是否通过回调而非直接调用

## 验证思路

1. **入库流程**：UART发送 `inbound` → 观察SLE绑定命令 → BS21E响应 → 标签状态变为BOUND → UART回复ok → 云端收到tag_update
2. **盘点流程**：UART发送 `inventory` → SLE盘点命令 → BS21E响应 → 标签数据更新 → UART回复标签列表 → 云端收到更新
3. **出库流程**：UART发送 `outbound` → 标签从map删除 → NV保存 → UART回复ok
4. **超时场景**：发送 `inbound` 后BS21E不响应 → 5秒后超时 → 标签被回滚删除 → UART回复timeout
5. **WiFi配置**：UART发送 `wifi_connect` → 回调触发 `cs_wifi_connect()` → NV保存 → 重启后自动连接
6. **MQTT配置**：UART发送 `mqtt_connect` → 回调触发 `cs_mqtt_connect()` → NV保存 → 重启后自动连接
7. **云端上报**：盘点完成后验证ThingsKit收到 `v1/devices/me/telemetry` 主题的JSON数据
