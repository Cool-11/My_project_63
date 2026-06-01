#include "business_logic.h"
#include "business_logic_internal.h"
#include "soc_osal.h"
#include "nv.h"
#include "securec.h"
#include "cJSON.h"
#include "tcxo.h"
#include <string.h>

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

char *biz_build_tags_json(void)
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

void biz_publish_tag_update(biz_tag_entry_t *entry)
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
