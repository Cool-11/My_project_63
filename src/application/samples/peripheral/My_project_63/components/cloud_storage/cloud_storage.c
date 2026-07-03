#include "cloud_storage.h"
#include "soc_osal.h"
#include "securec.h"
#include "nv.h"
#include "wifi_device.h"
#include "emqxsl_ca.h"
#include "wifi_event.h"
#include "wifi_hotspot_config.h"
#include "wifi_linked_info.h"
#include "lwip/netifapi.h"
#include "MQTTClient.h"
#include "tcxo.h"
#include <string.h>

static cs_wifi_state_t g_cs_wifi_state = CS_WIFI_IDLE;
static cs_wifi_state_cb g_cs_wifi_state_cb = NULL;
static struct netif *g_cs_netif = NULL;
static char g_cs_ifname[CS_IFNAME_LEN] = "wlan0";
static bool g_cs_wifi_inited = false;
static uint64_t g_cs_dhcp_start_ms = 0;
#define CS_DHCP_TIMEOUT_MS 30000

static cs_mqtt_state_t g_cs_mqtt_state = CS_MQTT_IDLE;
static cs_mqtt_state_cb g_cs_mqtt_state_cb = NULL;
static cs_mqtt_msg_cb g_cs_mqtt_msg_cb = NULL;
static MQTTClient g_cs_mqtt_client = NULL;
static cs_mqtt_config_t g_cs_mqtt_config = {0};
static bool g_cs_mqtt_inited = false;

typedef struct {
    char topic[CS_MQTT_TOPIC_MAX];
    char payload[CS_MQTT_PAYLOAD_MAX];
    uint16_t payload_len;
    bool used;
} cs_cache_entry_t;

static cs_cache_entry_t g_cs_cache[CS_CACHE_MAX] = {0};
static uint16_t g_cs_cache_head = 0;
static uint16_t g_cs_cache_count = 0;

static void cs_set_wifi_state(cs_wifi_state_t state)
{
    if (g_cs_wifi_state != state) {
        osal_printk("[WS63_CLOUD] wifi state %d->%d\r\n",
            (int)g_cs_wifi_state, (int)state);
        g_cs_wifi_state = state;
        if (g_cs_wifi_state_cb != NULL) {
            g_cs_wifi_state_cb(state);
        }
    }
}

static void cs_set_mqtt_state(cs_mqtt_state_t state)
{
    if (g_cs_mqtt_state != state) {
        osal_printk("[WS63_CLOUD] mqtt state %d->%d\r\n",
            (int)g_cs_mqtt_state, (int)state);
        g_cs_mqtt_state = state;
        if (g_cs_mqtt_state_cb != NULL) {
            g_cs_mqtt_state_cb(state);
        }
    }
}

void cs_wifi_register_state_cb(cs_wifi_state_cb cb)
{
    g_cs_wifi_state_cb = cb;
}

cs_wifi_state_t cs_wifi_get_state(void)
{
    return g_cs_wifi_state;
}

bool cs_wifi_is_got_ip(void)
{
    return g_cs_wifi_state == CS_WIFI_GOT_IP;
}

static void cs_wifi_event_connection_changed(int32_t state,
    const wifi_linked_info_stru *info, int32_t reason_code)
{
    unused(info);
    if (state == WIFI_STATE_AVALIABLE) {
        osal_printk("[WS63_CLOUD] wifi connected\r\n");
        cs_set_wifi_state(CS_WIFI_CONNECTED);
    } else {
        osal_printk("[WS63_CLOUD] wifi disconnected reason=%d\r\n",
            (int)reason_code);
        cs_set_wifi_state(CS_WIFI_DISCONNECTED);
        g_cs_netif = NULL;
        if (g_cs_mqtt_state == CS_MQTT_CONNECTED) {
            cs_set_mqtt_state(CS_MQTT_DISCONNECTED);
        }
    }
}

static void cs_wifi_event_scan_state_changed(int32_t state, int32_t size)
{
    unused(state);
    osal_printk("[WS63_CLOUD] scan done size=%d\r\n", (int)size);
    cs_set_wifi_state(CS_WIFI_SCAN_DONE);
}

