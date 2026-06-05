# WS63 端代码修复报告 — 2026-06-04

> 日期：2026-06-04
> 修复人：TcXc（接手）
> 修复范围：事件驱动架构、扫描表、屏通信、ESP32 协议对齐
> 编译结果：零错误零警告，所有改动已验证编译通过

---

## 修复总览

| 编号 | 严重度 | 模块 | 问题 | 影响 | 状态 |
|------|--------|------|------|------|------|
| FIX-01 | **P0** | sle_network / uart / main | 事件驱动架构 `osEventFlagsSet` 从未调用 | UART1/UART2/SLE 广播数据全部不被处理，整机无响应 | ✅ 已修复 |
| FIX-02 | **P0** | sle_network | 扫描表用 tag_id 做主键，未注册标签全为 0 | 多个 BS21E 相互覆盖，扫描表永远只有一个条目 | ✅ 已修复 |
| FIX-03 | **P0** | sle_network | `tag_id=0` 的广播被显式过滤 | 所有未注册标签的广播在 `sle_adv_extract_and_update` 中被丢弃 | ✅ 已修复 |
| FIX-04 | **P0** | biz_screen_cmd | `@in,start` 不区分已注册/未注册 | 屏永远显示 `#TAG,0000`，TF 卡存的都是 0x0000 | ✅ 已修复 |
| FIX-05 | **P0** | biz_screen_cmd | `#VERIFY` 帧从未发送 | 入库验证式更新（Mode B）入口完全不可达 | ✅ 已修复 |
| FIX-06 | **P1** | biz_sle | ESP32 JSON 字段 `"qty"` vs 协议 `"quantity"` | ESP32 无法解析数量字段 | ✅ 已修复 |
| FIX-07 | **P1** | biz_screen_cmd | `@out,confirm` 持久化为 TODO | 出库确认后不写 NV，重启数据丢失 | ✅ 已修复 |
| FIX-08 | **P1** | biz_screen_cmd | `@inv,all/tag/zone` 命令被静默丢弃 | 协议规定的盘点命令无响应 | ✅ 已修复 |
| FIX-09 | **P1** | app/main.c | `@setting,disconnect` 不真断 WiFi | 屏提示断开但 WiFi 仍连接 | ✅ 已修复 |
| FIX-10 | **P1** | biz_esp32_cmd | `biz_cmd_inbound` JSON key `zone`/`item` | 与协议 `storage_area`/`item_name` 不一致 | ✅ 已修复 |
| FIX-11 | **P1** | biz_esp32_resp | `#DONE,out,success` 缺 `remaining_qty` | 屏端无法显示剩余库存 | ✅ 已修复 |
| FIX-12 | **P2** | biz_esp32_resp | error code 默认 `UNKNOWN` | 与协议 `ERR_UNKNOWN` 不一致 | ✅ 已修复 |
| FIX-13 | **P2** | biz_screen_cmd / sle | 残留中文 → 英文 | GB2312 屏渲染 UTF-8 中文为乱码（~15 处） | ✅ 已修复 |
| FIX-14 | **P2** | biz_screen_cmd | `@find,start` 命令无匹配分支 | 屏发寻物命令被静默丢弃 | ✅ 已修复 |

---

## FIX-01: 事件驱动架构 osEventFlagsSet 从未调用 (P0)

### 根因

提交 `3cabe046`（feat: 事件驱动架构改造）将主循环从 10ms 固定轮询改为 `osEventFlagsWait()` 阻塞等待，但**全项目零次调用 `osEventFlagsSet()`**。`g_my63_events` 在 `main.c:22` 声明但无 `extern`，任何其他模块都无法引用。

```c
// main.c:301-336（修复前）
for (;;) {
    uint32_t flags = osEventFlagsWait(g_my63_events, EVENT_ALL,
        osFlagsWaitAny, 100);  // 永远超时，flags 永远是 osFlagsErrorTimeout

    if (flags & EVENT_UART1_RX) { uart_vision_poll(); }    // 永不执行 — 死代码
    if (flags & EVENT_UART2_RX) { uart_display_poll(); }   // 永不执行 — 死代码
    if (flags & EVENT_SLE_ADV) {                            // 永不执行 — 死代码
        sle_adv_dequeue();
        biz_handle_sle_adv();
    }

    // 只有以下无条件代码每 100ms 执行一次：
    cloud_storage_poll();
    my63_poll_sle(now);
    business_logic_poll();
    my63_heartbeat(now);
}
```

三个中断回调正常被 SDK 触发，数据写入缓冲区，但主循环不知道：

