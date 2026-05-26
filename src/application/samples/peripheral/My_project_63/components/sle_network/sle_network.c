#include "sle_network.h"
#include "soc_osal.h"
#include "securec.h"
#include "common_def.h"
#include "tcxo.h"
#include <string.h>

#include "sle_device_discovery.h"
#include "sle_connection_manager.h"
#include "sle_errcode.h"
#include "sle_ssap_client.h"
#include "../shared_protocol/shared_protocol.h"

#define SLE_MTU_SIZE_DEFAULT        512
#define MY63_SLE_SEEK_INTERVAL_DEFAULT 0xC8
#define MY63_SLE_SEEK_WINDOW_DEFAULT   0x50
#define MY63_SLE_SCAN_PHY_NUM          1
#define MY63_SLE_DEFAULT_CONN_INTERVAL  0x64
#define MY63_SLE_DEFAULT_TIMEOUT        0x1f4
#define MY63_SLE_DEFAULT_SCAN_INTERVAL   400
#define MY63_SLE_DEFAULT_SCAN_WINDOW     20
#define MY63_ADV_FIELD_TYPE_MANUFACTURER 0xFF
#define MY63_ADV_FIELD_TYPE_COMPLETE_NAME 0x0B
#define MY63_MANUFACTURER_ID_L           0x5A
#define MY63_MANUFACTURER_ID_H           0xA5
#define MY63_MANUFACTURER_ID_LEN         2
#define MY63_UUID_16BIT_LEN              2
#define MY63_UUID_128BIT_LEN             16
#define MY63_UUID_INDEX                  14
#define MY63_SERVICE_UUID_16             0xFF00
#define MY63_PROPERTY_UUID_16            0xFF01
#define MY63_BS21E_LOCAL_NAME            "BS2x_Tag"
#define MY63_BS21E_LOCAL_NAME_LEN        8
#define MY63_SCAN_RESTART_INTERVAL_MS    10000

static const uint8_t g_my63_app_uuid[MY63_UUID_128BIT_LEN] __attribute__((unused)) = {
    0x00, 0x00, 0xFF, 0xFF,
    0x00, 0x00, 0x10, 0x00,
    0x80, 0x00, 0x00, 0x80,
    0x5F, 0x9B, 0x34, 0xFB
};

static const uint8_t g_my63_service_uuid[MY63_UUID_128BIT_LEN] = {
    0x00, 0x00, 0xFF, 0x00,
    0x00, 0x00, 0x10, 0x00,
    0x80, 0x00, 0x00, 0x80,
    0x5F, 0x9B, 0x34, 0xFB
};

static const uint8_t g_my63_property_uuid[MY63_UUID_128BIT_LEN] = {
    0x00, 0x00, 0xFF, 0x01,
    0x00, 0x00, 0x10, 0x00,
    0x80, 0x00, 0x00, 0x80,
    0x5F, 0x9B, 0x34, 0xFB
};

static sle_announce_seek_callbacks_t g_my63_seek_cbk = {0};
static sle_connection_callbacks_t g_my63_conn_cbk = {0};
static ssapc_callbacks_t g_my63_ssapc_cbk = {0};
static sle_addr_t g_my63_target_addr = {0};
static int g_my63_target_found = 0;
static int g_my63_connecting = 0;
static int g_my63_connected = 0;
static int g_my63_link_lost = 0;
static int g_my63_authenticated = 0;
static int g_my63_ssap_ready = 0;
static uint16_t g_my63_conn_id = 0;
static ssapc_find_service_result_t g_my63_find_service_result = {0};
static uint16_t g_my63_property_handle = 0;
static int g_my63_cccd_written = 0;
static sle_notify_callback g_my63_notify_cb = NULL;
static volatile uint32_t g_my63_scan_result_count = 0;
static volatile int g_my63_scan_active = 0;

/* 扫描表：记录所有扫到的 BS21E 标签 */
static sle_scan_entry_t g_scan_table[SLE_SCAN_TABLE_MAX] = {0};
static uint16_t g_scan_count = 0;

static sle_scan_entry_t *scan_table_find_by_tag(uint16_t tag_id);
static void scan_table_cleanup(void);

static int my63_check_local_name(const sle_seek_result_info_t *seek_result)
{
    if (seek_result == NULL || seek_result->data == NULL || seek_result->data_length == 0) {
        return 0;
    }

    const uint8_t *data = seek_result->data;
    uint8_t length = seek_result->data_length;

    for (uint8_t offset = 0; (uint8_t)(offset + 1U) < length;) {
        uint8_t field_len = data[offset];
        uint8_t field_type;
        uint8_t field_data_len;

        if (field_len == 0 || (uint16_t)offset + (uint16_t)field_len >= (uint16_t)length) {
            break;
        }

        field_type = data[offset + 1U];
        field_data_len = (uint8_t)(field_len - 1U);

        if (field_type == MY63_ADV_FIELD_TYPE_COMPLETE_NAME) {
            if (field_data_len == MY63_BS21E_LOCAL_NAME_LEN &&
                memcmp(&data[offset + 2U], MY63_BS21E_LOCAL_NAME, MY63_BS21E_LOCAL_NAME_LEN) == 0) {
                return 1;
            }
            if (field_data_len > 0 && field_data_len <= 32) {
                char name_buf[33] = {0};
                uint8_t copy_len = field_data_len;
                if (copy_len > 32) {
                    copy_len = 32;
                }
                (void)memcpy_s(name_buf, 32, &data[offset + 2U], copy_len);
                osal_printk("[WS63_NET] found local_name=\"%s\" len=%u (expect \"%s\" len=%u)\r\n",
                    name_buf, (unsigned int)field_data_len,
                    MY63_BS21E_LOCAL_NAME, (unsigned int)MY63_BS21E_LOCAL_NAME_LEN);
            }
        }

        offset = (uint8_t)(offset + field_len + 1U);
    }

    return 0;
}

