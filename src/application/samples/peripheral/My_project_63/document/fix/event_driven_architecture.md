# 事件驱动架构改造 — 子任务清单

> 日期: 2026-05-26
> 目标: 轮询→事件驱动 + SLE非阻塞 + UART2串口屏 + 白名单去重 + CPU监控
> 约束: 单线程(My63Task), 函数≤50行, 中文注释, 高内聚低耦合

---

## 已完成的旧逻辑（不重复）

以下改造已在先前阶段完成，本次不再重复：

| 阶段 | 文档 | 内容 |
|------|------|------|
| Phase 1 | phase1_protocol_sync_fix.md | SSAP_RSP_UNBIND_OK、0xA1 分发、outbound 区分 |
| Phase 2 | phase2_scan_restructure_fix.md | scan_table、seek_result_cb 重构、connect_by_tag |
| Phase 3 | phase3_business_logic_fix.md | biz_map_add、register 流程、outbound 部分/全量 |
| Phase 4 | mqtt_gateway_publish&rpc.md | MQTT 网关上云 topic/格式/订阅 |

---

## 本次新需求

用户提出的新改造需求：

1. **轮询→事件驱动**: 主循环从 `osal_msleep(10)` 改为 `osEventFlagsWait`
2. **SLE 回调不阻塞 bt_service**: 回调只做 memcpy+入队，业务在主循环处理
3. **广播载荷静态化**: 使用静态 buffer + 偏移量修改字节
4. **广播间隔 500ms**: 已在 CLAUDE.md 更新（0x320）
5. **status 语义**: 0=空闲, 1=寻物, 2=使用中, 3=未配网
6. **DMA+IDLE+CSV 解析**: UART2 串口屏收发
7. **白名单去重**: TagListEntry 数组 + 时间窗去重
8. **status 映射**: BS21E→WS63 上云值转换
9. **串口屏分发**: `@in`/`@out`/`@inv`/`@find`/`@back` 命令处理
10. **CPU 监控**: idle hook 非轮询方式测量 CPU 占用率

---

## Phase 1: 基础设施 — packed 结构体 + 类型定义 (任务 1-10)

> 新增结构体对齐 CLAUDE.md §4 规范，不改动已有业务逻辑

| # | 文件 | 任务 | 说明 | 状态 |
|---|------|------|------|------|
| 1 | shared_protocol.h | 新增 `struct sle_adv_msg` | 80B，SLE 广播原始消息入队载体 | ✅ |
| 2 | shared_protocol.h | 新增 `struct TagState` | 21B，扫描表条目（替换原 sle_scan_entry_t） | ✅ |
| 3 | shared_protocol.h | 新增 `struct TagListEntry` | 27B，白名单+去重双功能条目 | ✅ |
| 4 | shared_protocol.h | 新增宏 `SLE_ADV_RAW_MAX=64` / `TAG_LIST_MAX=32` / `DEDUP_WINDOW_MS=3000` | 队列和去重参数 | ✅ |
| 5 | shared_protocol.h | `_Static_assert` 验证三个结构体大小 | 防止编译器填充 | ✅ |
| 6 | sle_network.h | 新增 `sle_adv_queue_init()` / `sle_adv_queue_get()` 声明 | 消息队列 API | ✅ |
| 7 | sle_network.h | 新增事件标志宏 `EVENT_SLE_ADV` / `EVENT_UART1_RX` / `EVENT_UART2_RX` / `EVENT_TIMER` | 主循环事件源 | ✅ |
| 8 | business_logic.h | 新增 `biz_ud_cmd_handler_t` 回调类型 | 串口屏命令回调签名 | ✅ |
| 9 | business_logic.h | 新增 `biz_register_screen_cb()` 声明 | 注册串口屏回调 | ✅ |
| 10 | business_logic.h | 更新 `biz_tag_status_t` 枚举: IDLE=0, FINDING=1, IN_USE=2, NOT_PROVISIONED=3 | 对齐 BS21E 新 status | ✅ |

## Phase 2: SLE 非阻塞回调 — osMessageQueue (任务 11-20)

> 核心: my63_seek_result_cb 只做 memcpy+osMessageQueuePut+return，不阻塞 bt_service

