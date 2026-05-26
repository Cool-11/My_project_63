#ifndef MY63_CLOUD_STORAGE_H
#define MY63_CLOUD_STORAGE_H

#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

#define CS_SSID_MAX_LEN     33
#define CS_PSK_MAX_LEN      65
#define CS_IFNAME_LEN       16

#define CS_MQTT_URI_MAX     128
#define CS_MQTT_CLIENTID_MAX 64
#define CS_MQTT_USER_MAX    64
#define CS_MQTT_PASS_MAX    64
#define CS_MQTT_TOPIC_MAX   128
#define CS_MQTT_PAYLOAD_MAX 512

#define CS_CACHE_MAX        16
#define CS_NV_KEY_MQTT_CFG  0x5002
#define CS_NV_KEY_WIFI_CFG  0x5003

#define CS_THINGSKIT_GATEWAY_TELEMETRY    "v1/gateway/telemetry"
#define CS_THINGSKIT_GATEWAY_RPC_SUB      "v1/gateway/rpc"

typedef enum {
    CS_WIFI_IDLE = 0,
    CS_WIFI_SCANNING,
    CS_WIFI_SCAN_DONE,
    CS_WIFI_CONNECTING,
    CS_WIFI_CONNECTED,
    CS_WIFI_GOT_IP,
    CS_WIFI_DISCONNECTED
} cs_wifi_state_t;

typedef enum {
    CS_MQTT_IDLE = 0,
    CS_MQTT_CONNECTING,
    CS_MQTT_CONNECTED,
    CS_MQTT_DISCONNECTED,
    CS_MQTT_FAILED
} cs_mqtt_state_t;

typedef struct {
    char uri[CS_MQTT_URI_MAX];
    char client_id[CS_MQTT_CLIENTID_MAX];
    char username[CS_MQTT_USER_MAX];
    char password[CS_MQTT_PASS_MAX];
} cs_mqtt_config_t;

typedef struct {
    char ssid[CS_SSID_MAX_LEN];
    char psk[CS_PSK_MAX_LEN];
} cs_wifi_config_t;

typedef void (*cs_wifi_state_cb)(cs_wifi_state_t state);
typedef void (*cs_mqtt_state_cb)(cs_mqtt_state_t state);
typedef void (*cs_mqtt_msg_cb)(const char *topic, const char *payload, uint16_t len);

int cloud_storage_init(void);
void cloud_storage_poll(void);

int cs_wifi_connect(const char *ssid, const char *psk);
int cs_wifi_disconnect(void);
cs_wifi_state_t cs_wifi_get_state(void);
bool cs_wifi_is_got_ip(void);
void cs_wifi_register_state_cb(cs_wifi_state_cb cb);

int cs_wifi_config_save_nv(const cs_wifi_config_t *cfg);
int cs_wifi_config_load_nv(cs_wifi_config_t *cfg);

int cs_mqtt_connect(const cs_mqtt_config_t *config);
int cs_mqtt_disconnect(void);
cs_mqtt_state_t cs_mqtt_get_state(void);
bool cs_mqtt_is_connected(void);
int cs_mqtt_publish(const char *topic, const char *payload, uint16_t len);
int cs_mqtt_publish_telemetry(const char *payload, uint16_t len);
int cs_mqtt_publish_gateway(const char *payload, uint16_t len);
void cs_mqtt_register_state_cb(cs_mqtt_state_cb cb);
void cs_mqtt_register_msg_cb(cs_mqtt_msg_cb cb);
int cs_mqtt_subscribe_gateway(void);

int cs_cache_push(const char *topic, const char *payload, uint16_t len);
uint16_t cs_cache_count(void);
int cs_cache_flush(void);

int cs_mqtt_config_save_nv(const cs_mqtt_config_t *config);
int cs_mqtt_config_load_nv(cs_mqtt_config_t *config);

#ifdef __cplusplus
}
#endif

#endif
