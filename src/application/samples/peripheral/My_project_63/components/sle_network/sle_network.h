#ifndef MY63_SLE_NETWORK_H
#define MY63_SLE_NETWORK_H

#include "sle_device_discovery.h"

#ifdef __cplusplus
extern "C" {
#endif

int sle_network_init(void);
void sle_network_connect_param_init(void);
int sle_network_start_scan(void);
int sle_network_stop_scan(void);
int sle_network_is_target_found(void);
int sle_network_is_connected(void);
int sle_network_is_link_lost(void);
int sle_network_is_authenticated(void);
int sle_network_is_ssap_ready(void);
const sle_addr_t *sle_network_get_target_addr(void);
uint32_t sle_network_get_scan_count(void);
int sle_network_get_scan_active(void);

#ifdef __cplusplus
}
#endif

#endif
