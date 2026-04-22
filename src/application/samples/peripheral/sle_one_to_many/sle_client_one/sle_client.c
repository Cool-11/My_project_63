/**
 * Copyright (c) HiSilicon (Shanghai) Technologies Co., Ltd. 2024-2025. All rights reserved.
 *
 * Description: SLE uart sample of client. \n
 *
 * History: \n
 * 2025-07-16, Create file. \n
 */
#include "common_def.h"
#include "securec.h"
#include "soc_osal.h"
#include "sle_errcode.h"
#include "sle_connection_manager.h"
#include "sle_device_discovery.h"
#include "../../../../../include/middleware/services/bts/sle/sle_ssap_client.h"
#include "sle_client.h"
#include "app_init.h"
#include "pinctrl.h"
#include "uart.h"
#include "sle_low_latency.h"
#include <stdlib.h>
#include <string.h>
#define SLE_UART_TASK_STACK_SIZE            0x600
#define SLE_MTU_SIZE_DEFAULT            520
#define SLE_SEEK_INTERVAL_DEFAULT       100
#define SLE_SEEK_WINDOW_DEFAULT         100
#define UUID_16BIT_LEN                  2
#define UUID_128BIT_LEN                 16
#define SLE_UART_TASK_DELAY_MS          1000
#define SLE_UART_WAIT_SLE_CORE_READY_MS 5000
#define SLE_UART_RECV_CNT               1000
#define SLE_UART_LOW_LATENCY_2K         2000
#ifndef SLE_UART_SERVER_NAME
#define SLE_UART_SERVER_NAME            "sle_uart_server"
#endif
#define SLE_UART_CLIENT_LOG             "[sle uart client]"
#define SLE_UART_CLIENT_MAX_CON         8
#define SLE_UART_PENDING_MAX             16
static ssapc_find_service_result_t g_sle_uart_find_service_result = { 0 };
static sle_announce_seek_callbacks_t g_sle_uart_seek_cbk = { 0 };
static sle_connection_callbacks_t g_sle_uart_connect_cbk = { 0 };
static ssapc_callbacks_t g_sle_uart_ssapc_cbk = { 0 };
static sle_addr_t g_sle_uart_remote_addr = { 0 };
static sle_addr_t g_pending_addrs[SLE_UART_PENDING_MAX] = { 0 };
static sle_addr_t g_connected_addrs[SLE_UART_CLIENT_MAX_CON] = { 0 };
ssapc_write_param_t g_sle_uart_send_param = { 0 };
static uint8_t g_sle_uart_tx_buff[512] = { 0 };
uint16_t g_sle_uart_conn_id[SLE_UART_CLIENT_MAX_CON] = { 0 };
uint16_t g_sle_uart_conn_num = 0;
static uint8_t g_pending_count = 0;
static bool g_connecting = false;

void sle_uart_start_scan(void);
void sle_uart_client_init(ssapc_notification_callback notification_cb, ssapc_indication_callback indication_cb);
void sle_uart_notification_cb(uint8_t client_id, uint16_t conn_id, ssapc_handle_value_t *data,
    errcode_t status);
void sle_uart_indication_cb(uint8_t client_id, uint16_t conn_id, ssapc_handle_value_t *data,
    errcode_t status);

#define SLE_UART_TASK_PRIO                  28
#define SLE_UART_TASK_DURATION_MS           2000
#define SLE_UART_BAUDRATE                   115200
#define SLE_UART_TRANSFER_SIZE              512

#define CONFIG_SLE_UART_BUS 0
#define CONFIG_UART_TXD_PIN 17
#define CONFIG_UART_RXD_PIN 18

#define MAC_ADDR_LENGTH 6
#define MAC_ADDR_FIRST_OCTET 0   // 第一个字节（通常用于厂商识别）
#define MAC_ADDR_4TH_OCTET  4    // 倒数第二字节
#define MAC_ADDR_LAST_OCTET 5    // 最后一个字节

#define CHECK 3    

static uint8_t g_app_uart_rx_buff[SLE_UART_TRANSFER_SIZE] = { 0 };

static uart_buffer_config_t g_app_uart_buffer_config = {
    .rx_buffer = g_app_uart_rx_buff,
    .rx_buffer_size = SLE_UART_TRANSFER_SIZE
};

