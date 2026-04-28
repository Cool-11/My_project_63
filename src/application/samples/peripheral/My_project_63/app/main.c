/**
 * Copyright (c) HiSilicon (Shanghai) Technologies Co., Ltd. 2023-2023. All rights reserved.
 */

#include "common_def.h"
#include "soc_osal.h"
#include "app_init.h"
#include "../components/shared_protocol/shared_protocol.h"
#include "../components/sle_network/sle_network.h"
#include "../components/uart_vision/uart_vision.h"
#include "../components/cloud_storage/cloud_storage.h"
#include "../components/business_logic/business_logic.h"

#define MY63_TASK_STACK_SIZE 0x1000
#define MY63_TASK_PRIORITY   26
#define MY63_HEARTBEAT_MS    2000

static void my63_init_phase_log(void)
{
    osal_printk("[WS63_APP] init phase: shared_protocol\r\n");
    osal_printk("[WS63_APP] init phase: sle_network\r\n");
    osal_printk("[WS63_APP] init phase: uart_vision\r\n");
    osal_printk("[WS63_APP] init phase: cloud_storage\r\n");
    osal_printk("[WS63_APP] init phase: business_logic\r\n");
}

static int my63_init_modules(void)
{
    int ret;

    my63_init_phase_log();

    osal_printk("[WS63_APP] call shared_protocol_init\r\n");
    ret = shared_protocol_init();
    osal_printk("[WS63_APP] shared_protocol_init ret=%d\r\n", ret);
    if (ret != 0) {
        osal_printk("[WS63_APP] shared_protocol init failed\r\n");
        return ret;
    }

    osal_printk("[WS63_APP] call sle_network_init\r\n");
    ret = sle_network_init();
    osal_printk("[WS63_APP] sle_network_init ret=%d\r\n", ret);
    if (ret != 0) {
        osal_printk("[WS63_APP] sle_network init failed\r\n");
        return ret;
    }

    osal_printk("[WS63_APP] call uart_vision_init\r\n");
    ret = uart_vision_init();
    osal_printk("[WS63_APP] uart_vision_init ret=%d\r\n", ret);
    if (ret != 0) {
        osal_printk("[WS63_APP] uart_vision init failed\r\n");
        return ret;
    }

    osal_printk("[WS63_APP] call cloud_storage_init\r\n");
    ret = cloud_storage_init();
    osal_printk("[WS63_APP] cloud_storage_init ret=%d\r\n", ret);
    if (ret != 0) {
        osal_printk("[WS63_APP] cloud_storage init failed\r\n");
        return ret;
    }

    osal_printk("[WS63_APP] call business_logic_init\r\n");
    ret = business_logic_init();
    osal_printk("[WS63_APP] business_logic_init ret=%d\r\n", ret);
    if (ret != 0) {
        osal_printk("[WS63_APP] business_logic init failed\r\n");
        return ret;
    }

    return 0;
}

static void *my63_main_task(const char *arg)
{
    int ret;

    unused(arg);

    osal_printk("[WS63_APP] My_project_63 main task start\r\n");
    ret = my63_init_modules();
    if (ret != 0) {
        osal_printk("[WS63_APP] module init failed, task exit ret=%d\r\n", ret);
        return NULL;
    }
    osal_printk("[WS63_APP] all modules init done\r\n");

    for (;;) {
        if (sle_network_is_target_found() != 0) {
            const sle_addr_t *addr = sle_network_get_target_addr();
            osal_printk("[WS63_APP] heartbeat target=%d connected=%d link_lost=%d authenticated=%d ssap_ready=%d scan_cnt=%u scan_on=%d\r\n",
                sle_network_is_target_found(), sle_network_is_connected(),
                sle_network_is_link_lost(), sle_network_is_authenticated(), sle_network_is_ssap_ready(),
                sle_network_get_scan_count(), sle_network_get_scan_active());
            if (addr != NULL) {
                osal_printk("[WS63_APP] target addr=%02x:%02x:%02x:%02x:%02x:%02x\r\n",
                    addr->addr[0], addr->addr[1], addr->addr[2],
                    addr->addr[3], addr->addr[4], addr->addr[5]);
            }
        } else {
            osal_printk("[WS63_APP] heartbeat target=%d connected=%d link_lost=%d authenticated=%d ssap_ready=%d scan_cnt=%u scan_on=%d\r\n",
                sle_network_is_target_found(), sle_network_is_connected(),
                sle_network_is_link_lost(), sle_network_is_authenticated(), sle_network_is_ssap_ready(),
                sle_network_get_scan_count(), sle_network_get_scan_active());

            if (sle_network_get_scan_count() == 0 && sle_network_get_scan_active() == 0) {
                osal_printk("[WS63_APP] scan not active and no results, restarting scan\r\n");
                (void)sle_network_start_scan();
            }
        }
        osal_msleep(MY63_HEARTBEAT_MS);
    }

    return NULL;
}

static void my63_entry(void)
{
    osal_task *task_handle = NULL;

    osal_printk("[WS63_APP] my63_entry start\r\n");
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
