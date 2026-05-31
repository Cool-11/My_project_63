#include "business_logic.h"
#include "soc_osal.h"
#include "nv.h"
#include "securec.h"
#include "cJSON.h"
#include "../uart_vision/uart_vision.h"
#include "../uart_display/uart_display.h"
#include "../sle_network/sle_network.h"
#include "tcxo.h"
#include <string.h>

static biz_tag_map_t g_biz_map = {0};
static biz_notify_uart_t g_biz_uart_cb = NULL;
static biz_raw_json_uart_t g_biz_raw_json_cb = NULL;
static biz_cloud_publish_t g_biz_cloud_cb = NULL;
static biz_wifi_cmd_t g_biz_wifi_cmd_cb = NULL;
static biz_mqtt_cmd_handler_t g_biz_mqtt_cmd_cb = NULL;
static biz_ud_cmd_handler_t g_biz_screen_cb = NULL;

/* 前向声明 */
static void biz_screen_reply(const char *cmd, const char *fmt, ...);

/* 白名单 + 去重条目数组（packed 27B × 32 = 864B） */
static struct TagListEntry g_biz_tag_list[TAG_LIST_MAX] = {0};

static struct {
    char cmd[16];
    uint16_t seq;
    uint16_t tag_id;
    bool active;
    uint64_t start_ms;
    uint32_t timeout_ms;
} g_biz_pending = {0};

static void biz_reply(uint16_t seq, const char *cmd, int code,
    const char *msg, const char *data_json)
{
    if (g_biz_uart_cb != NULL) {
        g_biz_uart_cb(seq, cmd, code, msg, data_json);
    }
}

static void biz_cloud_publish(const char *payload, uint16_t len)
{
    if (g_biz_cloud_cb != NULL) {
        g_biz_cloud_cb(payload, len);
    }
}

static void biz_raw_json_send(const char *json_str)
{
    if (g_biz_raw_json_cb != NULL) {
        g_biz_raw_json_cb(json_str);
    }
}

static uint32_t biz_get_pending_timeout_ms(const char *cmd)
{
    if (cmd == NULL) {
        return BIZ_PENDING_TIMEOUT_SLE_MS;
    }
    if (strcmp(cmd, "register") == 0 || strcmp(cmd, "outbound") == 0) {
        return BIZ_PENDING_TIMEOUT_ESP32_MS;
    }
    return BIZ_PENDING_TIMEOUT_SLE_MS;
}

static const char *biz_map_esp32_task(const char *task)
{
    if (task == NULL) {
        return "unknown";
    }
    if (strcmp(task, "register") == 0) {
        return "inbound";
    }
    return task;
}

void business_logic_register_uart_cb(biz_notify_uart_t cb)
{
    g_biz_uart_cb = cb;
    osal_printk("[WS63_BIZ] uart cb registered=%p\r\n", (void *)cb);
}

void business_logic_register_cloud_cb(biz_cloud_publish_t cb)
{
    g_biz_cloud_cb = cb;
    osal_printk("[WS63_BIZ] cloud cb registered=%p\r\n", (void *)cb);
}

void business_logic_register_raw_json_cb(biz_raw_json_uart_t cb)
{
    g_biz_raw_json_cb = cb;
    osal_printk("[WS63_BIZ] raw_json cb registered=%p\r\n", (void *)cb);
}

void business_logic_register_wifi_cmd_cb(biz_wifi_cmd_t cb)
{
    g_biz_wifi_cmd_cb = cb;
    osal_printk("[WS63_BIZ] wifi cmd cb registered=%p\r\n", (void *)cb);
}

void business_logic_register_mqtt_cmd_cb(biz_mqtt_cmd_handler_t cb)
{
    g_biz_mqtt_cmd_cb = cb;
    osal_printk("[WS63_BIZ] mqtt cmd cb registered=%p\r\n", (void *)cb);
}

void business_logic_register_screen_cb(biz_ud_cmd_handler_t cb)
{
    g_biz_screen_cb = cb;
    osal_printk("[WS63_BIZ] screen cb registered=%p\r\n", (void *)cb);
}

biz_tag_entry_t *biz_map_find_by_tag(uint16_t tag_id)
{
    for (uint16_t i = 0; i < g_biz_map.count; i++) {
        if (g_biz_map.entries[i].tag_id == tag_id) {
            return &g_biz_map.entries[i];
        }
    }
    return NULL;
}

biz_tag_entry_t *biz_map_find_by_mac(const uint8_t *mac)
{
    if (mac == NULL) {
        return NULL;
    }
    for (uint16_t i = 0; i < g_biz_map.count; i++) {
        if (memcmp(g_biz_map.entries[i].mac, mac, BIZ_MAC_LEN) == 0) {
            return &g_biz_map.entries[i];
        }
    }
    return NULL;
}

biz_tag_entry_t *biz_map_add(uint16_t tag_id)
{
    if (g_biz_map.count >= BIZ_TAG_MAX) {
        osal_printk("[WS63_BIZ] map full count=%u max=%u\r\n",
            (unsigned int)g_biz_map.count, BIZ_TAG_MAX);
        return NULL;
    }
    /* 检查是否已存在 */
    if (biz_map_find_by_tag(tag_id) != NULL) {
        osal_printk("[WS63_BIZ] map add: tag_id=%u already exists\r\n",
            (unsigned int)tag_id);
        return NULL;
    }
    biz_tag_entry_t *entry = &g_biz_map.entries[g_biz_map.count];
    entry->tag_id = tag_id;
    entry->status = BIZ_TAG_IDLE;
    entry->qty = 0;
    entry->battery = 0;
    memset(entry->mac, 0, BIZ_MAC_LEN);
    memset(entry->zone, 0, BIZ_ZONE_LEN);
    memset(entry->item, 0, BIZ_ITEM_LEN);
    g_biz_map.count++;
    osal_printk("[WS63_BIZ] map add tag_id=%u count=%u\r\n",
        (unsigned int)tag_id, (unsigned int)g_biz_map.count);
    return entry;
}

