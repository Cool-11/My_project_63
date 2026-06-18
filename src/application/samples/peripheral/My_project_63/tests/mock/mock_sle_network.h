#ifndef MOCK_SLE_NETWORK_H
#define MOCK_SLE_NETWORK_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

/* ========== Mock SLE 扫描表 ========== */
#define SLE_SCAN_TABLE_MAX 32
#define SLE_ADDR_LEN 6

typedef struct {
    bool used;
    uint16_t tag_id;
    uint8_t mac[6];
    uint8_t battery;
    uint16_t qty;
    uint8_t status;
    int8_t rssi;
    uint64_t last_seen_ms;
} sle_scan_entry_t;

static sle_scan_entry_t g_mock_scan_table[SLE_SCAN_TABLE_MAX];
static uint16_t g_mock_scan_count = 0;
static bool g_mock_ssap_ready = false;
static bool g_mock_link_lost = false;
static int g_mock_send_cmd_ret = 0;

/* Mock 函数：重置所有状态 */
static inline void mock_sle_reset(void) {
    memset(g_mock_scan_table, 0, sizeof(g_mock_scan_table));
    g_mock_scan_count = 0;
    g_mock_ssap_ready = false;
    g_mock_link_lost = false;
    g_mock_send_cmd_ret = 0;
}

/* Mock 函数：添加扫描表条目 */
static inline void mock_sle_add_scan(uint16_t tag_id, const uint8_t *mac,
    uint8_t battery, uint16_t qty, uint8_t status) {
    for (int i = 0; i < SLE_SCAN_TABLE_MAX; i++) {
        if (!g_mock_scan_table[i].used) {
            g_mock_scan_table[i].used = true;
            g_mock_scan_table[i].tag_id = tag_id;
            if (mac) memcpy(g_mock_scan_table[i].mac, mac, 6);
            g_mock_scan_table[i].battery = battery;
            g_mock_scan_table[i].qty = qty;
            g_mock_scan_table[i].status = status;
            g_mock_scan_count++;
            break;
        }
    }
}

/* Mock API：获取扫描表 */
static inline const sle_scan_entry_t *sle_network_get_scan_table(void) {
    return g_mock_scan_table;
}

static inline uint16_t sle_network_get_scan_table_count(void) {
    return g_mock_scan_count;
}

/* Mock API：SSAP 状态 */
static inline int sle_network_is_ssap_ready(void) {
    return g_mock_ssap_ready ? 1 : 0;
}

static inline int sle_network_is_link_lost(void) {
    return g_mock_link_lost ? 1 : 0;
}

/* Mock API：发送命令 */
#define SSAP_CMD_BIND_TAG 0x20
static inline int sle_network_send_cmd(uint8_t cmd, uint16_t param) {
    (void)cmd;
    (void)param;
    return g_mock_send_cmd_ret;
}

/* Mock API：连接 */
static inline int sle_network_connect_by_tag(uint16_t tag_id) {
    (void)tag_id;
    return 0;
}

/* Mock API：扫描控制 */
static inline int sle_network_start_scan(void) {
    return 0;
}

#endif /* MOCK_SLE_NETWORK_H */