static void uart_init_pin(void)
{
    if (CONFIG_SLE_UART_BUS == 0) {
        uapi_pin_set_mode(CONFIG_UART_TXD_PIN, PIN_MODE_1);
        uapi_pin_set_mode(CONFIG_UART_RXD_PIN, PIN_MODE_1);       
    }else if (CONFIG_SLE_UART_BUS == 1) {
        uapi_pin_set_mode(CONFIG_UART_TXD_PIN, PIN_MODE_1);
        uapi_pin_set_mode(CONFIG_UART_RXD_PIN, PIN_MODE_1);       
    }
}

static void uart_init_config(void)
{
    uart_attr_t attr = {
        .baud_rate = SLE_UART_BAUDRATE,
        .data_bits = UART_DATA_BIT_8,
        .stop_bits = UART_STOP_BIT_1,
        .parity = UART_PARITY_NONE
    };

    uart_pin_config_t pin_config = {
        .tx_pin = CONFIG_UART_TXD_PIN,
        .rx_pin = CONFIG_UART_RXD_PIN,
        .cts_pin = PIN_NONE,
        .rts_pin = PIN_NONE
    };
    uapi_uart_deinit(CONFIG_SLE_UART_BUS);
    uapi_uart_init(CONFIG_SLE_UART_BUS, &pin_config, &attr, NULL, &g_app_uart_buffer_config);

}

ssapc_write_param_t *get_g_sle_uart_send_param(void)
{
    return &g_sle_uart_send_param;
}

static bool sle_addr_equal(const sle_addr_t *lhs, const sle_addr_t *rhs)
{
    return (lhs->type == rhs->type) && (memcmp(lhs->addr, rhs->addr, SLE_ADDR_LEN) == 0);
}

static bool sle_addr_in_list(const sle_addr_t *addr, const sle_addr_t *list, uint8_t count)
{
    for (uint8_t i = 0; i < count; i++) {
        if (sle_addr_equal(addr, &list[i])) {
            return true;
        }
    }
    return false;
}

static bool sle_pending_push(const sle_addr_t *addr)
{
    if (g_pending_count >= SLE_UART_PENDING_MAX) {
        return false;
    }
    if (sle_addr_in_list(addr, g_pending_addrs, g_pending_count)) {
        return false;
    }
    g_pending_addrs[g_pending_count++] = *addr;
    return true;
}

static bool sle_pending_pop(sle_addr_t *addr)
{
    if (g_pending_count == 0) {
        return false;
    }
    *addr = g_pending_addrs[0];
    for (uint8_t i = 1; i < g_pending_count; i++) {
        g_pending_addrs[i - 1] = g_pending_addrs[i];
    }
    g_pending_count--;
    return true;
}

static bool sle_connected_find_index(uint16_t conn_id, uint8_t *index)
{
    for (uint8_t i = 0; i < g_sle_uart_conn_num; i++) {
        if (g_sle_uart_conn_id[i] == conn_id) {
            if (index != NULL) {
                *index = i;
            }
            return true;
        }
    }
    return false;
}

static bool sle_connected_get_primary(uint16_t *conn_id)
{
    if (conn_id == NULL || g_sle_uart_conn_num == 0) {
        return false;
    }

    *conn_id = g_sle_uart_conn_id[0];
    return true;
}

static bool sle_connected_remove(uint16_t conn_id)
{
    uint8_t index = 0;

    if (!sle_connected_find_index(conn_id, &index)) {
        return false;
    }

    for (uint8_t i = index + 1; i < g_sle_uart_conn_num; i++) {
        g_sle_uart_conn_id[i - 1] = g_sle_uart_conn_id[i];
        g_connected_addrs[i - 1] = g_connected_addrs[i];
    }

    if (g_sle_uart_conn_num > 0) {
        g_sle_uart_conn_num--;
        g_sle_uart_conn_id[g_sle_uart_conn_num] = 0;
        (void)memset_s(&g_connected_addrs[g_sle_uart_conn_num], sizeof(sle_addr_t), 0, sizeof(sle_addr_t));
    }

    return true;
}

