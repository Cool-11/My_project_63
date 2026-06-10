#include "business_logic.h"
#include "business_logic_internal.h"
#include "soc_osal.h"
#include "securec.h"
#include "cJSON.h"
#include "../uart_display/uart_display.h"
#include "../sle_network/sle_network.h"
#include "tcxo.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

/* ========== 共用扫描逻辑 ========== */

/* 扫描表查找结果 */
typedef enum {
    SCAN_OK,            /* 找到最佳标签 */
    SCAN_EMPTY,         /* 扫描表为空 */
    SCAN_ALL_REGISTERED /* 所有标签已注册 */
} scan_result_t;

/* 从扫描表取最强标签（registered=true 取已注册，false 取未注册） */
static scan_result_t biz_scan_find_best(bool registered, int *out_idx)
{
    const sle_scan_entry_t *scan = sle_network_get_scan_table();
    if (scan == NULL) {
        return SCAN_EMPTY;
    }

    int best_idx = -1;
    uint64_t best_time = 0;
    bool has_any = false;
    bool has_match = false;

    for (uint16_t i = 0; i < SLE_SCAN_TABLE_MAX; i++) {
        if (!scan[i].used) continue;
        has_any = true;

        bool in_map = (biz_map_find_by_tag(scan[i].tag_id) != NULL);
        bool match = registered ? in_map : !in_map;
        if (!match) continue;

        has_match = true;
        if (scan[i].last_seen_ms > best_time) {
            best_time = scan[i].last_seen_ms;
            best_idx = (int)i;
        }
    }

    if (!has_any) return SCAN_EMPTY;
    if (!has_match) return SCAN_ALL_REGISTERED;
    *out_idx = best_idx;
    return SCAN_OK;
}

/* ========== Page1 入库命令处理 ========== */

/* @in,start → 扫描未注册 → #TAG；已注册 → #VERIFY */
static void biz_screen_in_start(void)
{
    int idx = 0;
    scan_result_t r = biz_scan_find_best(false, &idx);

    if (r == SCAN_EMPTY) {
        biz_screen_reply("MSG", "No tag nearby");
        return;
    }

    const sle_scan_entry_t *scan = sle_network_get_scan_table();

    if (r == SCAN_ALL_REGISTERED) {
        /* 所有标签已注册 → 取最强的已注册标签发 #VERIFY */
        int ridx = 0;
        scan_result_t rr = biz_scan_find_best(true, &ridx);
        if (rr != SCAN_OK) {
            biz_screen_reply("MSG", "No registered tag nearby");
            return;
        }
        uint16_t rtag = scan[ridx].tag_id;
        biz_tag_entry_t *entry = biz_map_find_by_tag(rtag);
        if (entry == NULL) {
            biz_screen_reply("MSG", "Tag not in database");
            return;
        }
        char tag_str[8];
        ud_tag_id_to_str(rtag, tag_str, sizeof(tag_str));
        biz_screen_reply("VERIFY", "%s,%s,%s,%u",
            tag_str, entry->item, entry->zone, (unsigned int)entry->qty);
        biz_set_pending("in_start", 0, rtag);
        osal_printk("[WS63_BIZ] in,start VERIFY tag=%s item=%s zone=%s qty=%u\r\n",
            tag_str, entry->item, entry->zone, (unsigned int)entry->qty);
        return;
    }

    uint16_t tag_id = scan[idx].tag_id;

    /* 未注册标签（tag_id=0）：预分配新 ID */
    if (tag_id == 0) {
        tag_id = 1;
        for (uint16_t i = 0; i < g_biz_map.count; i++) {
            if (g_biz_map.entries[i].tag_id >= tag_id) {
                tag_id = g_biz_map.entries[i].tag_id + 1;
            }
        }
        biz_tag_entry_t *entry = biz_map_add(tag_id);
        if (entry != NULL) {
            (void)memcpy_s(entry->mac, BIZ_MAC_LEN, scan[idx].mac, BIZ_MAC_LEN);
            sle_network_update_scan_tag_id(scan[idx].mac, tag_id);
            osal_printk("[WS63_BIZ] in,start pre-assign tag_id=%u\r\n",
                (unsigned int)tag_id);
        }
    }

    char tag_str[8];
    ud_tag_id_to_str(tag_id, tag_str, sizeof(tag_str));
    biz_screen_reply("TAG", "%s", tag_str);
    biz_set_pending("in_start", 0, tag_id);
}

