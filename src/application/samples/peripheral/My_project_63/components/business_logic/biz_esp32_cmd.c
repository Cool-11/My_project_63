#include "business_logic.h"
#include "business_logic_internal.h"
#include "soc_osal.h"
#include "securec.h"
#include "cJSON.h"
#include "../sle_network/sle_network.h"
#include <string.h>

void biz_cmd_inbound(uint16_t seq, const char *data_json)
{
    cJSON *root = cJSON_Parse(data_json);
    if (root == NULL) {
        biz_reply(seq, "inbound", -2, "json parse fail", NULL);
        return;
    }
    cJSON *j_tag_id = cJSON_GetObjectItem(root, "tag_id");
    if (j_tag_id == NULL || !cJSON_IsNumber(j_tag_id) ||
        j_tag_id->valueint < 0 || j_tag_id->valueint > 0xFFFF) {
        cJSON_Delete(root);
        biz_reply(seq, "inbound", -3, "missing or invalid tag_id", NULL);
        return;
    }
    uint16_t tag_id = (uint16_t)j_tag_id->valueint;

    /* 检查扫描表 */
    const sle_scan_entry_t *scan = sle_network_get_scan_table();
    bool found = false;
    for (uint16_t i = 0; i < SLE_SCAN_TABLE_MAX; i++) {
        if (scan[i].used && scan[i].tag_id == tag_id) {
            found = true;
            break;
        }
    }
    if (!found) {
        cJSON_Delete(root);
        biz_reply(seq, "inbound", -4, "tag_id not in scan table", NULL);
        return;
    }

    if (biz_map_find_by_tag(tag_id) != NULL) {
        cJSON_Delete(root);
        biz_reply(seq, "inbound", -5, "tag_id already registered", NULL);
        return;
    }

    if (g_biz_pending.active) {
        cJSON_Delete(root);
        biz_reply(seq, "inbound", -6, "busy", NULL);
        return;
    }

    biz_tag_entry_t *entry = biz_map_add(tag_id);
    if (entry == NULL) {
        cJSON_Delete(root);
        biz_reply(seq, "inbound", -7, "map full", NULL);
        return;
    }

    /* 从扫描表复制 MAC */
    for (uint16_t i = 0; i < SLE_SCAN_TABLE_MAX; i++) {
        if (scan[i].used && scan[i].tag_id == tag_id) {
            (void)memcpy_s(entry->mac, BIZ_MAC_LEN, scan[i].mac, BIZ_MAC_LEN);
            entry->battery = scan[i].battery;
            break;
        }
    }

    cJSON *j_zone = cJSON_GetObjectItem(root, "storage_area");
    cJSON *j_item = cJSON_GetObjectItem(root, "item_name");
    if (j_zone != NULL && cJSON_IsString(j_zone)) {
        errno_t rc = strncpy_s(entry->zone, BIZ_ZONE_LEN,
            j_zone->valuestring, BIZ_ZONE_LEN - 1);
        if (rc != EOK) {
            osal_printk("[WS63_BIZ] inbound zone copy fail rc=%d\r\n", (int)rc);
            entry->zone[0] = '\0';
        }
    }
    if (j_item != NULL && cJSON_IsString(j_item)) {
        errno_t rc = strncpy_s(entry->item, BIZ_ITEM_LEN,
            j_item->valuestring, BIZ_ITEM_LEN - 1);
        if (rc != EOK) {
            osal_printk("[WS63_BIZ] inbound item copy fail rc=%d\r\n", (int)rc);
            entry->item[0] = '\0';
        }
    }
    cJSON_Delete(root);

    /* 发起连接 */
    int ret = sle_network_connect_by_tag(tag_id);
    if (ret != 0) {
        biz_map_remove(tag_id);
        biz_reply(seq, "inbound", -8, "connect_by_tag fail", NULL);
        return;
    }
    biz_set_pending("inbound", seq, tag_id);
}

void biz_cmd_inventory(uint16_t seq, const char *data_json)
{
    (void)data_json;
    if (sle_network_is_ssap_ready() == 0) {
        biz_reply(seq, "inventory", -1, "sle not ready", NULL);
        return;
    }
    int ret = sle_network_send_cmd(SSAP_CMD_INVENTORY, 0);
    if (ret != 0) {
        biz_reply(seq, "inventory", -2, "sle send fail", NULL);
        return;
    }
    biz_set_pending("inventory", seq, 0);
}