static bool sle_parse_adv_payload(const uint8_t *data, uint8_t length, char *name_buf, uint8_t name_buf_len,
    bool *name_hit, bool *magic_hit)
{
    bool matched = false;

    if (name_hit != NULL) {
        *name_hit = false;
    }
    if (magic_hit != NULL) {
        *magic_hit = false;
    }

    if (data == NULL || length < 2 || name_buf == NULL || name_buf_len == 0) {
        return false;
    }

    for (uint8_t offset = 0; (uint8_t)(offset + 1U) < length;) {
        uint8_t field_len = data[offset];
        uint8_t field_type;
        uint8_t field_data_len;

        if (field_len == 0 || (uint8_t)(offset + field_len) >= length + 1U) {
            break;
        }

        field_type = data[offset + 1];
        field_data_len = field_len - 1U;

        if ((field_type == 0x08 || field_type == 0x09) && field_data_len > 0) {
            uint8_t copy_len = (field_data_len < (name_buf_len - 1U)) ? field_data_len : (name_buf_len - 1U);
            if (memcpy_s(name_buf, name_buf_len, &data[offset + 2], copy_len) == EOK) {
                name_buf[copy_len] = '\0';
                if (strstr(name_buf, SLE_UART_SERVER_NAME) != NULL) {
                    matched = true;
                    if (name_hit != NULL) {
                        *name_hit = true;
                    }
                }
            }
        }

        if (field_type == 0xff && field_data_len >= 2U) {
            if (data[offset + 2] == 0xaa && data[offset + 3] == 0xbb) {
                matched = true;
                if (magic_hit != NULL) {
                    *magic_hit = true;
                }
            }
        }

        offset = (uint8_t)(offset + field_len + 1U);
    }

    return matched;
}

static errcode_t sle_uart_client_send_payload(uint16_t conn_id, const uint8_t *data, uint16_t data_len)
{
    ssapc_write_param_t *send_param = get_g_sle_uart_send_param();

    if (send_param == NULL || data == NULL || data_len == 0) {
        return ERRCODE_SLE_FAIL;
    }

    if (data_len > sizeof(g_sle_uart_tx_buff)) {
        osal_printk("%s payload too large:%u max:%u\r\n", SLE_UART_CLIENT_LOG,
            data_len, (uint16_t)sizeof(g_sle_uart_tx_buff));
        return ERRCODE_SLE_FAIL;
    }

    if (conn_id == 0) {
        if (!sle_connected_get_primary(&conn_id)) {
            osal_printk("%s no active connection for transparent send\r\n", SLE_UART_CLIENT_LOG);
            return ERRCODE_SLE_FAIL;
        }
    } else if (!sle_connected_find_index(conn_id, NULL)) {
        osal_printk("%s target conn_id not found:%u\r\n", SLE_UART_CLIENT_LOG, conn_id);
        return ERRCODE_SLE_FAIL;
    }

    if (memcpy_s(g_sle_uart_tx_buff, sizeof(g_sle_uart_tx_buff), data, data_len) != EOK) {
        osal_printk("%s payload copy failed\r\n", SLE_UART_CLIENT_LOG);
        return ERRCODE_SLE_FAIL;
    }

    send_param->data = g_sle_uart_tx_buff;
    send_param->data_len = data_len;
    return ssapc_write_req(0, conn_id, send_param);
}

static void sle_try_connect_next(void)
{
    if (g_connecting || g_sle_uart_conn_num >= SLE_UART_CLIENT_MAX_CON) {
        return;
    }

    if (sle_pending_pop(&g_sle_uart_remote_addr)) {
        g_connecting = true;
        (void)sle_connect_remote_device(&g_sle_uart_remote_addr);
        return;
    }

    sle_uart_start_scan();
}

void sle_uart_start_scan(void)
{
    sle_seek_param_t param = { 0 };
    param.own_addr_type = 0;
    param.filter_duplicates = 1;
    param.seek_filter_policy = 0;
    param.seek_phys = 1;
    param.seek_type[0] = 1;
    param.seek_interval[0] = SLE_SEEK_INTERVAL_DEFAULT;
    param.seek_window[0] = SLE_SEEK_WINDOW_DEFAULT;
    sle_set_seek_param(&param);
    g_connecting = false;
    sle_start_seek();
}

static void sle_uart_client_sample_sle_enable_cbk(errcode_t status)
{
    unused(status);
    sle_uart_start_scan();
}

static void sle_uart_client_sample_seek_enable_cbk(errcode_t status)
{
    unused(status);
}