static wifi_event_stru g_cs_wifi_event_cb = {
    .wifi_event_connection_changed = cs_wifi_event_connection_changed,
    .wifi_event_scan_state_changed = cs_wifi_event_scan_state_changed,
    .wifi_event_softap_state_changed = NULL,
    .wifi_event_softap_sta_join = NULL,
    .wifi_event_softap_sta_leave = NULL,
    .wifi_event_p2p_receive_connect = NULL,
    .wifi_event_p2p_go_neg_result = NULL,
    .wifi_event_p2p_go_start = NULL,
    .wifi_event_p2p_invitation_result = NULL,
    .wifi_event_p2p_gc_connection_changed = NULL,
    .wifi_event_p2p_go_connection_changed = NULL,
    .wifi_event_wps_result = NULL,
};

static int cs_wifi_do_connect(const char *ssid, const char *psk)
{
    wifi_sta_config_stru config = {0};

    if (ssid == NULL || strlen(ssid) == 0 || strlen(ssid) > WIFI_MAX_SSID_LEN - 1) {
        osal_printk("[WS63_CLOUD] ssid invalid len=%u\r\n",
            ssid ? (unsigned int)strlen(ssid) : 0);
        return -1;
    }

    errno_t rc = strncpy_s((char *)config.ssid, WIFI_MAX_SSID_LEN,
        ssid, WIFI_MAX_SSID_LEN - 1);
    if (rc != EOK) {
        osal_printk("[WS63_CLOUD] ssid copy fail\r\n");
        return -1;
    }

    if (psk != NULL && strlen(psk) > 0) {
        rc = strncpy_s((char *)config.pre_shared_key, WIFI_MAX_KEY_LEN,
            psk, WIFI_MAX_KEY_LEN - 1);
        if (rc != EOK) {
            osal_printk("[WS63_CLOUD] psk copy fail\r\n");
            return -1;
        }
        config.security_type = WIFI_SEC_TYPE_WPA2PSK;
    } else {
        config.security_type = WIFI_SEC_TYPE_OPEN;
    }

    config.ip_type = DHCP;

    errcode_t ret = wifi_sta_connect(&config);
    if (ret != ERRCODE_SUCC) {
        osal_printk("[WS63_CLOUD] wifi_sta_connect fail ret=0x%x\r\n", ret);
        return -1;
    }

    osal_printk("[WS63_CLOUD] wifi_sta_connect ssid=%s\r\n", ssid);
    cs_set_wifi_state(CS_WIFI_CONNECTING);
    return 0;
}

static int cs_wifi_start_dhcp(void)
{
    g_cs_netif = netifapi_netif_find(g_cs_ifname);
    if (g_cs_netif == NULL) {
        osal_printk("[WS63_CLOUD] netif find fail ifname=%s\r\n", g_cs_ifname);
        return -1;
    }

    errcode_t ret = netifapi_dhcp_start(g_cs_netif);
    if (ret != ERRCODE_SUCC) {
        osal_printk("[WS63_CLOUD] dhcp start fail ret=0x%x\r\n", ret);
        g_cs_netif = NULL;
        return -1;
    }

    g_cs_dhcp_start_ms = uapi_tcxo_get_ms();
    osal_printk("[WS63_CLOUD] dhcp started\r\n");
    return 0;
}

int cs_wifi_connect(const char *ssid, const char *psk)
{

    if (ssid == NULL) {
        osal_printk("[WS63_CLOUD] ssid is null\r\n");
        return -1;
    }

    if (g_cs_wifi_state == CS_WIFI_GOT_IP ||
        g_cs_wifi_state == CS_WIFI_CONNECTED) {
        osal_printk("[WS63_CLOUD] already connected, disconnect first\r\n");
        cs_wifi_disconnect();
        osal_msleep(500);
    }

    if (!g_cs_wifi_inited) {
        osal_printk("[WS63_CLOUD] wifi not inited yet\r\n");
        return -1;
    }

    return cs_wifi_do_connect(ssid, psk);
}