void biz_cmd_find(uint16_t seq, const char *data_json)
{
    cJSON *root = cJSON_Parse(data_json);
    if (root == NULL) {
        biz_reply(seq, "find", -1, "json parse fail", NULL);
        return;
    }
    biz_tag_entry_t *entry = NULL;
    cJSON *j_tag_id = cJSON_GetObjectItem(root, "tag_id");
    cJSON *j_item = cJSON_GetObjectItem(root, "item");

    if (j_tag_id != NULL && cJSON_IsNumber(j_tag_id) &&
        j_tag_id->valueint >= 0 && j_tag_id->valueint <= 0xFFFF) {
        entry = biz_map_find_by_tag((uint16_t)j_tag_id->valueint);
    } else if (j_item != NULL && cJSON_IsString(j_item)) {
        for (uint16_t i = 0; i < g_biz_map.count; i++) {
            if (strncmp(g_biz_map.entries[i].item, j_item->valuestring,
                BIZ_ITEM_LEN) == 0) {
                entry = &g_biz_map.entries[i];
                break;
            }
        }
    }
    cJSON_Delete(root);

    if (entry == NULL) {
        biz_reply(seq, "find", -3, "tag not found", NULL);
        return;
    }
    if (sle_network_is_ssap_ready() != 0) {
        sle_network_send_cmd(SSAP_CMD_FIND, 0);
    }
    char data_buf[64];
    snprintf(data_buf, sizeof(data_buf),
        "{\"tag_id\":%u,\"zone\":\"%s\",\"item\":\"%s\"}",
        (unsigned int)entry->tag_id, entry->zone, entry->item);
    biz_reply(seq, "find", 0, "ok", data_buf);
}

void biz_cmd_outbound(uint16_t seq, const char *data_json)
{
    cJSON *root = cJSON_Parse(data_json);
    if (root == NULL) {
        biz_reply(seq, "outbound", -1, "json parse fail", NULL);
        return;
    }

    /* support both tag_id and mac for lookup */
    biz_tag_entry_t *entry = NULL;
    cJSON *j_tag_id = cJSON_GetObjectItem(root, "tag_id");
    cJSON *j_mac = cJSON_GetObjectItem(root, "mac");

    if (j_tag_id != NULL && cJSON_IsNumber(j_tag_id) &&
        j_tag_id->valueint >= 0 && j_tag_id->valueint <= 0xFFFF) {
        entry = biz_map_find_by_tag((uint16_t)j_tag_id->valueint);
    } else if (j_mac != NULL && cJSON_IsString(j_mac)) {
        uint8_t mac[BIZ_MAC_LEN];
        if (biz_parse_mac(j_mac->valuestring, mac) == 0) {
            entry = biz_map_find_by_mac(mac);
        }
    }

    if (entry == NULL) {
        cJSON_Delete(root);
        biz_reply(seq, "outbound", -3, "tag not found", NULL);
        return;
    }

    uint16_t tag_id = entry->tag_id;
    uint16_t current_qty = entry->qty;

    /* 读取 remove_qty：未指定或 >= current_qty → 全量出库 */
    cJSON *j_remove = cJSON_GetObjectItem(root, "remove_qty");
    cJSON_Delete(root);

    int raw_remove = (j_remove != NULL && cJSON_IsNumber(j_remove)) ?
        j_remove->valueint : -1;

    if (raw_remove < 0 || raw_remove > 0xFFFF) {
        raw_remove = -1; /* 未指定 */
    }

    bool full_outbound = (raw_remove < 0 || (uint16_t)raw_remove >= current_qty);

    if (full_outbound) {
        /* 全量出库：发送 UNBIND_TAG */
        if (sle_network_is_ssap_ready() != 0) {
            int ret = sle_network_send_cmd(SSAP_CMD_UNBIND_TAG, tag_id);
            if (ret == 0) {
                biz_set_pending("outbound", seq, tag_id);
                return;
            }
            osal_printk("[WS63_BIZ] outbound unbind send fail, remove locally\r\n");
        }
        /* SLE 不可用或发送失败，本地删除 */
        biz_map_remove(tag_id);
        biz_map_save_nv();
        char data_buf[32];
        snprintf(data_buf, sizeof(data_buf), "{\"tag_id\":%u}", (unsigned int)tag_id);
        biz_reply(seq, "outbound", 0, "ok", data_buf);
    } else {
        /* 部分出库：发送 UPDATE_QTY */
        uint16_t new_qty = current_qty - (uint16_t)raw_remove;
        if (sle_network_is_ssap_ready() != 0) {
            int ret = sle_network_send_cmd(SSAP_CMD_UPDATE_QTY, new_qty);
            if (ret == 0) {
                entry->qty = new_qty;
                biz_map_save_nv();
                biz_publish_tag_update(entry);
                char data_buf[48];
                snprintf(data_buf, sizeof(data_buf),
                    "{\"tag_id\":%u,\"qty\":%u}", (unsigned int)tag_id, (unsigned int)new_qty);
                biz_reply(seq, "outbound", 0, "ok", data_buf);
                return;
            }
        }
        /* SLE 不可用或发送失败，仅本地更新 */
        entry->qty = new_qty;
        biz_map_save_nv();
        biz_publish_tag_update(entry);
        char data_buf[48];
        snprintf(data_buf, sizeof(data_buf),
            "{\"tag_id\":%u,\"qty\":%u}", (unsigned int)tag_id, (unsigned int)new_qty);
        biz_reply(seq, "outbound", 0, "ok", data_buf);
    }
}