| 回调 | 数据去向 | 消费入口 | 消费入口执行？ |
|------|---------|---------|:---:|
| `ud_uart_rx_cb` (UART2 屏) | `g_ud_ring[1024]` | `uart_display_poll()` | ❌ |
| `uv_uart_rx_cb` (UART1 ESP32) | `g_uv_ring[2048]` | `uart_vision_poll()` | ❌ |
| `my63_seek_result_cb` (SLE 扫描) | `g_adv_queue[256]` | `sle_adv_dequeue()` | ❌ |

### 修复

1. `sle_network.h` — 添加 `extern osEventFlagsId_t g_my63_events;` 及 `#include "cmsis_os2.h"`
2. `sle_network.c` `my63_seek_result_cb()` — `osMessageQueuePut` 后加 `osEventFlagsSet(EVENT_SLE_ADV)`
3. `uart_display.c` `ud_uart_rx_cb()` — `ud_ring_push` 后加 `osEventFlagsSet(EVENT_UART2_RX)`
4. `uart_vision.c` `uv_uart_rx_cb()` — `uv_ring_push` 后加 `osEventFlagsSet(EVENT_UART1_RX)`
5. `main.c` — 心跳日志加 `scan_cnt` 字段；无条件区加 `uart_vision_poll()` + `uart_display_poll()` 防御性回退

### 涉及文件

- `components/sle_network/sle_network.h` (+3 行)
- `components/sle_network/sle_network.c` (+4 行)
- `components/uart_display/uart_display.c` (+8 行 includes + 回调)
- `components/uart_vision/uart_vision.c` (+8 行 includes + 回调)
- `app/main.c` (+7 行)

---

## FIX-02: 扫描表 tag_id 做主键导致多标签覆盖 (P0)

### 根因

`scan_table_add_or_update()` 只用 `tag_id` 匹配已有条目。所有未注册 BS21E 标签广播 `tag_id=0`，导致：

```
BS21E-A (MAC=A, tag=0) → scan_table slot[0] 创建
BS21E-B (MAC=B, tag=0) → scan_table slot[0] 覆盖为 MAC=B  ← A 丢失
BS21E-C (MAC=C, tag=0) → scan_table slot[0] 覆盖为 MAC=C  ← B 丢失
```

扫描表永远只有一个条目。

### 修复

`scan_table_add_or_update()` 增加 MAC 优先匹配（3 层查找）：

```c
// 1. MAC 匹配优先（不同 BS21E 可能共享 tag_id=0）
if (mac != NULL) {
    for (...) if (used && memcmp(mac, 6) == 0) { update; return; }
}
// 2. tag_id 匹配（已注册标签回退）
if (tag_id != 0) {
    for (...) if (used && tag_id match) { update; return; }
}
// 3. 新条目
for (...) if (!used) { create; return; }
```

### 涉及文件

- `components/sle_network/sle_network.c`

---

## FIX-03: tag_id=0 广播被显式过滤 (P0)

### 根因

`sle_adv_extract_and_update()` 在成功解析 manufacturer data 后：

```c
// sle_network.c:147（修复前）
if (s_adv.tag_id != 0) {
    scan_table_add_or_update(...);   // 从未执行
    return 1;
}
return 0;  /* tag_id=0 */            // 所有广播在这里返回
```

`[WS63_SHARED] unpack BE ok` 日志说明解析成功，但随即被 `tag_id != 0` 条件过滤。

### 修复

移除 `tag_id != 0` 守卫，允许 tag_id=0 进入扫描表（预分配逻辑在 FIX-04 中处理）。

### 涉及文件

- `components/sle_network/sle_network.c`

---

## FIX-04: @in,start tag_id 预分配 (P0)

### 根因

`biz_screen_in_start()` 直接从扫描表读取 `tag_id` 发给屏。所有未注册标签 tag_id=0 → 屏永远显示 `0000` → ESP32 TF 卡存的都是 `0x0000` → BIND 后才分配正式 tag_id，但 TF 卡已经存了 0x0000。

### 修复

1. 新增 `sle_network_update_scan_tag_id(mac, new_tag_id)` API — 按 MAC 更新扫描表 tag_id
2. `biz_screen_in_start()` — tag_id=0 时预分配新 ID（遍历 biz_map 找最大值 +1），预创建 biz_map 条目，同步更新扫描表
3. `biz_screen_in_cancel()` — 取消时清理预分配的 biz_map 条目（status 仍为 IDLE 的）

