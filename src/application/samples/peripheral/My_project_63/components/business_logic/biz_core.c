#include "business_logic.h"
#include "business_logic_internal.h"
#include "soc_osal.h"
#include "securec.h"
#include "cJSON.h"
#include "../uart_vision/uart_vision.h"
#include "../uart_display/uart_display.h"
#include "../sle_network/sle_network.h"
#include "tcxo.h"
#include <string.h>

biz_tag_map_t g_biz_map = {0};
biz_notify_uart_t g_biz_uart_cb = NULL;
biz_raw_json_uart_t g_biz_raw_json_cb = NULL;
biz_cloud_publish_t g_biz_cloud_cb = NULL;
biz_wifi_cmd_t g_biz_wifi_cmd_cb = NULL;
biz_mqtt_cmd_handler_t g_biz_mqtt_cmd_cb = NULL;
biz_ud_cmd_handler_t g_biz_screen_cb = NULL;

/* 白名单 + 去重条目数组（packed 27B × 32 = 864B） */
struct TagListEntry g_biz_tag_list[TAG_LIST_MAX] = {0};

biz_pending_t g_biz_pending = {0};

void biz_reply(uint16_t seq, const char *cmd, int code,
    const char *msg, const char *data_json)
{
    if (g_biz_uart_cb != NULL) {
        g_biz_uart_cb(seq, cmd, code, msg, data_json);
    }
}

void biz_cloud_publish(const char *payload, uint16_t len)
{
    if (g_biz_cloud_cb != NULL) {
        g_biz_cloud_cb(payload, len);
    }
}

void biz_raw_json_send(const char *json_str)
{
    if (g_biz_raw_json_cb != NULL) {
        g_biz_raw_json_cb(json_str);
    }
}

uint32_t biz_get_pending_timeout_ms(const char *cmd)
{
    if (cmd == NULL) {
        return BIZ_PENDING_TIMEOUT_SLE_MS;
    }
    /* ESP32 命令：拍摄过程较长，15秒超时 */
    if (strcmp(cmd, "register") == 0 ||
        strcmp(cmd, "outbound") == 0 ||
        strcmp(cmd, "in_capture") == 0 ||
        strcmp(cmd, "check_global") == 0) {
        return BIZ_PENDING_TIMEOUT_ESP32_MS;
    }
    /* SLE 命令：BIND_TAG/FIND 等，5秒超时 */
    return BIZ_PENDING_TIMEOUT_SLE_MS;
}

const char *biz_map_esp32_task(const char *task)
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

void biz_set_pending(const char *cmd, uint16_t seq, uint16_t tag_id)
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

void biz_clear_pending(void)
{
    g_biz_pending.active = false;
    g_biz_pending.cmd[0] = '\0';
}

int biz_parse_mac(const char *str, uint8_t *mac)
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
int biz_tag_id_to_esp32(uint16_t id, char *buf, uint16_t len)
{
    if (buf == NULL || len < 7) {
        return -1;
    }
    return snprintf(buf, len, "0x%04X", (unsigned int)id);
}

/* Tag ID 格式转换: "0x0001" → uint16_t (从ESP32接收) */
int biz_esp32_to_tag_id(const char *str, uint16_t *out)
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

/* 串口屏回复封装：#cmd,param1,param2,...\r\n */
void biz_screen_reply(const char *cmd, const char *fmt, ...)
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
            strcmp(g_biz_pending.cmd, "register_bind") == 0 ||
            strcmp(g_biz_pending.cmd, "in_capture") == 0) {
            biz_map_remove(g_biz_pending.tag_id);
        }
        biz_reply(g_biz_pending.seq, g_biz_pending.cmd, -10, "timeout", NULL);
        biz_clear_pending();
    }

    /* 寻物超时检查：5秒后自动停止蜂鸣 */
    biz_locate_check_timeout();
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