static void sle_uart_client_sample_seek_result_info_cbk(sle_seek_result_info_t *seek_result_data)
{
    char name_buf[SLE_NAME_MAX_LEN + 1] = {0};
    bool name_hit = false;
    bool magic_hit = false;

    if (seek_result_data == NULL || seek_result_data->data == NULL || seek_result_data->data_length == 0) {
        return;
    }

    if (!sle_parse_adv_payload(seek_result_data->data, seek_result_data->data_length,
        name_buf, sizeof(name_buf), &name_hit, &magic_hit)) {
        return;
    }

    if (!name_hit && !magic_hit) {
        return;
    }

    if (name_buf[0] == '\0') {
        (void)memcpy_s(name_buf, sizeof(name_buf), "manufacturer_magic", sizeof("manufacturer_magic"));
    }

    if (g_sle_uart_conn_num >= SLE_UART_CLIENT_MAX_CON) {
        return;
    }

    if (sle_addr_in_list(&seek_result_data->addr, g_connected_addrs, g_sle_uart_conn_num)) {
        return;
    }

    if (sle_pending_push(&seek_result_data->addr)) {
        osal_printk("%s target device:%s addr:%02x:%02x:%02x:%02x:%02x:%02x\r\n",
            SLE_UART_CLIENT_LOG,
            name_buf,
            seek_result_data->addr.addr[0], seek_result_data->addr.addr[1], seek_result_data->addr.addr[2],
            seek_result_data->addr.addr[3], seek_result_data->addr.addr[4], seek_result_data->addr.addr[5]);
    }

    if (!g_connecting) {
        sle_stop_seek();
    }
}

static void sle_uart_client_sample_seek_disable_cbk(errcode_t status)
{
    unused(status);
    sle_try_connect_next();
}

static void sle_uart_client_sample_seek_cbk_register(void)
{
    g_sle_uart_seek_cbk.sle_enable_cb = sle_uart_client_sample_sle_enable_cbk;
    g_sle_uart_seek_cbk.seek_enable_cb = sle_uart_client_sample_seek_enable_cbk;
    g_sle_uart_seek_cbk.seek_result_cb = sle_uart_client_sample_seek_result_info_cbk;
    g_sle_uart_seek_cbk.seek_disable_cb = sle_uart_client_sample_seek_disable_cbk;
    sle_announce_seek_register_callbacks(&g_sle_uart_seek_cbk);
}

static void sle_uart_client_sample_connect_state_changed_cbk(uint16_t conn_id, const sle_addr_t *addr,
                                                             sle_acb_state_t conn_state, sle_pair_state_t pair_state,
                                                             sle_disc_reason_t disc_reason)
{
    unused(addr);
    unused(pair_state);
    unused(disc_reason);
    if (conn_state == SLE_ACB_STATE_CONNECTED) {
        osal_printk("%s connect success conn_id:%u\r\n", SLE_UART_CLIENT_LOG, conn_id);
        if (g_sle_uart_conn_num < SLE_UART_CLIENT_MAX_CON) {
            if (!sle_connected_find_index(conn_id, NULL)) {
                g_sle_uart_conn_id[g_sle_uart_conn_num] = conn_id;
                if (addr != NULL) {
                    g_connected_addrs[g_sle_uart_conn_num] = *addr;
                }
                g_sle_uart_conn_num++;
            }
        }
        g_connecting = false;
        ssap_exchange_info_t info = {0};
        info.mtu_size = SLE_MTU_SIZE_DEFAULT;
        info.version = 1;
        ssapc_exchange_info_req(1, conn_id, &info);
        sle_try_connect_next();
    } else if (conn_state == SLE_ACB_STATE_DISCONNECTED) {
        (void)sle_connected_remove(conn_id);
        g_connecting = false;
        sle_try_connect_next();
    }
}



void  sle_uart_client_sample_pair_complete_cbk(uint16_t conn_id, const sle_addr_t *addr, errcode_t status)
{
    unused(conn_id);
    unused(addr);
    if (status == 0) {
        ssap_exchange_info_t info = {0};
        info.mtu_size = SLE_MTU_SIZE_DEFAULT;
        info.version = 1;
        ssapc_exchange_info_req(0, conn_id, &info);
    }
}

static void sle_uart_client_sample_connect_cbk_register(void)
{
    g_sle_uart_connect_cbk.connect_state_changed_cb = sle_uart_client_sample_connect_state_changed_cbk;
    g_sle_uart_connect_cbk.pair_complete_cb =  sle_uart_client_sample_pair_complete_cbk;
    sle_connection_register_callbacks(&g_sle_uart_connect_cbk);
}

