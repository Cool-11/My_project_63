# 阶段二修复报告：扫描逻辑重构

> 日期: 2026-05-17
> 阶段: Phase 2 — WS63 扫描逻辑重构 (任务 #11-#24)
> 文件: sle_network.h, sle_network.c, main.c

---

## 背景

原扫描逻辑：`seek_result_cb` 发现第一个匹配的 BS21E 后立即停止扫描并自动连接。这导致：
- 只能连接一个标签
- 连接期间无法发现其他标签
- 用户无法选择要连接哪个标签

新逻辑：持续扫描，记录所有标签到扫描表，用户通过 `connect_by_tag()` 指定连接。

---

## 改动清单

### 1. 新增扫描表结构体 (sle_network.h)

```c
typedef struct {
    uint16_t tag_id;
    uint8_t  mac[6];
    uint8_t  battery;
    uint16_t qty;
    uint8_t  status;
    uint64_t last_seen_ms;
    bool     used;
} sle_scan_entry_t;

#define SLE_SCAN_TABLE_MAX          32
#define SLE_SCAN_ENTRY_TIMEOUT_MS   30000   /* 30s 标记离线 */
#define SLE_SCAN_ENTRY_EXPIRE_MS    300000  /* 5min 清除 */
```

### 2. 扫描表管理函数 (sle_network.c)

| 函数 | 职责 |
|------|------|
| `scan_table_add_or_update()` | 添加新条目或更新已有条目的 qty/battery/status |
| `scan_table_find_by_tag()` | 按 tag_id 查找条目 |
| `scan_table_cleanup()` | 30s 未扫到标记离线，5min 清除条目 |

### 3. seek_result_cb 重构

**删除**：
- `MY63_TARGET_TAG_ID` 硬编码筛选
- `sle_network_stop_scan()` 调用
- `sle_connect_remote_device()` 自动连接

**新增**：
- `tag_id == 0` 忽略（未配网标签）
- 调用 `scan_table_add_or_update()` 记录到扫描表
- 扫描持续进行，不停止

### 4. 新增 API

```c
/* 按 tag_id 从扫描表找 MAC，停止扫描，发起连接 */
int sle_network_connect_by_tag(uint16_t tag_id);

/* 返回扫描表指针和条目数 */
const sle_scan_entry_t *sle_network_get_scan_table(void);
uint16_t sle_network_get_scan_table_count(void);

/* 轮询函数，清理过期条目 */
void sle_network_poll(void);
```

### 5. main.c 适配

- 主循环调用 `sle_network_poll()` 清理过期扫描条目
- 心跳日志增加 `scan_tbl=N` 显示扫描表条目数
- 重启扫描条件改为：未连接 && 扫描未激活

### 6. 断开回调增强

- 断开时 `g_my63_target_found = 0`
- 断开后自动重启扫描（已有逻辑，保持不变）

---

## 模块解耦验证

`sle_network.c` 不引用 `business_logic.h`。扫描表状态更新通过 `sle_network_get_scan_table()` API 由 `business_logic` 主动读取，而非 SLE 层直接调用业务函数。

---

## 新的业务流程

```
上电 → 持续扫描 → 记录所有标签到扫描表
                         ↓
用户发送 register(tag_id=N)
                         ↓
business_logic 调 sle_network_connect_by_tag(N)
                         ↓
从扫描表找 MAC → 停止扫描 → 连接 → 配对 → SSAP → CCCD
                         ↓
发送 BIND_TAG → 收到 0xA0 → 转发 ESP32 → task_done
                         ↓
断开连接 → 自动重启扫描
```

---

## 关联任务

| # | 任务 | 状态 |
|---|------|------|
| 11 | 定义 sle_scan_entry_t | ✅ |
| 12 | 全局扫描表 g_scan_table[32] | ✅ |
| 13 | scan_table_add_or_update() | ✅ |
| 14 | scan_table_find_by_tag() | ✅ |
| 15 | scan_table_cleanup() | ✅ |
| 16 | seek_result_cb 不停扫描 | ✅ |
| 17 | seek_result_cb 记录扫描表 | ✅ |
| 18 | 更新已入库标签状态（通过API） | ✅ |
| 19 | sle_network_connect_by_tag() | ✅ |
| 20 | sle_network_get_scan_table() | ✅ |
| 21 | sle_network_get_scan_table_count() | ✅ |
| 22 | 断开自动重启扫描 | ✅ |
| 23 | 删除 MY63_TARGET_TAG_ID | ✅ |
| 24 | 删除自动连接逻辑 | ✅ |