int biz_map_remove(uint16_t tag_id)
{
    for (uint16_t i = 0; i < g_biz_map.count; i++) {
        if (g_biz_map.entries[i].tag_id == tag_id) {
            uint16_t last = g_biz_map.count - 1;
            if (i < last) {
                errno_t rc = memcpy_s(&g_biz_map.entries[i], sizeof(biz_tag_entry_t),
                    &g_biz_map.entries[last], sizeof(biz_tag_entry_t));
                if (rc != EOK) {
                    osal_printk("[WS63_BIZ] remove memcpy fail rc=%d\r\n", rc);
                    return -1;
                }
            }
            memset(&g_biz_map.entries[last], 0, sizeof(biz_tag_entry_t));
            g_biz_map.count--;
            osal_printk("[WS63_BIZ] remove tag_id=%u count=%u\r\n",
                (unsigned int)tag_id, (unsigned int)g_biz_map.count);
            return 0;
        }
    }
    osal_printk("[WS63_BIZ] remove not found tag_id=%u\r\n", (unsigned int)tag_id);
    return -1;
}

int biz_map_save_nv(void)
{
    uint16_t data_len = (uint16_t)sizeof(biz_tag_map_t);
    errcode_t ret = uapi_nv_write(BIZ_NV_KEY_TAG_MAP,
        (const uint8_t *)&g_biz_map, data_len);
    if (ret != ERRCODE_SUCC) {
        osal_printk("[WS63_BIZ] nv write fail ret=0x%x\r\n", ret);
        return (int)ret;
    }
    osal_printk("[WS63_BIZ] nv write ok count=%u\r\n",
        (unsigned int)g_biz_map.count);
    return 0;
}

int biz_map_load_nv(void)
{
    uint16_t data_len = 0;
    uint16_t max_len = (uint16_t)sizeof(biz_tag_map_t);
    errcode_t ret = uapi_nv_read(BIZ_NV_KEY_TAG_MAP,
        max_len, &data_len, (uint8_t *)&g_biz_map);
    if (ret != ERRCODE_SUCC) {
        osal_printk("[WS63_BIZ] nv read fail ret=0x%x\r\n", ret);
        g_biz_map.count = 0;
        return (int)ret;
    }
    if (data_len != max_len || g_biz_map.count > BIZ_TAG_MAX) {
        osal_printk("[WS63_BIZ] nv data invalid\r\n");
        g_biz_map.count = 0;
        return -1;
    }
    osal_printk("[WS63_BIZ] nv read ok count=%u\r\n",
        (unsigned int)g_biz_map.count);
    return 0;
}

static char *biz_build_tags_json(void)
{
    cJSON *root = cJSON_CreateObject();
    if (root == NULL) {
        return NULL;
    }
    cJSON_AddNumberToObject(root, "count", g_biz_map.count);
    cJSON *arr = cJSON_AddArrayToObject(root, "tags");
    if (arr == NULL) {
        cJSON_Delete(root);
        return NULL;
    }
    for (uint16_t i = 0; i < g_biz_map.count; i++) {
        biz_tag_entry_t *e = &g_biz_map.entries[i];
        cJSON *obj = cJSON_CreateObject();
        if (obj == NULL) {
            break;
        }
        cJSON_AddNumberToObject(obj, "tag_id", e->tag_id);
        cJSON_AddStringToObject(obj, "zone", e->zone);
        cJSON_AddStringToObject(obj, "item", e->item);
        cJSON_AddNumberToObject(obj, "qty", e->qty);
        cJSON_AddNumberToObject(obj, "status", e->status);
        cJSON_AddNumberToObject(obj, "battery", e->battery);
        cJSON_AddItemToArray(arr, obj);
    }
    char *str = cJSON_PrintUnformatted(root);
    cJSON_Delete(root);
    return str;
}

static void biz_publish_tag_update(biz_tag_entry_t *entry)
{
    if (entry == NULL) {
        return;
    }
    cJSON *root = cJSON_CreateObject();
    if (root == NULL) {
        return;
    }
    cJSON *arr = cJSON_CreateArray();
    if (arr == NULL) {
        cJSON_Delete(root);
        return;
    }
    cJSON *tag = cJSON_CreateObject();
    if (tag == NULL) {
        cJSON_Delete(arr);
        cJSON_Delete(root);
        return;
    }
    cJSON_AddNumberToObject(tag, "tag_id", entry->tag_id);
    cJSON_AddStringToObject(tag, "zone", entry->zone);
    cJSON_AddStringToObject(tag, "item", entry->item);
    cJSON_AddNumberToObject(tag, "qty", entry->qty);
    cJSON_AddNumberToObject(tag, "status", entry->status);
    cJSON_AddNumberToObject(tag, "battery", entry->battery);
    cJSON_AddItemToArray(arr, tag);

    char key[16];
    snprintf(key, sizeof(key), "tag_%03u", (unsigned int)entry->tag_id);
    cJSON_AddItemToObject(root, key, arr);

    char *str = cJSON_PrintUnformatted(root);
    cJSON_Delete(root);
    if (str != NULL) {
        biz_cloud_publish(str, (uint16_t)strlen(str));
        cJSON_free(str);
    }
}

static void biz_set_pending(const char *cmd, uint16_t seq, uint16_t tag_id)
{
    errno_t rc = strncpy_s(g_biz_pending.cmd, sizeof(g_biz_pending.cmd),
        cmd, sizeof(g_biz_pending.cmd) - 1);
    if (rc != EOK) {
        g_biz_pending.cmd[0] = '\0';
    }
    g_biz_pending.seq = seq;
    g_biz_pending.tag_id = tag_id;
    g_biz_pending.active = true;
    g_biz_pending.start_ms = uapi_tcxo_get_ms();
    g_biz_pending.timeout_ms = biz_get_pending_timeout_ms(cmd);
    osal_printk("[WS63_BIZ] pending cmd=%s seq=%u tag_id=%u timeout=%ums\r\n",
        cmd, (unsigned int)seq, (unsigned int)tag_id,
        (unsigned int)g_biz_pending.timeout_ms);
}

static void biz_clear_pending(void)
{
    g_biz_pending.active = false;
    g_biz_pending.cmd[0] = '\0';
}

static void biz_cmd_inbound(uint16_t seq, const char *data_json)
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

    cJSON *j_zone = cJSON_GetObjectItem(root, "zone");
    cJSON *j_item = cJSON_GetObjectItem(root, "item");
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

static void biz_cmd_inventory(uint16_t seq, const char *data_json)
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

static void biz_cmd_find(uint16_t seq, const char *data_json)
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

