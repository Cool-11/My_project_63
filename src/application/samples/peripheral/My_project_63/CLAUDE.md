# My_project_63 开发规范

> WS63 智能仓储网关固件 — 迭代升级约束文件
> 本文件约束所有后续开发行为，任何修改必须先阅读此文件。

## 项目定位

WS63 芯片作为 SLE 网关，桥接四层通信：
- **下行**：SLE (NearLink) 连接 BS21E 电子标签
- **上行1**：UART1 JSON 与 ESP32-S3 交互（数据透传 + 摄像头 + L610 AT 指令）
- **上行2**：UART2 CSV 文本帧与 4.3寸淘晶驰 T1 串口屏交互（人机界面）
- **云端**：WiFi + MQTT (ThingsKit) 上报/下发

### 系统拓扑

```
                    ┌─────────────┐
                    │  ThingsKit  │
                    │  MQTT 云平台 │
                    └──────┬──────┘
                           │ WiFi
                    ┌──────┴──────┐
                    │    WS63     │
                    │  (网关核心)  │
                    ├──────┬──────┤
               UART1│      │UART2│
                    │      │     │
            ┌───────┴──┐ ┌─┴─────┴──┐
            │ ESP32-S3 │ │4.3寸T1串口屏│
            │(摄像头+透传)│ │(淘晶驰HMI) │
            └────┬─────┘ └──────────┘
                 │ AT指令
            ┌────┴─────┐
            │ L610 4G  │
            └──────────┘

                    ┌──────────────┐
                    │   BS21E ×N   │
                    │ (SLE电子标签) │
                    └──────┬───────┘
                           │ SLE (NearLink)
                    ┌──────┴──────┐
                    │    WS63     │
                    └─────────────┘
```

## 架构铁律（不可违反）

### 1. 模块解耦

```
uart_vision  (UART1, ESP32 JSON)  ──┐
                                     ├──→ business_logic ──→ sle_network
uart_display (UART2, 屏幕 CSV)   ──┘         │
                                              │ (回调函数指针，仅 main.c 注册)
                                              ▼
                                       cloud_storage
```

- **business_logic 禁止 `#include "cloud_storage.h"`**。所有云端交互必须通过 `main.c` 注册的回调函数指针完成。
- **sle_network 禁止 `#include "business_logic.h"`**。SLE 层只通过 notify 回调向上通知。
- **uart_vision 禁止 `#include "business_logic.h"` 或 `cloud_storage.h"`**。只通过 `uv_cmd_handler_t` 回调分发命令。
- **uart_display 禁止 `#include "business_logic.h"` 或 `cloud_storage.h"`**。只通过 `ud_cmd_handler_t` 回调分发命令。
- **跨组件引用只允许单向**：`business_logic` → `sle_network`、`business_logic` → `uart_vision`（发送 ESP32 回复）、`business_logic` → `uart_display`（发送屏幕数据）。
- **唯一耦合点是 `app/main.c`**，它注册所有桥接回调。

#### uart_vision vs uart_display 职责划分

| | uart_vision | uart_display |
|--|------------|--------------|
| UART 总线 | UART1 | UART2 |
| 对端设备 | ESP32-S3 | 4.3寸淘晶驰 T1 串口屏 |
| 协议格式 | JSON 文本帧，`\n` 分割 | CSV 文本帧，`@`/`#` 头，`\r\n` 尾 |
| 解析方式 | cJSON 解析 | 按逗号 split，首字节判断方向 |
| 回调类型 | `uv_cmd_handler_t` | `ud_cmd_handler_t` |
| Tag ID 格式 | `"0x0001"` 十六进制字符串 | `"0001"` 纯数字字符串 |
| 驱动模式 | DMA + IDLE 中断 | DMA + IDLE 中断（同模式，独立实例） |

### 2. 事件驱动架构