int cs_wifi_disconnect(void)
{
    if (g_cs_netif != NULL) {
        netifapi_dhcp_stop(g_cs_netif);
        g_cs_netif = NULL;
    }

    errcode_t ret = wifi_sta_disconnect();
    if (ret != ERRCODE_SUCC) {
        osal_printk("[WS63_CLOUD] wifi_sta_disconnect fail ret=0x%x\r\n", ret);
        return -1;
    }

    cs_set_wifi_state(CS_WIFI_IDLE);
    osal_printk("[WS63_CLOUD] wifi disconnected\r\n");
    return 0;
}

static bool cs_check_dhcp_done(void)
{
    if (g_cs_netif == NULL) {
        return false;
    }
    if (ip_addr_isany(&(g_cs_netif->ip_addr)) == 0) {
        return true;
    }
    return false;
}

int cs_wifi_config_save_nv(const cs_wifi_config_t *cfg)
{
    if (cfg == NULL) {
        return -1;
    }
    uint16_t data_len = (uint16_t)sizeof(cs_wifi_config_t);
    errcode_t ret = uapi_nv_write(CS_NV_KEY_WIFI_CFG,
        (const uint8_t *)cfg, data_len);
    if (ret != ERRCODE_SUCC) {
        osal_printk("[WS63_CLOUD] wifi cfg nv write fail ret=0x%x\r\n", ret);
        return (int)ret;
    }
    osal_printk("[WS63_CLOUD] wifi cfg nv write ok ssid=%s\r\n", cfg->ssid);
    return 0;
}

int cs_wifi_config_load_nv(cs_wifi_config_t *cfg)
{
    if (cfg == NULL) {
        return -1;
    }
    uint16_t data_len = 0;
    uint16_t max_len = (uint16_t)sizeof(cs_wifi_config_t);
    errcode_t ret = uapi_nv_read(CS_NV_KEY_WIFI_CFG,
        max_len, &data_len, (uint8_t *)cfg);
    if (ret != ERRCODE_SUCC) {
        osal_printk("[WS63_CLOUD] wifi cfg nv read fail ret=0x%x\r\n", ret);
        return (int)ret;
    }
    if (data_len != max_len) {
        osal_printk("[WS63_CLOUD] wifi cfg nv len mismatch\r\n");
        return -1;
    }
    osal_printk("[WS63_CLOUD] wifi cfg nv read ok ssid=%s\r\n", cfg->ssid);
    return 0;
}

static void cs_mqtt_connection_lost(void *context, char *cause)
{
    unused(context);
    osal_printk("[WS63_CLOUD] mqtt connection lost cause=%s\r\n",
        cause ? cause : "unknown");
    cs_set_mqtt_state(CS_MQTT_DISCONNECTED);
}

static int cs_mqtt_msg_arrived(void *context, char *topicName, int topicLen,
    MQTTClient_message *message)
{
    unused(context);
    unused(topicLen);

    if (topicName != NULL && message != NULL && g_cs_mqtt_msg_cb != NULL) {
        g_cs_mqtt_msg_cb(topicName, (const char *)message->payload,
            (uint16_t)message->payloadlen);
    }

    if (topicName != NULL) {
        MQTTClient_free(topicName);
    }
    if (message != NULL) {
        MQTTClient_freeMessage(&message);
    }
    return 1;
}

static void cs_mqtt_delivery_complete(void *context, MQTTClient_deliveryToken dt)
{
    unused(context);
    unused(dt);
}

