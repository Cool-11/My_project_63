# 协议对齐实施计划

> **基于**: END_TO_END_PROTOCOL.md + WS63_MONITOR_PROTOCOL.md v2.3 + ESP32_WS63_PROTOCOL.md v3.3
> **日期**: 2026-05-29
> **状态**: 执行中（Phase A-G 已完成，待验证）

---

## 一、用户确认的实施范围

| 决策项 | 用户选择 |
|--------|---------|
| 串口屏命令集 | **分批实现** — 先核心流程(start/capture)，photo/confirm/cancel后续 |
| Tag ID格式 | **改为0x%04X** — 严格对齐协议文档 |
| ESP32响应处理 | **全部处理** — capture_progress/asset_info/asset_detail/asset_list_page/verification_start/pong |
| 出库流程 | **改造为分步** — outbound→asset_info→capture→task_done |

---

## 二、50个子任务清单

### Phase A: Tag ID 格式对齐 (任务 1-5)

| # | 文件 | 任务 | 说明 |
|---|------|------|------|
| A1 | business_logic.c | `biz_cmd_register` 中 tag_id 改为 `"0x%04X"` 格式 | 当前 `%u` → `"0x0001"` |
| A2 | business_logic.c | `biz_cmd_inbound` 中 tag_id 改为 `"0x%04X"` 格式 | 同上 |
| A3 | business_logic.c | `biz_cmd_outbound` 中 tag_id 改为 `"0x%04X"` 格式 | 同上 |
| A4 | business_logic.c | `biz_cmd_find` 中 tag_id 改为 `"0x%04X"` 格式 | 同上 |
| A5 | business_logic.c | `biz_cmd_passthrough_to_esp32` 中 tag_id 统一格式化 | 确保所有透传命令使用正确格式 |

### Phase B: ESP32 响应处理扩展 (任务 6-15)

| # | 文件 | 任务 | 说明 |
|---|------|------|------|
| B1 | business_logic.c | 新增 `biz_handle_capture_progress()` | 解析 step/view/blur_score → 转发 #PROG |
| B2 | business_logic.c | 新增 `biz_handle_asset_info()` | 解析 task 类型区分 outbound/inventory |
| B3 | business_logic.c | outbound 场景: asset_info → `#ASSET_INFO` 转发屏 | 出库分步第一步 |
| B4 | business_logic.c | inventory 场景: asset_info → 记录日志（不重复发#TAG_INFO） | 盘点资产确认 |
| B5 | business_logic.c | 新增 `biz_handle_asset_detail()` | get_asset 响应 → `#TAG_INFO` 转发屏 |
| B6 | business_logic.c | 新增 `biz_handle_asset_list_page()` | 解析分页数据 → `#LIST` + `#ITEM`×N |
| B7 | business_logic.c | 新增 `biz_handle_verification_start()` | 验证模式开始 → 可选 `#MSG` 提醒 |
| B8 | business_logic.c | 新增 `biz_handle_pong()` | ping 响应 → 日志记录 |
| B9 | business_logic.c | 新增 `biz_handle_task_done_outbound()` | 根据 is_match → `#DONE,out,success/fail` |
| B10 | business_logic.c | 新增 `biz_handle_task_done_inventory()` | 根据 confidence≥0.75 → `#DONE,check,match/mismatch` |

### Phase C: 串口屏命令分批实现 (任务 16-25)

> **第一批**: 核心流程命令（start/capture）

