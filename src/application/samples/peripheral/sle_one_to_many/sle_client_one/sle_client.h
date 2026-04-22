/**
 * Copyright (c) HiSilicon (Shanghai) Technologies Co., Ltd. 2024-2025. All rights reserved.
 *
 * Description: SLE uart client Config. \n
 *
 * History: \n
 * 2025-07-16, Create file. \n
 */

#ifndef SLE_UART_CLIENT_H
#define SLE_UART_CLIENT_H

#include <stdint.h>
#include "../../../../../include/middleware/services/bts/sle/sle_ssap_client.h"
#include "errcode.h"

#ifdef __cplusplus
#if __cplusplus
extern "C" {
#endif /* __cplusplus */
#endif /* __cplusplus */

uint16_t sle_uart_client_is_connected(void);
uint16_t get_connect_id(void);

ssapc_write_param_t *get_g_sle_uart_send_param(void);
void sle_uart_start_scan(void);
void sle_uart_client_init(ssapc_notification_callback notification_cb, ssapc_indication_callback indication_cb);
void sle_uart_notification_cb(uint8_t client_id, uint16_t conn_id, ssapc_handle_value_t *data, errcode_t status);
void sle_uart_indication_cb(uint8_t client_id, uint16_t conn_id, ssapc_handle_value_t *data, errcode_t status);

#ifdef __cplusplus
#if __cplusplus
}
#endif /* __cplusplus */
#endif /* __cplusplus */

#endif