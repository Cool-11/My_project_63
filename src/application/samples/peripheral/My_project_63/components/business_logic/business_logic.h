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
#define BIZ_PENDING_TIMEOUT_ESP32_MS 120000

#define BIZ_MQTT_URI_MAX        128
#define BIZ_MQTT_CID_MAX        64
#define BIZ_MQTT_USER_MAX       64
#define BIZ_MQTT_PASS_MAX       64

/* BS21E status → WS63 上云映射 */
typedef enum {
    BIZ_TAG_IDLE = 0,           /* 未注册/空闲 */
    BIZ_TAG_BOUND,              /* 已绑定（注册完成） */
    BIZ_TAG_ONLINE,             /* 在线（BS21E status=0/1/2 映射） */
    BIZ_TAG_OFFLINE             /* 离线（超时未扫描到） */
} biz_tag_status_t;

/* BS21E 广播中的原始 status 值 */
typedef enum {
    BS21E_STATUS_IDLE = 0,          /* 空闲 */
    BS21E_STATUS_FINDING = 1,       /* 寻物中 */
    BS21E_STATUS_IN_USE = 2,        /* 使用中 */
    BS21E_STATUS_NOT_PROVISIONED = 3 /* 未配网 */
} bs21e_adv_status_t;

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

/* 串口屏命令回调：cmd="in_start", params="0005" 等已解析参数 */
typedef void (*biz_ud_cmd_handler_t)(const char *cmd, const char *params);

int business_logic_init(void);
void business_logic_poll(void);

/* 事件驱动新增：主循环调用的非阻塞入口 */
void biz_handle_sle_adv(void);      /* 处理 SLE 广播队列数据 */
void biz_check_confirm_bind(void);  /* 检查 in_confirm_connecting，SSAP 就绪后发 BIND_TAG */
void biz_locate_record_tag(uint16_t tag_id);  /* 记录已定位标签（FIND 发送后调用） */
void biz_handle_screen_cmd(const char *cmd, const char *params); /* 串口屏命令入口 */

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
void business_logic_register_screen_cb(biz_ud_cmd_handler_t cb);

#ifdef __cplusplus
}
#endif

#endif