- **禁止在业务代码中创建新线程或任务**。所有逻辑必须在 `My63Task` 单线程内协作完成。
- `My63Task` 主循环使用 `osEventFlagsWait()` 阻塞等待事件，不再固定 10ms 轮询。
- 使用 CMSIS-RTOS2 官方 API：`osEventFlagsNew` / `osEventFlagsSet` / `osEventFlagsWait`。
- 事件源：
  - **UART1 RX（ESP32，DMA + IDLE 空闲中断）** → 硬件 DMA 搬运整帧数据到缓冲区 → IDLE 中断触发时设置 `EVENT_UART1_RX` 标志。**严禁使用传统的字节级 UART RX 中断。** 只有 IDLE 中断才发送事件标志，DMA 搬运期间不打扰 CPU。
  - **UART2 RX（串口屏，DMA + IDLE 空闲中断）** → 同上，独立 DMA 实例，设置 `EVENT_UART2_RX` 标志。
  - **SLE 广播中断** → 原始字节流入 `osMessageQueue` → 设置 `EVENT_SLE_ADV` 标志
  - **定时器事件** → pending 超时检查、心跳、扫描重启
- 所有模块仍暴露 `_poll()` 函数，但由事件触发调用，不再空转。
- 中断回调（UART IDLE、SLE 事件、WiFi 事件）**只做数据搬运 + 设置事件标志**，禁止阻塞或执行业务逻辑。
- 无事件时 `My63Task` 睡眠，CPU 让给 `bt_service` 等高优先级任务。

### 3. 单待处理槽

- 同一时间只能有一个 SLE 命令在等待 BS21E 响应（`g_biz_pending`）。
- 新命令必须等待当前 pending 完成或超时（5秒）后才能发送。
- 扩展多标签时，此约束可升级为每标签独立 pending，但不能取消超时机制。

### 4. 结构体打包规范

**所有跨模块结构体必须使用 `__attribute__((packed))`，禁止依赖编译器对齐填充。**

扫描表核心结构体（21 字节，精准无浪费）：

```c
struct __attribute__((packed)) TagState {
    uint16_t tag_id;        // 2B
    uint8_t  mac[6];        // 6B
    uint8_t  battery;       // 1B
    uint16_t qty;           // 2B
    uint8_t  status;        // 1B
    uint64_t last_seen_ms;  // 8B
    bool     used;          // 1B
};  // 总计 21B
```

- packed 结构体的字段访问可能非对齐，RISC-V 支持非对齐访问但有性能损失，当前数据量可接受。
- NV 存储的结构体也必须 packed，避免序列化/反序列化时填充字节不一致。
- 新增结构体必须用 `_Static_assert(sizeof(...) == N, "size check")` 验证大小。

### 5. SLE 广播消息队列与去重

**SLE 扫描回调 (`my63_seek_result_cb`) 运行在 `bt_service` 高优先级中断上下文，必须极快返回。**

#### 5.1 消息队列

- 使用 CMSIS-RTOS2 官方 API：`osMessageQueueNew` / `osMessageQueuePut` / `osMessageQueueGet`。
- 队列容量：**256 条**（packed 结构体仅 ~80B/条，总 RAM ~20KB，可接受）。
- 队列中流转的是**未经处理的原始字节流**，不包含任何业务数据。
- **SDK `sle_set_announce_data` 确认为拷贝模式**：SDK 内部拷贝 buffer 数据到自身 buffer，应用层可安全修改原 buffer 后再次调用。

**广播频率与队列压力：**

| 参数 | BS21E 值 | 说明 |
|------|----------|------|
| 广播间隔 | `0x320` (800) | 800 × 0.625ms = **500ms**，即每秒 **2 次**广播 |
| 单标签回调频率 | ~2 次/s | 每 500ms 触发一次 `my63_seek_result_cb` |
| 32 标签总回调频率 | ~64 次/s | 相比原 256 次/s 降低 75%，NMI 风险大幅降低 |

队列深度 256 条可缓冲约 4 秒的突发数据。出队处理速度远大于入队速度，队列溢出风险极低。

```c
#define SLE_ADV_RAW_MAX  64   /* 单条广播最大原始长度 */

struct __attribute__((packed)) sle_adv_msg {
    uint8_t  raw[SLE_ADV_RAW_MAX];  // 原始广播字节（AD data 完整内容）
    uint16_t raw_len;                // 有效字节长度
    uint8_t  addr[6];               // 发送方 MAC 地址
    int8_t   rssi;                  // 信号强度
    uint64_t ts_ms;                 // 入队时间戳
};  // 约 80B
```

#### 5.2 入队（SLE 回调中）

- 只做：`memcpy` 原始广播字节 + MAC + RSSI → `osMessageQueuePut()` → return。
- **严禁在 SLE 回调中执行**：`osal_printk`、`shared_protocol_unpack_adv`、`scan_table_add_or_update`、任何 cJSON 操作。

#### 5.3 出队与处理（主循环中）

