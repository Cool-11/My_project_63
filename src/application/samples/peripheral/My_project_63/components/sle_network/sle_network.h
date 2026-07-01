#ifndef MY63_SLE_NETWORK_H
#define MY63_SLE_NETWORK_H

#include <stdint.h>
#include <stdbool.h>
#include "cmsis_os2.h"
#include "sle_device_discovery.h"
#include "../shared_protocol/shared_protocol.h"

#ifdef __cplusplus
extern "C" {
#endif

/* ========== 事件标志位（主循环 osEventFlagsWait 使用） ========== */
#define EVENT_SLE_ADV     (1U << 0)   /* SLE 广播队列有数据 */
#define EVENT_UART1_RX    (1U << 1)   /* UART1 (ESP32) 接收完成 */
#define EVENT_UART2_RX    (1U << 2)   /* UART2 (串口屏) 接收完成 */
#define EVENT_TIMER       (1U << 3)   /* 定时器事件（心跳/超时） */
#define EVENT_ALL         (EVENT_SLE_ADV | EVENT_UART1_RX | EVENT_UART2_RX | EVENT_TIMER)

/* 事件标志句柄（main.c 创建，各模块中断回调设置） */
extern osEventFlagsId_t g_my63_events;

#define SLE_SCAN_TABLE_MAX      32
#define SLE_SCAN_ENTRY_TIMEOUT_MS   30000   /* 30s 未扫到标记为离线 */
#define SLE_SCAN_ENTRY_EXPIRE_MS    300000  /* 5min 未扫到清除条目 */

typedef struct {
    uint16_t tag_id;
    uint8_t  mac[6];
    uint8_t  battery;
    uint16_t qty;
    uint8_t  status;        /* 0=空闲 1=寻物 2=使用中 3=未配网 */
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
int sle_network_is_connecting(void);
void sle_network_clear_connecting(void);
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
void sle_network_update_scan_tag_id(const uint8_t *mac, uint16_t new_tag_id);
void sle_network_poll(void);

/* SLE 广播消息队列 API（事件驱动核心） */
int sle_adv_queue_init(void);
int sle_adv_queue_get(struct sle_adv_msg *msg);
uint16_t sle_adv_queue_count(void);
uint16_t sle_adv_dequeue(void);  /* 主循环调用：出队+解析+扫描表更新 */

#ifdef __cplusplus
}
#endif

#endif
