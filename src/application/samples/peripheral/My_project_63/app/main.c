#include "common_def.h"
#include "soc_osal.h"
#include "app_init.h"
#include "tcxo.h"
#include "securec.h"
#include "../components/shared_protocol/shared_protocol.h"
#include "../components/sle_network/sle_network.h"
#include "../components/uart_vision/uart_vision.h"
#include "../components/cloud_storage/cloud_storage.h"
#include "../components/business_logic/business_logic.h"

#define MY63_TASK_STACK_SIZE 0x2000
#define MY63_TASK_PRIORITY   26
#define MY63_POLL_INTERVAL_MS  10
#define MY63_HEARTBEAT_MS    30000
#define MY63_SLE_RESCAN_MS   5000

static uint64_t g_my63_last_heartbeat = 0;
static uint64_t g_my63_last_rescan = 0;
static cs_mqtt_config_t g_my63_mqtt_cfg = {0};
static bool g_my63_mqtt_cfg_loaded = false;
static cs_wifi_config_t g_my63_wifi_cfg = {0};
static bool g_my63_wifi_cfg_loaded = false;

static void my63_wifi_state_cb(cs_wifi_state_t state)
{
    osal_printk("[WS63_APP] wifi state cb=%d\r\n", (int)state);
    if (state == CS_WIFI_GOT_IP && g_my63_mqtt_cfg_loaded) {
        osal_printk("[WS63_APP] wifi got ip, auto reconnect mqtt\r\n");
        cs_mqtt_connect(&g_my63_mqtt_cfg);
    }
}

static void my63_mqtt_state_cb(cs_mqtt_state_t state)
{
    osal_printk("[WS63_APP] mqtt state cb=%d\r\n", (int)state);
}

static void my63_mqtt_msg_cb(const char *topic, const char *payload, uint16_t len)
{
    unused(payload);
    osal_printk("[WS63_APP] mqtt msg topic=%s len=%u\r\n",
        topic ? topic : "null", (unsigned int)len);
}

static void my63_cloud_publish_cb(const char *payload, uint16_t len)
{
    if (payload == NULL || len == 0) {
        return;
    }
    int ret = cs_mqtt_publish_telemetry(payload, len);
    if (ret != 0) {
        osal_printk("[WS63_APP] cloud publish fail ret=%d\r\n", ret);
    }
}

static int my63_wifi_cmd_cb(const char *ssid, const char *psk)
{
    if (ssid == NULL && psk == NULL) {
        return (int)cs_wifi_get_state();
    }
    if (ssid == NULL) {
        return -1;
    }

    cs_wifi_config_t cfg = {0};
    errno_t rc = strncpy_s(cfg.ssid, CS_SSID_MAX_LEN, ssid, CS_SSID_MAX_LEN - 1);
    if (rc != EOK) {
        return -1;
    }
    if (psk != NULL) {
        rc = strncpy_s(cfg.psk, CS_PSK_MAX_LEN, psk, CS_PSK_MAX_LEN - 1);
        if (rc != EOK) {
            return -1;
        }
    }

    int ret = cs_wifi_connect(ssid, psk);
    if (ret == 0) {
        cs_wifi_config_save_nv(&cfg);
        g_my63_wifi_cfg = cfg;
        g_my63_wifi_cfg_loaded = true;
    }
    return ret;
}

static int my63_mqtt_cmd_cb(biz_mqtt_cmd_t cmd, const biz_mqtt_connect_params_t *params)
{
    if (cmd == BIZ_MQTT_CMD_STATUS) {
        return (int)cs_mqtt_get_state();
    }
    if (cmd == BIZ_MQTT_CMD_DISCONNECT) {
        return cs_mqtt_disconnect();
    }
    if (cmd == BIZ_MQTT_CMD_CONNECT) {
        if (params == NULL) {
            return -1;
        }
        cs_mqtt_config_t cfg = {0};
        errno_t rc = strncpy_s(cfg.uri, CS_MQTT_URI_MAX,
            params->uri, CS_MQTT_URI_MAX - 1);
        if (rc != EOK) {
            return -1;
        }
        rc = strncpy_s(cfg.client_id, CS_MQTT_CLIENTID_MAX,
            params->client_id, CS_MQTT_CLIENTID_MAX - 1);
        if (rc != EOK) {
            return -1;
        }
        rc = strncpy_s(cfg.username, CS_MQTT_USER_MAX,
            params->username, CS_MQTT_USER_MAX - 1);
        if (rc != EOK) {
            return -1;
        }
        rc = strncpy_s(cfg.password, CS_MQTT_PASS_MAX,
            params->password, CS_MQTT_PASS_MAX - 1);
        if (rc != EOK) {
            return -1;
        }

        int ret = cs_mqtt_connect(&cfg);
        if (ret == 0) {
            cs_mqtt_config_save_nv(&cfg);
            g_my63_mqtt_cfg = cfg;
            g_my63_mqtt_cfg_loaded = true;
        }
        return ret;
    }
    return -1;
}