static int my63_extract_adv_field(const sle_seek_result_info_t *seek_result,
    shared_proto_adv_field_t *out_field)
{
    if (seek_result == NULL || seek_result->data == NULL || seek_result->data_length == 0 || out_field == NULL) {
        return 0;
    }

    const uint8_t *data = seek_result->data;
    uint8_t length = seek_result->data_length;

    for (uint8_t offset = 0; (uint8_t)(offset + 1U) < length;) {
        uint8_t field_len = data[offset];
        uint8_t field_type;
        uint8_t field_data_len;

        if (field_len == 0 || (uint16_t)offset + (uint16_t)field_len >= (uint16_t)length) {
            osal_printk("[WS63_NET] AD field parse break at offset=%u field_len=%u total_len=%u\r\n",
                (unsigned int)offset, (unsigned int)field_len, (unsigned int)length);
            break;
        }

        field_type = data[offset + 1U];
        field_data_len = (uint8_t)(field_len - 1U);

        osal_printk("[WS63_NET] AD field offset=%u len=%u type=0x%02X data_len=%u hex: ",
            (unsigned int)offset, (unsigned int)field_len, (unsigned int)field_type,
            (unsigned int)field_data_len);
        {
            uint8_t print_len = field_data_len;
            if (print_len > 16) {
                print_len = 16;
            }
            for (uint8_t p = 0; p < print_len; p++) {
                osal_printk("%02X ", data[offset + 2U + p]);
            }
        }
        osal_printk("\r\n");

        if (field_type == MY63_ADV_FIELD_TYPE_MANUFACTURER &&
            field_data_len >= SHARED_PROTO_ADV_FIELD_LEN + MY63_MANUFACTURER_ID_LEN) {
            if (data[offset + 2U] != MY63_MANUFACTURER_ID_L ||
                data[offset + 2U + 1U] != MY63_MANUFACTURER_ID_H) {
                osal_printk("[WS63_NET] manufacturer ID mismatch: got 0x%02X 0x%02X, expect 0x%02X 0x%02X\r\n",
                    data[offset + 2U], data[offset + 2U + 1U],
                    MY63_MANUFACTURER_ID_L, MY63_MANUFACTURER_ID_H);
            } else if (shared_protocol_unpack_adv(&data[offset + 2U + MY63_MANUFACTURER_ID_LEN],
                SHARED_PROTO_ADV_FIELD_LEN, out_field) == SHARED_PROTO_OK) {
                return 1;
            } else {
                osal_printk("[WS63_NET] manufacturer field found, ID ok, but unpack/magic failed, payload first 4 bytes: %02X %02X %02X %02X\r\n",
                    data[offset + 2U + MY63_MANUFACTURER_ID_LEN],
                    data[offset + 2U + MY63_MANUFACTURER_ID_LEN + 1U],
                    data[offset + 2U + MY63_MANUFACTURER_ID_LEN + 2U],
                    data[offset + 2U + MY63_MANUFACTURER_ID_LEN + 3U]);
            }
        } else if (field_type == MY63_ADV_FIELD_TYPE_MANUFACTURER) {
            osal_printk("[WS63_NET] manufacturer field type=0xFF but data_len=%u expect>=%u\r\n",
                (unsigned int)field_data_len,
                (unsigned int)(SHARED_PROTO_ADV_FIELD_LEN + MY63_MANUFACTURER_ID_LEN));
        }

        offset = (uint8_t)(offset + field_len + 1U);
    }

    return 0;
}

static int my63_uuid_match(const sle_uuid_t *uuid, const uint8_t *uuid_128, uint16_t u16)
{
    if (uuid == NULL) {
        osal_printk("[WS63_NET] uuid_match: null uuid\r\n");
        return 0;
    }

    osal_printk("[WS63_NET] uuid_match: uuid_len=%u comparing to u16=0x%04X\r\n",
        (unsigned int)uuid->len, (unsigned int)u16);

    if (uuid->len == MY63_UUID_128BIT_LEN && uuid_128 != NULL) {
        if (memcmp(uuid->uuid, uuid_128, MY63_UUID_128BIT_LEN) == 0) {
            osal_printk("[WS63_NET] uuid_match: 128-bit match ok\r\n");
            return 1;
        }
        osal_printk("[WS63_NET] uuid_match: 128-bit mismatch, got: ");
        for (int i = 0; i < MY63_UUID_128BIT_LEN; i++) {
            osal_printk("%02X ", uuid->uuid[i]);
        }
        osal_printk("\r\n");
    }

    if (uuid->len == MY63_UUID_16BIT_LEN) {
        uint16_t got = (uint16_t)(uuid->uuid[MY63_UUID_INDEX] |
            ((uint16_t)uuid->uuid[MY63_UUID_INDEX + 1U] << 8));
        osal_printk("[WS63_NET] uuid_match: 16-bit got=0x%04X expect=0x%04X %s\r\n",
            (unsigned int)got, (unsigned int)u16, (got == u16) ? "MATCH" : "MISMATCH");
        return (got == u16) ? 1 : 0;
    }

    osal_printk("[WS63_NET] uuid_match: unknown len=%u\r\n", (unsigned int)uuid->len);
    return 0;
}

static void my63_restart_scan_after_security_fail(const sle_addr_t *addr, const char *reason)
{
    osal_printk("[WS63_NET] %s, remove pair and restart scan after delay\r\n", reason);
    if (addr != NULL) {
        sle_remove_paired_remote_device(addr);
    }

    g_my63_connecting = 0;
    g_my63_connected = 0;
    g_my63_link_lost = 0;
    g_my63_authenticated = 0;
    g_my63_ssap_ready = 0;
    g_my63_property_handle = 0;
    g_my63_cccd_written = 0;
    (void)memset_s(&g_my63_find_service_result, sizeof(ssapc_find_service_result_t), 0,
        sizeof(ssapc_find_service_result_t));
    osal_msleep(1000);
    (void)sle_network_start_scan();
}