int cs_mqtt_connect(const cs_mqtt_config_t *config)
{
    if (config == NULL) {
        osal_printk("[WS63_CLOUD] mqtt config null\r\n");
        return -1;
    }

    if (config->uri == NULL || strlen(config->uri) < 6 ||
        (strncmp(config->uri, "tcp://", 6) != 0 &&
         strncmp(config->uri, "ssl://", 6) != 0)) {
        osal_printk("[WS63_CLOUD] mqtt uri invalid: %s\r\n",
            config->uri ? config->uri : "null");
        return -1;
    }

    if (cs_wifi_is_got_ip() == false) {
        osal_printk("[WS63_CLOUD] mqtt connect blocked: wifi state=%d (need GOT_IP=3)\r\n",
            (int)cs_wifi_get_state());
        return -2;
    }

    if (g_cs_mqtt_client != NULL) {
        cs_mqtt_disconnect();
    }

    errno_t rc = strncpy_s(g_cs_mqtt_config.uri, CS_MQTT_URI_MAX,
        config->uri, CS_MQTT_URI_MAX - 1);
    if (rc != EOK) {
        return -1;
    }
    rc = strncpy_s(g_cs_mqtt_config.client_id, CS_MQTT_CLIENTID_MAX,
        config->client_id, CS_MQTT_CLIENTID_MAX - 1);
    if (rc != EOK) {
        return -1;
    }
    rc = strncpy_s(g_cs_mqtt_config.username, CS_MQTT_USER_MAX,
        config->username, CS_MQTT_USER_MAX - 1);
    if (rc != EOK) {
        return -1;
    }
    rc = strncpy_s(g_cs_mqtt_config.password, CS_MQTT_PASS_MAX,
        config->password, CS_MQTT_PASS_MAX - 1);
    if (rc != EOK) {
        return -1;
    }

    cs_set_mqtt_state(CS_MQTT_CONNECTING);

    int mqtt_rc = MQTTClient_create(&g_cs_mqtt_client, g_cs_mqtt_config.uri,
        g_cs_mqtt_config.client_id, MQTTCLIENT_PERSISTENCE_NONE, NULL);
    if (mqtt_rc != MQTTCLIENT_SUCCESS) {
        osal_printk("[WS63_CLOUD] mqtt create fail rc=%d\r\n", mqtt_rc);
        cs_set_mqtt_state(CS_MQTT_FAILED);
        return -3;
    }

    mqtt_rc = MQTTClient_setCallbacks(g_cs_mqtt_client, NULL,
        cs_mqtt_connection_lost, cs_mqtt_msg_arrived, cs_mqtt_delivery_complete);
    if (mqtt_rc != MQTTCLIENT_SUCCESS) {
        osal_printk("[WS63_CLOUD] mqtt setcallbacks fail rc=%d\r\n", mqtt_rc);
        MQTTClient_destroy(&g_cs_mqtt_client);
        g_cs_mqtt_client = NULL;
        cs_set_mqtt_state(CS_MQTT_FAILED);
        return -4;
    }

    MQTTClient_connectOptions conn_opts = MQTTClient_connectOptions_initializer;
    MQTTClient_SSLOptions ssl_opts = MQTTClient_SSLOptions_initializer;

    conn_opts.keepAliveInterval = 60;
    conn_opts.cleansession = 1;
    conn_opts.connectTimeout = 10;
    if (strlen(g_cs_mqtt_config.username) > 0) {
        conn_opts.username = g_cs_mqtt_config.username;
        conn_opts.password = g_cs_mqtt_config.password;
    }

    /* SSL 配置：启用 SSL 但跳过证书验证（测试阶段） */
    if (strncmp(g_cs_mqtt_config.uri, "ssl://", 6) == 0) {
        ssl_opts.verify = 0;  /* 跳过证书验证 */
        conn_opts.ssl = &ssl_opts;
        osal_printk("[WS63_CLOUD] mqtt SSL enabled (verify=0)\r\n");
    }

    mqtt_rc = MQTTClient_connect(g_cs_mqtt_client, &conn_opts);
    if (mqtt_rc != MQTTCLIENT_SUCCESS) {
        osal_printk("[WS63_CLOUD] mqtt connect fail rc=%d\r\n", mqtt_rc);
        MQTTClient_destroy(&g_cs_mqtt_client);
        g_cs_mqtt_client = NULL;
        cs_set_mqtt_state(CS_MQTT_FAILED);
        return -5;
    }

    cs_set_mqtt_state(CS_MQTT_CONNECTED);
    osal_printk("[WS63_CLOUD] mqtt connected uri=%s\r\n", g_cs_mqtt_config.uri);

    mqtt_rc = MQTTClient_subscribe(g_cs_mqtt_client,
        CS_THINGSKIT_GATEWAY_RPC_SUB, 1);
    if (mqtt_rc != MQTTCLIENT_SUCCESS) {
        osal_printk("[WS63_CLOUD] mqtt subscribe fail rc=%d\r\n", mqtt_rc);
    } else {
        osal_printk("[WS63_CLOUD] mqtt subscribed topic=%s\r\n",
            CS_THINGSKIT_GATEWAY_RPC_SUB);
    }

    mqtt_rc = MQTTClient_subscribe(g_cs_mqtt_client,
        CS_THINGSKIT_GATEWAY_RPC_SUB, 1);
    if (mqtt_rc != MQTTCLIENT_SUCCESS) {
        osal_printk("[WS63_CLOUD] gateway subscribe fail rc=%d\r\n", mqtt_rc);
    } else {
        osal_printk("[WS63_CLOUD] gateway subscribed topic=%s\r\n",
            CS_THINGSKIT_GATEWAY_RPC_SUB);
    }

    cs_cache_flush();
    return 0;
}