| # | 文件 | 任务 | 说明 | 状态 |
|---|------|------|------|------|
| 11 | sle_network.c | 新增 `#include "cmsis_os2.h"` | RTOS2 API 头文件 | ✅ |
| 12 | sle_network.c | 新增静态变量 `g_adv_queue` (osMessageQueueId_t) | 消息队列句柄 | ✅ |
| 13 | sle_network.c | 实现 `sle_adv_queue_init()`: 创建 256 条队列，每条 sizeof(sle_adv_msg) | 队列初始化 | ✅ |
| 14 | sle_network.c | 改造 `my63_seek_result_cb`: 去掉所有 osal_printk（6-8处） | 消除阻塞源 | ✅ |
| 15 | sle_network.c | 改造 `my63_seek_result_cb`: 去掉 `shared_protocol_unpack_adv` 调用 | 协议解析移到主循环 | ✅ |
| 16 | sle_network.c | 改造 `my63_seek_result_cb`: 去掉 `scan_table_add_or_update` 调用 | 业务逻辑移到主循环 | ✅ |
| 17 | sle_network.c | 改造 `my63_seek_result_cb`: memcpy raw+addr+rssi → osMessageQueuePut → return | 非阻塞核心 | ✅ |
| 18 | sle_network.c | 新增 `sle_adv_dequeue()`: 出队 → unpack_adv → scan_table_update → 返回处理条数 | 主循环调用 | ✅ |
| 19 | sle_network.c | `sle_adv_dequeue()` 中广播载荷使用静态 buffer + 偏移量操作 | 静态化要求 | ✅ |
| 20 | sle_network.c | `sle_network_init()` 中调用 `sle_adv_queue_init()` | 初始化串联 | ✅ |

## Phase 3: UART2 串口屏模块 — DMA+IDLE+CSV (任务 21-30)

> 新建 uart_display 模块，UART2 独立实例，CSV 文本帧协议

| # | 文件 | 任务 | 说明 | 状态 |
|---|------|------|------|------|
| 21 | uart_display.h | 新建头文件: `ud_cmd_handler_t` 回调类型 | `void (*)(const char *cmd, const char *params)` | ✅ |
| 22 | uart_display.h | 定义常量 `UD_LINE_MAX=256` / `UD_RING_SIZE=1024` | 缓冲区大小 | ✅ |
| 23 | uart_display.h | 声明 `uart_display_init()` / `uart_display_poll()` / `uart_display_send()` | 模块 API | ✅ |
| 24 | uart_display.c | 实现 `uart_display_init()`: UART2 DMA+IDLE 中断初始化 | 硬件初始化 | ✅ |
| 25 | uart_display.c | 实现 `ud_uart_rx_cb()`: IDLE 中断 → 写入 ring buffer | 中断回调（非阻塞） | ✅ |
| 26 | uart_display.c | 实现 `ud_parse_frame()`: 从 ring buffer 按 `\r\n` 分割帧 | 帧切割 | ✅ |
| 27 | uart_display.c | 实现 `ud_dispatch_line()`: 解析 `@` 开头 → 提取 cmd + 参数 | 上行帧解析 | ✅ |
| 28 | uart_display.c | 实现 `ud_send_frame()`: 组装 `#cmd,param1,param2\r\n` 发送 | 下行帧组装 | ✅ |
| 29 | uart_display.c | 实现 `ud_tag_id_to_str()` / `ud_str_to_tag_id()`: `"0005"` ↔ uint16_t | Tag ID 格式转换 | ✅ |
| 30 | uart_display.c | 实现 `uart_display_poll()`: 调用 ud_parse_frame + ud_dispatch_line | 主循环调用入口 | ✅ |

## Phase 4: 业务逻辑改造 — 白名单+去重+status+屏分发 (任务 31-40)

> 在已有 business_logic.c 基础上新增功能，不改动已有 register/outbound/inventory 逻辑

| # | 文件 | 任务 | 说明 | 状态 |
|---|------|------|------|------|
| 31 | business_logic.c | 新增静态数组 `g_biz_tag_list[TAG_LIST_MAX]` | 白名单+去重条目 | ✅ |
| 32 | business_logic.c | 实现 `biz_tag_list_find_by_mac()`: 按 MAC 查找 TagListEntry | O(n) 线性查找 | ✅ |
| 33 | business_logic.c | 实现 `biz_tag_list_update()`: 更新 last_seen_ms + rssi | 扫描表同步 | ✅ |
| 34 | business_logic.c | 实现 `biz_is_whitelisted()`: 查 biz_tag_map 判定是否已注册 | 白名单核心 | ✅ |
| 35 | business_logic.c | 实现 `biz_should_publish()`: `now - last_publish_ms < DEDUP_WINDOW_MS` → 跳过 | 时间窗去重 | ✅ |
| 36 | business_logic.c | 实现 `biz_map_status_to_cloud()`: BS21E(0/1/2/3) → WS63(0/1/2/3) 映射 | status 映射核心 | ✅ |
| 37 | business_logic.c | 实现 `biz_handle_sle_adv()`: 主循环调用，串联 白名单→去重→status映射→MQTT上云 | SLE 数据处理流水线 | ✅ |
| 38 | business_logic.c | 实现 `biz_handle_screen_cmd()`: 解析 `@in`/`@out`/`@inv`/`@find`/`@back` 分发 | 串口屏命令入口 | ✅ |
| 39 | business_logic.c | 实现 `biz_screen_reply()`: 调用 ud_send_frame 发送 `#TAG`/`#DONE`/`#ERR` 等 | 串口屏回复封装 | ✅ |
| 40 | business_logic.c | 注册串口屏回调: `uart_display_register_cmd_handler(biz_handle_screen_cmd)` | 回调串联 | ✅ |

