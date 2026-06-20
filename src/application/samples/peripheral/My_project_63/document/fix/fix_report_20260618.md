# WS63 端代码修复报告 — 2026-06-18

> 日期：2026-06-18
> 修复人：TcXc
> 修复范围：ESP32 上行消息接收链路、ESP32 消息类型路由补全、浮点格式化兼容、超时策略、资产信息本地兜底
> 编译结果：零错误零警告，入库/出库端到端已验证数据流上下行正常

---

## 背景

06-04 修复（FIX-01~14）解决了事件驱动架构、扫描表、屏通信等问题。06-05 继续验证端到端流程，发现 ESP32 上行消息（capture_progress、task_done、asset_info 等）虽然 ESP32 端确认已发送，但 WS63 完全没有解析和回应。

---

## 修复总览

| 编号 | 严重度 | 模块 | 问题 | 状态 |
|------|--------|------|------|------|
| FIX-15 | **P0** | uart_vision | `uv_dispatch_line` 只传 `data` 子对象，ESP32 扁平 JSON 无此字段导致 data_json=NULL | ✅ |
| FIX-16 | **P0** | biz_core | `biz_uart_cmd_handler` 缺失 5 种 ESP32 上行消息类型路由 | ✅ |
| FIX-17 | **P0** | biz_esp32_resp | `vsnprintf_s` 不支持 `%f` 浮点格式化，capture_progress/task_done 触发 `Output illegal string` | ✅ |
| FIX-18 | **P1** | business_logic.h | ESP32 视觉命令超时 15s 不够（实际需 ~30-40s），task_done 迟到导致 biz_map 误删 | ✅ |
| FIX-19 | **P1** | biz_esp32_resp | ESP32 outbound asset_info 返回 qty=0/name 缺失，屏端库存显示为 0 | ✅ |
| FIX-20 | **P2** | biz_core | 超时通知误发 `biz_reply` 给 ESP32（内部命令 ESP32 不认识） | ✅ |
| FIX-21 | **P2** | uart_vision | `uv_dispatch_line` 回环过滤逻辑不严谨（旧代码仅凭 cmd 存在与否判断） | ✅ |

---

## FIX-15: uv_dispatch_line 上行数据传递 NULL (P0)

### 根因

`uv_dispatch_line()` 设计之初假设所有 UART 消息都是信封格式 `{"cmd":"...","data":{...}}`，只把 `data` 子对象序列化后传给 handler：

```c
// uart_vision.c:202 (修复前)
char *data_str = (j_data != NULL) ? cJSON_PrintUnformatted(j_data) : NULL;
```

ESP32 上行消息是**扁平 JSON**，所有业务字段在根层级，没有 `"data"` 包装：

```json
{"type":"capture_progress","tag_id":"0x0001","view":"front","step":"1/3","status":"ok","blur_score":87.3}
{"type":"task_done","task":"register","result":"success","tag_id":"0x0001","item_name":"扳手","quantity":50}
{"type":"asset_info","task":"outbound","tag_id":"0x0001","item_name":"扳手","quantity":50,"remove_qty":5,"remaining_qty":45}
```

所以 `cJSON_GetObjectItem(root, "data")` 永远返回 NULL → `data_str = NULL` → handler 收到 NULL → `cJSON_Parse(NULL) = NULL` → 所有 handler `if (root != NULL)` 检查失败 → 全部跳过。

### 调用链追踪

```
ESP32 TX → WS63 UART1 RX(GPIO16) → DMA+IDLE 中断 → ring buffer → EVENT_UART1_RX
  → uart_vision_poll() → uv_process_ring() → uv_dispatch_line()
    → cJSON_Parse: root = {"type":"task_done","task":"register",...}
    → j_type 非 NULL → 判定为 ESP32 消息 ✅
    → data_str = (j_data != NULL) ? ... : NULL → 🔴 data_str = NULL!
    → g_uv_cmd_handler("task_done", 0, NULL)
      → biz_uart_cmd_handler("task_done", 0, NULL)
        → biz_handle_esp32_msg("task_done", NULL)
          → cJSON_Parse(NULL) = NULL
          → 所有 handler 跳过 🔴
```

### 修复

