#include "business_logic.h"
#include "business_logic_internal.h"
#include "soc_osal.h"
#include "securec.h"
#include "cJSON.h"
#include "../shared_protocol/shared_protocol.h"
#include <string.h>

void biz_cmd_wifi_connect(uint16_t seq, const char *data_json)
{
    cJSON *root = cJSON_Parse(data_json);
    if (root == NULL) {
        biz_reply(seq, "wifi_connect", -1, "json parse fail", NULL);
        return;
    }
    cJSON *j_ssid = cJSON_GetObjectItem(root, "ssid");
    cJSON *j_psk = cJSON_GetObjectItem(root, "psk");
    if (j_ssid == NULL || !cJSON_IsString(j_ssid)) {
        cJSON_Delete(root);
        biz_reply(seq, "wifi_connect", -2, "missing ssid", NULL);
        return;
    }
    const char *ssid = j_ssid->valuestring;
    const char *psk = NULL;
    if (j_psk != NULL && cJSON_IsString(j_psk)) {
        psk = j_psk->valuestring;
    }

    if (g_biz_wifi_cmd_cb != NULL) {
        int ret = g_biz_wifi_cmd_cb(ssid, psk);
        cJSON_Delete(root);
        if (ret != 0) {
            biz_reply(seq, "wifi_connect", -3, "connect fail", NULL);
            return;
        }
    } else {
        cJSON_Delete(root);
        biz_reply(seq, "wifi_connect", -4, "wifi not available", NULL);
        return;
    }
    biz_reply(seq, "wifi_connect", 0, "connecting", NULL);
}

void biz_cmd_wifi_status(uint16_t seq, const char *data_json)
{
    (void)data_json;
    if (g_biz_wifi_cmd_cb != NULL) {
        int state = g_biz_wifi_cmd_cb(NULL, NULL);
        char data_buf[32];
        snprintf(data_buf, sizeof(data_buf), "{\"wifi_state\":%d}", state);
        biz_reply(seq, "wifi_status", 0, "ok", data_buf);
    } else {
        biz_reply(seq, "wifi_status", -1, "wifi not available", NULL);
    }
}

