# 阶段一修复报告：协议层同步

> 日期: 2026-05-17
> 阶段: Phase 1 — 协议层同步 (任务 #1-#10)
> 文件: shared_protocol.h, sle_network.c, business_logic.c

---

## 改动清单

### Fix P1-1: 添加 SSAP_RSP_UNBIND_OK 定义

**文件**: `shared_protocol.h`
**任务**: #1

```c
#define SSAP_RSP_UNBIND_OK      0xA1
```

**原因**: BS21E 解绑成功后发送 0xA1 响应，WS63 原先未定义此宏，导致通知回调无法识别解绑成功。

### Fix P1-2: 通知回调增加 0xA1 分发

**文件**: `sle_network.c` — `my63_ssap_notification_cb()`
**任务**: #5

```c
/* 修复前 */
} else if (data->data[0] == SSAP_RSP_BIND_OK || data->data[0] == SSAP_RSP_BIND_FAIL) {

/* 修复后 */
} else if (data->data[0] == SSAP_RSP_BIND_OK || data->data[0] == SSAP_RSP_UNBIND_OK || data->data[0] == SSAP_RSP_BIND_FAIL) {
```

**原因**: 0xA1 (unbind OK) 使用与 0xA0 (bind OK) 相同的 `ssap_bind_rsp_t` 结构体（cmd + tag_id），共用解包逻辑。

### Fix P1-3: outbound 区分解绑成功/失败

**文件**: `business_logic.c` — `biz_sle_notify_cb()` outbound 段
**任务**: #6

```c
/* 修复前：不区分成功失败，一律删映射+回复成功 */
biz_map_remove(tag_id);
biz_reply(seq, "outbound", 0, "ok", ...);

/* 修复后：区分 0xA0/0xA1 成功 vs 0xAF 失败 */
if (bind->cmd == SSAP_RSP_BIND_OK || bind->cmd == SSAP_RSP_UNBIND_OK) {
    biz_map_remove(tag_id);
    biz_map_save_nv();
    biz_reply(seq, "outbound", 0, "ok", ...);
} else {
    biz_reply(seq, "outbound", -5, "unbind failed", NULL);
}
```

**原因**: 原代码将 0xAF (失败) 也当作成功处理，会误删映射表条目。

---

## 验证方法

1. 串口屏发送 `{"cmd":"outbound","seq":1,"data":{"tag_id":5,"remove_qty":0}}`
2. WS63 发送 UNBIND_TAG (0x21) 给 BS21E
3. BS21E 回复 0xA1 → WS63 回复串口屏 `code=0`
4. BS21E 回复 0xAF → WS63 回复串口屏 `code=-5 "unbind failed"`

---

## 关联任务

- #1 SSAP_RSP_UNBIND_OK 定义 ✅
- #5 通知回调 0xA1 分发 ✅
- #6 business_logic unbind 处理 ✅