static int biz_parse_mac(const char *str, uint8_t *mac)
{
    if (str == NULL || mac == NULL) {
        return -1;
    }
    unsigned int a, b, c, d, e, f;
    if (sscanf(str, "%02x:%02x:%02x:%02x:%02x:%02x",
        &a, &b, &c, &d, &e, &f) != 6) {
        return -1;
    }
    mac[0] = (uint8_t)a; mac[1] = (uint8_t)b; mac[2] = (uint8_t)c;
    mac[3] = (uint8_t)d; mac[4] = (uint8_t)e; mac[5] = (uint8_t)f;
    return 0;
}

/* Tag ID 格式转换: uint16_t → "0x0001" (发给ESP32) */
static int biz_tag_id_to_esp32(uint16_t id, char *buf, uint16_t len)
{
    if (buf == NULL || len < 7) {
        return -1;
    }
    return snprintf(buf, len, "0x%04X", (unsigned int)id);
}

/* Tag ID 格式转换: "0x0001" → uint16_t (从ESP32接收) */
static int biz_esp32_to_tag_id(const char *str, uint16_t *out)
{
    if (str == NULL || out == NULL) {
        return -1;
    }
    const char *p = str;
    if (p[0] == '0' && (p[1] == 'x' || p[1] == 'X')) {
        p += 2;
    }
    unsigned long val = strtoul(p, NULL, 16);
    if (val == 0 || val > 0xFFFF) {
        return -2;
    }
    *out = (uint16_t)val;
    return 0;
}

static void biz_cmd_outbound(uint16_t seq, const char *data_json)
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

static void biz_cmd_list(uint16_t seq, const char *data_json)
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

static void biz_cmd_update_qty(uint16_t seq, const char *data_json)
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

static void biz_cmd_wifi_connect(uint16_t seq, const char *data_json)
{
    cJSON *root = cJSON_Parse(data_json);
    if (root == NULL) {
        biz_reply(seq, "wifi_connect", -1, "json parse fail", NULL);
        return;
    }
    cJSON *j_ssid = cJSON_GetObjectItem(root, "ssid");
    cJSON *j_psk = cJSON_GetObjectItem(root, "psk");
    if (j_ssid == NULL || !cJSON_IsString(j_ssid)) {
        cJSON_Delete(root);
        biz_reply(seq, "wifi_connect", -2, "missing ssid", NULL);
        return;
    }
    const char *ssid = j_ssid->valuestring;
    const char *psk = NULL;
    if (j_psk != NULL && cJSON_IsString(j_psk)) {
        psk = j_psk->valuestring;
    }

    if (g_biz_wifi_cmd_cb != NULL) {
        int ret = g_biz_wifi_cmd_cb(ssid, psk);
        cJSON_Delete(root);
        if (ret != 0) {
            biz_reply(seq, "wifi_connect", -3, "connect fail", NULL);
            return;
        }
    } else {
        cJSON_Delete(root);
        biz_reply(seq, "wifi_connect", -4, "wifi not available", NULL);
        return;
    }
    biz_reply(seq, "wifi_connect", 0, "connecting", NULL);
}

static void biz_cmd_wifi_status(uint16_t seq, const char *data_json)
{
    (void)data_json;
    if (g_biz_wifi_cmd_cb != NULL) {
        int state = g_biz_wifi_cmd_cb(NULL, NULL);
        char data_buf[32];
        snprintf(data_buf, sizeof(data_buf), "{\"wifi_state\":%d}", state);
        biz_reply(seq, "wifi_status", 0, "ok", data_buf);
    } else {
        biz_reply(seq, "wifi_status", -1, "wifi not available", NULL);
    }
}

static void biz_cmd_mqtt_connect(uint16_t seq, const char *data_json)
{
    cJSON *root = cJSON_Parse(data_json);
    if (root == NULL) {
        biz_reply(seq, "mqtt_connect", -1, "json parse fail", NULL);
        return;
    }

    /* support both "uri" and "host"+"port" formats */
    cJSON *j_uri = cJSON_GetObjectItem(root, "uri");
    cJSON *j_host = cJSON_GetObjectItem(root, "host");

    if (j_uri == NULL && j_host == NULL) {
        cJSON_Delete(root);
        biz_reply(seq, "mqtt_connect", -2, "missing uri/host", NULL);
        return;
    }

    if (g_biz_mqtt_cmd_cb == NULL) {
        cJSON_Delete(root);
        biz_reply(seq, "mqtt_connect", -3, "mqtt not available", NULL);
        return;
    }

    biz_mqtt_connect_params_t params = {0};

    if (j_uri != NULL && cJSON_IsString(j_uri)) {
        errno_t rc = strncpy_s(params.uri, BIZ_MQTT_URI_MAX,
            j_uri->valuestring, BIZ_MQTT_URI_MAX - 1);
        if (rc != EOK) {
            cJSON_Delete(root);
            biz_reply(seq, "mqtt_connect", -4, "uri copy fail", NULL);
            return;
        }
    } else if (j_host != NULL && cJSON_IsString(j_host)) {
        /* ESP32 format: host+port → assemble uri */
        cJSON *j_port = cJSON_GetObjectItem(root, "port");
        int port = (j_port != NULL && cJSON_IsNumber(j_port)) ?
            j_port->valueint : 1883;
        /* validate host length: "tcp://"(6) + host + ":"(1) + port(5) + \0 */
        uint32_t host_len = (uint32_t)strlen(j_host->valuestring);
        if (host_len == 0 || host_len > (BIZ_MQTT_URI_MAX - 13) ||
            port < 1 || port > 65535) {
            cJSON_Delete(root);
            biz_reply(seq, "mqtt_connect", -4, "invalid host/port", NULL);
            return;
        }
        snprintf(params.uri, BIZ_MQTT_URI_MAX, "tcp://%s:%d",
            j_host->valuestring, port);
    }
    cJSON *j_cid = cJSON_GetObjectItem(root, "client_id");
    if (j_cid != NULL && cJSON_IsString(j_cid)) {
        errno_t rc2 = strncpy_s(params.client_id, BIZ_MQTT_CID_MAX,
            j_cid->valuestring, BIZ_MQTT_CID_MAX - 1);
        if (rc2 != EOK) {
            osal_printk("[WS63_BIZ] mqtt_connect client_id copy fail rc=%d\r\n", (int)rc2);
        }
    }
    cJSON *j_user = cJSON_GetObjectItem(root, "username");
    if (j_user != NULL && cJSON_IsString(j_user)) {
        errno_t rc3 = strncpy_s(params.username, BIZ_MQTT_USER_MAX,
            j_user->valuestring, BIZ_MQTT_USER_MAX - 1);
        if (rc3 != EOK) {
            osal_printk("[WS63_BIZ] mqtt_connect username copy fail rc=%d\r\n", (int)rc3);
        }
    }
    cJSON *j_pass = cJSON_GetObjectItem(root, "password");
    if (j_pass != NULL && cJSON_IsString(j_pass)) {
        errno_t rc4 = strncpy_s(params.password, BIZ_MQTT_PASS_MAX,
            j_pass->valuestring, BIZ_MQTT_PASS_MAX - 1);
        if (rc4 != EOK) {
            osal_printk("[WS63_BIZ] mqtt_connect password copy fail rc=%d\r\n", (int)rc4);
        }
    }
    cJSON_Delete(root);

    int ret = g_biz_mqtt_cmd_cb(BIZ_MQTT_CMD_CONNECT, &params);
    if (ret != 0) {
        char err_buf[32];
        snprintf(err_buf, sizeof(err_buf), "connect fail ret=%d", ret);
        biz_reply(seq, "mqtt_connect", -5, err_buf, NULL);
        return;
    }
    biz_reply(seq, "mqtt_connect", 0, "ok", NULL);
}