/* @in,capture,<id>,<qty>,<area>,<name>,<mode> → 拼register JSON */
static void biz_screen_in_capture(const char *params)
{
    /* 解析: id,qty,area,name,mode */
    char id_str[8] = {0};
    char qty_str[8] = {0};
    char area[32] = {0};
    char name[64] = {0};
    char mode_str[4] = {0};

    int parsed = sscanf(params, "%7[^,],%7[^,],%31[^,],%63[^,],%3[^,]",
        id_str, qty_str, area, name, mode_str);
    if (parsed < 2) {
        biz_screen_reply("ERR", "INVALID_PARAMS,Missing params");
        return;
    }

    uint16_t tag_id = 0;
    if (ud_str_to_tag_id(id_str, &tag_id) != 0) {
        biz_screen_reply("ERR", "INVALID_ID,Bad tag ID");
        return;
    }

    int mode = (parsed >= 5) ? atoi(mode_str) : 0;
    int qty = atoi(qty_str);

    /* 构造ESP32 register JSON */
    char tag_esp32[8];
    biz_tag_id_to_esp32(tag_id, tag_esp32, sizeof(tag_esp32));

    char esp32_json[256];
    if (mode == 2) {
        /* 验证模式: 仅tag_id+quantity */
        snprintf(esp32_json, sizeof(esp32_json),
            "{\"cmd\":\"register\",\"tag_id\":\"%s\",\"quantity\":%d}",
            tag_esp32, qty);
    } else {
        /* 新注册/覆写: 完整字段 */
        snprintf(esp32_json, sizeof(esp32_json),
            "{\"cmd\":\"register\",\"tag_id\":\"%s\",\"item_name\":\"%s\","
            "\"storage_area\":\"%s\",\"quantity\":%d,\"is_overwrite\":%s}",
            tag_esp32, name, area, qty, (mode == 1) ? "true" : "false");
    }

    biz_raw_json_send(esp32_json);

    /* 记录 pending（不连接 BS21E，等 @in,confirm 时再连） */
    biz_set_pending("in_capture", 0, tag_id);
    biz_screen_reply("PROG", "1,front,0");
    osal_printk("[WS63_BIZ] screen in,capture tag=%s qty=%d mode=%d json=%s\r\n",
        id_str, qty, mode, esp32_json);
}

/* @in,photo,<view> → capture JSON */
static void biz_screen_in_photo(const char *view)
{
    char esp32_json[64];
    snprintf(esp32_json, sizeof(esp32_json),
        "{\"cmd\":\"capture\",\"view\":\"%s\"}", view);
    osal_printk("[WS63_BIZ] →ESP32 capture view=%s json=%s\r\n", view, esp32_json);
    biz_raw_json_send(esp32_json);
}

