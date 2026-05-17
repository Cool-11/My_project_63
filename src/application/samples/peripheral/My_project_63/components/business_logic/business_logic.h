#ifndef MY63_BUSINESS_LOGIC_H
#define MY63_BUSINESS_LOGIC_H

#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

#define BIZ_TAG_MAX             32
#define BIZ_ZONE_LEN            8
#define BIZ_ITEM_LEN            16
#define BIZ_MAC_LEN             6
#define BIZ_NV_KEY_TAG_MAP      0x5001
#define BIZ_PENDING_TIMEOUT_SLE_MS   5000
#define BIZ_PENDING_TIMEOUT_ESP32_MS 15000

#define BIZ_MQTT_URI_MAX        128
#define BIZ_MQTT_CID_MAX        64
#define BIZ_MQTT_USER_MAX       64
#define BIZ_MQTT_PASS_MAX       64

typedef enum {
    BIZ_TAG_IDLE = 0,
    BIZ_TAG_BOUND,
    BIZ_TAG_ONLINE,
    BIZ_TAG_OFFLINE
} biz_tag_status_t;

typedef enum {
    BIZ_MQTT_CMD_CONNECT = 1,
    BIZ_MQTT_CMD_DISCONNECT,
    BIZ_MQTT_CMD_STATUS
} biz_mqtt_cmd_t;

typedef struct {
    char uri[BIZ_MQTT_URI_MAX];
    char client_id[BIZ_MQTT_CID_MAX];
    char username[BIZ_MQTT_USER_MAX];
    char password[BIZ_MQTT_PASS_MAX];
} biz_mqtt_connect_params_t;

typedef struct {
    uint16_t tag_id;
    uint8_t  mac[BIZ_MAC_LEN];
    char     zone[BIZ_ZONE_LEN];
    char     item[BIZ_ITEM_LEN];
    uint16_t qty;
    biz_tag_status_t status;
    uint8_t  battery;
} biz_tag_entry_t;

typedef struct {
    uint16_t count;
    biz_tag_entry_t entries[BIZ_TAG_MAX];
} biz_tag_map_t;

typedef void (*biz_notify_uart_t)(uint16_t seq, const char *cmd, int code,
    const char *msg, const char *data_json);
typedef void (*biz_raw_json_uart_t)(const char *json_str);
typedef void (*biz_cloud_publish_t)(const char *payload, uint16_t len);
typedef int (*biz_wifi_cmd_t)(const char *ssid, const char *psk);
typedef int (*biz_mqtt_cmd_handler_t)(biz_mqtt_cmd_t cmd, const biz_mqtt_connect_params_t *params);

int business_logic_init(void);
void business_logic_poll(void);

biz_tag_entry_t *biz_map_find_by_tag(uint16_t tag_id);
biz_tag_entry_t *biz_map_find_by_mac(const uint8_t *mac);
biz_tag_entry_t *biz_map_add(uint16_t tag_id);
int biz_map_remove(uint16_t tag_id);
int biz_map_save_nv(void);
int biz_map_load_nv(void);

void business_logic_register_uart_cb(biz_notify_uart_t cb);
void business_logic_register_raw_json_cb(biz_raw_json_uart_t cb);
void business_logic_register_cloud_cb(biz_cloud_publish_t cb);
void business_logic_register_wifi_cmd_cb(biz_wifi_cmd_t cb);
void business_logic_register_mqtt_cmd_cb(biz_mqtt_cmd_handler_t cb);

#ifdef __cplusplus
}
#endif

#endif