static void sle_uart_client_sample_exchange_info_cbk(uint8_t client_id, uint16_t conn_id, ssap_exchange_info_t *param,
                                                     errcode_t status)
{
    unused(client_id);
    unused(status);
    unused(param);
    ssapc_find_structure_param_t find_param = { 0 };
    find_param.type = SSAP_FIND_TYPE_PROPERTY;
    find_param.start_hdl = 1;
    find_param.end_hdl = 0xFFFF;
    ssapc_find_structure(0, conn_id, &find_param);
}

static void sle_uart_client_sample_find_structure_cbk(uint8_t client_id, uint16_t conn_id,
                                                      ssapc_find_service_result_t *service,
                                                      errcode_t status)
{
    unused(client_id);
    unused(conn_id);
    unused(status);
    g_sle_uart_find_service_result.start_hdl = service->start_hdl;
    g_sle_uart_find_service_result.end_hdl = service->end_hdl;
    memcpy_s(&g_sle_uart_find_service_result.uuid, sizeof(sle_uuid_t), &service->uuid, sizeof(sle_uuid_t));
}

static void sle_uart_client_sample_find_property_cbk(uint8_t client_id, uint16_t conn_id,
                                                     ssapc_find_property_result_t *property, errcode_t status)
{
    unused(client_id);
    unused(conn_id);
    unused(status);
    g_sle_uart_send_param.handle = property->handle;
    g_sle_uart_send_param.type = SSAP_PROPERTY_TYPE_VALUE;
}

static void sle_uart_client_sample_find_structure_cmp_cbk(uint8_t client_id, uint16_t conn_id,
                                                          ssapc_find_structure_result_t *structure_result,
                                                          errcode_t status)
{
    unused(conn_id);
    unused(client_id);
    unused(status);
    unused(structure_result);
}

static void sle_uart_client_sample_write_cfm_cb(uint8_t client_id, uint16_t conn_id,
                                                ssapc_write_result_t *write_result, errcode_t status)
{
    unused(client_id);
    unused(write_result);
    if (status == ERRCODE_SLE_SUCCESS) {
        osal_printk("%s tx success conn_id:%u\r\n", SLE_UART_CLIENT_LOG, conn_id);
    }
}

static void sle_uart_client_sample_ssapc_cbk_register(ssapc_notification_callback notification_cb,
                                                      ssapc_notification_callback indication_cb)
{
    g_sle_uart_ssapc_cbk.exchange_info_cb = sle_uart_client_sample_exchange_info_cbk;
    g_sle_uart_ssapc_cbk.find_structure_cb = sle_uart_client_sample_find_structure_cbk;
    g_sle_uart_ssapc_cbk.ssapc_find_property_cbk = sle_uart_client_sample_find_property_cbk;
    g_sle_uart_ssapc_cbk.find_structure_cmp_cb = sle_uart_client_sample_find_structure_cmp_cbk;
    g_sle_uart_ssapc_cbk.write_cfm_cb = sle_uart_client_sample_write_cfm_cb;
    g_sle_uart_ssapc_cbk.notification_cb = notification_cb;
    g_sle_uart_ssapc_cbk.indication_cb = indication_cb;
    ssapc_register_callbacks(&g_sle_uart_ssapc_cbk);
}


void sle_uart_client_init(ssapc_notification_callback notification_cb, ssapc_indication_callback indication_cb)
{
    (void)osal_msleep(SLE_UART_TASK_DELAY_MS); /* 延时5s，等待SLE初始化完毕 */
    g_pending_count = 0;
    g_connecting = false;
    g_sle_uart_conn_num = 0;
    (void)memset_s(g_pending_addrs, sizeof(g_pending_addrs), 0, sizeof(g_pending_addrs));
    (void)memset_s(g_connected_addrs, sizeof(g_connected_addrs), 0, sizeof(g_connected_addrs));
    (void)memset_s(g_sle_uart_conn_id, sizeof(g_sle_uart_conn_id), 0, sizeof(g_sle_uart_conn_id));
    sle_uart_client_sample_seek_cbk_register();
    sle_uart_client_sample_connect_cbk_register();
    sle_uart_client_sample_ssapc_cbk_register(notification_cb, indication_cb);
    if (enable_sle() != ERRCODE_SUCC) {
        osal_printk("[SLE Client] sle enbale fail !\r\n");
    }
}

void sle_uart_notification_cb(uint8_t client_id, uint16_t conn_id, ssapc_handle_value_t *data,
    errcode_t status)
{
    unused(client_id);
    unused(conn_id);
    unused(status);
    if (data == NULL || data->data == NULL || data->data_len == 0) {
        return;
    }
    osal_printk("%s rx success conn_id:%u len:%u\r\n", SLE_UART_CLIENT_LOG, conn_id, data->data_len);
    uapi_uart_write(CONFIG_SLE_UART_BUS, (uint8_t *)(data->data), data->data_len, 0);
}