int cs_mqtt_disconnect(void)
{
    if (g_cs_mqtt_client == NULL) {
        return 0;
    }

    if (MQTTClient_isConnected(g_cs_mqtt_client)) {
        MQTTClient_disconnect(g_cs_mqtt_client, 1000);
    }
    MQTTClient_destroy(&g_cs_mqtt_client);
    g_cs_mqtt_client = NULL;
    cs_set_mqtt_state(CS_MQTT_IDLE);
    osal_printk("[WS63_CLOUD] mqtt disconnected\r\n");
    return 0;
}

cs_mqtt_state_t cs_mqtt_get_state(void)
{
    return g_cs_mqtt_state;
}

bool cs_mqtt_is_connected(void)
{
    return g_cs_mqtt_state == CS_MQTT_CONNECTED;
}

int cs_mqtt_publish(const char *topic, const char *payload, uint16_t len)
{
    if (topic == NULL || payload == NULL || len == 0) {
        return -1;
    }

    if (!cs_mqtt_is_connected() || g_cs_mqtt_client == NULL) {
        osal_printk("[WS63_CLOUD] mqtt not connected, caching\r\n");
        return cs_cache_push(topic, payload, len);
    }

    MQTTClient_message pubmsg = MQTTClient_message_initializer;
    pubmsg.payload = (void *)payload;
    pubmsg.payloadlen = (int)len;
    pubmsg.qos = 1;
    pubmsg.retained = 0;

    MQTTClient_deliveryToken token = 0;
    int rc = MQTTClient_publishMessage(g_cs_mqtt_client, topic, &pubmsg, &token);
    if (rc != MQTTCLIENT_SUCCESS) {
        osal_printk("[WS63_CLOUD] mqtt publish fail rc=%d, caching\r\n", rc);
        return cs_cache_push(topic, payload, len);
    }

    rc = MQTTClient_waitForCompletion(g_cs_mqtt_client, token, 5000);
    if (rc != MQTTCLIENT_SUCCESS) {
        osal_printk("[WS63_CLOUD] mqtt publish wait fail rc=%d\r\n", rc);
        return -2;
    }

    osal_printk("[WS63_CLOUD] mqtt publish ok topic=%s len=%u\r\n",
        topic, (unsigned int)len);
    return 0;
}

int cs_mqtt_publish_telemetry(const char *payload, uint16_t len)
{
    return cs_mqtt_publish(CS_THINGSKIT_GATEWAY_TELEMETRY, payload, len);
}

int cs_mqtt_publish_gateway(const char *payload, uint16_t len)
{
    return cs_mqtt_publish(CS_THINGSKIT_GATEWAY_TELEMETRY, payload, len);
}

void cs_mqtt_register_state_cb(cs_mqtt_state_cb cb)
{
    g_cs_mqtt_state_cb = cb;
}

void cs_mqtt_register_msg_cb(cs_mqtt_msg_cb cb)
{
    g_cs_mqtt_msg_cb = cb;
}