`My63Task` 从队列逐条取出，执行以下流水线：

```
osMessageQueueGet()
    │
    ▼
① 协议层过滤（入队前已完成，此处仅做 AD 解析）
    │  从原始字节提取 manufacturer data → unpack_adv()
    │  unpack 失败 → 丢弃
    ▼
② 扫描表更新（所有合法标签都写入扫描表）
    │  更新 TagState 条目（无论是否已注册）
    ▼
③ 业务层分流（白名单判定）
    │
    ├─ 已注册 + MAC 匹配 → whitelisted = true → 继续 ④
    ├─ 已注册 + MAC 异常 → 标记异常，不上云，打印警告
    └─ 未注册           → whitelisted = false，不上云，仅保留在扫描表
    │
    ▼
④ 时间窗去重（Deduplication）
    │  同一 MAC 在 3~5 秒内已上云 → 仅更新 RSSI + 时间戳，跳过 ⑤
    ▼
⑤ MQTT 网关上云
    │  {"tag_%03u":[{...}]}
    ▼
⑥ 队列空 → 退出 poll，CPU 让出
```

**核心原则：扫描发现 ≠ 上云。白名单控制的是"谁能上云"，不是"谁能被看见"。**

- **已配网未连接的标签** → 扫描表可见，用户通过 ESP32 串口屏发起 register 流程后变为已注册
- **已注册的标签** → 去重后自动上云
- **不在本项目中的 BS21E** → 扫描表可见但不上云，不浪费 MQTT 带宽

#### 5.4 白名单与去重 TagList

本地维护一张 packed 数组，兼具白名单判定 + 时间窗去重双重功能：

```c
#define TAG_LIST_MAX  32

struct __attribute__((packed)) TagListEntry {
    uint8_t  mac[6];            // 6B — 主键，用于匹配
    uint16_t tag_id;            // 2B — 协议解析后填入
    uint64_t last_publish_ms;   // 8B — 上次 MQTT 上云时间戳
    uint64_t last_seen_ms;      // 8B — 最后扫描时间戳
    int8_t   rssi;              // 1B — 最新信号强度
    bool     whitelisted;       // 1B — 白名单标志（是否已注册）
    bool     used;              // 1B — 条目有效
};  // 27B × 32 = 864B
```

**白名单判定逻辑（查 `biz_tag_map_t`）：**

```
解析出 tag_id + MAC
    │
    ▼
biz_map_find_by_tag(tag_id) 存在？
    │                    │
    否                   是
    │                    │
    ▼                    ▼
whitelisted = false     MAC 与 biz_map 记录一致？
写入扫描表，不上云       │              │
                        是              否
                        │              │
                        ▼              ▼
                   whitelisted = true  标记异常
                   进入去重 → 上云     不上云，打印警告
```

**时间窗去重：**

- `now - last_publish_ms < DEDUP_WINDOW_MS (3~5s)` 时，仅更新 `rssi` + `last_seen_ms`，**不触发 MQTT 上云**。
- 去重窗口结束后，下一次扫描到该 MAC 才触发上云。
- 防止高频广播（BS21E 默认 ~1s 一次）导致 MQTT 消息风暴。

### 6. 大小端协议规范（关键！）

**BS21E 与 WS63 之间所有 SSAP 通信使用大端序（Big-Endian）。**

| 场景 | 字节序 | 依据 |
|------|--------|------|
| 广播数据 (adv field) | 大端 | BS21E 用 `proto_write_u32_be/u16_be` 序列化 |
| Notify 响应 (inventory/bind) | 大端 | BS21E 用 `proto_write_u16_be` 序列化 |
| Write 命令 (find/inventory/bind/qty) | 大端 | BS21E 用 `data[1]<<8 \| data[2]` 解析 |

**新增任何跨设备字段，必须使用 `read_be16`/`write_be16` 处理，禁止使用 `read_le16`/`write_le16`。**

广播解析的自动检测机制（先 LE 读 magic，不匹配则 BE）仅适用于 `unpack_adv()`。Notify 解析和 Write 打包直接使用大端，因为 BS21E 端固定使用大端。

### 7. NV 存储规范

| NV Key | 模块 | 数据 | 大小 |
|--------|------|------|------|
| 0x5001 | business_logic | `biz_tag_map_t` | ~1154B |
| 0x5002 | cloud_storage | `cs_mqtt_config_t` | 320B |
| 0x5003 | cloud_storage | `cs_wifi_config_t` | 98B |