static void biz_cmd_mqtt_disconnect(uint16_t seq, const char *data_json)
{
    (void)data_json;
    if (g_biz_mqtt_cmd_cb != NULL) {
        g_biz_mqtt_cmd_cb(BIZ_MQTT_CMD_DISCONNECT, NULL);
    }
    biz_reply(seq, "mqtt_disconnect", 0, "ok", NULL);
}

static void biz_cmd_mqtt_status(uint16_t seq, const char *data_json)
{
    (void)data_json;
    if (g_biz_mqtt_cmd_cb != NULL) {
        int state = g_biz_mqtt_cmd_cb(BIZ_MQTT_CMD_STATUS, NULL);
        char data_buf[48];
        snprintf(data_buf, sizeof(data_buf),
            "{\"mqtt_state\":%d}", state);
        biz_reply(seq, "mqtt_status", 0, "ok", data_buf);
    } else {
        biz_reply(seq, "mqtt_status", -1, "mqtt not available", NULL);
    }
}

static void biz_cmd_mqtt_publish(uint16_t seq, const char *data_json)
{
    cJSON *root = cJSON_Parse(data_json);
    if (root == NULL) {
        biz_reply(seq, "mqtt_publish", -1, "json parse fail", NULL);
        return;
    }
    cJSON *j_payload = cJSON_GetObjectItem(root, "payload");
    if (j_payload == NULL) {
        cJSON_Delete(root);
        biz_reply(seq, "mqtt_publish", -2, "missing payload", NULL);
        return;
    }
    char *payload_str = cJSON_PrintUnformatted(j_payload);
    cJSON_Delete(root);
    if (payload_str == NULL) {
        biz_reply(seq, "mqtt_publish", -3, "payload format fail", NULL);
        return;
    }

    biz_cloud_publish(payload_str, (uint16_t)strlen(payload_str));
    cJSON_free(payload_str);
    biz_reply(seq, "mqtt_publish", 0, "ok", NULL);
}

/* ESP32响应处理: capture_progress → #PROG,<step>,<view>,<score> */
static void biz_handle_capture_progress(cJSON *root)
{
    cJSON *j_view = cJSON_GetObjectItem(root, "view");
    cJSON *j_step = cJSON_GetObjectItem(root, "step");
    cJSON *j_score = cJSON_GetObjectItem(root, "blur_score");

    const char *view = (j_view && cJSON_IsString(j_view)) ? j_view->valuestring : "?";
    const char *step_str = (j_step && cJSON_IsString(j_step)) ? j_step->valuestring : "0/0";
    double score = (j_score && cJSON_IsNumber(j_score)) ? j_score->valuedouble : 0.0;

    /* step "1/3" → 取分子 "1" */
    int step_num = atoi(step_str);

    biz_screen_reply("PROG", "%d,%s,%.1f", step_num, view, score);
    osal_printk("[WS63_BIZ] capture_progress step=%d view=%s score=%.1f\r\n",
        step_num, view, score);
}

/* ESP32响应处理: asset_info → 按task区分outbound/inventory */
static void biz_handle_asset_info(cJSON *root)
{
    cJSON *j_task = cJSON_GetObjectItem(root, "task");
    const char *task = (j_task && cJSON_IsString(j_task)) ? j_task->valuestring : "";

    if (strcmp(task, "outbound") == 0) {
        /* 出库分步: asset_info → #ASSET_INFO,id,name,qty,remove,remain */
        cJSON *j_tag = cJSON_GetObjectItem(root, "tag_id");
        cJSON *j_name = cJSON_GetObjectItem(root, "item_name");
        cJSON *j_qty = cJSON_GetObjectItem(root, "quantity");
        cJSON *j_remove = cJSON_GetObjectItem(root, "remove_qty");
        cJSON *j_remain = cJSON_GetObjectItem(root, "remaining_qty");

        const char *tag_str = (j_tag && cJSON_IsString(j_tag)) ? j_tag->valuestring : "0";
        const char *name = (j_name && cJSON_IsString(j_name)) ? j_name->valuestring : "?";
        int qty = (j_qty && cJSON_IsNumber(j_qty)) ? j_qty->valueint : 0;
        int remove = (j_remove && cJSON_IsNumber(j_remove)) ? j_remove->valueint : 0;
        int remain = (j_remain && cJSON_IsNumber(j_remain)) ? j_remain->valueint : 0;

        /* tag_id "0x0001" → "0001" for screen */
        uint16_t tag_id = 0;
        biz_esp32_to_tag_id(tag_str, &tag_id);
        char tag_display[8];
        ud_tag_id_to_str(tag_id, tag_display, sizeof(tag_display));

        biz_screen_reply("ASSET_INFO", "%s,%s,%d,%d,%d", tag_display, name, qty, remove, remain);
        osal_printk("[WS63_BIZ] outbound asset_info: %s qty=%d remove=%d remain=%d\r\n",
            tag_display, qty, remove, remain);
    } else if (strcmp(task, "inventory") == 0) {
        /* 盘点: asset_info → 日志记录（屏已通过#TAG_INFO显示） */
        osal_printk("[WS63_BIZ] inventory asset_info (log only)\r\n");
    }
}

