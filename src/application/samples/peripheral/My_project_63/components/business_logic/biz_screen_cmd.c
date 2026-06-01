#include "business_logic.h"
#include "business_logic_internal.h"
#include "soc_osal.h"
#include "cJSON.h"
#include "../uart_display/uart_display.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

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