| # | 文件 | 任务 | 说明 |
|---|------|------|------|
| C1 | business_logic.c | 实现 `@in,start` 处理 | SLE扫描 → 查DB → `#TAG` 或 `#VERIFY` |
| C2 | business_logic.c | 实现 `@in,capture,<id>,<qty>,<area>,<name>,<mode>` | 解析6字段 → 根据mode拼register JSON |
| C3 | business_logic.c | 实现 `@out,start` 处理 | SLE扫描 → 查DB → `#TAG,id,name,area,total` |
| C4 | business_logic.c | 实现 `@out,capture,<id>,<qty>` | → `{"cmd":"outbound","tag_id":"0x%04X","remove_qty":N}` |
| C5 | business_logic.c | 实现 `@check,specific,<id>` | → `{"cmd":"get_asset","tag_id":"0x%04X"}` |
| C6 | business_logic.c | 实现 `@check,capture,<id>` | → `{"cmd":"inventory","tag_id":"0x%04X"}` |
| C7 | business_logic.c | 实现 `@check,global` | SLE扫描数 + `list_assets_page` total_count |
| C8 | business_logic.c | 实现 `@find,list,<page>` | → `{"cmd":"list_assets_page","page":N,"page_size":6}` |
| C9 | business_logic.c | 实现 `@find,locate,<id>` | WS63→SLE直接蜂鸣（不经ESP32） |
| C10 | business_logic.c | 实现 `@find,stop` | WS63→SLE停止蜂鸣 |

### Phase D: 出库分步流程改造 (任务 26-35)

| # | 文件 | 任务 | 说明 |
|---|------|------|------|
| D1 | business_logic.c | 新增 `g_biz_outbound_state` 结构 | 跟踪出库分步状态 |
| D2 | business_logic.c | `@out,capture` → 发outbound → 等asset_info | 不再直接等task_done |
| D3 | business_logic.c | 收到asset_info(task=outbound) → `#ASSET_INFO` 转发屏 | sys0=2，等待用户确认 |
| D4 | business_logic.c | `@out,photo,front` → 发capture | 用户确认后才拍照 |
| D5 | business_logic.c | 收到task_done(outbound) → 根据is_match判断 | `#DONE,out,success/fail` |
| D6 | business_logic.c | `@out,confirm` → 持久化 | 确认出库完成 |
| D7 | business_logic.c | `@out,cancel` → 发cancel给ESP32 | 取消当前出库任务 |
| D8 | business_logic.c | 出库超时处理 | pending超时自动清理 |
| D9 | business_logic.c | `@in,confirm` → 持久化 | 确认入库完成 |
| D10 | business_logic.c | `@in,cancel` → 发cancel给ESP32 | 取消当前入库任务 |

### Phase E: 盘点流程完善 (任务 36-40)

| # | 文件 | 任务 | 说明 |
|---|------|------|------|
| E1 | business_logic.c | `@check,specific` → get_asset → `#TAG_INFO` | 先查资产信息 |
| E2 | business_logic.c | `@check,capture` → inventory → 等task_done | 三视图拍摄流程 |
| E3 | business_logic.c | task_done(inventory) → confidence判断 | ≥0.75→match, <0.75→mismatch |
| E4 | business_logic.c | `@check,photo,<view>` → capture | 三视图拍照 |
| E5 | business_logic.c | `@check,cancel` → cancel | 取消盘点 |

### Phase F: 设置页 + 取消 (任务 41-45)

| # | 文件 | 任务 | 说明 |
|---|------|------|------|
| F1 | business_logic.c | 实现 `@setting,wifi,<ssid>,<pwd>` | → WiFi连接 |
| F2 | business_logic.c | 实现 `@setting,disconnect` | → WiFi断开 |
| F3 | business_logic.c | 实现 `@setting,cancel` | → 返回主页 |
| F4 | business_logic.c | 统一 `@*,cancel` 处理 | 发cancel给ESP32 + 清pending |
| F5 | main.c | WiFi状态变化 → `#NET,wifi,<status>,<signal>` 推送屏 | 网络状态通知 |

### Phase G: Tag ID 双向转换工具 (任务 46-48)

| # | 文件 | 任务 | 说明 |
|---|------|------|------|
| G1 | uart_display.c | `ud_str_to_tag_id` 验证 `"0001"` → `uint16_t 1` | 已实现，需验证 |
| G2 | uart_display.c | `ud_tag_id_to_str` 验证 `uint16_t 1` → `"0001"` | 已实现，需验证 |
| G3 | business_logic.c | 新增 `biz_tag_id_to_esp32(uint16_t id, char *buf)` | `uint16_t 1` → `"0x0001"` |
| G4 | business_logic.c | 新增 `biz_esp32_to_tag_id(const char *str)` | `"0x0001"` → `uint16_t 1` |

### Phase H: 文档与验证 (任务 49-50)

