#include "business_logic.h"
#include "business_logic_internal.h"
#include "soc_osal.h"
#include "securec.h"
#include "cJSON.h"
#include "../shared_protocol/shared_protocol.h"
#include "../sle_network/sle_network.h"
#include "tcxo.h"
#include <string.h>

void biz_sle_notify_cb(const ssap_inventory_rsp_t *inv,
    const ssap_bind_rsp_t *bind)
{
    if (inv != NULL) {
        osal_printk("[WS63_BIZ] inv tag=%u qty=%u\r\n",
            (unsigned int)inv->tag_id, (unsigned int)inv->qty);
        biz_tag_entry_t *entry = biz_map_find_by_tag(inv->tag_id);
        if (entry != NULL) {
            entry->qty = inv->qty;
            entry->status = (inv->status == 0) ? BIZ_TAG_ONLINE : BIZ_TAG_OFFLINE;
            entry->battery = inv->battery;
            biz_map_save_nv();
            biz_publish_tag_update(entry);
        }
        if (g_biz_pending.active &&
            strcmp(g_biz_pending.cmd, "inventory") == 0) {
            char *tags_json = biz_build_tags_json();
            biz_reply(g_biz_pending.seq, "inventory", 0, "ok",
                tags_json ? tags_json : "{}");
            if (tags_json != NULL) {
                cJSON_free(tags_json);
            }
            biz_clear_pending();
        }
    }

    if (bind != NULL) {
        osal_printk("[WS63_BIZ] bind cmd=0x%02x tag=%u\r\n",
            bind->cmd, (unsigned int)bind->tag_id);

        /* handle inbound/register bind response */
        if (g_biz_pending.active &&
            (strcmp(g_biz_pending.cmd, "inbound") == 0 ||
             strcmp(g_biz_pending.cmd, "inbound_bind") == 0 ||
             strcmp(g_biz_pending.cmd, "register") == 0 ||
             strcmp(g_biz_pending.cmd, "register_bind") == 0)) {
            if (bind->cmd == SSAP_RSP_BIND_OK) {
                biz_tag_entry_t *entry = biz_map_find_by_tag(g_biz_pending.tag_id);
                if (entry != NULL) {
                    entry->status = BIZ_TAG_BOUND;
                    biz_map_save_nv();
                    biz_publish_tag_update(entry);
                }
                /* for register, forward to ESP32 after bind */
                if (strcmp(g_biz_pending.cmd, "register") == 0 ||
                    strcmp(g_biz_pending.cmd, "register_bind") == 0) {
                    /* update pending.cmd so esp32 task_done "register"
                     * maps to "inbound" and matches */
                    errno_t rc = strncpy_s(g_biz_pending.cmd,
                        sizeof(g_biz_pending.cmd), "inbound",
                        sizeof(g_biz_pending.cmd) - 1);
                    if (rc != EOK) {
                        g_biz_pending.cmd[0] = '\0';
                    }
                    /* 从映射表读取完整参数转发 ESP32 */
                    biz_tag_entry_t *reg_entry = biz_map_find_by_tag(g_biz_pending.tag_id);
                    static char esp32_cmd[192];  /* static: 减少回调栈压力 */
                    char tag_str[8];
                    biz_tag_id_to_esp32(g_biz_pending.tag_id, tag_str, sizeof(tag_str));
                    if (reg_entry != NULL) {
                        snprintf(esp32_cmd, sizeof(esp32_cmd),
                            "{\"cmd\":\"register\",\"tag_id\":\"%s\","
                            "\"item_name\":\"%s\",\"storage_area\":\"%s\",\"quantity\":%u}",
                            tag_str,
                            reg_entry->item, reg_entry->zone,
                            (unsigned int)reg_entry->qty);
                    } else {
                        snprintf(esp32_cmd, sizeof(esp32_cmd),
                            "{\"cmd\":\"register\",\"tag_id\":\"%s\"}",
                            tag_str);
                    }
                    biz_raw_json_send(esp32_cmd);
                    /* keep pending (timeout=15s), wait for ESP32 task_done */
                    return;
                }
                char data_buf[32];
                snprintf(data_buf, sizeof(data_buf),
                    "{\"tag_id\":%u}", (unsigned int)g_biz_pending.tag_id);
                biz_reply(g_biz_pending.seq, "inbound", 0, "ok", data_buf);
            } else {
                biz_map_remove(g_biz_pending.tag_id);
                biz_reply(g_biz_pending.seq, g_biz_pending.cmd, -5, "bind failed", NULL);
            }
            biz_clear_pending();
        }

        /* handle @in,confirm BIND response */
        if (g_biz_pending.active &&
            strcmp(g_biz_pending.cmd, "in_confirm") == 0) {
            if (bind->cmd == SSAP_RSP_BIND_OK) {
                /* 绑定成功：更新状态 + NV + 上云 + 蜂鸣 */
                biz_tag_entry_t *entry = biz_map_find_by_tag(g_biz_pending.tag_id);
                if (entry != NULL) {
                    entry->status = BIZ_TAG_BOUND;
                    biz_map_save_nv();
                    biz_publish_tag_update(entry);
                }
                /* 发送蜂鸣指令（5秒后自动停止由 main loop 处理） */
                sle_network_send_cmd(SSAP_CMD_FIND, g_biz_pending.tag_id);
                biz_screen_reply("MSG", "Bind OK");
                osal_printk("[WS63_BIZ] in,confirm BIND_OK tag=%u\r\n",
                    (unsigned int)g_biz_pending.tag_id);
            } else {
                /* 绑定失败：BS21E 不在范围 */
                biz_screen_reply("ERR", "ERR_BIND_FAIL,Retry scan");
                osal_printk("[WS63_BIZ] in,confirm BIND_FAIL tag=%u\r\n",
                    (unsigned int)g_biz_pending.tag_id);
            }
            biz_clear_pending();
        }

        /* handle outbound unbind/update_qty response */
        if (g_biz_pending.active &&
            strcmp(g_biz_pending.cmd, "outbound") == 0) {
            uint16_t tag_id = g_biz_pending.tag_id;
            if (bind->cmd == SSAP_RSP_BIND_OK || bind->cmd == SSAP_RSP_UNBIND_OK) {
                /* 全量出库解绑成功：删除映射，保存NV */
                biz_map_remove(tag_id);
                biz_map_save_nv();
                char data_buf[32];
                snprintf(data_buf, sizeof(data_buf),
                    "{\"tag_id\":%u}", (unsigned int)tag_id);
                biz_reply(g_biz_pending.seq, "outbound", 0, "ok", data_buf);
            } else {
                /* 0xAF: 解绑/更新失败 */
                biz_reply(g_biz_pending.seq, "outbound", -5, "unbind failed", NULL);
            }
            biz_clear_pending();
        }
    }
}

