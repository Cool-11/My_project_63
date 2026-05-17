# 阶段三修复报告：业务逻辑改造

> 日期: 2026-05-17
> 阶段: Phase 3 — WS63 业务逻辑改造 (任务 #25-#44)
> 文件: business_logic.c, business_logic.h

---

## 改动清单

### 1. 删除 g_biz_next_tag_id 自动分配 (#25)

**改动**：删除 `static uint16_t g_biz_next_tag_id = 1;` 及其在 `biz_map_load_nv()` 和 `business_logic_init()` 中的恢复逻辑。

**原因**：tag_id 由用户在 BS21E 端预设，WS63 不再自动分配。

### 2. biz_map_alloc → biz_map_add (#42-43)

**改动**：`biz_map_alloc()` 改为 `biz_map_add(uint16_t tag_id)`，接受用户指定的 tag_id，并增加重复检查。

```c
biz_tag_entry_t *biz_map_add(uint16_t tag_id) {
    /* 检查是否已存在 */
    if (biz_map_find_by_tag(tag_id) != NULL) return NULL;
    ...
}
```

### 3. biz_cmd_register 重构 (#26-29)

**新流程**：
1. 从 `data_json` 读取用户指定的 `tag_id`
2. 检查扫描表中是否有该标签
3. 检查映射表中是否已注册
4. 检查无 pending 冲突
5. 添加到映射表，从扫描表复制 MAC
6. 调用 `sle_network_connect_by_tag(tag_id)` 发起异步连接
7. 设置 pending "register"，超时 15s

**状态机**（在 `business_logic_poll` 中）：
- pending="register" + SSAP 就绪 → 发送 BIND_TAG → pending 改为 "register_bind"
- pending="register_bind" + 收到 0xA0 → 转发 ESP32 → 等待 task_done
- 超时 → 清理映射表条目

### 4. biz_cmd_inbound 改造 (#26)

**改动**：从 `data_json` 读取 `tag_id`，使用 `biz_map_add(tag_id)`，从扫描表复制 MAC。

### 5. outbound 部分/全量出库 (#30-32)

**新逻辑**：
```c
if (remove_qty 未指定 || remove_qty >= current_qty) {
    /* 全量出库：发送 UNBIND_TAG */
    sle_network_send_cmd(SSAP_CMD_UNBIND_TAG, tag_id);
} else {
    /* 部分出库：发送 UPDATE_QTY(new_qty) */
    uint16_t new_qty = current_qty - remove_qty;
    sle_network_send_cmd(SSAP_CMD_UPDATE_QTY, new_qty);
}
```

### 6. biz_cmd_scan_list 新增 (#37-39)

**新命令**：`scan_list` — 返回扫描表所有标签，含 `registered` 字段。

```json
{"cmd":"scan_list","seq":1,"code":0,"msg":"ok","data":{
  "scan_list":[
    {"tag_id":5,"battery":95,"qty":100,"status":0,"registered":true},
    {"tag_id":8,"battery":80,"qty":50,"status":0,"registered":false}
  ]
}}
```

### 7. register ESP32 参数增强 (#40)

**改动**：bind 成功后转发 ESP32 的消息增加 `item_name`、`storage_area`、`qty` 字段。

```json
{"cmd":"register","tag_id":5,"item_name":"Type-C","storage_area":"A1","qty":0}
```

### 8. notify 回调 register_bind 支持 (#33-36)

**改动**：`biz_sle_notify_cb` 的 bind 响应处理增加 `"register_bind"` 状态匹配。

断开连接后自动重启扫描（由 `sle_network.c` 的 disconnect 回调处理）。

---

## 新的完整业务流程

### register（入库）

```
串口屏 → {"cmd":"register","tag_id":5,"storage_area":"A1","item_name":"Type-C"}
  ↓
biz_cmd_register:
  1. 检查扫描表有 tag_id=5 ✓
  2. 检查映射表无 tag_id=5 ✓
  3. 添加到映射表，复制 MAC
  4. connect_by_tag(5) → 停止扫描，连接 BS21E
  5. pending="register", timeout=15s
  ↓
business_logic_poll:
  6. SSAP 就绪 → 发送 BIND_TAG(5)
  7. pending 改为 "register_bind"
  ↓
biz_sle_notify_cb:
  8. 收到 0xA0 → 更新状态 BOUND
  9. pending.cmd 改为 "inbound"
  10. 转发 ESP32 {"cmd":"register","tag_id":5,"item_name":"Type-C","storage_area":"A1","qty":0}
  11. 等待 ESP32 task_done
  ↓
biz_handle_esp32_msg:
  12. task_done "register" → 映射为 "inbound" → 匹配 pending
  13. 回复串口屏 code=0
  ↓
sle_network disconnect → 自动重启扫描
```

### outbound 部分出库

```
串口屏 → {"cmd":"outbound","tag_id":5,"remove_qty":30}
  ↓
当前 qty=100, remove_qty=30 < 100 → 部分出库
  ↓
发送 UPDATE_QTY(70) → 本地 qty=70 → 回复串口屏
```

### outbound 全量出库

```
串口屏 → {"cmd":"outbound","tag_id":5,"remove_qty":0}
  ↓
remove_qty=0 未指定 → 全量出库
  ↓
发送 UNBIND_TAG(5) → 收到 0xA1 → 删除映射 → 回复串口屏
```

---

## 关联任务

| # | 任务 | 状态 |
|---|------|------|
| 25 | 删除 g_biz_next_tag_id | ✅ |
| 26 | register/inbound 改读用户指定 tag_id | ✅ |
| 27 | register 从扫描表查 mac | ✅ |
| 28 | register 预检查 | ✅ |
| 29 | register 调 connect_by_tag | ✅ |
| 30 | outbound 加 remove_qty 逻辑 | ✅ |
| 31 | 部分出库发 UPDATE_QTY | ✅ |
| 32 | 全量出库发 UNBIND_TAG | ✅ |
| 33 | notify 加 0xA1 处理 | ✅ (阶段一) |
| 34 | unbind 失败处理 | ✅ (阶段一) |
| 35 | task_done 后断开连接 | ✅ (由 disconnect 回调自动处理) |
| 36 | 断开自动恢复扫描 | ✅ (阶段二) |
| 37 | 新增 biz_cmd_scan_list | ✅ |
| 38 | scan_list 分发注册 | ✅ |
| 39 | scan_list 含 status+registered | ✅ |
| 40 | register 传参给 ESP32 | ✅ |
| 41 | inventory 传参给 ESP32 | ✅ (已有完整 JSON) |
| 42 | 删除 biz_map_alloc | ✅ |
| 43 | 新增 biz_map_add | ✅ |
| 44 | NV 恢复删 next_tag_id | ✅ |