| # | 文件 | 任务 | 说明 |
|---|------|------|------|
| H1 | document/fix/protocol_alignment_plan.md | 更新本文档完成状态 | 变更记录 |
| H2 | — | 编译验证 + 零错误零警告 | 验收标准 |

---

## 三、数据流对比（改造前 vs 改造后）

### 3.1 入库流程

```
改造前:
  屏 @in → WS63 拼register JSON(tag_id:%u) → ESP32 → task_done → #DONE

改造后:
  屏 @in,start → WS63 SLE扫描+查DB → #TAG,0001 或 #VERIFY,0001,扳手,A,50
  屏 @in,capture,0001,50,A,扳手,0 → WS63 拼register JSON(tag_id:"0x0001") → ESP32
  ESP32 → capture_progress(×3) → WS63 → #PROG,1,front,87.3
  ESP32 → task_done → WS63 → #DONE,reg,success,0001
  屏 @in,confirm → WS63 持久化
```

### 3.2 出库流程

```
改造前:
  屏 @out → WS63 拼outbound JSON → ESP32 → task_done → #DONE

改造后:
  屏 @out,start → WS63 SLE扫描+查DB → #TAG,0001,扳手,A,50
  屏 @out,capture,0001,5 → WS63 拼outbound JSON → ESP32
  ESP32 → asset_info(未初始化硬件) → WS63 → #ASSET_INFO,0001,扳手,50,5,45
  屏 @out,photo,front → WS63 拼capture JSON → ESP32
  ESP32 → 初始化AI+拍摄+比对+扣减 → task_done(is_match)
  WS63 → #DONE,out,success 或 #DONE,out,fail
  屏 @out,confirm → WS63 持久化
```

### 3.3 盘点流程

```
改造前:
  屏 @inv → WS63 拼inventory JSON → ESP32 → task_done → #DONE

改造后:
  屏 @check,specific,0001 → WS63 拼get_asset JSON → ESP32
  ESP32 → asset_detail → WS63 → #TAG_INFO,0001,扳手,A,50
  屏 @check,capture,0001 → WS63 拼inventory JSON → ESP32
  ESP32 → asset_info → (日志)
  ESP32 → capture_progress(×3) → WS63 → #PROG
  ESP32 → task_done(confidence=0.93) → WS63 → #DONE,check,match,0.93
```

### 3.4 查找流程

```
改造前:
  未实现

改造后:
  屏 @find,list,1 → WS63 拼list_assets_page JSON → ESP32
  ESP32 → asset_list_page → WS63 → #LIST,1,25,150 + #ITEM×6
  屏 @find,locate,0003 → WS63 → SLE蜂鸣(不经ESP32) → #LOCATE,found,0003
  屏 @find,stop → WS63 → SLE停止蜂鸣
```

---

## 四、关键转换规则

### 4.1 Tag ID 转换链

```
屏→WS63:  "0001"     → ud_str_to_tag_id() → uint16_t 1
WS63内部: uint16_t 1  → 存储/比较
WS63→ESP32: uint16_t 1 → biz_tag_id_to_esp32() → "0x0001"
ESP32→WS63: "0x0001"  → biz_esp32_to_tag_id() → uint16_t 1
WS63→屏:  uint16_t 1  → ud_tag_id_to_str() → "0001"
```

### 4.2 JSON 字段名映射

| WS63→ESP32 JSON | 屏→WS63 CSV | 说明 |
|----------------|------------|------|
| `tag_id: "0x0001"` | `tag_id: "0001"` | WS63负责格式转换 |
| `item_name` | `name` | 字段名不同 |
| `storage_area` | `area` | 字段名不同 |
| `quantity` | `count` | 字段名不同 |
| `remove_qty` | `out_count` | 字段名不同 |

---

## 五、执行顺序

```
Phase A (Tag ID格式) ──→ Phase B (ESP32响应) ──→ Phase C (屏命令)
                                      ↓
                              Phase D (出库分步)
                                      ↓
                          Phase E (盘点) + Phase F (设置)
                                      ↓
                          Phase G (转换工具) + Phase H (验证)
```

---

**维护者**: Claude Code
**反馈**: 按用户确认的4个决策执行
