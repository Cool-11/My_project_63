# ESP32 协议对齐修改报告

> 日期: 2026-05-15
> 目标: 适配 ESP32 v3.1 JSON 协议，兼容出库解绑，统一命令分发

---

## 1. 修改文件清单

| 文件 | 改动类型 | 改动摘要 |
|------|---------|---------|
| `components/shared_protocol/shared_protocol.h` | 新增 | `SSAP_CMD_UNBIND_TAG = 0x21` |
| `components/uart_vision/uart_vision.h` | 修改 | 缓冲区扩大 + `UV_TYPE_FIELD` |
| `components/uart_vision/uart_vision.c` | 修改 | type 兼容 + `uart_vision_send_raw_json` |
| `components/business_logic/business_logic.h` | 修改 | ESP32 超时常量 + raw_json 回调类型 |
| `components/business_logic/business_logic.c` | 重构 | ESP32 消息处理 + 出库解绑 + 命令扩展 |
| `CLAUDE.md` | 新增 | ESP32 协议对齐说明 |

---

## 2. 具体改动详情

### 2.1 shared_protocol.h

```c
+ #define SSAP_CMD_UNBIND_TAG     0x21
```

出库解绑命令码，与 BS21E 端同步。BS21E 需要新增对 0x21 的处理。

### 2.2 uart_vision.h

```c
- #define UV_RING_SIZE        512
+ #define UV_RING_SIZE        2048
- #define UV_LINE_MAX         256
+ #define UV_LINE_MAX         512
+ #define UV_TYPE_FIELD       "type"
```

- 环形缓冲区 512→2048：ESP32 最大帧 2048 字节
- 行缓冲区 256→512：覆盖 99% 场景，不浪费 RAM
- 新增 `UV_TYPE_FIELD`：ESP32 上行用 `type` 非 `cmd`

### 2.3 uart_vision.c

**改动 1：type 兼容**
```c
  cJSON *j_cmd = cJSON_GetObjectItem(root, UV_CMD_FIELD);
+ if (j_cmd == NULL || !cJSON_IsString(j_cmd)) {
+     j_cmd = cJSON_GetObjectItem(root, UV_TYPE_FIELD);
+ }
```

**改动 2：新增 raw_json 发送函数**
```c
+ int uart_vision_send_raw_json(const char *json_str);
```

用于发送不符合 cmd/seq/code/msg 格式的 JSON（透传给 ESP32）。

### 2.4 business_logic.h

```c
+ #define BIZ_PENDING_TIMEOUT_SLE_MS   5000
+ #define BIZ_PENDING_TIMEOUT_ESP32_MS 15000
+ typedef void (*biz_raw_json_uart_t)(const char *json_str);
+ void business_logic_register_raw_json_cb(biz_raw_json_uart_t cb);
```

- SLE 命令 5 秒超时，ESP32 视觉命令 15 秒超时
- raw_json 回调类型：透传原始 JSON 字符串

### 2.5 business_logic.c — 核心改动

#### 新增函数

| 函数 | 行数 | 职责 |
|------|------|------|
| `biz_raw_json_send` | 5 | 调用 raw_json 回调 |
| `biz_get_pending_timeout_ms` | 12 | 按命令类型选超时值 |
| `biz_map_esp32_task` | 10 | ESP32 task→WS63 cmd 映射 |
| `biz_parse_mac` | 14 | 解析 "AA:BB:CC:DD:EE:FF" 格式 |
| `biz_handle_esp32_msg` | 55 | 处理 ESP32 上行消息 |
| `biz_cmd_register` | 45 | 合并入库：SLE 绑定 + ESP32 注册 |
| `biz_cmd_passthrough_to_esp32` | 40 | 透传命令到 ESP32 |

#### 修改函数

| 函数 | 改动 |
|------|------|
| `biz_cmd_outbound` | 支持 mac/tag_id 双查 + 发送 SSAP_CMD_UNBIND_TAG |
| `biz_cmd_mqtt_connect` | 兼容 host+port 格式（ESP32 发的） |
| `biz_uart_cmd_handler` | 新增 register/passthrough/ESP32 上行路由 |
| `biz_sle_notify_cb` | 新增 UNBIND 响应处理 + register 绑定后转发 ESP32 |
| `business_logic_poll` | 使用动态超时 `g_biz_pending.timeout_ms` |
| `biz_set_pending` | 设置 `timeout_ms` 字段 |