void sle_network_connect_param_init(void)
{
    sle_default_connect_param_t param = {0};

    param.enable_filter_policy = 0;
    param.gt_negotiate = SLE_ANNOUNCE_ROLE_G_CAN_NEGO;
    param.initiate_phys = 1;
    param.max_interval = MY63_SLE_DEFAULT_CONN_INTERVAL;
    param.min_interval = MY63_SLE_DEFAULT_CONN_INTERVAL;
    param.scan_interval = MY63_SLE_DEFAULT_SCAN_INTERVAL;
    param.scan_window = MY63_SLE_DEFAULT_SCAN_WINDOW;
    param.timeout = MY63_SLE_DEFAULT_TIMEOUT;
    sle_default_connection_param_set(&param);
    osal_printk("[WS63_NET] sle_network_connect_param_init done\r\n");
}

static void my63_start_ssap_exchange(void)
{
    ssap_exchange_info_t info = {0};

    osal_printk("[WS63_NET] start_ssap_exchange check: connected=%d conn_id=%u authenticated=%d\r\n",
        g_my63_connected, g_my63_conn_id, g_my63_authenticated);

    if (g_my63_connected == 0 || g_my63_conn_id == 0) {
        osal_printk("[WS63_NET] skip ssap exchange connected=%d conn_id=%u\r\n",
            g_my63_connected, g_my63_conn_id);
        return;
    }

    info.mtu_size = SLE_MTU_SIZE_DEFAULT;
    info.version = 1;
    osal_printk("[WS63_NET] request ssap exchange info conn_id=%u mtu=%u version=%u\r\n",
        g_my63_conn_id, info.mtu_size, info.version);
    errcode_t ret = ssapc_exchange_info_req(1, g_my63_conn_id, &info);
    osal_printk("[WS63_NET] ssapc_exchange_info_req ret=0x%x\r\n", ret);
}

int sle_network_start_scan(void)
{
    sle_seek_param_t param = {0};
    errcode_t ret;

    osal_printk("[WS63_NET] sle_network_start_scan start\r\n");
    param.own_addr_type = 0;
    param.filter_duplicates = 0;
    param.seek_filter_policy = 0;
    param.seek_phys = MY63_SLE_SCAN_PHY_NUM;
    param.seek_type[0] = SLE_SEEK_ACTIVE;
    param.seek_interval[0] = MY63_SLE_SEEK_INTERVAL_DEFAULT;
    param.seek_window[0] = MY63_SLE_SEEK_WINDOW_DEFAULT;

    ret = sle_set_seek_param(&param);
    osal_printk("[WS63_NET] sle_set_seek_param ret=0x%x (seek_type=ACTIVE)\r\n", ret);
    if (ret != ERRCODE_SLE_SUCCESS) {
        osal_printk("[WS63_NET] sle_network_start_scan failed at set param\r\n");
        return (int)ret;
    }

    ret = sle_start_seek();
    osal_printk("[WS63_NET] sle_start_seek ret=0x%x\r\n", ret);
    if (ret != ERRCODE_SLE_SUCCESS) {
        osal_printk("[WS63_NET] sle_network_start_scan failed at start seek\r\n");
        return (int)ret;
    }

    g_my63_scan_active = 1;
    osal_printk("[WS63_NET] sle_network_start_scan done (active scan, scan_count=%u)\r\n",
        (unsigned int)g_my63_scan_result_count);
    return 0;
}

int sle_network_stop_scan(void)
{
    errcode_t ret;

    osal_printk("[WS63_NET] sle_network_stop_scan start (scan_count=%u)\r\n",
        (unsigned int)g_my63_scan_result_count);
    g_my63_scan_active = 0;
    ret = sle_stop_seek();
    osal_printk("[WS63_NET] sle_stop_seek ret=0x%x\r\n", ret);
    if (ret != ERRCODE_SLE_SUCCESS) {
        osal_printk("[WS63_NET] sle_network_stop_scan failed\r\n");
        return (int)ret;
    }

    osal_printk("[WS63_NET] sle_network_stop_scan done\r\n");
    return 0;
}

int sle_network_is_target_found(void)
{
    return g_my63_target_found;
}

int sle_network_is_connected(void)
{
    return g_my63_connected;
}

int sle_network_is_link_lost(void)
{
    return g_my63_link_lost;
}

int sle_network_is_authenticated(void)
{
    return g_my63_authenticated;
}

int sle_network_is_ssap_ready(void)
{
    return (g_my63_ssap_ready != 0 && g_my63_property_handle != 0 && g_my63_cccd_written != 0) ? 1 : 0;
}

const sle_addr_t *sle_network_get_target_addr(void)
{
    return &g_my63_target_addr;
}

uint32_t sle_network_get_scan_count(void)
{
    return (uint32_t)g_my63_scan_result_count;
}

int sle_network_get_scan_active(void)
{
    return (int)g_my63_scan_active;
}

int sle_network_send_cmd(uint8_t cmd, uint16_t param)
{
    ssapc_write_param_t write_param = {0};
    static uint8_t cmd_buf[3] = {0};
    int pack_len;

    if (g_my63_conn_id == 0 || g_my63_property_handle == 0 || g_my63_cccd_written == 0) {
        osal_printk("[WS63_NET] send_cmd failed: conn_id=%u handle=0x%04x cccd=%d\r\n",
            g_my63_conn_id, g_my63_property_handle, g_my63_cccd_written);
        return -1;
    }

    pack_len = shared_protocol_pack_write_cmd(cmd, param, cmd_buf, (uint16_t)sizeof(cmd_buf));
    if (pack_len < 0) {
        osal_printk("[WS63_NET] send_cmd pack failed: cmd=0x%02X ret=%d\r\n", (unsigned int)cmd, pack_len);
        return pack_len;
    }

    write_param.handle = g_my63_property_handle;
    write_param.type = SSAP_PROPERTY_TYPE_VALUE;
    write_param.data_len = (uint16_t)pack_len;
    write_param.data = cmd_buf;

    osal_printk("[WS63_NET] send_cmd cmd=0x%02X param=%u len=%d handle=0x%04x\r\n",
        (unsigned int)cmd, (unsigned int)param, pack_len, g_my63_property_handle);
    errcode_t ret = ssapc_write_req(0, g_my63_conn_id, &write_param);
    if (ret != ERRCODE_SLE_SUCCESS) {
        osal_printk("[WS63_NET] send_cmd write failed ret=0x%x\r\n", ret);
        return (int)ret;
    }

    osal_printk("[WS63_NET] send_cmd req sent ok\r\n");
    return 0;
}