/* ESP32响应处理: asset_detail → #TAG_INFO,id,name,area,count */
static void biz_handle_asset_detail(cJSON *root)
{
    cJSON *j_found = cJSON_GetObjectItem(root, "found");
    if (j_found && cJSON_IsBool(j_found) && !cJSON_IsTrue(j_found)) {
        biz_screen_reply("ERR", "ERR_ASSET_NOT_FOUND,标签未注册");
        return;
    }

    cJSON *j_tag = cJSON_GetObjectItem(root, "tag_id");
    cJSON *j_name = cJSON_GetObjectItem(root, "item_name");
    cJSON *j_area = cJSON_GetObjectItem(root, "storage_area");
    cJSON *j_qty = cJSON_GetObjectItem(root, "quantity");

    const char *tag_str = (j_tag && cJSON_IsString(j_tag)) ? j_tag->valuestring : "0";
    const char *name = (j_name && cJSON_IsString(j_name)) ? j_name->valuestring : "?";
    const char *area = (j_area && cJSON_IsString(j_area)) ? j_area->valuestring : "?";
    int qty = (j_qty && cJSON_IsNumber(j_qty)) ? j_qty->valueint : 0;

    uint16_t tag_id = 0;
    biz_esp32_to_tag_id(tag_str, &tag_id);
    char tag_display[8];
    ud_tag_id_to_str(tag_id, tag_display, sizeof(tag_display));

    biz_screen_reply("TAG_INFO", "%s,%s,%s,%d", tag_display, name, area, qty);
}

/* ESP32响应处理: asset_list_page → #LIST + #ITEM×N */
static void biz_handle_asset_list_page(cJSON *root)
{
    cJSON *j_page = cJSON_GetObjectItem(root, "page");
    cJSON *j_tp = cJSON_GetObjectItem(root, "total_pages");
    cJSON *j_tc = cJSON_GetObjectItem(root, "total_count");
    cJSON *j_assets = cJSON_GetObjectItem(root, "assets");

    int page = (j_page && cJSON_IsNumber(j_page)) ? j_page->valueint : 1;
    int tp = (j_tp && cJSON_IsNumber(j_tp)) ? j_tp->valueint : 1;
    int tc = (j_tc && cJSON_IsNumber(j_tc)) ? j_tc->valueint : 0;

    biz_screen_reply("LIST", "%d,%d,%d", page, tp, tc);

    if (j_assets && cJSON_IsArray(j_assets)) {
        int count = cJSON_GetArraySize(j_assets);
        for (int i = 0; i < count && i < 6; i++) {
            cJSON *item = cJSON_GetArrayItem(j_assets, i);
            if (item == NULL) continue;

            cJSON *j_tag = cJSON_GetObjectItem(item, "tag_id");
            cJSON *j_name = cJSON_GetObjectItem(item, "item_name");
            cJSON *j_area = cJSON_GetObjectItem(item, "storage_area");
            cJSON *j_qty = cJSON_GetObjectItem(item, "quantity");

            const char *tag_str = (j_tag && cJSON_IsString(j_tag)) ? j_tag->valuestring : "0";
            const char *name = (j_name && cJSON_IsString(j_name)) ? j_name->valuestring : "?";
            const char *area = (j_area && cJSON_IsString(j_area)) ? j_area->valuestring : "?";
            int qty = (j_qty && cJSON_IsNumber(j_qty)) ? j_qty->valueint : 0;

            uint16_t tag_id = 0;
            biz_esp32_to_tag_id(tag_str, &tag_id);
            char tag_display[8];
            ud_tag_id_to_str(tag_id, tag_display, sizeof(tag_display));

            biz_screen_reply("ITEM", "%d,%s,%s,%s,%d", i, tag_display, name, area, qty);
        }
    }
}

/* ESP32响应处理: task_done → 按task分发 */
static void biz_handle_task_done(cJSON *root, const char *data_json)
{
    cJSON *j_task = cJSON_GetObjectItem(root, "task");
    if (j_task == NULL || !cJSON_IsString(j_task)) {
        return;
    }
    const char *task = j_task->valuestring;

    if (strcmp(task, "register") == 0) {
        cJSON *j_result = cJSON_GetObjectItem(root, "result");
        const char *result = (j_result && cJSON_IsString(j_result)) ? j_result->valuestring : "?";
        cJSON *j_tag = cJSON_GetObjectItem(root, "tag_id");
        const char *tag_str = (j_tag && cJSON_IsString(j_tag)) ? j_tag->valuestring : "0";
        uint16_t tag_id = 0;
        biz_esp32_to_tag_id(tag_str, &tag_id);
        char tag_display[8];
        ud_tag_id_to_str(tag_id, tag_display, sizeof(tag_display));

        biz_screen_reply("DONE", "reg,%s,%s", result, tag_display);
        if (g_biz_pending.active) {
            biz_clear_pending();
        }
    } else if (strcmp(task, "outbound") == 0) {
        cJSON *j_match = cJSON_GetObjectItem(root, "is_match");
        bool is_match = (j_match && cJSON_IsBool(j_match)) ? cJSON_IsTrue(j_match) : false;
        biz_screen_reply("DONE", "out,%s", is_match ? "success" : "fail");
        if (g_biz_pending.active) {
            biz_clear_pending();
        }
    } else if (strcmp(task, "inventory") == 0) {
        cJSON *j_conf = cJSON_GetObjectItem(root, "weighted_confidence");
        double conf = (j_conf && cJSON_IsNumber(j_conf)) ? j_conf->valuedouble : 0.0;
        const char *result = (conf >= 0.75) ? "match" : "mismatch";
        biz_screen_reply("DONE", "check,%s,%.2f", result, conf);
        if (g_biz_pending.active) {
            biz_clear_pending();
        }
    } else if (strcmp(task, "delete") == 0) {
        biz_screen_reply("DONE", "del,success");
        if (g_biz_pending.active) {
            biz_clear_pending();
        }
    } else {
        /* 其他task_done: 保持原有逻辑 */
        const char *mapped = biz_map_esp32_task(task);
        if (g_biz_pending.active && strcmp(mapped, g_biz_pending.cmd) == 0) {
            biz_reply(g_biz_pending.seq, g_biz_pending.cmd, 0, "ok", data_json);
            biz_clear_pending();
        }
    }
}