- NV Key 范围：`[0x5000, 0xFFFF)`，单条上限 4060 字节。
- **新增 NV 项必须在本文件登记**，Key 不可与已有项冲突。
- 读取失败时必须优雅降级（空表/默认值），禁止 panic。

### 8. SSAP 连接参数对齐

WS63 端连接参数必须与 BS21E 端保持一致，否则会莫名断联：

| 参数 | BS21E 值 | WS63 值 | 单位 | 实际时间 |
|------|----------|---------|------|----------|
| conn_interval | 0x64 | 0x64 | 0.625ms/slot | 62.5ms |
| conn_latency | 0x0F | N/A | slots | 最大静默 937.5ms |
| conn_timeout | 0x1F4 | 0x1F4 | 10ms | 5s |
| MTU | 默认(~300) | 512 | bytes | 协商取较小值 |
| CCCD 位置 | Property(0xFF01) | Property(0xFF01) | - | ✅ 已确认一致 |

**已确认事项：**
- 连接间隔单位：0.625ms/slot（与 BLE slot 定义一致），0x64 = 100 slots = 62.5ms
- CCCD 描述符：在 Property (0xFF01) 上，不在 Service (0xFF00) 上，两端已对齐
- MTU：WS63 请求 512，BS21E 使用 SDK 默认值，协商后取较小值。当前最大 payload 仅 12 字节（广播），不会溢出

**修改连接参数前必须两端同步修改。**

### 9. status 字段语义映射（关键！）

**`0x02` 在 BS21E 协议中有双重含义，必须区分上下文：**

| 上下文 | `0x02` 的含义 | 说明 |
|--------|-------------|------|
| SSAP 命令码 | 盘点（INVENTORY） | WS63 发给 BS21E 的单播命令 |
| adv_field status 字段 | 使用中（IN_USE） | BS21E 广播中的标签状态 |

**BS21E 端 status 定义（广播字段，已更新）：**

| 值 | BS21E 含义 | 触发条件 |
|----|-----------|---------|
| 0x00 | 空闲（IDLE） | 默认状态 |
| 0x01 | 寻物（FINDING） | 收到 0x01 寻物命令 |
| 0x02 | 使用中（IN_USE） | 正常工作中 |
| 0x03 | 未配网（NOT_PROVISIONED） | 未完成配网流程 |

**WS63 端 status 定义（物模型/上云）：**

| 值 | WS63 含义 | 说明 |
|----|-----------|------|
| 0 | 空闲 | 未绑定 |
| 1 | 已绑定 | 注册完成 |
| 2 | 在线 | 正在通信 |
| 3 | 离线 | 超时未扫描到 |

**WS63 上云时必须做映射转换**，不能直接透传 BS21E 的 status 值：

```
BS21E status → WS63 上云 status:
  0x00 (IDLE)           → 2 (在线，空闲)
  0x01 (FINDING)        → 2 (在线，寻物中)
  0x02 (IN_USE)         → 2 (在线，使用中)
  0x03 (NOT_PROVISIONED)→ 0 (空闲，未配网)
  未扫描到              → 3 (离线)
  未注册                → 0 (空闲)
```

映射逻辑放在 `business_logic.c` 的 `biz_publish_tag_update()` 中，不在 `sle_network` 层做。

## 代码风格约束

### 命名规范

- **模块前缀**：每个 `.c` 文件使用固定前缀打印日志
  - `[WS63_APP]` — main.c
  - `[WS63_NET]` — sle_network.c
  - `[WS63_UART]` — uart_vision.c
  - `[WS63_BIZ]` — business_logic.c
  - `[WS63_CLOUD]` — cloud_storage.c
  - `[WS63_PROTO]` — shared_protocol.c
- **静态全局变量**：`g_<模块缩写>_<变量名>`
- **函数**：`<模块缩写>_<动作>`
- **宏常量**：全大写，`<模块缩写>_<名称>`
- **回调类型**：`<模块缩写>_<名称>_t`

### 安全编码

- 字符串拷贝必须使用 `strncpy_s()`，目标缓冲区大小传 `-1` 后的实际长度。
- 内存拷贝必须使用 `memcpy_s()`。
- 所有函数入口对指针参数做 NULL 检查。
- cJSON 解析结果必须检查 NULL 后再访问。

### UART JSON 协议