int sle_network_disconnect(void)
{
    if (g_my63_conn_id == 0 || g_my63_connected == 0) {
        osal_printk("[WS63_NET] disconnect skip: not connected\r\n");
        return -1;
    }

    osal_printk("[WS63_NET] disconnect conn_id=%u\r\n", g_my63_conn_id);
    errcode_t ret = sle_disconnect_remote_device(&g_my63_target_addr);
    if (ret != ERRCODE_SLE_SUCCESS) {
        osal_printk("[WS63_NET] disconnect failed ret=0x%x\r\n", ret);
        return (int)ret;
    }
    return 0;
}

int sle_network_connect_by_tag(uint16_t tag_id)
{
    if (g_my63_connecting || g_my63_connected) {
        osal_printk("[WS63_NET] connect_by_tag skip: already connecting/connected\r\n");
        return -1;
    }

    sle_scan_entry_t *entry = scan_table_find_by_tag(tag_id);
    if (entry == NULL) {
        osal_printk("[WS63_NET] connect_by_tag: tag_id=%u not found in scan table\r\n",
            (unsigned int)tag_id);
        return -2;
    }

    /* 停止扫描，准备连接 */
    (void)sle_network_stop_scan();

    g_my63_target_addr.type = 0;
    (void)memcpy_s(g_my63_target_addr.addr, SLE_ADDR_LEN, entry->mac, SLE_ADDR_LEN);
    g_my63_target_found = 1;
    g_my63_connecting = 1;

    osal_printk("[WS63_NET] connect_by_tag tag_id=%u mac=%02x:%02x:%02x:%02x:%02x:%02x\r\n",
        (unsigned int)tag_id,
        entry->mac[0], entry->mac[1], entry->mac[2],
        entry->mac[3], entry->mac[4], entry->mac[5]);

    errcode_t ret = sle_connect_remote_device(&g_my63_target_addr);
    if (ret != ERRCODE_SLE_SUCCESS) {
        osal_printk("[WS63_NET] connect_by_tag failed ret=0x%x\r\n", ret);
        g_my63_connecting = 0;
        (void)sle_network_start_scan();
        return (int)ret;
    }
    return 0;
}

const sle_scan_entry_t *sle_network_get_scan_table(void)
{
    return g_scan_table;
}

uint16_t sle_network_get_scan_table_count(void)
{
    return g_scan_count;
}

void sle_network_poll(void)
{
    scan_table_cleanup();
}

void sle_network_register_notify_cb(sle_notify_callback cb)
{
    g_my63_notify_cb = cb;
    osal_printk("[WS63_NET] notify callback registered cb=%p\r\n", (void *)cb);
}

static void my63_sle_enable_cb(errcode_t status)
{
    osal_printk("[WS63_NET] my63_sle_enable_cb status=0x%x\r\n", status);
    if (status != ERRCODE_SLE_SUCCESS) {
        osal_printk("[WS63_NET] sle enable failed\r\n");
        return;
    }

    {
        sle_addr_t local_address = {0};
        if (sle_get_local_addr(&local_address) == ERRCODE_SLE_SUCCESS) {
            osal_printk("[WS63_NET] using real local addr: %02X:%02X:%02X:%02X:%02X:%02X\r\n",
                local_address.addr[0], local_address.addr[1], local_address.addr[2],
                local_address.addr[3], local_address.addr[4], local_address.addr[5]);
        } else {
            osal_printk("[WS63_NET] WARN: sle_get_local_addr failed, using default\r\n");
            uint8_t fallback_addr[SLE_ADDR_LEN] = {0x13, 0x67, 0x5c, 0x07, 0x00, 0x51};
            local_address.type = 0;
            (void)memcpy_s(local_address.addr, SLE_ADDR_LEN, fallback_addr, SLE_ADDR_LEN);
        }
        sle_set_local_addr(&local_address);
    }

    sle_network_connect_param_init();
    (void)sle_network_start_scan();
}

static void my63_seek_enable_cb(errcode_t status)
{
    osal_printk("[WS63_NET] my63_seek_enable_cb status=0x%x\r\n", status);
}

static void my63_seek_disable_cb(errcode_t status)
{
    osal_printk("[WS63_NET] my63_seek_disable_cb status=0x%x\r\n", status);
}

static void my63_auth_complete_cb(uint16_t conn_id, const sle_addr_t *addr, errcode_t status,
    const sle_auth_info_evt_t *evt)
{
    unused(conn_id);
    unused(evt);

    osal_printk("[WS63_NET] auth complete status=0x%x\r\n", status);
    if (status == ERRCODE_SLE_SUCCESS) {
        g_my63_authenticated = 1;
        return;
    }

    my63_restart_scan_after_security_fail(addr, "[WS63_NET] auth failed");
}

static void my63_pair_complete_cb(uint16_t conn_id, const sle_addr_t *addr, errcode_t status)
{
    osal_printk("[WS63_NET] pair complete conn_id=%u status=0x%x\r\n", conn_id, status);
    if (addr != NULL) {
        osal_printk("[WS63_NET] pair complete addr=%02x:%02x:%02x:%02x:%02x:%02x\r\n",
            addr->addr[0], addr->addr[1], addr->addr[2],
            addr->addr[3], addr->addr[4], addr->addr[5]);
    }

    if (status == ERRCODE_SLE_SUCCESS) {
        g_my63_authenticated = 1;
        my63_start_ssap_exchange();
        return;
    }

    my63_restart_scan_after_security_fail(addr, "[WS63_NET] pair failed");
}