int cs_mqtt_subscribe_gateway(void)
{
    if (!cs_mqtt_is_connected() || g_cs_mqtt_client == NULL) {
        osal_printk("[WS63_CLOUD] subscribe_gateway skipped, mqtt not connected\r\n");
        return -1;
    }

    int rc = MQTTClient_subscribe(g_cs_mqtt_client,
        CS_THINGSKIT_GATEWAY_RPC_SUB, 1);
    if (rc != MQTTCLIENT_SUCCESS) {
        osal_printk("[WS63_CLOUD] subscribe_gateway fail rc=%d\r\n", rc);
        return -2;
    }

    osal_printk("[WS63_CLOUD] subscribe_gateway ok topic=%s\r\n",
        CS_THINGSKIT_GATEWAY_RPC_SUB);
    return 0;
}

int cs_cache_push(const char *topic, const char *payload, uint16_t len)
{
    if (topic == NULL || payload == NULL || len == 0) {
        return -1;
    }
    if (len > CS_MQTT_PAYLOAD_MAX) {
        osal_printk("[WS63_CLOUD] cache payload too large len=%u max=%u\r\n",
            (unsigned int)len, CS_MQTT_PAYLOAD_MAX);
        return -2;
    }
    if (g_cs_cache_count >= CS_CACHE_MAX) {
        osal_printk("[WS63_CLOUD] cache full, dropping oldest\r\n");
        uint16_t oldest = g_cs_cache_head;
        if (oldest >= CS_CACHE_MAX) {
            oldest = 0;
        }
        g_cs_cache[oldest].used = false;
        g_cs_cache_head = (oldest + 1) % CS_CACHE_MAX;
        g_cs_cache_count--;
    }

    for (uint16_t i = 0; i < CS_CACHE_MAX; i++) {
        if (!g_cs_cache[i].used) {
            errno_t rc = strncpy_s(g_cs_cache[i].topic, CS_MQTT_TOPIC_MAX,
                topic, CS_MQTT_TOPIC_MAX - 1);
            if (rc != EOK) {
                continue;
            }
            rc = memcpy_s(g_cs_cache[i].payload, CS_MQTT_PAYLOAD_MAX,
                payload, len);
            if (rc != EOK) {
                continue;
            }
            g_cs_cache[i].payload_len = len;
            g_cs_cache[i].used = true;
            g_cs_cache_count++;
            osal_printk("[WS63_CLOUD] cache push idx=%u count=%u topic=%s\r\n",
                (unsigned int)i, (unsigned int)g_cs_cache_count, topic);
            return 0;
        }
    }

    osal_printk("[WS63_CLOUD] cache no free slot\r\n");
    return -3;
}

uint16_t cs_cache_count(void)
{
    return g_cs_cache_count;
}

int cs_cache_flush(void)
{
    if (!cs_mqtt_is_connected() || g_cs_mqtt_client == NULL) {
        osal_printk("[WS63_CLOUD] cache flush skipped, mqtt not connected\r\n");
        return -1;
    }

    uint16_t flushed = 0;
    for (uint16_t i = 0; i < CS_CACHE_MAX; i++) {
        if (!g_cs_cache[i].used) {
            continue;
        }

        MQTTClient_message pubmsg = MQTTClient_message_initializer;
        pubmsg.payload = (void *)g_cs_cache[i].payload;
        pubmsg.payloadlen = (int)g_cs_cache[i].payload_len;
        pubmsg.qos = 1;
        pubmsg.retained = 0;

        MQTTClient_deliveryToken token = 0;
        int rc = MQTTClient_publishMessage(g_cs_mqtt_client,
            g_cs_cache[i].topic, &pubmsg, &token);
        if (rc == MQTTCLIENT_SUCCESS) {
            MQTTClient_waitForCompletion(g_cs_mqtt_client, token, 3000);
            g_cs_cache[i].used = false;
            g_cs_cache_count--;
            flushed++;
        } else {
            osal_printk("[WS63_CLOUD] cache flush fail idx=%u rc=%d\r\n",
                (unsigned int)i, rc);
            break;
        }
    }

    osal_printk("[WS63_CLOUD] cache flushed=%u remaining=%u\r\n",
        (unsigned int)flushed, (unsigned int)g_cs_cache_count);
    return (int)flushed;
}