/* ESP32响应处理: verification_start → #MSG提醒 */
static void biz_handle_verification_start(cJSON *root)
{
    cJSON *j_msg = cJSON_GetObjectItem(root, "message");
    const char *msg = (j_msg && cJSON_IsString(j_msg)) ? j_msg->valuestring : "请拍摄正面视图验证";
    biz_screen_reply("MSG", "%s", msg);
}

/* ESP32响应处理: pong → 日志记录 */
static void biz_handle_pong(cJSON *root)
{
    cJSON *j_state = cJSON_GetObjectItem(root, "current_state");
    const char *state = (j_state && cJSON_IsString(j_state)) ? j_state->valuestring : "?";
    osal_printk("[WS63_BIZ] pong state=%s\r\n", state);
}

static void biz_handle_esp32_msg(const char *cmd, const char *data_json)
{
    cJSON *root = (data_json != NULL) ? cJSON_Parse(data_json) : NULL;

    /* 按 cmd 分发到具体处理函数 */
    if (strcmp(cmd, "capture_progress") == 0) {
        if (root != NULL) biz_handle_capture_progress(root);
    } else if (strcmp(cmd, "asset_info") == 0) {
        if (root != NULL) biz_handle_asset_info(root);
    } else if (strcmp(cmd, "asset_detail") == 0) {
        if (root != NULL) biz_handle_asset_detail(root);
    } else if (strcmp(cmd, "asset_list_page") == 0) {
        if (root != NULL) biz_handle_asset_list_page(root);
    } else if (strcmp(cmd, "task_done") == 0) {
        if (root != NULL) biz_handle_task_done(root, data_json);
    } else if (strcmp(cmd, "verification_start") == 0) {
        if (root != NULL) biz_handle_verification_start(root);
    } else if (strcmp(cmd, "pong") == 0) {
        if (root != NULL) biz_handle_pong(root);
    } else if (strcmp(cmd, "error") == 0) {
        if (root != NULL) {
            cJSON *j_msg = cJSON_GetObjectItem(root, "msg");
            cJSON *j_code = cJSON_GetObjectItem(root, "code");
            const char *msg = (j_msg && cJSON_IsString(j_msg)) ? j_msg->valuestring : "esp32 error";
            const char *code = (j_code && cJSON_IsString(j_code)) ? j_code->valuestring : "UNKNOWN";
            biz_screen_reply("ERR", "%s,%s", code, msg);
            if (g_biz_pending.active) {
                biz_clear_pending();
            }
            osal_printk("[WS63_BIZ] esp32 error: %s %s\r\n", code, msg);
        }
    } else if (strcmp(cmd, "mqtt_connected") == 0 ||
               strcmp(cmd, "mqtt_error") == 0 ||
               strcmp(cmd, "mqtt_publish_result") == 0 ||
               strcmp(cmd, "l610_error") == 0 ||
               strcmp(cmd, "l610_at_result") == 0 ||
               strcmp(cmd, "l610_status") == 0) {
        /* forward L610/MQTT status to serial screen */
        biz_reply(0, cmd, 0, "ok", data_json);
        osal_printk("[WS63_BIZ] esp32 status: %s\r\n", cmd);
    } else {
        osal_printk("[WS63_BIZ] esp32 unknown msg: %s\r\n", cmd);
    }

    if (root != NULL) {
        cJSON_Delete(root);
    }
}

static void biz_cmd_register(uint16_t seq, const char *data_json)
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

static void biz_cmd_scan_list(uint16_t seq, const char *data_json)
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