/* @in,confirm → 连接BS21E → BIND_TAG → 蜂鸣5s → NV+上云 */
static void biz_screen_in_confirm(void)
{
    if (!g_biz_pending.active) {
        biz_screen_reply("ERR", "ERR_NO_PENDING,No pending op");
        return;
    }

    /* 用 pending 中的 tag_id 查 biz_map 获取 MAC */
    biz_tag_entry_t *entry = biz_map_find_by_tag(g_biz_pending.tag_id);
    if (entry == NULL) {
        biz_screen_reply("ERR", "ERR_NOT_REGISTERED,Not registered");
        biz_clear_pending();
        return;
    }

    /* 连接 BS21E */
    int ret = sle_network_connect_by_tag(g_biz_pending.tag_id);
    if (ret != 0) {
        biz_screen_reply("ERR", "ERR_CONNECT_FAIL,Connect fail(%d)", ret);
        biz_clear_pending();
        return;
    }

    /* 发送 BIND_TAG */
    ret = sle_network_send_cmd(SSAP_CMD_BIND_TAG, g_biz_pending.tag_id);
    if (ret != 0) {
        biz_screen_reply("ERR", "ERR_BIND_SEND_FAIL,Bind send fail");
        biz_clear_pending();
        return;
    }

    /* 更新 pending 状态，等待 biz_sle_notify_cb 回调 */
    biz_set_pending("in_confirm", 0, g_biz_pending.tag_id);
    biz_screen_reply("MSG", "Binding...");
    osal_printk("[WS63_BIZ] in,confirm tag=%u sent BIND_TAG\r\n",
        (unsigned int)g_biz_pending.tag_id);
}

/* @in,cancel → 取消 */
static void biz_screen_in_cancel(void)
{
    char esp32_json[32];
    snprintf(esp32_json, sizeof(esp32_json), "{\"cmd\":\"cancel\"}");
    biz_raw_json_send(esp32_json);

    /* 清理预分配的 biz_map 条目（状态仍为 IDLE） */
    if (g_biz_pending.active && g_biz_pending.tag_id != 0) {
        biz_tag_entry_t *entry = biz_map_find_by_tag(g_biz_pending.tag_id);
        if (entry != NULL && entry->status == BIZ_TAG_IDLE) {
            biz_map_remove(g_biz_pending.tag_id);
            osal_printk("[WS63_BIZ] in,cancel remove pre-assigned tag_id=%u\r\n",
                (unsigned int)g_biz_pending.tag_id);
        }
    }
    biz_clear_pending();
    biz_screen_reply("MSG", "Inbound cancelled");
}

/* ========== Page2 出库命令处理 ========== */

/* @out,start → 扫描已注册 → #TAG,name,area,total / #MSG */
static void biz_screen_out_start(void)
{
    int idx = 0;
    scan_result_t r = biz_scan_find_best(true, &idx);

    if (r == SCAN_EMPTY || r == SCAN_ALL_REGISTERED) {
        biz_screen_reply("MSG", "No registered tag nearby");
        return;
    }

    const sle_scan_entry_t *scan = sle_network_get_scan_table();
    biz_tag_entry_t *entry = biz_map_find_by_tag(scan[idx].tag_id);
    if (entry == NULL) {
        biz_screen_reply("ERR", "ERR_INTERNAL,Internal error");
        return;
    }

    char tag_str[8];
    ud_tag_id_to_str(entry->tag_id, tag_str, sizeof(tag_str));
    biz_screen_reply("TAG", "%s,%s,%s,%u",
        tag_str, entry->item, entry->zone, (unsigned int)entry->qty);
    biz_set_pending("out_start", 0, entry->tag_id);
}

/* @out,capture,<id>,<qty> → outbound JSON */
static void biz_screen_out_capture(const char *params)
{
    char id_str[8] = {0};
    char qty_str[8] = {0};

    if (sscanf(params, "%7[^,],%7[^,]", id_str, qty_str) < 2) {
        biz_screen_reply("ERR", "INVALID_PARAMS,Missing params");
        return;
    }

    uint16_t tag_id = 0;
    if (ud_str_to_tag_id(id_str, &tag_id) != 0) {
        biz_screen_reply("ERR", "INVALID_ID,Bad tag ID");
        return;
    }

    char tag_esp32[8];
    biz_tag_id_to_esp32(tag_id, tag_esp32, sizeof(tag_esp32));

    char esp32_json[128];
    snprintf(esp32_json, sizeof(esp32_json),
        "{\"cmd\":\"outbound\",\"tag_id\":\"%s\",\"remove_qty\":%s}",
        tag_esp32, qty_str);

    biz_raw_json_send(esp32_json);
    biz_set_pending("outbound", 0, tag_id);
    osal_printk("[WS63_BIZ] screen out,capture tag=%s qty=%s\r\n", id_str, qty_str);
}

