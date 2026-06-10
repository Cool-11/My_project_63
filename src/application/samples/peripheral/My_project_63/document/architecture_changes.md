# 架构改造文件清单

> 从"事件驱动架构讨论"到当前进度的全部待修改/新建文件

---

## 一、架构改造总览

```
改造前（轮询模式）                    改造后（事件驱动模式）
─────────────────                    ─────────────────
for(;;) {                            osEventFlagsWait()
  uart_vision_poll();       →          EVENT_UART1_RX → uart_vision_poll()
  business_logic_poll();    →          EVENT_UART2_RX → uart_display_poll()
  cloud_storage_poll();     →          EVENT_SLE_ADV  → sle_adv_dequeue()
  sle_network_poll();       →          EVENT_TIMER    → heartbeat/timeout
  osal_msleep(10);          →          无事件 → CPU 睡眠 (0% 占用)
}
```

---

## 二、文件修改状态图

```
┌─────────────────────────────────────────────────────────────────────┐
│                        项目根目录                                    │
│  My_project_63/                                                     │
│                                                                     │
│  ┌── app/ ──────────────────────────────────────────────────────┐   │
│  │  main.c                              [🔴 大改]               │   │
│  │  ├─ 事件驱动主循环 (osEventFlagsWait)                         │   │
│  │  ├─ UART2 回调注册 (uart_display)                             │   │
│  │  ├─ EVENT_UART1_RX / EVENT_UART2_RX / EVENT_SLE_ADV 分发     │   │
│  │  └─ 去掉 osal_msleep(10) 轮询                                │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌── components/ ───────────────────────────────────────────────┐   │
│  │                                                              │   │
│  │  shared_protocol/                                            │   │
│  │  ├─ shared_protocol.c                  [🟡 小改]             │   │
│  │  │  └─ magic number 修复 (已完成)                             │   │
│  │  └─ shared_protocol.h                  [🟡 小改]             │   │
│  │     └─ 新增 TagState / TagListEntry packed 结构体定义         │   │
│  │                                                              │   │
│  │  sle_network/                                                │   │
│  │  ├─ sle_network.c                      [🔴 大改]             │   │
│  │  │  ├─ my63_seek_result_cb: 只做 memcpy+osMessageQueuePut    │   │
│  │  │  ├─ 新增 osMessageQueue (256条, raw bytes)                │   │
│  │  │  ├─ 新增 sle_adv_dequeue(): 出队+协议解析+扫描表更新       │   │
│  │  │  ├─ 去掉 cb 中的 osal_printk / scan_table_add_or_update   │   │
│  │  │  └─ scan_table 改用 packed TagState                       │   │
│  │  └─ sle_network.h                      [🟡 小改]             │   │
│  │     └─ sle_scan_entry_t → TagState (packed)                  │   │
│  │                                                              │   │
│  │  business_logic/                                             │   │
│  │  ├─ business_logic.c                   [🔴 大改]             │   │
│  │  │  ├─ 新增 TagListEntry 白名单+去重数组                      │   │
│  │  │  ├─ 白名单判定逻辑 (biz_map_find_by_tag + MAC 校验)       │   │
│  │  │  ├─ 时间窗去重 (DEDUP_WINDOW_MS)                          │   │
│  │  │  ├─ status 映射: BS21E→WS63 (§9 语义)                    │   │
│  │  │  ├─ tag_id 格式转换: uint16↔"0005"↔"0x0005"              │   │
│  │  │  ├─ 串口屏命令分发 (@in/@out/@inv/@find)                  │   │
│  │  │  └─ 盘点三种模式 (全量/单标签/区域)                        │   │
│  │  └─ business_logic.h                   [🟡 小改]             │   │
│  │     └─ 新增 TagListEntry / ud_cmd_handler_t 类型定义          │   │
│  │                                                              │   │
│  │  uart_vision/                                                │   │
│  │  ├─ uart_vision.c                      [🟡 小改]             │   │
│  │  │  └─ DMA+IDLE 中断驱动 (部分已实现, 需确认)                 │   │
│  │  └─ uart_vision.h                      [🟡 小改]             │   │
│  │     └─ 无大变化                                              │   │
│  │                                                              │   │
│  │  uart_display/                          [🟢 新建]             │   │
│  │  ├─ uart_display.c                     [🟢 新建]             │   │
│  │  │  ├─ UART2 初始化 (DMA + IDLE 中断)                        │   │
│  │  │  ├─ CSV 文本帧解析 (@头, 逗号分隔, \r\n尾)                │   │
│  │  │  ├─ ud_cmd_handler_t 回调分发                              │   │
│  │  │  ├─ 下行帧组装 (#TAG/#PROG/#DONE/#ERR/#INV/#FIND)         │   │
│  │  │  └─ tag_id "0005" ↔ uint16_t 5 转换                      │   │
│  │  └─ uart_display.h                     [🟢 新建]             │   │
│  │     └─ 接口定义 + 回调类型 + 帧常量                           │   │
│  │                                                              │   │
│  │  cloud_storage/                                              │   │
│  │  ├─ cloud_storage.c                    [✅ 已完成]            │   │
│  │  │  ├─ cs_mqtt_publish_gateway()                              │   │
│  │  │  ├─ cs_mqtt_subscribe_gateway()                            │   │
│  │  │  └─ cs_mqtt_connect() 自动订阅网关 topic                   │   │
│  │  └─ cloud_storage.h                    [✅ 已完成]            │   │
│  │     └─ 网关 topic 宏 + 函数声明                               │   │
│  │                                                              │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌── document/ ─────────────────────────────────────────────────┐   │
│  │  protocols/WS63_uart_protocol.md       [✅ 已完成]            │   │
│  │  │  └─ 串口屏CSV协议v2.0 (单页UI/盘点三模式/寻物)             │   │
│  │  fix/mqtt_gateway_publish&rpc.md       [✅ 已完成]            │   │
│  │  │  └─ 网关模式改造记录                                       │   │
│  │  architecture_changes.md               [✅ 本文件]            │   │
│  │                                                              │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  CLAUDE.md                                  [✅ 已完成]              │
│  └─ 架构规范 + 协议对齐 + 检查清单                                  │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 三、修改优先级与依赖关系

```
Phase 1: 基础设施 (无依赖, 可并行)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [1] shared_protocol.h     ← 新增 TagState / TagListEntry packed 结构体
  [2] sle_network.h         ← sle_scan_entry_t 改为 TagState
  [3] uart_display.h        ← 新建模块接口