/* ========== Phase 4: 白名单 + 去重 + status 映射 + 串口屏分发 ========== */

/* 按 MAC 查找 TagListEntry（O(n) 线性查找） */
static struct TagListEntry *biz_tag_list_find_by_mac(const uint8_t *mac)
{
    if (mac == NULL) {
        return NULL;
    }
    for (uint16_t i = 0; i < TAG_LIST_MAX; i++) {
        if (g_biz_tag_list[i].used &&
            memcmp(g_biz_tag_list[i].mac, mac, 6) == 0) {
            return &g_biz_tag_list[i];
        }
    }
    return NULL;
}

/* 更新或创建 TagListEntry 条目 */
static void biz_tag_list_update(const uint8_t *mac, uint16_t tag_id, int8_t rssi)
{
    struct TagListEntry *entry = biz_tag_list_find_by_mac(mac);
    if (entry != NULL) {
        entry->last_seen_ms = uapi_tcxo_get_ms();
        entry->rssi = rssi;
        entry->tag_id = tag_id;
        return;
    }
    /* 新条目：找空位 */
    for (uint16_t i = 0; i < TAG_LIST_MAX; i++) {
        if (!g_biz_tag_list[i].used) {
            (void)memcpy_s(g_biz_tag_list[i].mac, 6, mac, 6);
            g_biz_tag_list[i].tag_id = tag_id;
            g_biz_tag_list[i].rssi = rssi;
            g_biz_tag_list[i].last_seen_ms = uapi_tcxo_get_ms();
            g_biz_tag_list[i].last_publish_ms = 0;
            g_biz_tag_list[i].whitelisted = false;
            g_biz_tag_list[i].used = true;
            return;
        }
    }
    /* 数组满，丢弃 */
}