/* @out,photo,front → capture JSON */
static void biz_screen_out_photo(const char *view)
{
    char esp32_json[64];
    snprintf(esp32_json, sizeof(esp32_json),
        "{\"cmd\":\"capture\",\"view\":\"%s\"}", view);
    biz_raw_json_send(esp32_json);
}

/* @out,confirm → 持久化 */
static void biz_screen_out_confirm(void)
{
    biz_map_save_nv();
    biz_screen_reply("MSG", "Outbound confirmed");
    osal_printk("[WS63_BIZ] out,confirm saved NV\r\n");
}

/* @out,cancel → 取消 */
static void biz_screen_out_cancel(void)
{
    char esp32_json[32];
    snprintf(esp32_json, sizeof(esp32_json), "{\"cmd\":\"cancel\"}");
    biz_raw_json_send(esp32_json);
    biz_clear_pending();
    biz_screen_reply("MSG", "Outbound cancelled");
}

/* ========== Page3 盘点命令处理 ========== */

/* @check,global → SLE计数 + ESP32 list_assets_page → 比对 → #INV + #MSG */
static uint16_t g_check_global_sle_count = 0;  /* 异步流程暂存 */

static void biz_screen_check_global(void)
{
    /* 1. 统计 SLE 扫描表中的标签数 */
    const sle_scan_entry_t *scan = sle_network_get_scan_table();
    uint16_t sle_count = 0;
    if (scan != NULL) {
        for (uint16_t i = 0; i < SLE_SCAN_TABLE_MAX; i++) {
            if (scan[i].used) {
                sle_count++;
            }
        }
    }
    g_check_global_sle_count = sle_count;

    /* 2. 发 list_assets_page 给 ESP32（仅取 total_count） */
    char esp32_json[64];
    snprintf(esp32_json, sizeof(esp32_json),
        "{\"cmd\":\"list_assets_page\",\"page\":1,\"page_size\":1}");
    biz_raw_json_send(esp32_json);

    /* 3. 设置 pending，等待 asset_list_page 响应 */
    biz_set_pending("check_global", 0, 0);
    biz_screen_reply("MSG", "Global inventory...");
    osal_printk("[WS63_BIZ] check,global sle_count=%u\r\n", (unsigned int)sle_count);
}

/* 全局盘点：收到 asset_list_page 后执行比对（由 biz_esp32_resp.c 调用） */
void biz_check_global_compare(uint16_t esp32_total)
{
    uint16_t sle_count = g_check_global_sle_count;
    uint16_t match_count = 0;
    uint16_t miss_count = 0;

    /* 遍历 biz_map，逐个比对 */
    const sle_scan_entry_t *scan = sle_network_get_scan_table();
    for (uint16_t i = 0; i < g_biz_map.count; i++) {
        biz_tag_entry_t *entry = &g_biz_map.entries[i];
        bool found_in_sle = false;

        /* 检查是否在 SLE 扫描表中 */
        if (scan != NULL) {
            for (uint16_t j = 0; j < SLE_SCAN_TABLE_MAX; j++) {
                if (scan[j].used && scan[j].tag_id == entry->tag_id) {
                    found_in_sle = true;
                    break;
                }
            }
        }

        if (!found_in_sle) {
            /* Not scanned */
            char tag_str[8];
            ud_tag_id_to_str(entry->tag_id, tag_str, sizeof(tag_str));
            biz_screen_reply("MSG", "%s Not scanned", tag_str);
            miss_count++;
        } else {
            /* 盘点到，比对数据（item_name + quantity） */
            /* 注意：ESP32 的详细数据需要逐页查询，这里只做 SLE 可见性检查 */
            match_count++;
        }
    }

    /* 返回概览 */
    biz_screen_reply("INV", "%u,%u", (unsigned int)sle_count, (unsigned int)esp32_total);
    osal_printk("[WS63_BIZ] check,global done: sle=%u esp32=%u match=%u miss=%u\r\n",
        (unsigned int)sle_count, (unsigned int)esp32_total,
        (unsigned int)match_count, (unsigned int)miss_count);
}