static void my63_connect_state_changed_cb(uint16_t conn_id, const sle_addr_t *addr,
    sle_acb_state_t conn_state, sle_pair_state_t pair_state, sle_disc_reason_t disc_reason)
{
    const char *state_str = "UNKNOWN";
    const char *pair_str = "UNKNOWN";

    switch (conn_state) {
        case SLE_ACB_STATE_NONE: state_str = "NONE"; break;
        case SLE_ACB_STATE_CONNECTED: state_str = "CONNECTED"; break;
        case SLE_ACB_STATE_DISCONNECTED: state_str = "DISCONNECTED"; break;
        default: break;
    }
    switch (pair_state) {
        case SLE_PAIR_NONE: pair_str = "NONE"; break;
        case SLE_PAIR_PAIRING: pair_str = "PAIRING"; break;
        case SLE_PAIR_PAIRED: pair_str = "PAIRED"; break;
        default: break;
    }

    osal_printk("[WS63_NET] conn state change conn_id=%u state=%s pair=%s reason=%d\r\n",
        conn_id, state_str, pair_str, disc_reason);

    if (conn_state == SLE_ACB_STATE_CONNECTED) {
        g_my63_connected = 1;
        g_my63_connecting = 0;
        g_my63_link_lost = 0;
        g_my63_authenticated = 0;
        g_my63_ssap_ready = 0;
        g_my63_property_handle = 0;
        g_my63_cccd_written = 0;
        g_my63_conn_id = conn_id;
        (void)memset_s(&g_my63_find_service_result, sizeof(ssapc_find_service_result_t), 0,
            sizeof(ssapc_find_service_result_t));
        if (addr != NULL) {
            osal_printk("[WS63_NET] connected addr=%02x:%02x:%02x:%02x:%02x:%02x\r\n",
                addr->addr[0], addr->addr[1], addr->addr[2],
                addr->addr[3], addr->addr[4], addr->addr[5]);
        }

        if (pair_state == SLE_PAIR_NONE) {
            osal_printk("[WS63_NET] pair state none, start pair\r\n");
            sle_pair_remote_device(&g_my63_target_addr);
        } else {
            g_my63_authenticated = 1;
            osal_printk("[WS63_NET] already paired, treat as authenticated\r\n");
            my63_start_ssap_exchange();
        }
        return;
    }

    if (conn_state == SLE_ACB_STATE_DISCONNECTED) {
        g_my63_connected = 0;
        g_my63_connecting = 0;
        g_my63_link_lost = 1;
        g_my63_authenticated = 0;
        g_my63_ssap_ready = 0;
        g_my63_target_found = 0;
        g_my63_property_handle = 0;
        g_my63_cccd_written = 0;
        (void)memset_s(&g_my63_find_service_result, sizeof(ssapc_find_service_result_t), 0,
            sizeof(ssapc_find_service_result_t));
        osal_printk("[WS63_NET] disconnected, reason=%d, auto-restart scan\r\n", disc_reason);
        (void)sle_network_start_scan();
    }
}

/* 扫描表：添加或更新条目 */
static void scan_table_add_or_update(uint16_t tag_id, const uint8_t *mac,
    uint8_t battery, uint16_t qty, uint8_t status)
{
    /* 先查找已有条目 */
    for (uint16_t i = 0; i < SLE_SCAN_TABLE_MAX; i++) {
        if (g_scan_table[i].used && g_scan_table[i].tag_id == tag_id) {
            g_scan_table[i].battery = battery;
            g_scan_table[i].qty = qty;
            g_scan_table[i].status = status;
            g_scan_table[i].last_seen_ms = uapi_tcxo_get_ms();
            if (mac != NULL) {
                (void)memcpy_s(g_scan_table[i].mac, 6, mac, 6);
            }
            return;
        }
    }
    /* 新条目：找空位 */
    for (uint16_t i = 0; i < SLE_SCAN_TABLE_MAX; i++) {
        if (!g_scan_table[i].used) {
            g_scan_table[i].tag_id = tag_id;
            g_scan_table[i].battery = battery;
            g_scan_table[i].qty = qty;
            g_scan_table[i].status = status;
            g_scan_table[i].last_seen_ms = uapi_tcxo_get_ms();
            g_scan_table[i].used = true;
            if (mac != NULL) {
                (void)memcpy_s(g_scan_table[i].mac, 6, mac, 6);
            }
            g_scan_count++;
            osal_printk("[WS63_NET] scan table add tag_id=%u total=%u\r\n",
                (unsigned int)tag_id, (unsigned int)g_scan_count);
            return;
        }
    }
    osal_printk("[WS63_NET] scan table FULL, drop tag_id=%u\r\n", (unsigned int)tag_id);
}

/* 扫描表：按 tag_id 查找 */
static sle_scan_entry_t *scan_table_find_by_tag(uint16_t tag_id)
{
    for (uint16_t i = 0; i < SLE_SCAN_TABLE_MAX; i++) {
        if (g_scan_table[i].used && g_scan_table[i].tag_id == tag_id) {
            return &g_scan_table[i];
        }
    }
    return NULL;
}

/* 扫描表：过期清理（30s标记离线，5min清除） */
static void scan_table_cleanup(void)
{
    uint64_t now = uapi_tcxo_get_ms();
    for (uint16_t i = 0; i < SLE_SCAN_TABLE_MAX; i++) {
        if (!g_scan_table[i].used) {
            continue;
        }
        uint64_t age = now - g_scan_table[i].last_seen_ms;
        if (age >= SLE_SCAN_ENTRY_EXPIRE_MS) {
            osal_printk("[WS63_NET] scan table expire tag_id=%u age=%ums\r\n",
                (unsigned int)g_scan_table[i].tag_id, (unsigned int)age);
            g_scan_table[i].used = false;
            g_scan_count--;
        } else if (age >= SLE_SCAN_ENTRY_TIMEOUT_MS) {
            /* 30s 未扫到，标记离线（status=0x02 语义复用为离线） */
            if (g_scan_table[i].status == 0x00) {
                g_scan_table[i].status = 0x02;
            }
        }
    }
}