Phase 2: 核心改造 (依赖 Phase 1)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [4] sle_network.c         ← osMessageQueue + 回调精简 + 出队处理
  [5] uart_display.c        ← UART2 DMA+IDLE + CSV 解析
  [6] business_logic.c      ← 白名单 + 去重 + status映射 + 串口屏分发

Phase 3: 入口集成 (依赖 Phase 2)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [7] main.c                ← 事件驱动主循环 + 回调注册

Phase 4: 验证
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [8] 编译零错误零警告
  [9] 单标签: 入库→出库→盘点→寻物 全流程
  [10] 多标签: 3标签同时广播, 队列不溢出, NMI 不崩溃
  [11] 串口屏: @in/start → #TAG → @in/capture → #DONE 全流程
```

---

## 四、改造前后对比

### 4.1 main.c 主循环

```c
/* ═══ 改造前 ═══ */
for (;;) {
    uart_vision_poll();           // 10ms 轮询
    business_logic_poll();
    cloud_storage_poll();
    sle_network_poll();
    heartbeat(now);
    osal_msleep(10);              // 固定睡眠, CPU 浪费
}

/* ═══ 改造后 ═══ */
for (;;) {
    uint32_t flags = osEventFlagsWait(g_events,
        EVENT_UART1_RX | EVENT_UART2_RX | EVENT_SLE_ADV | EVENT_TIMER,
        osFlagsWaitAny, osWaitForever);

    if (flags & EVENT_UART1_RX)   uart_vision_poll();
    if (flags & EVENT_UART2_RX)   uart_display_poll();
    if (flags & EVENT_SLE_ADV)    sle_adv_dequeue();
    if (flags & EVENT_TIMER)      timer_handler();
    // 无事件时 CPU 睡眠, 0% 占用
}
```

### 4.2 sle_network.c SLE 回调

```c
/* ═══ 改造前 ═══ */
static void my63_seek_result_cb(...) {
    osal_printk(...);                    // 6-8 次打印, 阻塞!
    shared_protocol_unpack_adv(...);     // 协议解析, 阻塞!
    scan_table_add_or_update(...);       // 业务逻辑, 阻塞!
    // → 运行在 bt_service IRQ 上下文, 导致 NMI 崩溃
}

/* ═══ 改造后 ═══ */
static void my63_seek_result_cb(...) {
    sle_adv_msg msg = {0};
    memcpy(msg.raw, adv_data, len);      // 仅 memcpy
    memcpy(msg.addr, addr, 6);
    msg.rssi = rssi;
    osMessageQueuePut(g_adv_queue, &msg, 0, 0);  // 入队
    osEventFlagsSet(g_events, EVENT_SLE_ADV);     // 设标志
    return;                                        // 立即返回
}
```

### 4.3 business_logic.c 白名单+去重

```c
/* ═══ 改造前 ═══ */
// 扫描到就直接上云, 无白名单, 无去重

/* ═══ 改造后 ═══ */
// ① 协议解析 (unpack_adv)
// ② 扫描表更新 (所有合法标签)
// ③ 白名单判定 (biz_map_find_by_tag + MAC 校验)
// ④ 时间窗去重 (now - last_publish_ms < 3s → 跳过)
// ⑤ MQTT 上云 (仅白名单+去重后的标签)
```

---

## 五、当前已完成项

| 项目 | 状态 | 提交 |
|------|------|------|
| MQTT 网关上云 (topic+格式+订阅) | ✅ 完成 | 5d8528a5 |
| shared_protocol magic number 修复 | ✅ 完成 | 5d8528a5 |
| CLAUDE.md 架构规范文档 | ✅ 完成 | 5d8528a5 |
| WS63_uart_protocol.md 串口屏协议v2.0 | ✅ 完成 | 5d8528a5 |
| architecture_changes.md 本文件 | ✅ 完成 | - |

---

## 六、待开发项 (按优先级)

| # | 文件 | 任务 | 预估行数 | 依赖 |
|---|------|------|---------|------|
| 1 | shared_protocol.h | TagState/TagListEntry 结构体 | ~30 | 无 |
| 2 | uart_display.h | 模块接口定义 | ~50 | 无 |
| 3 | sle_network.c | osMessageQueue + 回调精简 | ~150 | #1 |
| 4 | uart_display.c | UART2 CSV 解析模块 | ~400 | #2 |
| 5 | business_logic.c | 白名单+去重+status+串口屏分发 | ~200 | #1, #4 |
| 6 | main.c | 事件驱动主循环 | ~50 | #3, #4, #5 |