请求格式：`{"cmd":"<name>","seq":<N>,"data":{...}}\n`
响应格式：`{"cmd":"<name>","seq":<N>,"code":<0>,"msg":"ok","data":{...}}\r\n`

- `code=0` 表示成功，负数表示错误。
- 新增命令必须在 `business_logic.c` 的分发函数中注册。

### ESP32 协议对齐

ESP32 上行消息使用 `"type"` 字段（非 `"cmd"`），`uart_vision.c` 的 `uv_dispatch_line` 已做兼容：
优先读 `"cmd"`，找不到则读 `"type"`。business_logic 层无感。

ESP32 下行命令格式（扁平，无 data 包装）：
```json
{"cmd":"register","seq":1,"tag_id":5,"item_name":"Type-C","storage_area":"A1"}
```
`biz_cmd_passthrough_to_esp32` 将 data_json 字段合并到 root 对象中发送。

ESP32 上行消息格式：
```json
{"type":"task_done","task":"register","result":"success",...}
```
通过 type→cmd 兼容后，business_logic 收到 `cmd="task_done"`，用 `task` 字段匹配 pending。

任务名映射：ESP32 返回 `task="register"` → `biz_map_esp32_task` 映射为 `"inbound"` → 匹配 `pending.cmd`（SLE bind 成功后已从 `"register"` 改为 `"inbound"`）。

pending 超时：SLE 命令 5s，ESP32 视觉命令 15s（通过 `biz_get_pending_timeout_ms` 动态选择）。

### 串口屏协议对齐（uart_display）

串口屏（淘晶驰 T1 4.3寸）使用 CSV 文本帧，详见 `document/protocols/WS63_uart_protocol.md`。

上行帧（屏→WS63）格式：`@<cmd>,<param1>,<param2>,...\r\n`
下行帧（WS63→屏）格式：`#<cmd>,<param1>,<param2>,...\r\n`

WS63 在 `uart_display` 模块中解析 CSV 帧，提取 cmd 和参数，通过 `ud_cmd_handler_t` 回调转发给 `business_logic`。

Tag ID 格式转换职责：
- `uart_display` 内部做 `"0005"` ↔ `uint16_t 5` 的互转
- `business_logic` 做 `uint16_t 5` ↔ `"0x0005"` 的互转（对接 ESP32）

盘点操作支持三种模式：
- `@inv,all\r\n` — 全量盘点
- `@inv,tag,<tag_id>\r\n` — 单标签盘点
- `@inv,zone,<zone>\r\n` — 按区域盘点

## 迭代升级路径

### Phase 5: 多标签支持（计划中）

**目标**：从当前单连接模式扩展到同时管理多个 BS21E 标签。

约束：
- `sle_network` 需支持多连接（多 `conn_id`），但每个连接仍独立走 scan→connect→pair→SSAP 流程。
- `business_logic` 的 pending 机制需升级为每 tag 独立 pending（数组或链表），保留 5 秒超时。
- `biz_tag_map_t` 的 `BIZ_TAG_MAX` 可从 32 扩大，但需重新计算 NV 大小不超过 4060 字节。
- 扫描策略需改为"发现一个记录一个"，而非"发现目标后停止扫描"。
- 标签锁定策略：MAC 为主（SLE 协议层硬需求），tag_id 为辅（业务层语义）。

### Phase 6: 协议扩展（计划中）

约束：
- 新命令码必须 `>= 0x30`，避免与现有命令冲突（0x00/0x01/0x02/0x10/0x20）。
- 新回复码必须 `>= 0xB0`，避免与现有回复冲突（0x82/0xA0/0xAF）。
- `shared_protocol_pack_write_cmd()` 的 switch-case 必须同步扩展。
- `sle_network` 的 `my63_ssap_notification_cb` 必须同步扩展分发逻辑。
- **所有新字段必须使用大端序**。

### Phase 7: 云端增强（计划中）

约束：
- MQTT 下行消息处理必须在 `my63_mqtt_msg_cb` 中分发，解析后调用 business_logic 接口。
- **禁止在 cloud_storage 中直接执行业务逻辑**。
- 新增 MQTT topic 必须在 `cloud_storage.h` 中定义宏。
- 4G 模块 (L610) AT 指令透传方案：WS63 发 AT 命令字符串 → UART → ESP32 透传 → L610。

### Phase 8: OTA 固件升级（远期）