static void my63_seek_result_cb(sle_seek_result_info_t *seek_result_data)
{
    shared_proto_adv_field_t adv = {0};
    int name_matched = 0;
    int adv_matched = 0;

    if (seek_result_data == NULL) {
        osal_printk("[WS63_NET] my63_seek_result_cb null result\r\n");
        return;
    }

    g_my63_scan_result_count++;

    osal_printk("[WS63_NET] seek result #%u rssi=%d, addr=%02x:%02x:%02x:%02x:%02x:%02x\r\n",
        (unsigned int)g_my63_scan_result_count,
        (int)seek_result_data->rssi,
        seek_result_data->addr.addr[0],
        seek_result_data->addr.addr[1],
        seek_result_data->addr.addr[2],
        seek_result_data->addr.addr[3],
        seek_result_data->addr.addr[4],
        seek_result_data->addr.addr[5]);

    osal_printk("[WS63_NET] RAW PAYLOAD len=%u: ", (unsigned int)seek_result_data->data_length);
    if (seek_result_data->data != NULL && seek_result_data->data_length > 0) {
        uint16_t dump_len = seek_result_data->data_length;
        if (dump_len > 32) {
            dump_len = 32;
        }
        for (uint16_t i = 0; i < dump_len; i++) {
            osal_printk("%02X ", seek_result_data->data[i]);
        }
    } else {
        osal_printk("(null or empty)");
    }
    osal_printk("\r\n");

    name_matched = my63_check_local_name(seek_result_data);
    if (name_matched) {
        osal_printk("[WS63_NET] local_name matched \"%s\"\r\n", MY63_BS21E_LOCAL_NAME);
    }

    adv_matched = my63_extract_adv_field(seek_result_data, &adv);
    if (adv_matched == 0) {
        osal_printk("[WS63_NET] adv payload not matched or magic invalid\r\n");
        return;
    }

    /* tag_id=0 的广播忽略（未配网的标签） */
    if (adv.tag_id == 0) {
        osal_printk("[WS63_NET] adv tag_id=0 (unconfigured), skip\r\n");
        return;
    }

    osal_printk("[WS63_NET] adv matched tag=%u qty=%u status=%u bat=%u seq=%u\r\n",
        (unsigned int)adv.tag_id,
        (unsigned int)adv.qty,
        (unsigned int)adv.status,
        (unsigned int)adv.battery,
        (unsigned int)adv.seq);

    /* 记录到扫描表（不停止扫描，不自动连接） */
    scan_table_add_or_update(adv.tag_id, seek_result_data->addr.addr,
        adv.battery, adv.qty, adv.status);
}

static void my63_ssap_exchange_info_cb(uint8_t client_id, uint16_t conn_id, ssap_exchange_info_t *param,
    errcode_t status)
{
    ssapc_find_structure_param_t find_param = {0};

    if (param == NULL) {
        osal_printk("[WS63_NET] ssap exchange info null param\r\n");
        return;
    }

    osal_printk("[WS63_NET] ssap exchange info client_id=%u conn_id=%u status=0x%x mtu=%u version=%u\r\n",
        client_id, conn_id, status, param->mtu_size, param->version);
    if (status != ERRCODE_SLE_SUCCESS) {
        return;
    }

    find_param.type = SSAP_FIND_TYPE_PRIMARY_SERVICE;
    find_param.start_hdl = 1;
    find_param.end_hdl = 0xFFFF;
    ssapc_find_structure(0, conn_id, &find_param);
}

static void my63_ssap_find_structure_cb(uint8_t client_id, uint16_t conn_id, ssapc_find_service_result_t *service,
    errcode_t status)
{
    osal_printk("[WS63_NET] ssap find structure client_id=%u conn_id=%u status=0x%x\r\n",
        client_id, conn_id, status);
    if (service == NULL || status != ERRCODE_SLE_SUCCESS) {
        osal_printk("[WS63_NET] ssap find structure: service=%p status=0x%x, skip\r\n",
            (void *)service, status);
        return;
    }

    osal_printk("[WS63_NET] ssap find structure: start_hdl=0x%04x end_hdl=0x%04x uuid_len=%u uuid: ",
        service->start_hdl, service->end_hdl, service->uuid.len);
    for (uint8_t i = 0; i < service->uuid.len && i < 16; i++) {
        osal_printk("%02X ", service->uuid.uuid[i]);
    }
    osal_printk("\r\n");

    if (my63_uuid_match(&service->uuid, g_my63_service_uuid, MY63_SERVICE_UUID_16) == 0) {
        osal_printk("[WS63_NET] ssap service uuid not matched\r\n");
        return;
    }

    osal_printk("[WS63_NET] ssap service MATCHED start=0x%04x end=0x%04x\r\n",
        service->start_hdl, service->end_hdl);
    g_my63_find_service_result.start_hdl = service->start_hdl;
    g_my63_find_service_result.end_hdl = service->end_hdl;
    (void)memcpy_s(&g_my63_find_service_result.uuid, sizeof(sle_uuid_t), &service->uuid, sizeof(sle_uuid_t));
}