void biz_cmd_list(uint16_t seq, const char *data_json)
{
    (void)data_json;
    char *tags_json = biz_build_tags_json();
    if (tags_json == NULL) {
        biz_reply(seq, "list", -1, "json build fail", NULL);
        return;
    }
    biz_reply(seq, "list", 0, "ok", tags_json);
    cJSON_free(tags_json);
}

void biz_cmd_update_qty(uint16_t seq, const char *data_json)
{
    cJSON *root = cJSON_Parse(data_json);
    if (root == NULL) {
        biz_reply(seq, "update_qty", -1, "json parse fail", NULL);
        return;
    }
    cJSON *j_tag_id = cJSON_GetObjectItem(root, "tag_id");
    cJSON *j_qty = cJSON_GetObjectItem(root, "qty");
    if (j_tag_id == NULL || !cJSON_IsNumber(j_tag_id) ||
        j_qty == NULL || !cJSON_IsNumber(j_qty)) {
        cJSON_Delete(root);
        biz_reply(seq, "update_qty", -2, "missing tag_id or qty", NULL);
        return;
    }
    int raw_tag = j_tag_id->valueint;
    int raw_qty = j_qty->valueint;
    if (raw_tag < 0 || raw_tag > 0xFFFF || raw_qty < 0 || raw_qty > 0xFFFF) {
        cJSON_Delete(root);
        biz_reply(seq, "update_qty", -3, "value out of range", NULL);
        return;
    }
    uint16_t tag_id = (uint16_t)raw_tag;
    uint16_t qty = (uint16_t)raw_qty;
    cJSON_Delete(root);

    biz_tag_entry_t *entry = biz_map_find_by_tag(tag_id);
    if (entry == NULL) {
        biz_reply(seq, "update_qty", -3, "tag not found", NULL);
        return;
    }
    entry->qty = qty;
    biz_map_save_nv();
    if (sle_network_is_ssap_ready() != 0) {
        sle_network_send_cmd(SSAP_CMD_UPDATE_QTY, qty);
    }
    biz_publish_tag_update(entry);
    char data_buf[48];
    snprintf(data_buf, sizeof(data_buf),
        "{\"tag_id\":%u,\"qty\":%u}", (unsigned int)tag_id, (unsigned int)qty);
    biz_reply(seq, "update_qty", 0, "ok", data_buf);
}

void biz_cmd_register(uint16_t seq, const char *data_json)
{
    cJSON *root = cJSON_Parse(data_json);
    if (root == NULL) {
        biz_reply(seq, "register", -2, "json parse fail", NULL);
        return;
    }

    /* 读取用户指定的 tag_id */
    cJSON *j_tag_id = cJSON_GetObjectItem(root, "tag_id");
    if (j_tag_id == NULL || !cJSON_IsNumber(j_tag_id) ||
        j_tag_id->valueint < 0 || j_tag_id->valueint > 0xFFFF) {
        cJSON_Delete(root);
        biz_reply(seq, "register", -3, "missing or invalid tag_id", NULL);
        return;
    }
    uint16_t tag_id = (uint16_t)j_tag_id->valueint;

    /* 检查扫描表中是否有该标签 */
    const sle_scan_entry_t *scan = sle_network_get_scan_table();
    bool found_in_scan = false;
    for (uint16_t i = 0; i < SLE_SCAN_TABLE_MAX; i++) {
        if (scan[i].used && scan[i].tag_id == tag_id) {
            found_in_scan = true;
            break;
        }
    }
    if (!found_in_scan) {
        cJSON_Delete(root);
        biz_reply(seq, "register", -4, "tag_id not found in scan table", NULL);
        return;
    }

    /* 检查是否已在映射表中 */
    if (biz_map_find_by_tag(tag_id) != NULL) {
        cJSON_Delete(root);
        biz_reply(seq, "register", -5, "tag_id already registered", NULL);
        return;
    }

    /* 检查是否有 pending */
    if (g_biz_pending.active) {
        cJSON_Delete(root);
        biz_reply(seq, "register", -6, "busy, pending active", NULL);
        return;
    }

    /* 添加到映射表 */
    biz_tag_entry_t *entry = biz_map_add(tag_id);
    if (entry == NULL) {
        cJSON_Delete(root);
        biz_reply(seq, "register", -7, "map full or duplicate", NULL);
        return;
    }

    /* 从扫描表复制 MAC */
    for (uint16_t i = 0; i < SLE_SCAN_TABLE_MAX; i++) {
        if (scan[i].used && scan[i].tag_id == tag_id) {
            (void)memcpy_s(entry->mac, BIZ_MAC_LEN, scan[i].mac, BIZ_MAC_LEN);
            entry->battery = scan[i].battery;
            break;
        }
    }

    /* 拷贝 zone/item */
    cJSON *j_zone = cJSON_GetObjectItem(root, "storage_area");
    cJSON *j_item = cJSON_GetObjectItem(root, "item_name");
    if (j_zone != NULL && cJSON_IsString(j_zone)) {
        errno_t rc = strncpy_s(entry->zone, BIZ_ZONE_LEN,
            j_zone->valuestring, BIZ_ZONE_LEN - 1);
        if (rc != EOK) {
            osal_printk("[WS63_BIZ] register zone copy fail rc=%d\r\n", (int)rc);
            entry->zone[0] = '\0';
        }
    }
    if (j_item != NULL && cJSON_IsString(j_item)) {
        errno_t rc = strncpy_s(entry->item, BIZ_ITEM_LEN,
            j_item->valuestring, BIZ_ITEM_LEN - 1);
        if (rc != EOK) {
            osal_printk("[WS63_BIZ] register item copy fail rc=%d\r\n", (int)rc);
            entry->item[0] = '\0';
        }
    }
    cJSON_Delete(root);

    /* 发起连接（异步，connect + pair + SSAP + CCCD） */
    int ret = sle_network_connect_by_tag(tag_id);
    if (ret != 0) {
        biz_map_remove(tag_id);
        biz_reply(seq, "register", -8, "connect_by_tag fail", NULL);
        return;
    }
    /* pending 等待连接就绪后发送 BIND_TAG，超时 15s */
    biz_set_pending("register", seq, tag_id);
}