- 独立组件，不与现有模块耦合。
- 通过 MQTT 下发升级指令 + HTTP 下载固件。

## ThingsKit 云平台配置

### 网关模式

WS63 作为网关设备，管理多个 BS21E 子设备。子设备命名规则：`tag_%03u`（tag_001 ~ tag_032）。

### Topic 配置

| 方向 | Topic | 用途 |
|------|-------|------|
| 上报 | `v1/gateway/telemetry` | 网关子设备数据上报 |
| 下发 | `v1/gateway/rpc` | 网关 RPC 命令下发 |

### 上报数据格式

```json
{
  "tag_001": [
    {"tag_id": 1, "zone": "A1", "item": "Type-C", "qty": 50, "status": 1, "battery": 95}
  ]
}
```

每个子设备的遥测数据以数组形式包裹在对应的 key 下，支持批量上报多个标签。

### 物模型建议

| 属性名 | 类型 | 说明 |
|--------|------|------|
| tag_id | integer | 标签 ID |
| zone | string | 仓库区域 |
| item | string | 货物名称 |
| qty | integer | 库存数量 |
| status | integer | 0=空闲, 1=已绑定, 2=在线(IDLE/FINDING/IN_USE), 3=离线。**需从 BS21E 原始值映射，见 §9** |
| battery | integer | 电池百分比 |

## 修改检查清单

每次修改代码前，对照检查：

- [ ] 是否破坏了模块单向依赖？
- [ ] 新增的跨设备字段是否使用大端序？
- [ ] 新增的 NV Key 是否已登记且不冲突？
- [ ] 新增的 SSAP 命令码/回复码是否在共享头文件中定义？
- [ ] 新增结构体是否 packed + Static_assert？
- [ ] 字符串操作是否使用了安全函数？
- [ ] 中断回调中是否只做数据搬运 + 设置事件标志？
- [ ] SLE 回调中是否有 `osal_printk` 或协议解析？（禁止！）
- [ ] UART1/UART2 是否都使用 DMA + IDLE 中断？（禁止字节级 RX 中断！）
- [ ] 队列操作是否使用 `osMessageQueue` 官方 API？
- [ ] MQTT 上云前是否经过白名单过滤 + 时间窗去重？
- [ ] 日志是否使用了正确的模块前缀？
- [ ] 连接参数是否与 BS21E 端一致？
- [ ] MQTT 上报是否使用网关格式 `{"tag_%03u":[{...}]}`？
- [ ] 屏幕通信是否使用 CSV 文本帧格式（`@`/`#` + 逗号分隔 + `\r\n`）？
- [ ] Tag ID 格式转换是否正确（屏端纯数字 ↔ 内部 uint16_t ↔ ESP32 十六进制）？
- [ ] 编译是否零错误零警告？

## 文件索引

| 文件 | 行数 | 职责 |
|------|------|------|
| `app/main.c` | ~282 | 入口 + 主循环 + 回调桥接 |
| `components/shared_protocol/` | ~300 | 二进制协议编解码 (大端序!) |
| `components/sle_network/` | ~980 | SLE 扫描/连接/配对/SSAP |
| `components/uart_vision/` | ~350 | UART1 JSON 收发 + ESP32 命令分发 |
| `components/uart_display/` | ~400 | UART2 CSV 收发 + 串口屏命令分发 (淘晶驰 T1) |
| `components/business_logic/` | ~715 | 业务逻辑 + 标签映射表 + NV |
| `components/cloud_storage/` | ~675 | WiFi + MQTT + 离线缓存 |

### uart_display 模块协议

通信协议详见 `document/protocols/WS63_uart_protocol.md`。

| 项目 | 说明 |
|------|------|
| 屏幕型号 | 淘晶驰 T1系列 4.3寸 480x272 |
| 物理层 | UART2, 115200bps, 8N1, 3.3V TTL |
| 帧格式 | CSV 文本帧，`@`=屏→WS63，`#`=WS63→屏，`\r\n` 结尾 |
| UI 方案 | 单页设计，sys0 状态变量控制组件组显示/隐藏 |
| Tag ID 格式 | 屏端 `"0001"` (纯数字) ↔ 内部 `uint16_t 1` ↔ ESP32 `"0x0001"` |
| 功能 | 入库(含摄像头拍照)、出库(含摄像头验证)、全量/区域/单标签盘点、寻物 |
| 日志前缀 | `[WS63_DISP]` |