```
修复后：
BS21E-A(tag=0,MAC=A) → 扫描表(MAC=A,tag=1) → 屏 #TAG,0001 → TF卡 0x0001 → BIND OK✅
BS21E-B(tag=0,MAC=B) → 扫描表(MAC=B,tag=2) → 屏 #TAG,0002 → TF卡 0x0002 → BIND OK✅
```

### 涉及文件

- `components/sle_network/sle_network.h` (新增 API 声明)
- `components/sle_network/sle_network.c` (新增 `sle_network_update_scan_tag_id` 实现)
- `components/business_logic/biz_screen_cmd.c` (预分配 + cancel 清理)
- `components/business_logic/biz_screen_cmd.c` (添加 `#include "securec.h"`)

---

## FIX-05: #VERIFY 帧从未发送 (P0)

### 根因

`biz_screen_in_start()` 使用 `biz_scan_find_best(false, &idx)` 只搜索**未注册**标签。当所有标签均已注册时返回 `SCAN_ALL_REGISTERED`，代码只发送 `#MSG,All tags registered`。

协议定义的 `#VERIFY,<id>,<name>,<area>,<qty>` 帧用于触发屏端 sys0=5 验证式更新模式，全项目零匹配。

### 修复

`biz_screen_in_start()` 增加 `SCAN_ALL_REGISTERED` 分支：
1. 调用 `biz_scan_find_best(true, &ridx)` 取最强的已注册标签
2. 查 `biz_map` 获取 `item`/`zone`/`qty`
3. 发送 `#VERIFY,<id>,<name>,<area>,<qty>`

### 涉及文件

- `components/business_logic/biz_screen_cmd.c`

---

## FIX-06: ESP32 register JSON qty → quantity (P1)

### 根因

`biz_sle.c` 在 BIND_OK 回调中重发 register JSON 给 ESP32，使用字段名 `"qty"`。协议 `ESP32_WS63_PROTOCOL.md` 规定字段名为 `"quantity"`。

```c
// biz_sle.c:73（修复前）
"\"item_name\":\"%s\",\"storage_area\":\"%s\",\"qty\":%u"
```

### 修复

`"qty"` → `"quantity"`。

### 涉及文件

- `components/business_logic/biz_sle.c`

---

## FIX-07: @out,confirm 持久化 (P1)

### 根因

`biz_screen_out_confirm()` 只有 `/* TODO: 持久化 */` 注释，未调用 `biz_map_save_nv()`。协议规定 confirm 步骤应写 NV 持久化。

### 修复

添加 `biz_map_save_nv()` 调用。

### 涉及文件

- `components/business_logic/biz_screen_cmd.c`

---

## FIX-08: @inv,all/tag/zone 命令匹配 (P1)

### 根因

`biz_screen_dispatch_check()` 只匹配 `global`/`specific`/`capture`/`photo`/`cancel` 子命令。协议 `WS63_uart_protocol.md` 定义的 `@inv,all`、`@inv,tag,<id>`、`@inv,zone,<zone>` 全部无匹配分支，被静默丢弃。

### 修复

添加三个子命令分支：
- `@inv,all` → `biz_screen_check_global()`（同 `@check,global`）
- `@inv,tag,<id>` → `biz_screen_check_specific(params + 4)`（跳过 "tag,"）
- `@inv,zone,<zone>` → `biz_screen_check_global()`（暂降级为全局，待屏端支持区域筛选）

### 涉及文件

- `components/business_logic/biz_screen_cmd.c`

---

## FIX-09: @setting,disconnect WiFi 真断开 (P1)

### 根因

`biz_screen_setting_disconnect()` 调用 `g_biz_wifi_cmd_cb(NULL, NULL)`，该回调在 ssid/psk 均为 NULL 时只返回 `cs_wifi_get_state()`（状态查询），未调用 `cs_wifi_disconnect()`。

### 修复

`main.c` `my63_wifi_cmd_cb()` 中 ssid/psk 均为 NULL 时调用 `cs_wifi_disconnect()` 而非 `cs_wifi_get_state()`。

### 涉及文件

- `app/main.c`

---

## FIX-10: biz_cmd_inbound JSON key 对齐 (P1)

### 根因

`biz_cmd_inbound()` 从 ESP32 JSON 读取 `"zone"` 和 `"item"` 字段。协议 `END_TO_END_PROTOCOL.md` 规定 ESP32 使用 `"storage_area"` 和 `"item_name"`。

### 修复

`cJSON_GetObjectItem(root, "zone")` → `cJSON_GetObjectItem(root, "storage_area")`
`cJSON_GetObjectItem(root, "item")` → `cJSON_GetObjectItem(root, "item_name")`