/* @check,specific,<id> → get_asset → #TAG_INFO */
static void biz_screen_check_specific(const char *id_str)
{
    uint16_t tag_id = 0;
    if (ud_str_to_tag_id(id_str, &tag_id) != 0) {
        biz_screen_reply("ERR", "INVALID_ID,Bad tag ID");
        return;
    }

    char tag_esp32[8];
    biz_tag_id_to_esp32(tag_id, tag_esp32, sizeof(tag_esp32));

    char esp32_json[96];
    snprintf(esp32_json, sizeof(esp32_json),
        "{\"cmd\":\"get_asset\",\"tag_id\":\"%s\"}", tag_esp32);
    biz_raw_json_send(esp32_json);
    osal_printk("[WS63_BIZ] screen check,specific tag=%s\r\n", id_str);
}

/* @check,capture,<id> → inventory JSON */
static void biz_screen_check_capture(const char *id_str)
{
    uint16_t tag_id = 0;
    if (ud_str_to_tag_id(id_str, &tag_id) != 0) {
        biz_screen_reply("ERR", "INVALID_ID,Bad tag ID");
        return;
    }

    char tag_esp32[8];
    biz_tag_id_to_esp32(tag_id, tag_esp32, sizeof(tag_esp32));

    char esp32_json[96];
    snprintf(esp32_json, sizeof(esp32_json),
        "{\"cmd\":\"inventory\",\"tag_id\":\"%s\"}", tag_esp32);
    biz_raw_json_send(esp32_json);
    biz_set_pending("inventory", 0, tag_id);
    biz_screen_reply("PROG", "1,front,0");
}

/* @check,photo,<view> → capture JSON */
static void biz_screen_check_photo(const char *view)
{
    char esp32_json[64];
    snprintf(esp32_json, sizeof(esp32_json),
        "{\"cmd\":\"capture\",\"view\":\"%s\"}", view);
    biz_raw_json_send(esp32_json);
}

/* ========== Page4 查找命令处理 ========== */

#define LOCATE_MAX_TAGS    8
#define LOCATE_BEEP_MS     5000

static struct {
    uint16_t tag_id;
    uint64_t start_ms;
} g_locate_tags[LOCATE_MAX_TAGS] = {0};
static uint16_t g_locate_count = 0;

/* @find,list,<page> → list_assets_page */
static void biz_screen_find_list(const char *page_str)
{
    int page = atoi(page_str);
    if (page < 1) page = 1;

    char esp32_json[96];
    snprintf(esp32_json, sizeof(esp32_json),
        "{\"cmd\":\"list_assets_page\",\"page\":%d,\"page_size\":6}", page);
    biz_raw_json_send(esp32_json);
}