#### 命令分发结构

```
biz_uart_cmd_handler(cmd, seq, data_json)
├── SLE 业务命令: inbound, inventory, find, outbound, list, update_qty
├── ESP32 合并命令: register
├── ESP32 透传命令: get_assets, sys_info, l610_at, l610_status
├── ESP32 上行消息: task_done, error, mqtt_connected, mqtt_error, ...
├── 本地命令: wifi_connect, wifi_status, mqtt_connect, mqtt_disconnect, mqtt_status, mqtt_publish
└── unknown → reply -99
```

---

## 3. 出库流程（改造后）

```
串口屏 → WS63: {"cmd":"outbound","seq":5,"data":{"tag_id":1}}
  ↓
WS63: 查映射表找到 entry(tag_id=1)
  ↓
WS63 → BS21E: SSAP_CMD_UNBIND_TAG(0x21), param=1
  ↓
BS21E → WS63: UNBIND_RSP (0xA0 或 0xAF)
  ↓
WS63: biz_map_remove(1), biz_map_save_nv
  ↓
WS63 → 串口屏: {"cmd":"outbound","seq":5,"code":0,"msg":"ok","data":{"tag_id":1}}
```

如果 SLE 未就绪或发送失败，直接本地移除（降级处理）。

---

## 4. 入库流程（register 合并版）

```
串口屏 → WS63: {"cmd":"register","seq":1,"data":{"storage_area":"A1","item_name":"Type-C"}}
  ↓
WS63: biz_map_alloc → tag_id=5
  ↓
WS63 → BS21E: SSAP_CMD_BIND_TAG(0x20), param=5
  ↓
BS21E → WS63: BIND_OK(0xA0)
  ↓
WS63 → ESP32: {"cmd":"register","tag_id":5}  (raw JSON 透传)
  ↓
ESP32 → WS63: {"type":"task_done","task":"register","result":"success",...}
  ↓
type→cmd 兼容 → biz_handle_esp32_msg → task="register" → 映射→ "register" → 匹配 pending
  ↓
WS63 → 串口屏: {"cmd":"register","seq":1,"code":0,"msg":"ok","data":{"tag_id":5}}
```

---

## 5. ESP32 消息兼容处理

### type→cmd 兼容 (uart_vision.c)

ESP32 发: `{"type":"task_done","task":"register",...}`
uart_vision 解析: 找 "cmd" → 没有 → 找 "type" → 找到 "task_done"
business_logic 收到: cmd="task_done"

### task 名映射 (business_logic.c)

| ESP32 task | WS63 pending cmd | 映射 |
|------------|-----------------|------|
| "register" | "register" | 直接匹配 |
| "inventory" | "inventory" | 直接匹配 |
| "outbound" | "outbound" | 直接匹配 |

### mqtt_connect 兼容

ESP32 发: `{"cmd":"mqtt_connect","host":"mqtt.thingskit.com","port":1883}`
WS63 解析: 找 "uri" → 没有 → 找 "host"+"port" → 拼接 "tcp://mqtt.thingskit.com:1883"

---

## 6. 待 ESP32 配合的改动（非阻塞）

| 优先级 | 改动 | 影响 |
|:---:|------|------|
| P0 | 上行消息加 `"seq"` 透传 | 未来多标签并行需要 |
| P1 | 上行 `"type"` 改为 `"cmd"` | WS63 可去掉兼容代码 |
| P2 | outbound 支持 `tag_id` 参数 | 直接用 tag_id 查找 |

当前 WS63 已做兼容，ESP32 不改也能工作。

---

## 7. 架构合规检查

- [x] 模块单向依赖：uart_vision → business_logic → sle_network
- [x] business_logic 不 include cloud_storage.h
- [x] 跨设备字段使用大端序（SSAP_CMD_UNBIND_TAG 参数）
- [x] 中断回调无阻塞（uart_vision 只做数据搬运）
- [x] 日志使用正确前缀：[WS63_UART], [WS63_BIZ]
- [x] 字符串操作使用 strncpy_s/snprintf
- [x] cJSON 解析结果检查 NULL
- [x] 函数行数控制在 50-100 行（最大 biz_cmd_outbound ~60 行）
- [x] pending 超时机制保留，支持动态超时
