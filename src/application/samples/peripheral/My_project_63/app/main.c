#include "common_def.h"
#include "soc_osal.h"
#include "app_init.h"
#include "tcxo.h"
#include "securec.h"
#include "cmsis_os2.h"
#include "los_task.h"
#include "../components/shared_protocol/shared_protocol.h"
#include "../components/sle_network/sle_network.h"
#include "../components/uart_vision/uart_vision.h"
#include "../components/uart_display/uart_display.h"
#include "../components/cloud_storage/cloud_storage.h"
#include "../components/business_logic/business_logic.h"

#define MY63_TASK_STACK_SIZE 0x2000
#define MY63_TASK_PRIORITY   26
#define MY63_HEARTBEAT_MS    30000
#define MY63_SLE_RESCAN_MS   5000
#define MY63_EVENT_WAIT_MS   100     /* 无事件时最长睡眠 100ms */

/* 事件标志句柄（全局，供各模块 osEventFlagsSet 使用） */
osEventFlagsId_t g_my63_events = NULL;

static uint64_t g_my63_last_heartbeat = 0;
static uint64_t g_my63_last_rescan = 0;

/* CPU 监控计数器 */
static volatile uint32_t g_idle_count = 0;
static volatile uint32_t g_total_count = 0;
static cs_mqtt_config_t g_my63_mqtt_cfg = {0};
static bool g_my63_mqtt_cfg_loaded = false;
static cs_wifi_config_t g_my63_wifi_cfg = {0};
static bool g_my63_wifi_cfg_loaded = false;

