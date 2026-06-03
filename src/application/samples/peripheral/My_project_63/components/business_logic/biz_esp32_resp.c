#include "business_logic.h"
#include "business_logic_internal.h"
#include "soc_osal.h"
#include "cJSON.h"
#include "../uart_display/uart_display.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

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

/* ESP32响应处理: asset_list_page → #LIST + #ITEM×N 或 全局盘点比对 */
static void biz_handle_asset_list_page(cJSON *root)
{
    cJSON *j_page = cJSON_GetObjectItem(root, "page");
    cJSON *j_tp = cJSON_GetObjectItem(root, "total_pages");
    cJSON *j_tc = cJSON_GetObjectItem(root, "total_count");
    cJSON *j_assets = cJSON_GetObjectItem(root, "assets");

    int page = (j_page && cJSON_IsNumber(j_page)) ? j_page->valueint : 1;
    int tp = (j_tp && cJSON_IsNumber(j_tp)) ? j_tp->valueint : 1;
    int tc = (j_tc && cJSON_IsNumber(j_tc)) ? j_tc->valueint : 0;

    /* 全局盘点模式：收到 asset_list_page 后执行比对 */
    if (g_biz_pending.active &&
        strcmp(g_biz_pending.cmd, "check_global") == 0) {
        biz_check_global_compare((uint16_t)tc);
        biz_clear_pending();
        return;
    }

    /* 普通列表模式：发送 #LIST + #ITEM */
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

void biz_handle_esp32_msg(const char *cmd, const char *data_json)
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