void biz_cmd_scan_list(uint16_t seq, const char *data_json)
{
    (void)data_json;
    cJSON *root = cJSON_CreateObject();
    if (root == NULL) {
        biz_reply(seq, "scan_list", -1, "json create fail", NULL);
        return;
    }
    cJSON *arr = cJSON_AddArrayToObject(root, "scan_list");
    if (arr == NULL) {
        cJSON_Delete(root);
        biz_reply(seq, "scan_list", -2, "json array fail", NULL);
        return;
    }

    const sle_scan_entry_t *scan = sle_network_get_scan_table();
    for (uint16_t i = 0; i < SLE_SCAN_TABLE_MAX; i++) {
        if (!scan[i].used) {
            continue;
        }
        cJSON *obj = cJSON_CreateObject();
        if (obj == NULL) {
            break;
        }
        cJSON_AddNumberToObject(obj, "tag_id", scan[i].tag_id);
        cJSON_AddNumberToObject(obj, "battery", scan[i].battery);
        cJSON_AddNumberToObject(obj, "qty", scan[i].qty);
        cJSON_AddNumberToObject(obj, "status", scan[i].status);
        /* 检查是否已在映射表中（已注册） */
        cJSON_AddBoolToObject(obj, "registered",
            biz_map_find_by_tag(scan[i].tag_id) != NULL);
        cJSON_AddItemToArray(arr, obj);
    }

    char *str = cJSON_PrintUnformatted(root);
    cJSON_Delete(root);
    if (str == NULL) {
        biz_reply(seq, "scan_list", -3, "json print fail", NULL);
        return;
    }
    biz_reply(seq, "scan_list", 0, "ok", str);
    cJSON_free(str);
}

void biz_cmd_passthrough_to_esp32(uint16_t seq, const char *cmd,
    const char *data_json)
{
    /* forward command to ESP32 and wait for task_done */
    cJSON *root = cJSON_CreateObject();
    if (root == NULL) {
        biz_reply(seq, cmd, -1, "json create fail", NULL);
        return;
    }
    cJSON_AddStringToObject(root, "cmd", cmd);
    cJSON_AddNumberToObject(root, "seq", seq);

    if (data_json != NULL) {
        cJSON *data_obj = cJSON_Parse(data_json);
        if (data_obj != NULL) {
            /* merge data fields into root (flat format for ESP32) */
            cJSON *child = data_obj->child;
            while (child != NULL) {
                cJSON *dup = cJSON_Duplicate(child, 1);
                if (dup != NULL) {
                    cJSON_AddItemToObject(root, child->string, dup);
                }
                child = child->next;
            }
            cJSON_Delete(data_obj);
        }
    }

    char *out = cJSON_PrintUnformatted(root);
    cJSON_Delete(root);
    if (out == NULL) {
        biz_reply(seq, cmd, -2, "json print fail", NULL);
        return;
    }

    biz_raw_json_send(out);
    cJSON_free(out);
    biz_set_pending(cmd, seq, 0);
    osal_printk("[WS63_BIZ] passthrough cmd=%s to esp32\r\n", cmd);
}