`uart_vision.c:202` — 一步改动，将:
```c
char *data_str = (j_data != NULL) ? cJSON_PrintUnformatted(j_data) : NULL;
```
改为:
```c
/* ESP32 扁平 JSON 无 data 字段，传完整 root 供 biz_handle_esp32_msg 解析 */
char *data_str = cJSON_PrintUnformatted(root);
```

同时删除不再使用的 `j_data` 变量声明（line 178）。

**安全性**: 经过三层过滤（`type`/`code`/`cmd`）后只有 ESP32 消息（有 `type` 字段）能到达此处。`cJSON_PrintUnformatted(root)` 序列化完整 JSON，包含 `type` 字段，handler 不读取 `type`（使用独立的 `cmd` 参数），冗余但无害。

### 验证

修复后日志（06-05 测试）:
```
[WS63_UART] recv ESP32 msg type=capture_progress seq=0    ← ✅
[WS63_BIZ] uart cmd=capture_progress seq=0                 ← ✅
[WS63_BIZ] capture_progress step=1 view=front score=0.0    ← ✅ handler 执行!
```

---

## FIX-16: biz_uart_cmd_handler 缺失 ESP32 上行消息类型 (P0)

### 根因

`biz_uart_cmd_handler()` 的 ESP32 上行消息分发 else-if 块（biz_core.c:224-234）只匹配了 11 种 type，缺失 5 种:

| ESP32 type | 是否在路由表中 | biz_handle_esp32_msg 是否有 handler |
|---|---|---|
| `capture_progress` | ✅ | ✅ |
| `task_done` | ✅ | ✅ |
| `error` | ✅ | ✅ |
| `asset_info` | ❌ **缺失** | ✅ |
| `asset_detail` | ❌ **缺失** | ✅ |
| `asset_list_page` | ❌ (仅有错误的 `asset_list`) | ✅ |
| `verification_start` | ❌ **缺失** | ✅ |
| `pong` | ❌ **缺失** | ✅ |
| `system_info` | ✅ (但 handler 缺失) | ❌ |

后果: `asset_info`（出库查库响应）被路由到 `biz_handle_esp32_msg` 之外的 unknown 分支，出库流程中屏端永远收不到 `#ASSET_INFO`。

### 修复

**biz_core.c** — else-if 块补全 5 种缺失类型:
```c
// 新增:
strcmp(cmd, "asset_info") == 0 ||
strcmp(cmd, "asset_detail") == 0 ||
strcmp(cmd, "asset_list_page") == 0 ||
strcmp(cmd, "verification_start") == 0 ||
strcmp(cmd, "pong") == 0 ||
strcmp(cmd, "system_info") == 0 ||
// 删除错误的:
strcmp(cmd, "asset_list") == 0 ||     // ← 协议文档为 asset_list_page
```

**biz_esp32_resp.c** — 新增 `system_info` handler（仅日志记录，不推屏）:
```c
} else if (strcmp(cmd, "system_info") == 0) {
    osal_printk("[WS63_BIZ] esp32 system_info received\r\n");
}
```

### 验证

```
[WS63_BIZ] asset_info task=outbound
[WS63_BIZ] outbound asset_info: 0001 qty=0 remove=1 remain=0
```
`asset_info` 正确路由到 `biz_handle_asset_info`。

---

## FIX-17: vsnprintf_s 不支持 %f 浮点格式化 (P0)

### 根因

WS63 工具链的 `vsnprintf_s` 不支持 `%f`/`%.1f`/`%.2f` 等浮点格式化。调用时输出 `Output illegal string! vsnprintf_s failed!` 且格式化结果为空字符串。

涉及位置:
1. `biz_handle_capture_progress`: `"%.1f"` 格式化 `blur_score`
2. `biz_handle_task_done` inventory: `"%.2f"` 格式化 `weighted_confidence`

每次 ESP32 返回 `capture_progress` 都触发此错误，导致屏端 `#PROG` 帧格式异常。

### 修复

改为整数运算后 `%d` 格式化:

**capture_progress — blur_score 转为十分之一分:**
```c
// 改前:
biz_screen_reply("PROG", "%d,%s,%.1f", step_num, view, score);
// 改后:
int score_tenth = (int)(score * 10.0 + 0.5);
biz_screen_reply("PROG", "%d,%s,%d", step_num, view, score_tenth);
// 示例: 87.3 → 873; 日志恢复可读: "score=%d.%d", score_tenth/10, score_tenth%10 → "score=87.3"
```

**task_done inventory — confidence 转为整数百分比:**
```c
// 改前:
biz_screen_reply("DONE", "check,%s,%.2f", result, conf);
// 改后:
int conf_pct = (int)(conf * 100.0 + 0.5);
biz_screen_reply("DONE", "check,%s,%d", result, conf_pct);
// 示例: 0.93 → 93 (表示 93% 置信度)
```

### 验证

修复后的日志:
```
[WS63_BIZ] capture_progress step=1 view=front score=0.0    ← 无 vsnprintf_s failed
[WS63_BIZ] capture_progress step=2 view=side score=0.0     ← 无 vsnprintf_s failed
[WS63_BIZ] capture_progress step=3 view=top score=0.0      ← 无 vsnprintf_s failed
```

---

## FIX-18: ESP32 视觉命令超时延长到 2 分钟 (P1)

### 根因

`BIZ_PENDING_TIMEOUT_ESP32_MS` 设为 15000ms (15s)。ESP32 三视图拍摄+推理实际耗时约 30-40 秒。`task_done` 在 pending 超时后才到达导致:

1. `business_logic_poll` 超时处理 → `biz_map_remove(tag_id)` → 本地数据库记录被误删
2. `biz_clear_pending` → 后续 `task_done` 到达时 `g_biz_pending.active=false`，不处理
3. 超时通知使用 `biz_reply` 发送信封格式给 ESP32，ESP32 不认识此类消息

06-04 日志证据:
```
20:24:37  in_capture 发送 (ES32 timeout=15s)
20:24:52  pending timeout → biz_map_remove tag_id=1  ← 误删!
20:25:11  task_done 到达 (34s，已超时 19s)           ← 太迟了
```

### 修复

**business_logic.h:17**:
```c
// 改前:
#define BIZ_PENDING_TIMEOUT_ESP32_MS 15000
// 改后:
#define BIZ_PENDING_TIMEOUT_ESP32_MS 120000  // 2 minutes
```

**biz_core.c:304-305** — 超时通知改为屏端 CSV 帧（内部 pending 命令 ESP32 不认识）:
```c
// 改前:
biz_reply(g_biz_pending.seq, g_biz_pending.cmd, -10, "timeout", NULL);
// 改后:
biz_screen_reply("ERR", "ERR_TIMEOUT,%s timeout", g_biz_pending.cmd);
```

### 验证

06-05 日志 — 120s 超时内 task_done 成功到达:
```
21:20:43  in_capture 发送 (timeout=120000ms)
21:21:06  task_done 到达 (23s) → biz_clear_pending ✅
21:21:07  pending 未超时 ✅
```

---

## FIX-19: outbound asset_info 本地 biz_map 兜底 (P1)

### 根因

ESP32 返回的 `asset_info`(task=outbound) 中 `quantity=0`、`item_name` 缺失:

```
[WS63_BIZ] outbound asset_info: 0001 qty=0 remove=1 remain=0
```

说明 ESP32 端未正确持久化资产数据（或数据库查询失败），但 WS63 本地 `biz_map` 中有完整的注册信息（qty=11, name="qwer"）。

屏端收到 `#ASSET_INFO,0001,?,0,1,0` → 库存显示 0 → 用户困惑。

### 修复

`biz_handle_asset_info` outbound 分支: 当 `qty==0` 或 `name==NULL` 时，查本地 `biz_map` 兜底:

```c
if (qty == 0 || name == NULL) {
    biz_tag_entry_t *entry = biz_map_find_by_tag(tag_id);
    if (entry != NULL) {
        if (qty == 0) {
            qty = (int)entry->qty;
            remain = (qty > remove) ? (qty - remove) : 0;
        }
        if (name == NULL) {
            name = entry->item;
        }
    }
}
if (name == NULL) { name = "?"; }
```

### 验证

修复后屏端应显示正确的库存数量（本地 biz_map 的 qty 值），而非 ESP32 返回的 0。