int cs_mqtt_config_save_nv(const cs_mqtt_config_t *config)
{
    if (config == NULL) {
        return -1;
    }
    uint16_t data_len = (uint16_t)sizeof(cs_mqtt_config_t);
    errcode_t ret = uapi_nv_write(CS_NV_KEY_MQTT_CFG,
        (const uint8_t *)config, data_len);
    if (ret != ERRCODE_SUCC) {
        osal_printk("[WS63_CLOUD] mqtt cfg nv write fail ret=0x%x\r\n", ret);
        return (int)ret;
    }
    osal_printk("[WS63_CLOUD] mqtt cfg nv write ok\r\n");
    return 0;
}

int cs_mqtt_config_load_nv(cs_mqtt_config_t *config)
{
    if (config == NULL) {
        return -1;
    }
    uint16_t data_len = 0;
    uint16_t max_len = (uint16_t)sizeof(cs_mqtt_config_t);
    errcode_t ret = uapi_nv_read(CS_NV_KEY_MQTT_CFG,
        max_len, &data_len, (uint8_t *)config);
    if (ret != ERRCODE_SUCC) {
        osal_printk("[WS63_CLOUD] mqtt cfg nv read fail ret=0x%x\r\n", ret);
        return (int)ret;
    }
    if (data_len != max_len) {
        osal_printk("[WS63_CLOUD] mqtt cfg nv len mismatch\r\n");
        return -1;
    }
    osal_printk("[WS63_CLOUD] mqtt cfg nv read ok uri=%s\r\n", config->uri);
    return 0;
}

void cloud_storage_poll(void)
{
    if (g_cs_wifi_state == CS_WIFI_CONNECTED) {
        if (g_cs_netif == NULL) {
            cs_wifi_start_dhcp();
        }
    }

    if (g_cs_wifi_state == CS_WIFI_CONNECTED && g_cs_netif != NULL) {
        if (cs_check_dhcp_done()) {
            osal_printk("[WS63_CLOUD] dhcp got ip\r\n");
            cs_set_wifi_state(CS_WIFI_GOT_IP);
        } else if (g_cs_dhcp_start_ms != 0) {
            uint64_t now = uapi_tcxo_get_ms();
            if (now - g_cs_dhcp_start_ms >= CS_DHCP_TIMEOUT_MS) {
                osal_printk("[WS63_CLOUD] dhcp timeout %ums, disconnecting\r\n",
                    CS_DHCP_TIMEOUT_MS);
                g_cs_dhcp_start_ms = 0;
                cs_wifi_disconnect();
            }
        }
    }

    if (g_cs_mqtt_state == CS_MQTT_CONNECTED && g_cs_mqtt_client != NULL) {
        MQTTClient_yield();
    }
}

int cloud_storage_init(void)
{
    osal_printk("[WS63_CLOUD] init start\r\n");

    errcode_t ret = wifi_register_event_cb(&g_cs_wifi_event_cb);
    if (ret != ERRCODE_SUCC) {
        osal_printk("[WS63_CLOUD] register wifi event cb fail ret=0x%x\r\n", ret);
        return -1;
    }
    osal_printk("[WS63_CLOUD] wifi event cb registered\r\n");

    uint32_t wait_count = 0;
    while (wifi_is_wifi_inited() == 0) {
        osal_msleep(100);
        wait_count++;
        if (wait_count >= 50) {
            osal_printk("[WS63_CLOUD] wifi init timeout\r\n");
            return -1;
        }
    }
    osal_printk("[WS63_CLOUD] wifi inited\r\n");

    ret = wifi_sta_enable();
    if (ret != ERRCODE_SUCC) {
        osal_printk("[WS63_CLOUD] wifi_sta_enable fail ret=0x%x\r\n", ret);
        return -1;
    }
    osal_printk("[WS63_CLOUD] sta enabled\r\n");

    g_cs_wifi_inited = true;
    cs_set_wifi_state(CS_WIFI_IDLE);

    MQTTClient_init_options mqtt_init = MQTTClient_init_options_initializer;
    MQTTClient_global_init(&mqtt_init);
    g_cs_mqtt_inited = true;
    cs_set_mqtt_state(CS_MQTT_IDLE);

    osal_printk("[WS63_CLOUD] init done\r\n");
    return 0;
}