static int my63_init_modules(void)
{
    int ret;

    ret = shared_protocol_init();
    if (ret != 0) {
        osal_printk("[WS63_APP] shared_protocol init fail ret=%d\r\n", ret);
        return ret;
    }

    ret = sle_network_init();
    if (ret != 0) {
        osal_printk("[WS63_APP] sle_network init fail ret=%d\r\n", ret);
        return ret;
    }

    ret = uart_vision_init();
    if (ret != 0) {
        osal_printk("[WS63_APP] uart_vision init fail ret=%d\r\n", ret);
        return ret;
    }

    ret = cloud_storage_init();
    if (ret != 0) {
        osal_printk("[WS63_APP] cloud_storage init fail ret=%d\r\n", ret);
        return ret;
    }

    ret = business_logic_init();
    if (ret != 0) {
        osal_printk("[WS63_APP] business_logic init fail ret=%d\r\n", ret);
        return ret;
    }

    cs_wifi_register_state_cb(my63_wifi_state_cb);
    cs_mqtt_register_state_cb(my63_mqtt_state_cb);
    cs_mqtt_register_msg_cb(my63_mqtt_msg_cb);

    business_logic_register_cloud_cb(my63_cloud_publish_cb);
    business_logic_register_wifi_cmd_cb(my63_wifi_cmd_cb);
    business_logic_register_mqtt_cmd_cb(my63_mqtt_cmd_cb);

    if (cs_wifi_config_load_nv(&g_my63_wifi_cfg) == 0) {
        g_my63_wifi_cfg_loaded = true;
        osal_printk("[WS63_APP] wifi cfg loaded from nv ssid=%s\r\n", g_my63_wifi_cfg.ssid);
        cs_wifi_connect(g_my63_wifi_cfg.ssid, g_my63_wifi_cfg.psk);
    }

    if (cs_mqtt_config_load_nv(&g_my63_mqtt_cfg) == 0) {
        g_my63_mqtt_cfg_loaded = true;
        osal_printk("[WS63_APP] mqtt cfg loaded from nv uri=%s\r\n", g_my63_mqtt_cfg.uri);
    }

    return 0;
}

static void my63_poll_uart(void)
{
    uart_vision_poll();
}

static void my63_poll_business(void)
{
    business_logic_poll();
}

static void my63_poll_cloud(void)
{
    cloud_storage_poll();
}

static void my63_poll_sle(uint64_t now)
{
    if (sle_network_is_target_found() == 0) {
        if (sle_network_get_scan_count() == 0 &&
            sle_network_get_scan_active() == 0) {
            if (now - g_my63_last_rescan >= MY63_SLE_RESCAN_MS) {
                g_my63_last_rescan = now;
                (void)sle_network_start_scan();
            }
        }
    }
}

static void my63_heartbeat(uint64_t now)
{
    if (now - g_my63_last_heartbeat < MY63_HEARTBEAT_MS) {
        return;
    }
    g_my63_last_heartbeat = now;

    osal_printk("[WS63_APP] hb sle=%d/%d/%d wifi=%d mqtt=%d cache=%u\r\n",
        sle_network_is_target_found(),
        sle_network_is_connected(),
        sle_network_is_ssap_ready(),
        (int)cs_wifi_get_state(),
        (int)cs_mqtt_get_state(),
        (unsigned int)cs_cache_count());
}

static void *my63_main_task(const char *arg)
{
    unused(arg);

    osal_printk("[WS63_APP] main task start\r\n");

    int ret = my63_init_modules();
    if (ret != 0) {
        osal_printk("[WS63_APP] init fail ret=%d\r\n", ret);
        return NULL;
    }
    osal_printk("[WS63_APP] all modules init done\r\n");

    g_my63_last_heartbeat = uapi_tcxo_get_ms();
    g_my63_last_rescan = g_my63_last_heartbeat;

    for (;;) {
        uint64_t now = uapi_tcxo_get_ms();

        my63_poll_uart();
        my63_poll_business();
        my63_poll_cloud();
        my63_poll_sle(now);
        my63_heartbeat(now);

        osal_msleep(MY63_POLL_INTERVAL_MS);
    }

    return NULL;
}

static void my63_entry(void)
{
    osal_task *task_handle = NULL;

    osal_printk("[WS63_APP] entry start\r\n");
    osal_kthread_lock();
    task_handle = osal_kthread_create((osal_kthread_handler)my63_main_task, 0,
        "My63Task", MY63_TASK_STACK_SIZE);
    if (task_handle != NULL) {
        osal_kthread_set_priority(task_handle, MY63_TASK_PRIORITY);
        osal_printk("[WS63_APP] task create success\r\n");
    } else {
        osal_printk("[WS63_APP] task create failed\r\n");
    }
    osal_kthread_unlock();
}

app_run(my63_entry);