/* 判断 tag_id 是否已注册（白名单核心） */
static bool biz_is_whitelisted(uint16_t tag_id, const uint8_t *mac)
{
    biz_tag_entry_t *entry = biz_map_find_by_tag(tag_id);
    if (entry == NULL) {
        return false;
    }
    /* MAC 一致性校验 */
    if (memcmp(entry->mac, mac, BIZ_MAC_LEN) != 0) {
        osal_printk("[WS63_BIZ] whitelist MAC mismatch tag_id=%u\r\n",
            (unsigned int)tag_id);
        return false;
    }
    return true;
}

/* 时间窗去重：DEDUP_WINDOW_MS 内不重复上云 */
static bool biz_should_publish(const struct TagListEntry *entry)
{
    if (entry == NULL) {
        return false;
    }
    uint64_t now = uapi_tcxo_get_ms();
    if (entry->last_publish_ms != 0 &&
        (now - entry->last_publish_ms) < DEDUP_WINDOW_MS) {
        return false;  /* 去重窗口内，跳过 */
    }
    return true;
}

/* BS21E status → WS63 上云 status 映射 */
static int biz_map_status_to_cloud(uint8_t bs21e_status, bool whitelisted)
{
    if (!whitelisted) {
        return 0;  /* 未注册 → 空闲 */
    }
    switch (bs21e_status) {
        case BS21E_STATUS_IDLE:           return 2;  /* 在线-空闲 */
        case BS21E_STATUS_FINDING:        return 2;  /* 在线-寻物 */
        case BS21E_STATUS_IN_USE:         return 2;  /* 在线-使用中 */
        case BS21E_STATUS_NOT_PROVISIONED: return 0;  /* 未配网 → 空闲 */
        default:                          return 2;
    }
}

/* 主循环调用：处理扫描表中的条目，白名单+去重后上云 */
void biz_handle_sle_adv(void)
{
    const sle_scan_entry_t *scan = sle_network_get_scan_table();
    uint16_t count = sle_network_get_scan_table_count();
    uint64_t now = uapi_tcxo_get_ms();

    for (uint16_t i = 0; i < SLE_SCAN_TABLE_MAX && count > 0; i++) {
        if (!scan[i].used) {
            continue;
        }
        count--;

        /* 更新 TagListEntry（白名单+去重共用） */
        biz_tag_list_update(scan[i].mac, scan[i].tag_id, 0);

        struct TagListEntry *tle = biz_tag_list_find_by_mac(scan[i].mac);
        if (tle == NULL) {
            continue;
        }

        /* 自动同步 MAC：如果 biz_map 中该 tag_id 的 MAC 为空或不匹配，从扫描表更新 */
        biz_tag_entry_t *entry_for_mac = biz_map_find_by_tag(scan[i].tag_id);
        if (entry_for_mac != NULL) {
            bool mac_empty = true;
            for (int m = 0; m < BIZ_MAC_LEN; m++) {
                if (entry_for_mac->mac[m] != 0) { mac_empty = false; break; }
            }
            if (mac_empty || memcmp(entry_for_mac->mac, scan[i].mac, BIZ_MAC_LEN) != 0) {
                (void)memcpy_s(entry_for_mac->mac, BIZ_MAC_LEN, scan[i].mac, BIZ_MAC_LEN);
                biz_map_save_nv();
                osal_printk("[WS63_BIZ] auto-sync MAC for tag=%u from scan table\r\n",
                    (unsigned int)scan[i].tag_id);
            }
        }

        /* 白名单判定 */
        bool whitelisted = biz_is_whitelisted(scan[i].tag_id, scan[i].mac);
        tle->whitelisted = whitelisted;

        if (!whitelisted) {
            continue;  /* 未注册，不上云 */
        }

        /* 时间窗去重 */
        if (!biz_should_publish(tle)) {
            continue;
        }

        /* status 映射 */
        int cloud_status = biz_map_status_to_cloud(scan[i].status, whitelisted);

        /* 更新映射表条目 */
        biz_tag_entry_t *entry = biz_map_find_by_tag(scan[i].tag_id);
        if (entry != NULL) {
            entry->battery = scan[i].battery;
            entry->qty = scan[i].qty;
            entry->status = (biz_tag_status_t)cloud_status;
        }

        /* MQTT 网关上云 */
        biz_publish_tag_update(entry);

        /* 更新去重时间戳 */
        tle->last_publish_ms = now;
    }
}

