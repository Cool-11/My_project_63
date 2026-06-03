#ifndef MY63_BUSINESS_LOGIC_INTERNAL_H
#define MY63_BUSINESS_LOGIC_INTERNAL_H

#include "business_logic.h"
#include "../shared_protocol/shared_protocol.h"

#ifdef __cplusplus
extern "C" {
#endif

/* ========== Pending state struct ========== */
typedef struct {
    char cmd[16];
    uint16_t seq;
    uint16_t tag_id;
    bool active;
    uint64_t start_ms;
    uint32_t timeout_ms;
} biz_pending_t;

/* ========== Global variables (defined in biz_core.c) ========== */
extern biz_tag_map_t g_biz_map;
extern biz_pending_t g_biz_pending;
extern biz_notify_uart_t g_biz_uart_cb;
extern biz_raw_json_uart_t g_biz_raw_json_cb;
extern biz_cloud_publish_t g_biz_cloud_cb;
extern biz_wifi_cmd_t g_biz_wifi_cmd_cb;
extern biz_mqtt_cmd_handler_t g_biz_mqtt_cmd_cb;
extern biz_ud_cmd_handler_t g_biz_screen_cb;
extern struct TagListEntry g_biz_tag_list[TAG_LIST_MAX];

/* ========== biz_core.c — shared helper functions ========== */
void biz_reply(uint16_t seq, const char *cmd, int code,
    const char *msg, const char *data_json);
void biz_cloud_publish(const char *payload, uint16_t len);
void biz_raw_json_send(const char *json_str);
uint32_t biz_get_pending_timeout_ms(const char *cmd);
const char *biz_map_esp32_task(const char *task);
void biz_set_pending(const char *cmd, uint16_t seq, uint16_t tag_id);
void biz_clear_pending(void);
int biz_parse_mac(const char *str, uint8_t *mac);
int biz_tag_id_to_esp32(uint16_t id, char *buf, uint16_t len);
int biz_esp32_to_tag_id(const char *str, uint16_t *out);
void biz_screen_reply(const char *cmd, const char *fmt, ...);

/* ========== biz_tag_map.c ========== */
char *biz_build_tags_json(void);
void biz_publish_tag_update(biz_tag_entry_t *entry);

/* ========== biz_esp32_cmd.c — UART-dispatched commands ========== */
void biz_cmd_inbound(uint16_t seq, const char *data_json);
void biz_cmd_inventory(uint16_t seq, const char *data_json);
void biz_cmd_find(uint16_t seq, const char *data_json);
void biz_cmd_outbound(uint16_t seq, const char *data_json);
void biz_cmd_list(uint16_t seq, const char *data_json);
void biz_cmd_update_qty(uint16_t seq, const char *data_json);
void biz_cmd_register(uint16_t seq, const char *data_json);
void biz_cmd_scan_list(uint16_t seq, const char *data_json);
void biz_cmd_passthrough_to_esp32(uint16_t seq, const char *cmd,
    const char *data_json);

/* ========== biz_esp32_resp.c ========== */
void biz_handle_esp32_msg(const char *cmd, const char *data_json);

/* ========== biz_screen_cmd.c ========== */
void biz_handle_screen_cmd(const char *cmd, const char *params);
void biz_check_global_compare(uint16_t esp32_total);
void biz_locate_check_timeout(void);

/* ========== biz_wifi_mqtt.c ========== */
void biz_cmd_wifi_connect(uint16_t seq, const char *data_json);
void biz_cmd_wifi_status(uint16_t seq, const char *data_json);
void biz_cmd_mqtt_connect(uint16_t seq, const char *data_json);
void biz_cmd_mqtt_disconnect(uint16_t seq, const char *data_json);
void biz_cmd_mqtt_status(uint16_t seq, const char *data_json);
void biz_cmd_mqtt_publish(uint16_t seq, const char *data_json);

/* ========== biz_sle.c ========== */
void biz_sle_notify_cb(const ssap_inventory_rsp_t *inv,
    const ssap_bind_rsp_t *bind);
void biz_handle_sle_adv(void);

#ifdef __cplusplus
}
#endif

#endif
