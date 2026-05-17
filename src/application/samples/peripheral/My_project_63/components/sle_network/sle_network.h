#ifndef MY63_SLE_NETWORK_H
#define MY63_SLE_NETWORK_H

#include <stdint.h>
#include <stdbool.h>
#include "sle_device_discovery.h"
#include "../shared_protocol/shared_protocol.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SLE_SCAN_TABLE_MAX      32
#define SLE_SCAN_ENTRY_TIMEOUT_MS   30000   /* 30s 未扫到标记为离线 */
#define SLE_SCAN_ENTRY_EXPIRE_MS    300000  /* 5min 未扫到清除条目 */

typedef struct {
    uint16_t tag_id;
    uint8_t  mac[6];
    uint8_t  battery;
    uint16_t qty;
    uint8_t  status;        /* 0x00=正常 0x01=寻物 0x02=出库 */
    uint64_t last_seen_ms;  /* 最后扫描到的时间戳 */
    bool     used;          /* 条目是否有效 */
} sle_scan_entry_t;

typedef void (*sle_notify_callback)(const ssap_inventory_rsp_t *inv, const ssap_bind_rsp_t *bind);

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
int sle_network_send_cmd(uint8_t cmd, uint16_t param);
int sle_network_disconnect(void);
void sle_network_register_notify_cb(sle_notify_callback cb);

/* 扫描表 API */
int sle_network_connect_by_tag(uint16_t tag_id);
const sle_scan_entry_t *sle_network_get_scan_table(void);
uint16_t sle_network_get_scan_table_count(void);
void sle_network_poll(void);

#ifdef __cplusplus
}
#endif

#endif