static void my63_wifi_state_cb(cs_wifi_state_t state)
{
    osal_printk("[WS63_APP] wifi state cb=%d\r\n", (int)state);
    if (state == CS_WIFI_GOT_IP) {
        uart_display_send("NET", "wifi,connected,");
        if (g_my63_mqtt_cfg_loaded) {
            osal_printk("[WS63_APP] wifi got ip, auto reconnect mqtt uri=%s\r\n",
                g_my63_mqtt_cfg.uri);
            cs_mqtt_connect(&g_my63_mqtt_cfg);
        } else {
            osal_printk("[WS63_APP] wifi got ip but mqtt cfg not loaded, skip auto-connect\r\n");
        }
    } else if (state == CS_WIFI_DISCONNECTED) {
        uart_display_send("NET", "wifi,disconnected,");
    } else if (state == CS_WIFI_CONNECTING) {
        uart_display_send("NET", "wifi,connecting,");
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
    int ret = cs_mqtt_publish_gateway(payload, len);
    if (ret != 0) {
        osal_printk("[WS63_APP] cloud publish fail ret=%d\r\n", ret);
    }
}

static int my63_wifi_cmd_cb(const char *ssid, const char *psk)
{
    if (ssid == NULL && psk == NULL) {
        /* 断开 WiFi */
        return cs_wifi_disconnect();
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

/* CPU 监控：idle hook，注册到 LiteOS idle task（暂时禁用，排查 NMI） */
#if 0
static void my63_idle_hook(void)
{
    g_idle_count++;
    g_total_count++;
}
#endif

/* CPU 监控：计算并打印 CPU 占用率（暂时禁用，排查 NMI） */
#if 0
static void my63_cpu_report(void)
{
    uint32_t idle = g_idle_count;
    uint32_t total = g_total_count;
    g_idle_count = 0;
    g_total_count = 0;

    if (total == 0) {
        return;
    }
    uint32_t cpu_pct = (total > idle) ? ((total - idle) * 100 / total) : 0;
    osal_printk("[WS63_APP] cpu=%u%% (idle=%u/%u)\r\n",
        (unsigned int)cpu_pct, (unsigned int)idle, (unsigned int)total);
}
#endif

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

    ret = uart_display_init();
    if (ret != 0) {
        osal_printk("[WS63_APP] uart_display init fail ret=%d\r\n", ret);
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

    /* 注册 CPU 监控 idle hook（暂时禁用，排查 NMI） */
    /* LOS_IdleHandlerHookReg(my63_idle_hook); */

    business_logic_register_cloud_cb(my63_cloud_publish_cb);
    business_logic_register_wifi_cmd_cb(my63_wifi_cmd_cb);
    business_logic_register_mqtt_cmd_cb(my63_mqtt_cmd_cb);

    if (cs_wifi_config_load_nv(&g_my63_wifi_cfg) == 0) {
        g_my63_wifi_cfg_loaded = true;
        osal_printk("[WS63_APP] wifi cfg loaded from nv ssid=%s\r\n", g_my63_wifi_cfg.ssid);
        cs_wifi_connect(g_my63_wifi_cfg.ssid, g_my63_wifi_cfg.psk);
    } else {
        osal_printk("[WS63_APP] wifi cfg NOT in nv, waiting for screen cmd\r\n");
    }

    if (cs_mqtt_config_load_nv(&g_my63_mqtt_cfg) == 0) {
        g_my63_mqtt_cfg_loaded = true;
        osal_printk("[WS63_APP] mqtt cfg loaded from nv uri=%s client=%s user=%s\r\n",
            g_my63_mqtt_cfg.uri,
            g_my63_mqtt_cfg.client_id,
            g_my63_mqtt_cfg.username);
    } else {
        /* NV 中无 MQTT 配置，使用硬编码默认值并写入 NV */
        (void)memset_s(&g_my63_mqtt_cfg, sizeof(cs_mqtt_config_t), 0, sizeof(cs_mqtt_config_t));
        strncpy_s(g_my63_mqtt_cfg.uri, CS_MQTT_URI_MAX,
            CS_MQTT_DEFAULT_URI, CS_MQTT_URI_MAX - 1);
        strncpy_s(g_my63_mqtt_cfg.client_id, CS_MQTT_CLIENTID_MAX,
            CS_MQTT_DEFAULT_CLIENT_ID, CS_MQTT_CLIENTID_MAX - 1);
        strncpy_s(g_my63_mqtt_cfg.username, CS_MQTT_USER_MAX,
            CS_MQTT_DEFAULT_USERNAME, CS_MQTT_USER_MAX - 1);
        strncpy_s(g_my63_mqtt_cfg.password, CS_MQTT_PASS_MAX,
            CS_MQTT_DEFAULT_PASSWORD, CS_MQTT_PASS_MAX - 1);
        (void)cs_mqtt_config_save_nv(&g_my63_mqtt_cfg);
        g_my63_mqtt_cfg_loaded = true;
        osal_printk("[WS63_APP] mqtt cfg using defaults uri=%s client=%s (saved to nv)\r\n",
            g_my63_mqtt_cfg.uri, g_my63_mqtt_cfg.client_id);
    }

    return 0;
}

static void my63_poll_sle(uint64_t now)
{
    sle_network_poll();

    /* 扫描未激活时定期重启 */
    if (sle_network_is_connected() == 0 &&
        sle_network_get_scan_active() == 0) {
        if (now - g_my63_last_rescan >= MY63_SLE_RESCAN_MS) {
            g_my63_last_rescan = now;
            (void)sle_network_start_scan();
        }
    }
}

static void my63_heartbeat(uint64_t now)
{
    if (now - g_my63_last_heartbeat < MY63_HEARTBEAT_MS) {
        return;
    }
    g_my63_last_heartbeat = now;

    /* my63_cpu_report(); 暂时禁用，排查 NMI */

    osal_printk("[WS63_APP] hb sle=%d/%d/%d scan_tbl=%u scan_cnt=%u wifi=%d mqtt=%d cache=%u uart_ring=%u\r\n",
        sle_network_is_target_found(),
        sle_network_is_connected(),
        sle_network_is_ssap_ready(),
        (unsigned int)sle_network_get_scan_table_count(),
        (unsigned int)sle_network_get_scan_count(),
        (int)cs_wifi_get_state(),
        (int)cs_mqtt_get_state(),
        (unsigned int)cs_cache_count(),
        (unsigned int)uart_vision_ring_usage());
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

    /* 创建事件标志 */
    g_my63_events = osEventFlagsNew(NULL);
    if (g_my63_events == NULL) {
        osal_printk("[WS63_APP] FATAL: event flags create failed\r\n");
        return NULL;
    }
    osal_printk("[WS63_APP] event flags created\r\n");

    /* 事件驱动主循环 */
    for (;;) {
        uint32_t flags = osEventFlagsWait(g_my63_events, EVENT_ALL,
            osFlagsWaitAny, MY63_EVENT_WAIT_MS);
        uint64_t now = uapi_tcxo_get_ms();

        /* UART1 RX（ESP32 JSON） */
        if (flags & EVENT_UART1_RX) {
            uart_vision_poll();
        }

        /* UART2 RX（串口屏 CSV） */
        if (flags & EVENT_UART2_RX) {
            uart_display_poll();
        }

        /* SLE 广播队列有数据 */
        if (flags & EVENT_SLE_ADV) {
            sle_adv_dequeue();
            biz_handle_sle_adv();
        }

        /* 检查 in_confirm_connecting 状态，SSAP 就绪后发 BIND_TAG */
        biz_check_confirm_bind();

        /* 定时器事件（心跳/超时/扫描重启） */
        if (flags & EVENT_TIMER) {
            business_logic_poll();
        }

        /* 防御性回退：即使事件标志丢失也能处理环形缓冲区的数据 */
        uart_vision_poll();
        uart_display_poll();

        /* 轮询类任务（无论什么事件都检查） */
        cloud_storage_poll();
        my63_poll_sle(now);
        business_logic_poll();
        my63_heartbeat(now);

        /* 如果 flags 为超时（无特定事件），继续循环 */
        if ((int32_t)flags < 0) {
            continue;
        }
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