/* @find,locate,<id> → 连接BS21E + 蜂鸣（不经ESP32） */
static void biz_screen_find_locate(const char *id_str)
{
    uint16_t tag_id = 0;
    if (ud_str_to_tag_id(id_str, &tag_id) != 0) {
        biz_screen_reply("ERR", "INVALID_ID,Bad tag ID");
        return;
    }

    if (g_locate_count >= LOCATE_MAX_TAGS) {
        biz_screen_reply("ERR", "ERR_TOO_MANY,Max 8 tags");
        return;
    }

    /* 连接 BS21E */
    int ret = sle_network_connect_by_tag(tag_id);
    if (ret != 0) {
        biz_screen_reply("LOCATE", "timeout,%s", id_str);
        osal_printk("[WS63_BIZ] find,locate connect fail tag=%s ret=%d\r\n", id_str, ret);
        return;
    }

    /* 发送蜂鸣指令 */
    ret = sle_network_send_cmd(SSAP_CMD_FIND, tag_id);
    if (ret != 0) {
        biz_screen_reply("LOCATE", "timeout,%s", id_str);
        return;
    }

    /* 记录到活跃列表 */
    g_locate_tags[g_locate_count].tag_id = tag_id;
    g_locate_tags[g_locate_count].start_ms = uapi_tcxo_get_ms();
    g_locate_count++;

    biz_screen_reply("LOCATE", "found,%s", id_str);
    osal_printk("[WS63_BIZ] find,locate tag=%s beep started\r\n", id_str);
}

/* @find,stop → 停止所有蜂鸣 */
static void biz_screen_find_stop(void)
{
    for (uint16_t i = 0; i < g_locate_count; i++) {
        sle_network_send_cmd(SSAP_CMD_STOP_FIND, g_locate_tags[i].tag_id);
    }
    g_locate_count = 0;
    biz_screen_reply("MSG", "Stopped");
    osal_printk("[WS63_BIZ] find,stop all beeps stopped\r\n");
}

/* 寻物超时检查：5秒后自动停止蜂鸣（由 business_logic_poll 调用） */
void biz_locate_check_timeout(void)
{
    if (g_locate_count == 0) {
        return;
    }
    uint64_t now = uapi_tcxo_get_ms();
    uint16_t remaining = 0;

    for (uint16_t i = 0; i < g_locate_count; i++) {
        if (now - g_locate_tags[i].start_ms >= LOCATE_BEEP_MS) {
            /* 超时，自动停止蜂鸣 */
            sle_network_send_cmd(SSAP_CMD_STOP_FIND, g_locate_tags[i].tag_id);
            osal_printk("[WS63_BIZ] locate auto-stop tag=%u\r\n",
                (unsigned int)g_locate_tags[i].tag_id);
        } else {
            /* 未超时，保留 */
            if (remaining != i) {
                g_locate_tags[remaining] = g_locate_tags[i];
            }
            remaining++;
        }
    }
    g_locate_count = remaining;
}

/* ========== Page5 设置命令处理 ========== */

/* @setting,wifi,<ssid>,<pwd> → WiFi连接 */
static void biz_screen_setting_wifi(const char *params)
{
    char ssid[64] = {0};
    char pwd[64] = {0};
    sscanf(params, "%63[^,],%63[^,]", ssid, pwd);

    if (g_biz_wifi_cmd_cb != NULL) {
        int ret = g_biz_wifi_cmd_cb(ssid, pwd);
        if (ret == 0) {
            biz_screen_reply("WIFI", "ok");
        } else {
            biz_screen_reply("WIFI", "fail");
        }
    } else {
        biz_screen_reply("ERR", "WIFI_NOT_AVAILABLE,WiFi unavailable");
    }
}

/* @setting,disconnect → WiFi断开 */
static void biz_screen_setting_disconnect(void)
{
    if (g_biz_wifi_cmd_cb != NULL) {
        g_biz_wifi_cmd_cb(NULL, NULL);
    }
    biz_screen_reply("NET", "wifi,disconnected,");
}

/* ========== 统一命令分发（拆分为子分发器） ========== */

static void biz_screen_dispatch_in(const char *params)
{
    if (params == NULL || strncmp(params, "start", 5) == 0) {
        biz_screen_in_start();
    } else if (strncmp(params, "capture", 7) == 0) {
        biz_screen_in_capture(params + 8);
    } else if (strncmp(params, "photo", 5) == 0) {
        biz_screen_in_photo(params + 6);
    } else if (strncmp(params, "confirm", 7) == 0) {
        biz_screen_in_confirm();
    } else if (strncmp(params, "cancel", 6) == 0) {
        biz_screen_in_cancel();
    }
}