### 涉及文件

- `components/business_logic/biz_esp32_cmd.c`

---

## FIX-11: #DONE,out,success 补充 remaining_qty (P1)

### 根因

`biz_handle_task_done()` 处理 outbound task_done 时发送 `#DONE,out,success`，未包含 `remaining_qty`。协议格式为 `#DONE,out,success,<new_qty>`。

### 修复

从 ESP32 JSON 读取 `remaining_qty` 字段，拼入下行帧：`#DONE,out,success,45`。

### 涉及文件

- `components/business_logic/biz_esp32_resp.c`

---

## FIX-12: error code 默认值 (P2)

### 根因

ESP32 返回 error 时如 `code` 字段缺失，WS63 默认发送 `#ERR,UNKNOWN,<msg>`。协议错误码表使用 `ERR_UNKNOWN`。

### 修复

默认值 `"UNKNOWN"` → `"ERR_UNKNOWN"`。

### 涉及文件

- `components/business_logic/biz_esp32_resp.c`

---

## FIX-13: 残留中文字符串 → 英文 (P2)

### 根因

提交 `bf27065e` 将 `biz_screen_cmd.c` 中 ~19 处中文改为英文，但仍有 ~15 处中文残留在 `biz_screen_cmd.c`、`biz_sle.c`、`biz_esp32_resp.c`。源码 UTF-8 编码 → 淘晶驰 T1 屏 GB2312 渲染为乱码。

### 修复

所有 `biz_screen_reply()` 调用中的中文字符串替换为英文 ASCII（ASCII 是 UTF-8 和 GB2312 的公共子集）。

| 文件 | 处数 |
|------|:---:|
| `biz_screen_cmd.c` | ~12 |
| `biz_sle.c` | 2 |
| `biz_esp32_resp.c` | 2 |

### 涉及文件

- `components/business_logic/biz_screen_cmd.c`
- `components/business_logic/biz_sle.c`
- `components/business_logic/biz_esp32_resp.c`

---

## FIX-14: @find,start 命令匹配 (P2)

### 根因

`biz_screen_dispatch_find()` 只匹配 `list`/`locate`/`stop`/`cancel`，屏端协议发送的 `@find,start,<id>` 无匹配分支。

### 修复

添加 `strncmp(params, "start", 5)` 分支，复用 `biz_screen_find_locate(params + 6)`。

### 涉及文件

- `components/business_logic/biz_screen_cmd.c`

---

## 修改文件清单

| 文件 | 改动 | 涉及 FIX |
|------|:---:|------|
| `app/main.c` | 心跳增强 + 防御性轮询 + WiFi 断开修复 | 01, 09 |
| `components/sle_network/sle_network.h` | `extern g_my63_events` + `cmsis_os2.h` + 新 API 声明 | 01, 04 |
| `components/sle_network/sle_network.c` | `osEventFlagsSet` + MAC 扫描表 + 移除 tag_id=0 过滤 + `sle_network_update_scan_tag_id` | 01, 02, 03, 04 |
| `components/uart_display/uart_display.c` | `osEventFlagsSet(EVENT_UART2_RX)` + includes | 01 |
| `components/uart_vision/uart_vision.c` | `osEventFlagsSet(EVENT_UART1_RX)` + includes | 01 |
| `components/business_logic/biz_screen_cmd.c` | #VERIFY + 预分配 + cancel清理 + inv命令 + @find,start + 中文→英文 + out持久化 | 04, 05, 07, 08, 13, 14 |
| `components/business_logic/biz_sle.c` | `"qty"`→`"quantity"` + 中文→英文 | 06, 13 |
| `components/business_logic/biz_esp32_cmd.c` | `"zone"`/`"item"` → `"storage_area"`/`"item_name"` | 10 |
| `components/business_logic/biz_esp32_resp.c` | `remaining_qty` + error code + 中文→英文 | 11, 12, 13 |

**共 9 个文件，14 项修复，零错误编译通过。**

---

## 验证状态

- [x] 编译零错误零警告
- [x] SLE 广播解包正常（日志 `unpack BE ok`）
- [x] 串口屏命令收发正常（日志 `[WS63_DISP] recv cmd=in params=start`）
- [x] 扫描表多标签独立条目（MAC 匹配）
- [ ] 入库全流程（需 BS21E 标签在场 + ESP32 配合）
- [ ] 验证式更新流程（需已注册标签在场）
- [ ] 出库全流程（需已注册标签在场 + ESP32 配合）