## Phase 5: 事件驱动主循环 (任务 41-45)

> 改造 main.c 主循环，从轮询改为事件等待

| # | 文件 | 任务 | 说明 | 状态 |
|---|------|------|------|------|
| 41 | main.c | 新增 `#include "cmsis_os2.h"` + `#include "../components/uart_display/uart_display.h"` | 头文件 | ✅ |
| 42 | main.c | 新增 `g_my63_events` (osEventFlagsId_t) 全局事件句柄 | 事件标志 | ✅ |
| 43 | main.c | 改造主循环: `osEventFlagsWait(g_my63_events, ALL_EVENTS, osFlagsWaitAny, 100)` | 替代 osal_msleep(10) | ✅ |
| 44 | main.c | 主循环分发: UART1_RX→uart_vision_poll, UART2_RX→uart_display_poll, SLE_ADV→sle_adv_dequeue+biz_handle_sle_adv, TIMER→heartbeat+timeout | 事件分发 | ✅ |
| 45 | main.c | 初始化串联: `uart_display_init()` + 注册回调 | 模块注册 | ✅ |

## Phase 6: CPU 监控 (任务 46-48)

> 使用 idle task 计数法，非轮询，心跳时打印

| # | 文件 | 任务 | 说明 | 状态 |
|---|------|------|------|------|
| 46 | main.c | 新增静态变量 `g_idle_count` + `g_total_count` | 计数器 | ✅ |
| 47 | main.c | 实现 `my63_idle_hook()`: `g_idle_count++` | 注册到 LiteOS idle task | ✅ |
| 48 | main.c | 实现 `my63_cpu_report()`: 心跳时打印 `cpu=%u%%` = `(1 - idle/total)*100` | 非轮询测量 | ✅ |

## Phase 7: 文档与验证 (任务 49-50)

| # | 文件 | 任务 | 说明 | 状态 |
|---|------|------|------|------|
| 49 | document/fix/event_driven_architecture.md | 更新本文档完成状态 | 变更记录 | ✅ |
| 50 | — | 编译验证 + 零错误零警告 | 验收标准 | ⬜ |

---

## 与已有代码的关系

| 已有模块 | 本次改动 | 不动的部分 |
|---------|---------|-----------|
| sle_network.c | 只改 seek_result_cb + 新增 queue/dequeue | connect_by_tag、scan_table、SSAP 逻辑不动 |
| business_logic.c | 只新增白名单/去重/映射/屏分发 | register、outbound、inventory、mqtt_connect 不动 |
| main.c | 改主循环结构 + 新增 CPU 监控 | 初始化流程、回调注册不动 |
| shared_protocol.h | 只新增结构体和宏 | 已有协议函数不动 |
| uart_display.c/h | 全新模块 | — |

## 技术约束

- **系统 API**: CMSIS-RTOS2 (`osEventFlagsNew/Set/Wait`, `osMessageQueueNew/Put/Get`)
- **函数行数**: ≤ 50 行
- **命名**: `模块前缀_动作` (如 `sle_adv_dequeue`, `biz_tag_list_find_by_mac`)
- **注释**: 关键核心处中文注释
- **日志前缀**: `[WS63_APP]`/`[WS63_NET]`/`[WS63_DISP]`/`[WS63_BIZ]`

## 依赖关系

```
Phase 1 (#1-10)  ──→ Phase 2 (#11-20) ──┐
                  ──→ Phase 3 (#21-30) ──┼──→ Phase 4 (#31-40) ──→ Phase 5 (#41-45) ──→ Phase 6 (#46-48) ──→ Phase 7 (#49-50)
```