static void biz_screen_dispatch_out(const char *params)
{
    if (params == NULL || strncmp(params, "start", 5) == 0) {
        biz_screen_out_start();
    } else if (strncmp(params, "capture", 7) == 0) {
        biz_screen_out_capture(params + 8);
    } else if (strncmp(params, "photo", 5) == 0) {
        biz_screen_out_photo(params + 6);
    } else if (strncmp(params, "confirm", 7) == 0) {
        biz_screen_out_confirm();
    } else if (strncmp(params, "cancel", 6) == 0) {
        biz_screen_out_cancel();
    }
}

static void biz_screen_dispatch_check(const char *params)
{
    if (params == NULL || strncmp(params, "global", 6) == 0) {
        biz_screen_check_global();
    } else if (strncmp(params, "all", 3) == 0) {
        /* @inv,all → 同全局盘点 */
        biz_screen_check_global();
    } else if (strncmp(params, "specific", 8) == 0) {
        biz_screen_check_specific(params + 9);
    } else if (strncmp(params, "tag", 3) == 0) {
        /* @inv,tag,<id> → 单标签盘点 */
        biz_screen_check_specific(params + 4);
    } else if (strncmp(params, "zone", 4) == 0) {
        /* @inv,zone,<zone> → 按区域盘点（暂降级为全局，待屏端支持区域筛选） */
        biz_screen_check_global();
    } else if (strncmp(params, "capture", 7) == 0) {
        biz_screen_check_capture(params + 8);
    } else if (strncmp(params, "photo", 5) == 0) {
        biz_screen_check_photo(params + 6);
    } else if (strncmp(params, "cancel", 6) == 0) {
        biz_clear_pending();
        biz_screen_reply("MSG", "Check cancelled");
    }
}

static void biz_screen_dispatch_find(const char *params)
{
    if (strncmp(params, "list", 4) == 0) {
        biz_screen_find_list(params + 5);
    } else if (strncmp(params, "start", 5) == 0) {
        /* 屏端协议发送 @find,start,<id> 用于寻物，与 locate 行为一致 */
        biz_screen_find_locate(params + 6);
    } else if (strncmp(params, "locate", 6) == 0) {
        biz_screen_find_locate(params + 7);
    } else if (strncmp(params, "stop", 4) == 0) {
        biz_screen_find_stop();
    } else if (strncmp(params, "cancel", 6) == 0) {
        biz_screen_reply("MSG", "Find cancelled");
    }
}

static void biz_screen_dispatch_setting(const char *params)
{
    if (strncmp(params, "wifi", 4) == 0) {
        biz_screen_setting_wifi(params + 5);
    } else if (strncmp(params, "disconnect", 10) == 0) {
        biz_screen_setting_disconnect();
    } else if (strncmp(params, "cancel", 6) == 0) {
        biz_screen_reply("MSG", "Setting cancelled");
    }
}

/* 串口屏命令分发：按页面分发到子分发器 */
void biz_handle_screen_cmd(const char *cmd, const char *params)
{
    if (cmd == NULL) return;

    if (strcmp(cmd, "in") == 0) {
        biz_screen_dispatch_in(params);
    } else if (strcmp(cmd, "out") == 0) {
        biz_screen_dispatch_out(params);
    } else if (strcmp(cmd, "check") == 0 || strcmp(cmd, "inv") == 0) {
        biz_screen_dispatch_check(params);
    } else if (strcmp(cmd, "find") == 0) {
        biz_screen_dispatch_find(params);
    } else if (strcmp(cmd, "setting") == 0) {
        biz_screen_dispatch_setting(params);
    } else if (strcmp(cmd, "back") == 0) {
        biz_screen_reply("HOME", "");
    } else {
        biz_screen_reply("ERR", "UNKNOWN_CMD,Unknown cmd");
    }
}