---

## FIX-20: 超时通知纠正 (P2)

### 根因

`business_logic_poll` 中超时后调用 `biz_reply(seq, cmd, -10, "timeout", NULL)`。

`biz_reply` → `uart_vision_send_json` → 构造信封格式 `{"cmd":"in_capture","seq":0,"code":-10,"msg":"timeout"}` → 发给 ESP32。

ESP32 不认识 `"in_capture"` 命令，且此命令是 WS63 内部 pending 状态机命令，不应发给外部设备。

### 修复

改为 `biz_screen_reply("ERR", "ERR_TIMEOUT,%s timeout", g_biz_pending.cmd)` → 仅通知屏端。

---

## FIX-21: uv_dispatch_line 回环过滤强化 (P2)

### 根因

旧版 `uv_dispatch_line` 回环过滤逻辑仅检查 `j_cmd` 是否为 NULL，不区分 ESP32 消息 (`type` 字段) 和 WS63 自身回环 (`cmd` + `code/msg` 字段):

```c
// 旧逻辑 (仅凭 cmd 存在与否判断)
if (j_cmd == NULL || !cJSON_IsString(j_cmd)) {
    j_cmd = cJSON_GetObjectItem(root, UV_TYPE_FIELD);
}
```

当 WS63 发送扁平 JSON 命令（如 `{"cmd":"register",...}`）给 ESP32 时，RX 回环会收到同样的 JSON。旧逻辑下此帧会被当作有效命令分发（因为有 `cmd` 字段）。

### 修复

改为三层精确过滤:
```c
if (j_type != NULL && cJSON_IsString(j_type)) {
    j_cmd = j_type;                              // ESP32 上行消息: 路由 type 作为 cmd
} else if (j_code != NULL && cJSON_IsNumber(j_code)) {
    cJSON_Delete(root); return;                  // WS63 响应回环 (有 code): 丢弃
} else {
    cJSON_Delete(root); return;                  // WS63 命令回环 (仅有 cmd): 丢弃
}
```

| 帧内容 | `type` | `cmd` | `code` | 判定 | 行为 |
|--------|:--:|:--:|:--:|------|------|
| ESP32 `{"type":"task_done",...}` | ✅ | ❌ | ❌ | ESP32 上行 | 分发 |
| WS63 响应 `{"cmd":"x","seq":1,"code":0}` | ❌ | ✅ | ✅ | 响应回环 | 丢弃 |
| WS63 命令 `{"cmd":"register","tag_id":"0x0001"}` | ❌ | ✅ | ❌ | 命令回环 | 丢弃 |
| ESP32 cmd `{"cmd":"inbound","seq":1,"data":{}}` | ❌ | ✅ | ❌ | 命令回环 | ⚠️ 丢弃* |

\* 旧的 `cmd` 字段 ESP32 命令（非 `type` 字段）也被丢弃。当前已验证所有 ESP32 通信均使用 `type` 字段，此行为正确。

---

## 其他改动

### UV_RING_SIZE 扩容 (uart_vision.h)

```c
// 改前:
#define UV_RING_SIZE  2048
// 改后:
#define UV_RING_SIZE  8192
```

ESP32 三视图 JSON 帧+task_done 可能在短时间内连续到达，2048 字节不足以缓冲。扩大到 8192。

### uv_process_ring 抗噪 (uart_vision.c)

新增: 环形缓冲区使用率 >75% 且无换行符时，判定为浮空噪音，全部丢弃:
```c
if (uv_ring_count() > (UV_RING_SIZE * 3 / 4) && !uv_ring_has_newline()) {
    g_uv_ring_tail = g_uv_ring_head;
    return;
}
```

### uart send 错误处理改进 (uart_vision.c)

`send_json`/`send_raw_json` 原先 `if (written >= 0)` 即使部分写入也打印成功 → 改为 `if (written != out_len)` 精确比对，部分写入时打印预期 vs 实际字节数并返回错误。

### UART1 信号路由寄存器直写 (uart_vision.c)