static void biz_cmd_passthrough_to_esp32(uint16_t seq, const char *cmd,
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

static void biz_uart_cmd_handler(const char *cmd, uint16_t seq, const char *data_json)
{
    osal_printk("[WS63_BIZ] uart cmd=%s seq=%u\r\n", cmd, (unsigned int)seq);

    /* === existing SLE/warehouse commands === */
    if (strcmp(cmd, "inbound") == 0) {
        biz_cmd_inbound(seq, data_json);
    } else if (strcmp(cmd, "inventory") == 0) {
        biz_cmd_inventory(seq, data_json);
    } else if (strcmp(cmd, "find") == 0) {
        biz_cmd_find(seq, data_json);
    } else if (strcmp(cmd, "outbound") == 0) {
        biz_cmd_outbound(seq, data_json);
    } else if (strcmp(cmd, "list") == 0) {
        biz_cmd_list(seq, data_json);
    } else if (strcmp(cmd, "scan_list") == 0) {
        biz_cmd_scan_list(seq, data_json);
    } else if (strcmp(cmd, "update_qty") == 0) {
        biz_cmd_update_qty(seq, data_json);

    /* === ESP32 combined commands === */
    } else if (strcmp(cmd, "register") == 0) {
        biz_cmd_register(seq, data_json);

    /* === ESP32 passthrough commands (no SLE interaction) === */
    } else if (strcmp(cmd, "get_assets") == 0 ||
               strcmp(cmd, "sys_info") == 0 ||
               strcmp(cmd, "l610_at") == 0 ||
               strcmp(cmd, "l610_status") == 0) {
        biz_cmd_passthrough_to_esp32(seq, cmd, data_json);

    /* === ESP32 upstream messages (type→cmd compatibility) === */
    } else if (strcmp(cmd, "task_done") == 0 ||
               strcmp(cmd, "error") == 0 ||
               strcmp(cmd, "capture_progress") == 0 ||
               strcmp(cmd, "mqtt_connected") == 0 ||
               strcmp(cmd, "mqtt_error") == 0 ||
               strcmp(cmd, "mqtt_publish_result") == 0 ||
               strcmp(cmd, "l610_error") == 0 ||
               strcmp(cmd, "l610_at_result") == 0 ||
               strcmp(cmd, "l610_status") == 0 ||
               strcmp(cmd, "asset_list") == 0 ||
               strcmp(cmd, "system_info") == 0) {
        biz_handle_esp32_msg(cmd, data_json);

    /* === WiFi/MQTT commands (local to WS63) === */
    } else if (strcmp(cmd, "wifi_connect") == 0) {
        biz_cmd_wifi_connect(seq, data_json);
    } else if (strcmp(cmd, "wifi_status") == 0) {
        biz_cmd_wifi_status(seq, data_json);
    } else if (strcmp(cmd, "mqtt_connect") == 0) {
        biz_cmd_mqtt_connect(seq, data_json);
    } else if (strcmp(cmd, "mqtt_disconnect") == 0) {
        biz_cmd_mqtt_disconnect(seq, data_json);
    } else if (strcmp(cmd, "mqtt_status") == 0) {
        biz_cmd_mqtt_status(seq, data_json);
    } else if (strcmp(cmd, "mqtt_publish") == 0) {
        biz_cmd_mqtt_publish(seq, data_json);

    /* === unknown === */
    } else {
        biz_reply(seq, cmd, -99, "unknown cmd", NULL);
    }
}

static void biz_sle_notify_cb(const ssap_inventory_rsp_t *inv,
    const ssap_bind_rsp_t *bind)
{
    if (inv != NULL) {
        osal_printk("[WS63_BIZ] sle inv tag_id=%u qty=%u status=%u bat=%u\r\n",
            (unsigned int)inv->tag_id, (unsigned int)inv->qty,
            (unsigned int)inv->status, (unsigned int)inv->battery);
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
        osal_printk("[WS63_BIZ] sle bind cmd=0x%02x tag_id=%u\r\n",
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
                    char esp32_cmd[192];
                    char tag_str[8];
                    biz_tag_id_to_esp32(g_biz_pending.tag_id, tag_str, sizeof(tag_str));
                    if (reg_entry != NULL) {
                        snprintf(esp32_cmd, sizeof(esp32_cmd),
                            "{\"cmd\":\"register\",\"tag_id\":\"%s\","
                            "\"item_name\":\"%s\",\"storage_area\":\"%s\",\"qty\":%u}",
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

/* 串口屏回复封装：#cmd,param1,param2,...\r\n */
static void biz_screen_reply(const char *cmd, const char *fmt, ...)
{
    if (cmd == NULL) {
        return;
    }
    /* 使用 uart_display_send 直接发送 */
    char params[128] = {0};
    if (fmt != NULL && fmt[0] != '\0') {
        va_list ap;
        va_start(ap, fmt);
        vsnprintf(params, sizeof(params), fmt, ap);
        va_end(ap);
    }
    uart_display_send(cmd, "%s", params);
}

/* ========== Page1 入库命令处理 ========== */

/* @in,start → SLE扫描 + 查DB → #TAG/#VERIFY */
static void biz_screen_in_start(void)
{
    /* TODO: SLE扫描取最强标签 + 查biz_map */
    /* 临时实现: 提示需要SLE扫描 */
    biz_screen_reply("MSG", "请按匹配按钮扫描标签");
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
        biz_screen_reply("ERR", "INVALID_PARAMS,参数不足");
        return;
    }

    uint16_t tag_id = 0;
    if (ud_str_to_tag_id(id_str, &tag_id) != 0) {
        biz_screen_reply("ERR", "INVALID_ID,Tag ID格式错误");
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
    biz_set_pending("register", 0, tag_id);
    biz_screen_reply("PROG", "1,front,0");
    osal_printk("[WS63_BIZ] screen in,capture tag=%s qty=%d mode=%d\r\n",
        id_str, qty, mode);
}

/* @in,photo,<view> → capture JSON */
static void biz_screen_in_photo(const char *view)
{
    char esp32_json[64];
    snprintf(esp32_json, sizeof(esp32_json),
        "{\"cmd\":\"capture\",\"view\":\"%s\"}", view);
    biz_raw_json_send(esp32_json);
}

/* @in,confirm → 持久化+上云 */
static void biz_screen_in_confirm(void)
{
    biz_screen_reply("MSG", "确认入库完成");
    /* TODO: 持久化资产记录 */
}

/* @in,cancel → 取消 */
static void biz_screen_in_cancel(void)
{
    char esp32_json[32];
    snprintf(esp32_json, sizeof(esp32_json), "{\"cmd\":\"cancel\"}");
    biz_raw_json_send(esp32_json);
    biz_clear_pending();
    biz_screen_reply("MSG", "已取消入库");
}

/* ========== Page2 出库命令处理 ========== */

/* @out,start → SLE扫描+查DB → #TAG,id,name,area,total */
static void biz_screen_out_start(void)
{
    /* TODO: SLE扫描取最强标签 + 查biz_map → #TAG */
    biz_screen_reply("MSG", "请按匹配按钮扫描标签");
}

/* @out,capture,<id>,<qty> → outbound JSON */
static void biz_screen_out_capture(const char *params)
{
    char id_str[8] = {0};
    char qty_str[8] = {0};

    if (sscanf(params, "%7[^,],%7[^,]", id_str, qty_str) < 2) {
        biz_screen_reply("ERR", "INVALID_PARAMS,参数不足");
        return;
    }

    uint16_t tag_id = 0;
    if (ud_str_to_tag_id(id_str, &tag_id) != 0) {
        biz_screen_reply("ERR", "INVALID_ID,Tag ID格式错误");
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
    biz_screen_reply("MSG", "确认出库完成");
    /* TODO: 持久化 */
}

/* @out,cancel → 取消 */
static void biz_screen_out_cancel(void)
{
    char esp32_json[32];
    snprintf(esp32_json, sizeof(esp32_json), "{\"cmd\":\"cancel\"}");
    biz_raw_json_send(esp32_json);
    biz_clear_pending();
    biz_screen_reply("MSG", "已取消出库");
}

/* ========== Page3 盘点命令处理 ========== */

/* @check,global → SLE组播 + list_assets_page → #INV */
static void biz_screen_check_global(void)
{
    /* TODO: SLE组播统计 + ESP32 list_assets_page */
    biz_screen_reply("MSG", "全局盘点中...");
}

/* @check,specific,<id> → get_asset → #TAG_INFO */
static void biz_screen_check_specific(const char *id_str)
{
    uint16_t tag_id = 0;
    if (ud_str_to_tag_id(id_str, &tag_id) != 0) {
        biz_screen_reply("ERR", "INVALID_ID,Tag ID格式错误");
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
        biz_screen_reply("ERR", "INVALID_ID,Tag ID格式错误");
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

/* @find,locate,<id> → SLE蜂鸣(不经ESP32) */
static void biz_screen_find_locate(const char *id_str)
{
    uint16_t tag_id = 0;
    if (ud_str_to_tag_id(id_str, &tag_id) != 0) {
        biz_screen_reply("ERR", "INVALID_ID,Tag ID格式错误");
        return;
    }

    /* TODO: WS63→SLE直接蜂鸣指令 */
    biz_screen_reply("LOCATE", "found,%s", id_str);
    osal_printk("[WS63_BIZ] screen find,locate tag=%s (SLE蜂鸣)\r\n", id_str);
}

/* @find,stop → SLE停止蜂鸣 */
static void biz_screen_find_stop(void)
{
    /* TODO: WS63→SLE停止蜂鸣 */
    biz_screen_reply("MSG", "已停止定位");
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
        biz_screen_reply("ERR", "WIFI_NOT_AVAILABLE,WiFi不可用");
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

/* ========== 统一命令分发 ========== */

/* 串口屏命令分发：按页面分发到具体处理函数 */
void biz_handle_screen_cmd(const char *cmd, const char *params)
{
    if (cmd == NULL) {
        return;
    }

    osal_printk("[WS63_BIZ] screen cmd=%s params=%s\r\n",
        cmd, params ? params : "(null)");

    if (strcmp(cmd, "in") == 0) {
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
    } else if (strcmp(cmd, "out") == 0) {
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
    } else if (strcmp(cmd, "check") == 0 || strcmp(cmd, "inv") == 0) {
        if (params == NULL || strncmp(params, "global", 6) == 0) {
            biz_screen_check_global();
        } else if (strncmp(params, "specific", 8) == 0) {
            biz_screen_check_specific(params + 9);
        } else if (strncmp(params, "capture", 7) == 0) {
            biz_screen_check_capture(params + 8);
        } else if (strncmp(params, "photo", 5) == 0) {
            biz_screen_check_photo(params + 6);
        } else if (strncmp(params, "cancel", 6) == 0) {
            biz_clear_pending();
            biz_screen_reply("MSG", "已取消盘点");
        }
    } else if (strcmp(cmd, "find") == 0) {
        if (strncmp(params, "list", 4) == 0) {
            biz_screen_find_list(params + 5);
        } else if (strncmp(params, "locate", 6) == 0) {
            biz_screen_find_locate(params + 7);
        } else if (strncmp(params, "stop", 4) == 0) {
            biz_screen_find_stop();
        } else if (strncmp(params, "cancel", 6) == 0) {
            biz_screen_reply("MSG", "已取消查找");
        }
    } else if (strcmp(cmd, "setting") == 0) {
        if (strncmp(params, "wifi", 4) == 0) {
            biz_screen_setting_wifi(params + 5);
        } else if (strncmp(params, "disconnect", 10) == 0) {
            biz_screen_setting_disconnect();
        } else if (strncmp(params, "cancel", 6) == 0) {
            biz_screen_reply("MSG", "已取消设置");
        }
    } else if (strcmp(cmd, "back") == 0) {
        biz_screen_reply("HOME", "");
    } else {
        osal_printk("[WS63_BIZ] unknown screen cmd=%s\r\n", cmd);
        biz_screen_reply("ERR", "UNKNOWN_CMD,未知命令");
    }
}

void business_logic_poll(void)
{
    if (!g_biz_pending.active) {
        return;
    }

    /* inbound/register 状态机：等待 SSAP 就绪后发送 BIND_TAG */
    if ((strcmp(g_biz_pending.cmd, "inbound") == 0 ||
         strcmp(g_biz_pending.cmd, "register") == 0) &&
        sle_network_is_ssap_ready() != 0 &&
        sle_network_is_connected() != 0) {
        osal_printk("[WS63_BIZ] %s: SSAP ready, send BIND_TAG tag_id=%u\r\n",
            g_biz_pending.cmd, (unsigned int)g_biz_pending.tag_id);
        int ret = sle_network_send_cmd(SSAP_CMD_BIND_TAG, g_biz_pending.tag_id);
        if (ret != 0) {
            osal_printk("[WS63_BIZ] %s: BIND_TAG send fail ret=%d\r\n",
                g_biz_pending.cmd, ret);
            biz_map_remove(g_biz_pending.tag_id);
            biz_reply(g_biz_pending.seq, g_biz_pending.cmd, -9, "bind send fail", NULL);
            biz_clear_pending();
            return;
        }
        /* 更新 pending 标记，避免重复发送 */
        char new_cmd[16];
        snprintf(new_cmd, sizeof(new_cmd), "%s_bind", g_biz_pending.cmd);
        errno_t rc = strncpy_s(g_biz_pending.cmd, sizeof(g_biz_pending.cmd),
            new_cmd, sizeof(g_biz_pending.cmd) - 1);
        if (rc != EOK) {
            g_biz_pending.cmd[0] = '\0';
        }
    }

    uint64_t now = uapi_tcxo_get_ms();
    if (now - g_biz_pending.start_ms >= g_biz_pending.timeout_ms) {
        osal_printk("[WS63_BIZ] pending timeout cmd=%s seq=%u\r\n",
            g_biz_pending.cmd, (unsigned int)g_biz_pending.seq);
        if (strcmp(g_biz_pending.cmd, "inbound") == 0 ||
            strcmp(g_biz_pending.cmd, "inbound_bind") == 0 ||
            strcmp(g_biz_pending.cmd, "register") == 0 ||
            strcmp(g_biz_pending.cmd, "register_bind") == 0) {
            biz_map_remove(g_biz_pending.tag_id);
        }
        biz_reply(g_biz_pending.seq, g_biz_pending.cmd, -10, "timeout", NULL);
        biz_clear_pending();
    }
}

static void biz_uart_send_wrapper(uint16_t seq, const char *cmd, int code,
    const char *msg, const char *data_json)
{
    (void)uart_vision_send_json(seq, cmd, code, msg, data_json);
}

static void biz_raw_json_send_wrapper(const char *json_str)
{
    (void)uart_vision_send_raw_json(json_str);
}

int business_logic_init(void)
{
    osal_printk("[WS63_BIZ] init start\r\n");

    if (biz_map_load_nv() != 0) {
        osal_printk("[WS63_BIZ] nv load fail, start empty\r\n");
        g_biz_map.count = 0;
    }

    uart_vision_register_cmd_handler(biz_uart_cmd_handler);
    sle_network_register_notify_cb(biz_sle_notify_cb);
    business_logic_register_uart_cb(biz_uart_send_wrapper);
    business_logic_register_raw_json_cb(biz_raw_json_send_wrapper);
    uart_display_register_cmd_handler(biz_handle_screen_cmd);

    osal_printk("[WS63_BIZ] init done count=%u\r\n",
        (unsigned int)g_biz_map.count);
    return 0;
}