void biz_cmd_mqtt_connect(uint16_t seq, const char *data_json)
{
    cJSON *root = cJSON_Parse(data_json);
    if (root == NULL) {
        biz_reply(seq, "mqtt_connect", -1, "json parse fail", NULL);
        return;
    }

    /* support both "uri" and "host"+"port" formats */
    cJSON *j_uri = cJSON_GetObjectItem(root, "uri");
    cJSON *j_host = cJSON_GetObjectItem(root, "host");

    if (j_uri == NULL && j_host == NULL) {
        cJSON_Delete(root);
        biz_reply(seq, "mqtt_connect", -2, "missing uri/host", NULL);
        return;
    }

    if (g_biz_mqtt_cmd_cb == NULL) {
        cJSON_Delete(root);
        biz_reply(seq, "mqtt_connect", -3, "mqtt not available", NULL);
        return;
    }

    biz_mqtt_connect_params_t params = {0};

    if (j_uri != NULL && cJSON_IsString(j_uri)) {
        errno_t rc = strncpy_s(params.uri, BIZ_MQTT_URI_MAX,
            j_uri->valuestring, BIZ_MQTT_URI_MAX - 1);
        if (rc != EOK) {
            cJSON_Delete(root);
            biz_reply(seq, "mqtt_connect", -4, "uri copy fail", NULL);
            return;
        }
    } else if (j_host != NULL && cJSON_IsString(j_host)) {
        /* ESP32 format: host+port → assemble uri */
        cJSON *j_port = cJSON_GetObjectItem(root, "port");
        int port = (j_port != NULL && cJSON_IsNumber(j_port)) ?
            j_port->valueint : 1883;
        /* validate host length: "tcp://"(6) + host + ":"(1) + port(5) + \0 */
        uint32_t host_len = (uint32_t)strlen(j_host->valuestring);
        if (host_len == 0 || host_len > (BIZ_MQTT_URI_MAX - 13) ||
            port < 1 || port > 65535) {
            cJSON_Delete(root);
            biz_reply(seq, "mqtt_connect", -4, "invalid host/port", NULL);
            return;
        }
        snprintf(params.uri, BIZ_MQTT_URI_MAX, "tcp://%s:%d",
            j_host->valuestring, port);
    }
    cJSON *j_cid = cJSON_GetObjectItem(root, "client_id");
    if (j_cid != NULL && cJSON_IsString(j_cid)) {
        errno_t rc2 = strncpy_s(params.client_id, BIZ_MQTT_CID_MAX,
            j_cid->valuestring, BIZ_MQTT_CID_MAX - 1);
        if (rc2 != EOK) {
            osal_printk("[WS63_BIZ] mqtt_connect client_id copy fail rc=%d\r\n", (int)rc2);
        }
    }
    cJSON *j_user = cJSON_GetObjectItem(root, "username");
    if (j_user != NULL && cJSON_IsString(j_user)) {
        errno_t rc3 = strncpy_s(params.username, BIZ_MQTT_USER_MAX,
            j_user->valuestring, BIZ_MQTT_USER_MAX - 1);
        if (rc3 != EOK) {
            osal_printk("[WS63_BIZ] mqtt_connect username copy fail rc=%d\r\n", (int)rc3);
        }
    }
    cJSON *j_pass = cJSON_GetObjectItem(root, "password");
    if (j_pass != NULL && cJSON_IsString(j_pass)) {
        errno_t rc4 = strncpy_s(params.password, BIZ_MQTT_PASS_MAX,
            j_pass->valuestring, BIZ_MQTT_PASS_MAX - 1);
        if (rc4 != EOK) {
            osal_printk("[WS63_BIZ] mqtt_connect password copy fail rc=%d\r\n", (int)rc4);
        }
    }
    cJSON_Delete(root);

    int ret = g_biz_mqtt_cmd_cb(BIZ_MQTT_CMD_CONNECT, &params);
    if (ret != 0) {
        char err_buf[32];
        snprintf(err_buf, sizeof(err_buf), "connect fail ret=%d", ret);
        biz_reply(seq, "mqtt_connect", -5, err_buf, NULL);
        return;
    }
    biz_reply(seq, "mqtt_connect", 0, "ok", NULL);
}

void biz_cmd_mqtt_disconnect(uint16_t seq, const char *data_json)
{
    (void)data_json;
    if (g_biz_mqtt_cmd_cb != NULL) {
        g_biz_mqtt_cmd_cb(BIZ_MQTT_CMD_DISCONNECT, NULL);
    }
    biz_reply(seq, "mqtt_disconnect", 0, "ok", NULL);
}

void biz_cmd_mqtt_status(uint16_t seq, const char *data_json)
{
    (void)data_json;
    if (g_biz_mqtt_cmd_cb != NULL) {
        int state = g_biz_mqtt_cmd_cb(BIZ_MQTT_CMD_STATUS, NULL);
        char data_buf[48];
        snprintf(data_buf, sizeof(data_buf),
            "{\"mqtt_state\":%d}", state);
        biz_reply(seq, "mqtt_status", 0, "ok", data_buf);
    } else {
        biz_reply(seq, "mqtt_status", -1, "mqtt not available", NULL);
    }
}

void biz_cmd_mqtt_publish(uint16_t seq, const char *data_json)
{
    cJSON *root = cJSON_Parse(data_json);
    if (root == NULL) {
        biz_reply(seq, "mqtt_publish", -1, "json parse fail", NULL);
        return;
    }
    cJSON *j_payload = cJSON_GetObjectItem(root, "payload");
    if (j_payload == NULL) {
        cJSON_Delete(root);
        biz_reply(seq, "mqtt_publish", -2, "missing payload", NULL);
        return;
    }
    char *payload_str = cJSON_PrintUnformatted(j_payload);
    cJSON_Delete(root);
    if (payload_str == NULL) {
        biz_reply(seq, "mqtt_publish", -3, "payload format fail", NULL);
        return;
    }

    biz_cloud_publish(payload_str, (uint16_t)strlen(payload_str));
    cJSON_free(payload_str);
    biz_reply(seq, "mqtt_publish", 0, "ok", NULL);
}