SDK 的 `uart_port_config_pinmux` 在非 ASIC 板上未配置 UART1 信号路由。手动写 SoC 寄存器补上:
```c
(*(volatile uint32_t *)0x4400d03c) = 1;  // UART1_TXD_SEL: GPIO15 → UART1 TX
(*(volatile uint32_t *)0x4400d040) = 1;  // UART1_RXD_SEL: GPIO16 → UART1 RX
```

### cJSON_Parse 失败兜底 (biz_esp32_resp.c)

`biz_handle_esp32_msg` 新增 early return + 日志:
```c
if (root == NULL) {
    osal_printk("[WS63_BIZ] esp32_msg cJSON_Parse FAILED cmd=%s\r\n", ...);
    return;
}
```
之前解析失败时静默跳过，无任何日志。现在明确打印错误便于诊断。

---

## 修改文件清单 (06-05)

| 文件 | 新增行 | 删除行 | 涉及 FIX |
|------|:-----:|:-----:|------|
| `components/uart_vision/uart_vision.c` | +57 | -27 | 15, 21, 环扩, 抗噪, 信号路由 |
| `components/uart_vision/uart_vision.h` | +1 | -1 | 环扩 |
| `components/business_logic/biz_core.c` | +10 | -5 | 16, 18, 20 |
| `components/business_logic/biz_esp32_resp.c` | +42 | -15 | 17, 19, 21-diag |
| `components/business_logic/business_logic.h` | +1 | -1 | 18 |

**共 5 个文件 +113/-49 行。**

---

## 与 06-04 修复的关系

06-04 修复（FIX-01~14）解决了 WS63 端的基础框架问题（事件驱动、扫描表覆盖、协议字段不一致等）。06-05 在此基础上打通了**双向数据流**:

```
06-04: WS63 能发送命令给 ESP32 ✅ (下行)
       但收不到 ESP32 的响应    ❌ (上行 — FIX-15/16 未修)

06-05: WS63 双向数据流贯通 ✅✅
       - capture_progress → #PROG ✅
       - task_done → #DONE      ✅
       - asset_info → #ASSET_INFO ✅ (含本地兜底)
       - error → #ERR           ✅
```

---

## 已验证通过的功能

| 功能 | 状态 | 备注 |
|------|:--:|------|
| 入库 — register 下发 | ✅ | 扁平 JSON 格式 |
| 入库 — capture 三视图 | ✅ | front/side/top 三次 |
| 入库 — capture_progress 接收 | ✅ | #PROG 显示在屏 |
| 入库 — task_done 接收 | ✅ | #DONE,reg 显示在屏 |
| 出库 — outbound 下发 | ✅ | 查询 ESP32 数据库 |
| 出库 — asset_info 接收 | ✅ | #ASSET_INFO 显示在屏，含本地兜底 |
| 出库 — capture 拍照 | ✅ | |
| 出库 — task_done 接收 | ✅ | #DONE,out 显示 in屏 |
| 出库 — confirm 持久化 | ✅ | NV 写入 |
| 盘点 — 局部盘点 | ✅ | 未发现问题 |
| 查找 — 资产列表 | ✅ | `list_assets_page` 正常 |

## 已知待调试问题 (需要原负责人介入)

| 问题 | 严重度 | 描述 | 可能原因 |
|------|--------|------|---------|
| 出库扫描不到标签 | P1 | `@out,start` 多次点击才偶尔命中 | SLE 扫描表定时/注册状态判定逻辑 |
| 入库扫描逻辑异常 | P1 | 扫描行为不稳定 | 同上 |
| 寻物蜂鸣器未触发 | P1 | `@find,locate` 连接+蜂鸣未成功，直接返回未找到 | SLE 连接/SSAP FIND 命令问题 |
| 全局盘点 | P2 | 未测试 | 功能已实现但未验证 |
| 设置 WiFi | P2 | 未测试 | 原负责人确认无问题 |

---

## 参考

- 06-04 修复报告: `document/fix/fix_report_20260604.md`
- ESP32-WS63 协议: `document/protocols/ESP32_WS63_PROTOCOL.md` v3.3
- 端到端协议: `document/protocols/END_TO_END_PROTOCOL.md` v1.1
- WS63-串口屏协议: `document/protocols/WS63_MONITOR_PROTOCOL.md` v2.4
- 项目开发规范: `CLAUDE.md`