static void my63_ssap_find_structure_cmp_cb(uint8_t client_id, uint16_t conn_id,
    ssapc_find_structure_result_t *structure_result, errcode_t status)
{
    ssapc_find_structure_param_t prop_param = {0};

    if (structure_result == NULL) {
        osal_printk("[WS63_NET] ssap find structure cmp null result\r\n");
        return;
    }

    osal_printk("[WS63_NET] ssap find structure cmp client_id=%u conn_id=%u status=0x%x type=%u uuid_len=%u\r\n",
        client_id, conn_id, status, structure_result->type, structure_result->uuid.len);
    if (status != ERRCODE_SLE_SUCCESS) {
        osal_printk("[WS63_NET] ssap find structure cmp FAILED status=0x%x\r\n", status);
        return;
    }

    if (g_my63_find_service_result.start_hdl == 0 || g_my63_find_service_result.end_hdl == 0) {
        osal_printk("[WS63_NET] ssap service range invalid start=0x%04x end=0x%04x, skip property discovery\r\n",
            g_my63_find_service_result.start_hdl, g_my63_find_service_result.end_hdl);
        return;
    }

    osal_printk("[WS63_NET] ssap find property start_hdl=0x%04x end_hdl=0x%04x\r\n",
        g_my63_find_service_result.start_hdl, g_my63_find_service_result.end_hdl);
    prop_param.start_hdl = g_my63_find_service_result.start_hdl;
    prop_param.end_hdl = g_my63_find_service_result.end_hdl;
    prop_param.type = SSAP_FIND_TYPE_PROPERTY;
    errcode_t ret = ssapc_find_structure(0, conn_id, &prop_param);
    osal_printk("[WS63_NET] ssapc_find_structure(property) ret=0x%x\r\n", ret);
}

static void my63_write_cccd(void)
{
    ssapc_write_param_t param = {0};
    static uint8_t cccd_val[2] = {0x01, 0x00};
    errcode_t ret;

    if (g_my63_conn_id == 0 || g_my63_property_handle == 0) {
        osal_printk("[WS63_NET] write_cccd skip: conn_id=%u handle=0x%04x\r\n",
            g_my63_conn_id, g_my63_property_handle);
        return;
    }

    param.handle = g_my63_property_handle;
    param.type = SSAP_DESCRIPTOR_CLIENT_CONFIGURATION;
    param.data_len = 2;
    param.data = cccd_val;

    osal_printk("[WS63_NET] write_cccd handle=0x%04x data=[0x01,0x00] conn_id=%u\r\n",
        g_my63_property_handle, g_my63_conn_id);
    ret = ssapc_write_req(0, g_my63_conn_id, &param);
    if (ret != ERRCODE_SLE_SUCCESS) {
        osal_printk("[WS63_NET] write_cccd failed ret=0x%x\r\n", ret);
        return;
    }
    osal_printk("[WS63_NET] write_cccd req sent ok\r\n");
}

static void my63_ssap_find_property_cb(uint8_t client_id, uint16_t conn_id,
    ssapc_find_property_result_t *property, errcode_t status)
{
    if (property == NULL) {
        osal_printk("[WS63_NET] ssap find property null property\r\n");
        return;
    }

    osal_printk("[WS63_NET] ssap find property client_id=%u conn_id=%u status=0x%x handle=0x%04x descriptors=%u uuid_len=%u uuid: ",
        client_id, conn_id, status, property->handle, property->descriptors_count, property->uuid.len);
    for (uint8_t i = 0; i < property->uuid.len && i < 16; i++) {
        osal_printk("%02X ", property->uuid.uuid[i]);
    }
    osal_printk("\r\n");

    if (status != ERRCODE_SLE_SUCCESS) {
        osal_printk("[WS63_NET] ssap find property FAILED status=0x%x\r\n", status);
        return;
    }

    if (my63_uuid_match(&property->uuid, g_my63_property_uuid, MY63_PROPERTY_UUID_16) == 0) {
        osal_printk("[WS63_NET] ssap property uuid not matched\r\n");
        return;
    }

    g_my63_property_handle = property->handle;
    g_my63_ssap_ready = 1;
    osal_printk("[WS63_NET] ssap property MATCHED handle=0x%04x operate_indication=0x%x\r\n",
        property->handle, property->operate_indication);

    if (property->operate_indication & SSAP_OPERATE_INDICATION_BIT_NOTIFY) {
        osal_printk("[WS63_NET] property supports NOTIFY, writing CCCD\r\n");
        my63_write_cccd();
    } else {
        osal_printk("[WS63_NET] property does NOT support NOTIFY, skip CCCD\r\n");
    }
}

static void my63_ssap_write_cfm_cb(uint8_t client_id, uint16_t conn_id, ssapc_write_result_t *write_result,
    errcode_t status)
{
    unused(client_id);
    unused(conn_id);

    if (write_result == NULL) {
        osal_printk("[WS63_NET] ssap write cfm null result status=0x%x\r\n", status);
        return;
    }

    osal_printk("[WS63_NET] ssap write cfm handle=0x%04x type=%u len=%u status=0x%x\r\n",
        write_result->handle, (unsigned int)write_result->type,
        (unsigned int)write_result->data_len, status);

    if (write_result->type == SSAP_DESCRIPTOR_CLIENT_CONFIGURATION) {
        if (status == ERRCODE_SLE_SUCCESS) {
            g_my63_cccd_written = 1;
            osal_printk("[WS63_NET] CCCD write SUCCESS, Notify enabled\r\n");
        } else {
            osal_printk("[WS63_NET] CCCD write FAILED status=0x%x\r\n", status);
        }
    }
}

static void my63_ssap_read_cfm_cb(uint8_t client_id, uint16_t conn_id, ssapc_handle_value_t *read_data,
    errcode_t status)
{
    unused(client_id);
    unused(conn_id);
    unused(read_data);
    osal_printk("[WS63_NET] ssap read cfm status=0x%x\r\n", status);
}

