#ifndef MOCK_CLOUD_STORAGE_H
#define MOCK_CLOUD_STORAGE_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

/* ========== Mock MQTT 状态 ========== */
typedef enum {
    CS_MQTT_IDLE = 0,
    CS_MQTT_CONNECTING,
    CS_MQTT_CONNECTED,
    CS_MQTT_DISCONNECTED,
    CS_MQTT_FAILED
} cs_mqtt_state_t;

static cs_mqtt_state_t g_mock_mqtt_state = CS_MQTT_IDLE;
static char g_mock_mqtt_last_topic[128] = {0};
static char g_mock_mqtt_last_payload[512] = {0};
static int g_mock_mqtt_publish_ret = 0;

/* Mock 函数：重置 */
static inline void mock_cloud_reset(void) {
    g_mock_mqtt_state = CS_MQTT_IDLE;
    memset(g_mock_mqtt_last_topic, 0, sizeof(g_mock_mqtt_last_topic));
    memset(g_mock_mqtt_last_payload, 0, sizeof(g_mock_mqtt_last_payload));
    g_mock_mqtt_publish_ret = 0;
}

/* Mock API：MQTT 状态 */
static inline cs_mqtt_state_t cs_mqtt_get_state(void) {
    return g_mock_mqtt_state;
}

static inline bool cs_mqtt_is_connected(void) {
    return g_mock_mqtt_state == CS_MQTT_CONNECTED;
}

/* Mock API：MQTT 发布 */
static inline int cs_mqtt_publish_gateway(const char *payload, uint16_t len) {
    if (payload && len > 0) {
        strncpy(g_mock_mqtt_last_payload, payload,
            len < sizeof(g_mock_mqtt_last_payload) ? len : sizeof(g_mock_mqtt_last_payload) - 1);
    }
    return g_mock_mqtt_publish_ret;
}

#endif /* MOCK_CLOUD_STORAGE_H */