/* 主循环调用：检查 SSAP 就绪后发送命令（confirm_conn / find_locate_connecting） */
void biz_check_confirm_bind(void)
{
    if (!g_biz_pending.active) {
        return;
    }

    /* 只处理需要等待 SSAP 的 pending 状态 */
    bool is_confirm = (strcmp(g_biz_pending.cmd, "confirm_conn") == 0);
    bool is_locate = (strcmp(g_biz_pending.cmd, "locate_conn") == 0);
    if (!is_confirm && !is_locate) {
        return;
    }

    /* 检查连接是否还活着 */
    if (sle_network_is_link_lost()) {
        biz_screen_reply("ERR", "ERR_CONNECT_LOST,Connection lost");
        biz_clear_pending();
        sle_network_clear_connecting();
        (void)sle_network_start_scan();
        return;
    }

    /* 检查 SSAP 是否就绪 */
    if (!sle_network_is_ssap_ready()) {
        static uint32_t wait_log_count = 0;
        if (wait_log_count < 3) {
            wait_log_count++;
            osal_printk("[WS63_BIZ] ssap not ready yet, waiting...\r\n");
        }
        return;  /* 还没就绪，继续等 */
    }

    /* SSAP 就绪，根据 pending 类型发送不同命令 */
    uint8_t cmd = is_confirm ? SSAP_CMD_BIND_TAG : SSAP_CMD_FIND;
    int ret = sle_network_send_cmd(cmd, g_biz_pending.tag_id);
    if (ret != 0) {
        biz_screen_reply("ERR", is_confirm ? "ERR_BIND_SEND_FAIL,Bind send fail"
                                           : "ERR_FIND_SEND_FAIL,Find send fail");
        biz_clear_pending();
        sle_network_clear_connecting();
        (void)sle_network_start_scan();
        return;
    }

    if (is_confirm) {
        biz_set_pending("in_confirm", 0, g_biz_pending.tag_id);
        biz_screen_reply("MSG", "Binding...");
        osal_printk("[WS63_BIZ] in,confirm tag=%u SSAP ready, sent BIND_TAG\r\n",
            (unsigned int)g_biz_pending.tag_id);
    } else {
        /* 发送 #LOCATE,found 给屏幕，记录到活跃列表（start_ms 从现在开始） */
        biz_locate_record_tag(g_biz_pending.tag_id);
        biz_screen_reply("LOCATE", "found,%04u", (unsigned int)g_biz_pending.tag_id);
        biz_clear_pending();
        osal_printk("[WS63_BIZ] find,locate tag=%u SSAP ready, sent FIND\r\n",
            (unsigned int)g_biz_pending.tag_id);
    }
}