void sle_uart_indication_cb(uint8_t client_id, uint16_t conn_id, ssapc_handle_value_t *data,
    errcode_t status)
{
    unused(client_id);
    unused(conn_id);
    unused(status);
    if (data == NULL || data->data == NULL || data->data_len == 0) {
        return;
    }
    osal_printk("%s rx success conn_id:%u len:%u\r\n", SLE_UART_CLIENT_LOG, conn_id, data->data_len);
    uapi_uart_write(CONFIG_SLE_UART_BUS, (uint8_t *)(data->data), data->data_len, 0);
}

/**
 * @brief UART客户端数据读取中断处理函数（支持#分隔符格式）
 * 
 * @param buffer 接收到的数据缓冲区指针（格式："<conn_id>#<data>"）
 * @param length 数据总长度（字节数）
 * @param error 错误标志（未使用）
 * 
 * 数据格式要求：
 * - 必须以 '#' 分隔 conn_id 和实际数据（如 "123#Hello"）
 * - conn_id 必须为数字（1~65535）
 * - '#' 后至少1字节有效数据
 */
static void sle_uart_client_read_int_handler(const void *buffer, uint16_t length, bool error)
{
    unused(error);

    if (buffer == NULL || length == 0) {
        osal_printk("%s invalid uart frame\r\n", SLE_UART_CLIENT_LOG);
        return;
    }

    const uint8_t *buff = (const uint8_t *)buffer;

    uint16_t separator_pos = 0;
    uint16_t target_conn_id = 0;
    uint16_t payload_offset = 0;
    bool has_target = false;

    while (separator_pos < length && buff[separator_pos] != '#') {
        separator_pos++;
    }

    if (separator_pos > 0 && separator_pos < length - 1) {
        bool valid_number = true;
        uint32_t conn_value = 0;

        for (uint16_t i = 0; i < separator_pos; i++) {
            if (buff[i] < '0' || buff[i] > '9') {
                valid_number = false;
                break;
            }
            conn_value = conn_value * 10 + (uint32_t)(buff[i] - '0');
            if (conn_value > 0xFFFFU) {
                valid_number = false;
                break;
            }
        }

        if (valid_number) {
            target_conn_id = (uint16_t)conn_value;
            payload_offset = separator_pos + 1;
            has_target = true;
        }
    }

    if (!has_target) {
        payload_offset = 0;
        target_conn_id = 0;
    }

    if (payload_offset >= length) {
        osal_printk("%s empty uart payload\r\n", SLE_UART_CLIENT_LOG);
        return;
    }

    uint16_t payload_len = length - payload_offset;
    osal_printk("%s uart tx len:%u target:%u\r\n", SLE_UART_CLIENT_LOG, payload_len, target_conn_id);
    if (sle_uart_client_send_payload(target_conn_id, buff + payload_offset, payload_len) != ERRCODE_SLE_SUCCESS) {
        osal_printk("%s uart tx failed\r\n", SLE_UART_CLIENT_LOG);
    }
}


static void *sle_uart_client_task(const char *arg)
{
    unused(arg);
    uart_init_pin();
    uart_init_config();

#if defined(CONFIG_UART_SUPPORT_RX)
    errcode_t ret = uapi_uart_register_rx_callback(CONFIG_SLE_UART_BUS,
                                                   (uart_rx_condition_t)5,
                                                   1, sle_uart_client_read_int_handler);
    if (ret != ERRCODE_SUCC) {
        osal_printk("Register uart callback fail.");
        return NULL;
    }
#endif

    sle_uart_client_init(sle_uart_notification_cb, sle_uart_indication_cb);
    return NULL;
}

static void sle_uart_entry(void)
{
    osal_task *task_handle = NULL;
    osal_kthread_lock();
    task_handle = osal_kthread_create((osal_kthread_handler)sle_uart_client_task, 0, "SLEUartDongleTask",
                                      SLE_UART_TASK_STACK_SIZE);
    if (task_handle != NULL) {
        osal_kthread_set_priority(task_handle, SLE_UART_TASK_PRIO);
    }
    osal_kthread_unlock();
}

/* Run the sle_uart_entry. */
app_run(sle_uart_entry);