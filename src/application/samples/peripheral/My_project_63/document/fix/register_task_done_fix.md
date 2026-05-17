# 业务逻辑修复报告

> 日期: 2026-05-15
> 严重度: Critical + High
> 文件: `components/business_logic/business_logic.c`, `components/uart_vision/uart_vision.c`

---

## 问题描述

`biz_cmd_register()` 设置 `pending.cmd = "register"`，SLE bind 成功后转发 ESP32。ESP32 返回：

```json
{"type":"task_done","task":"register","result":"success",...}
```

经 `biz_map_esp32_task("register")` 映射为 `"inbound"`，但 `pending.cmd` 仍是 `"register"`，导致 `strcmp("inbound", "register")` 不匹配，pending 槽位被占 15 秒后超时。

**影响**：注册流程 100% 超时，串口屏收到 `code=-10 "timeout"`；15 秒内其他 SLE 命令被阻塞。

---

## 修复内容

### Fix 1: SLE bind 成功后更新 pending.cmd

**文件**: `business_logic.c` — `biz_sle_notify_cb()` bind 处理段

```c
/* 修复前 */
if (strcmp(g_biz_pending.cmd, "register") == 0) {
    char esp32_cmd[96];
    snprintf(...);
    biz_raw_json_send(esp32_cmd);
    return;
}

/* 修复后 */
if (strcmp(g_biz_pending.cmd, "register") == 0) {
    /* 更新 pending.cmd，使 esp32 task_done 映射能匹配 */
    errno_t rc = strncpy_s(g_biz_pending.cmd,
        sizeof(g_biz_pending.cmd), "inbound",
        sizeof(g_biz_pending.cmd) - 1);
    if (rc != EOK) {
        g_biz_pending.cmd[0] = '\0';
    }
    char esp32_cmd[96];
    snprintf(...);
    biz_raw_json_send(esp32_cmd);
    /* 保持 pending (timeout=15s)，等待 ESP32 task_done */
    return;
}
```

**原理**：bind 成功 → pending.cmd 从 `"register"` 改为 `"inbound"` → ESP32 task_done 映射 `"inbound"` → 匹配 `pending.cmd="inbound"` → 正确回复串口屏。

### Fix 2: Register 超时清理 tag 条目

**文件**: `business_logic.c` — `business_logic_poll()` 超时处理段

```c
/* 修复前 */
if (strcmp(g_biz_pending.cmd, "inbound") == 0) {
    biz_map_remove(g_biz_pending.tag_id);
}

/* 修复后 */
if (strcmp(g_biz_pending.cmd, "inbound") == 0 ||
    strcmp(g_biz_pending.cmd, "register") == 0) {
    biz_map_remove(g_biz_pending.tag_id);
}
```

**原理**：如果超时发生在 bind 阶段（pending.cmd 仍为 "register"），也需要清理已分配的 tag 条目，防止资源泄漏。

### Fix 3: biz_cmd_register strncpy_s 返回值检查

**文件**: `business_logic.c` — `biz_cmd_register()` 字段拷贝段

```c
/* 修复前 */
if (j_zone != NULL && cJSON_IsString(j_zone)) {
    strncpy_s(entry->zone, BIZ_ZONE_LEN,
        j_zone->valuestring, BIZ_ZONE_LEN - 1);
}

/* 修复后 */
if (j_zone != NULL && cJSON_IsString(j_zone)) {
    errno_t rc = strncpy_s(entry->zone, BIZ_ZONE_LEN,
        j_zone->valuestring, BIZ_ZONE_LEN - 1);
    if (rc != EOK) {
        osal_printk("[WS63_BIZ] register zone copy fail rc=%d\r\n", (int)rc);
        entry->zone[0] = '\0';
    }
}
```

与 `biz_cmd_inbound()` 保持一致的错误检查模式。

### Fix 4: cJSON valueint → uint16_t 边界检查 (H-02)

**文件**: `business_logic.c` — `biz_cmd_update_qty()`, `biz_cmd_find()`, `biz_cmd_outbound()`
**文件**: `uart_vision.c` — `uv_dispatch_line()`

cJSON 的 `valueint` 类型是 `int`（可为负数），直接转 `uint16_t` 会导致 -1 → 65535。

```c
/* 修复后（以 update_qty 为例） */
int raw_tag = j_tag_id->valueint;
int raw_qty = j_qty->valueint;
if (raw_tag < 0 || raw_tag > 0xFFFF || raw_qty < 0 || raw_qty > 0xFFFF) {
    cJSON_Delete(root);
    biz_reply(seq, "update_qty", -3, "value out of range", NULL);
    return;
}
uint16_t tag_id = (uint16_t)raw_tag;
uint16_t qty = (uint16_t)raw_qty;
```

同理修复了 `biz_cmd_find`、`biz_cmd_outbound` 的 tag_id 转换，以及 `uart_vision.c` 的 seq 转换。

### Fix 5: MQTT host 长度验证 (H-01)

**文件**: `business_logic.c` — `biz_cmd_mqtt_connect()`

`snprintf` 会截断超长字符串，截断后 `"tcp://longhost...:1883"` 可能变成 `"tcp://longhost..."`（端口丢失）。

```c
/* 修复后 */
uint32_t host_len = (uint32_t)strlen(j_host->valuestring);
if (host_len == 0 || host_len > (BIZ_MQTT_URI_MAX - 13) ||
    port < 1 || port > 65535) {
    cJSON_Delete(root);
    biz_reply(seq, "mqtt_connect", -4, "invalid host/port", NULL);
    return;
}
```

`BIZ_MQTT_URI_MAX - 13` = 128 - 13 = 115 字节，留给 host（"tcp://" 6 + host + ":" 1 + port 5 + \0 1 = 13）。

---

## 验证方法

**测试步骤**：
1. 串口屏发送 `{"cmd":"register","seq":1,"data":{"storage_area":"A1","item_name":"Type-C"}}`
2. 预期 SLE bind 成功后，WS63 转发 ESP32 `{"cmd":"register","tag_id":N}`
3. ESP32 回复 `{"type":"task_done","task":"register","result":"success"}`
4. WS63 回复串口屏 `{"cmd":"register","seq":1,"code":0,"msg":"ok","data":{...}}`
5. 确认回复在 1-2 秒内到达（非 15 秒超时）

**回归测试**：
- `inbound` 命令仍正常工作（SLE bind → 直接回复，不经过 ESP32）
- `outbound` 命令仍正常工作
- pending 超时机制不受影响

---

## 相关安全/审查发现（已修复）

| ID | 严重度 | 问题 | 状态 |
|----|--------|------|------|
| BUG-001 | Critical | register task_done 映射失败 | **已修复** |
| H-02 | High | cJSON valueint 转 uint16 无边界检查 | **已修复** |
| H-01 | High | MQTT host 字符串未验证长度 | **已修复** |
| M-01 | Medium | biz_cmd_register strncpy_s 未检查返回值 | **已修复** |