static void my63_ssap_notification_cb(uint8_t client_id, uint16_t conn_id, ssapc_handle_value_t *data,
    errcode_t status)
{
    unused(client_id);
    unused(conn_id);

    if (data == NULL || data->data == NULL || data->data_len == 0) {
        osal_printk("[WS63_NET] notify null data status=0x%x\r\n", status);
        return;
    }

    if (status != ERRCODE_SLE_SUCCESS) {
        osal_printk("[WS63_NET] notify error status=0x%x\r\n", status);
        return;
    }

    osal_printk("[WS63_NET] notify recv handle=0x%04x len=%u cmd=0x%02X\r\n",
        data->handle, (unsigned int)data->data_len, data->data[0]);

    if (data->data_len < 1) {
        osal_printk("[WS63_NET] notify data too short len=%u\r\n",
            (unsigned int)data->data_len);
        return;
    }

    if (data->data[0] == SSAP_RSP_INVENTORY) {
        if (data->data_len < SSAP_INVENTORY_RSP_LEN) {
            osal_printk("[WS63_NET] inventory rsp too short len=%u expect>=%u\r\n",
                (unsigned int)data->data_len, (unsigned int)SSAP_INVENTORY_RSP_LEN);
            return;
        }
        ssap_inventory_rsp_t inv = {0};
        int ret = shared_protocol_unpack_inventory(data->data, data->data_len, &inv);
        if (ret == SHARED_PROTO_OK) {
            osal_printk("[WS63_NET] inventory rsp: tag=%u qty=%u status=%u bat=%u seq=%u\r\n",
                (unsigned int)inv.tag_id, (unsigned int)inv.qty,
                (unsigned int)inv.status, (unsigned int)inv.battery, (unsigned int)inv.seq);
            if (g_my63_notify_cb != NULL) {
                g_my63_notify_cb(&inv, NULL);
            }
        } else {
            osal_printk("[WS63_NET] inventory unpack failed ret=%d\r\n", ret);
        }
    } else if (data->data[0] == SSAP_RSP_BIND_OK || data->data[0] == SSAP_RSP_UNBIND_OK || data->data[0] == SSAP_RSP_BIND_FAIL) {
        if (data->data_len < SSAP_BIND_RSP_LEN) {
            osal_printk("[WS63_NET] bind rsp too short len=%u expect>=%u\r\n",
                (unsigned int)data->data_len, (unsigned int)SSAP_BIND_RSP_LEN);
            return;
        }
        ssap_bind_rsp_t bind = {0};
        int ret = shared_protocol_unpack_bind_rsp(data->data, data->data_len, &bind);
        if (ret == SHARED_PROTO_OK) {
            osal_printk("[WS63_NET] bind rsp: cmd=0x%02X tag=%u\r\n",
                bind.cmd, (unsigned int)bind.tag_id);
            if (g_my63_notify_cb != NULL) {
                g_my63_notify_cb(NULL, &bind);
            }
        } else {
            osal_printk("[WS63_NET] bind unpack failed ret=%d\r\n", ret);
        }
    } else {
        osal_printk("[WS63_NET] notify unknown cmd=0x%02X\r\n", data->data[0]);
    }
}

static void my63_ssap_indication_cb(uint8_t client_id, uint16_t conn_id, ssapc_handle_value_t *data,
    errcode_t status)
{
    unused(client_id);
    unused(conn_id);
    unused(data);
    osal_printk("[WS63_NET] indication status=0x%x (unused)\r\n", status);
}

static void my63_ssapc_register(void)
{
    g_my63_ssapc_cbk.exchange_info_cb = my63_ssap_exchange_info_cb;
    g_my63_ssapc_cbk.find_structure_cb = my63_ssap_find_structure_cb;
    g_my63_ssapc_cbk.find_structure_cmp_cb = my63_ssap_find_structure_cmp_cb;
    g_my63_ssapc_cbk.ssapc_find_property_cbk = my63_ssap_find_property_cb;
    g_my63_ssapc_cbk.write_cfm_cb = my63_ssap_write_cfm_cb;
    g_my63_ssapc_cbk.read_cfm_cb = my63_ssap_read_cfm_cb;
    g_my63_ssapc_cbk.notification_cb = my63_ssap_notification_cb;
    g_my63_ssapc_cbk.indication_cb = my63_ssap_indication_cb;
    ssapc_register_callbacks(&g_my63_ssapc_cbk);
    osal_printk("[WS63_NET] ssap callbacks registered\r\n");
}

int sle_network_init(void)
{
    osal_printk("[WS63_NET] init start\r\n");

    g_my63_target_found = 0;
    g_my63_connecting = 0;
    g_my63_connected = 0;
    g_my63_link_lost = 0;
    g_my63_authenticated = 0;
    g_my63_ssap_ready = 0;
    g_my63_property_handle = 0;
    g_my63_cccd_written = 0;
    g_my63_conn_id = 0;
    g_my63_scan_result_count = 0;
    g_my63_scan_active = 0;
    memset_s(&g_my63_target_addr, sizeof(sle_addr_t), 0, sizeof(sle_addr_t));
    memset_s(&g_my63_find_service_result, sizeof(ssapc_find_service_result_t), 0,
        sizeof(ssapc_find_service_result_t));

    g_my63_seek_cbk.sle_enable_cb = my63_sle_enable_cb;
    g_my63_seek_cbk.seek_enable_cb = my63_seek_enable_cb;
    g_my63_seek_cbk.seek_disable_cb = my63_seek_disable_cb;
    g_my63_seek_cbk.seek_result_cb = my63_seek_result_cb;

    g_my63_conn_cbk.connect_state_changed_cb = my63_connect_state_changed_cb;
    g_my63_conn_cbk.auth_complete_cb = my63_auth_complete_cb;
    g_my63_conn_cbk.pair_complete_cb = my63_pair_complete_cb;

    osal_printk("[WS63_NET] register announce/seek callbacks start\r\n");
    sle_announce_seek_register_callbacks(&g_my63_seek_cbk);
    osal_printk("[WS63_NET] register announce/seek callbacks done\r\n");

    osal_printk("[WS63_NET] register connection callbacks start\r\n");
    sle_connection_register_callbacks(&g_my63_conn_cbk);
    osal_printk("[WS63_NET] register connection callbacks done\r\n");

    my63_ssapc_register();

    osal_printk("[WS63_NET] enable_sle start\r\n");
    enable_sle();
    osal_printk("[WS63_NET] enable_sle done (async wait callback)\r\n");

    osal_printk("[WS63_NET] init done\r\n");
    return 0;
}