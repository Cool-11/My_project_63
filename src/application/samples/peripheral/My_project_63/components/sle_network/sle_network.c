#include "sle_network.h"
#include "soc_osal.h"
#include "securec.h"
#include "common_def.h"
#include <string.h>

#include "sle_device_discovery.h"
#include "sle_connection_manager.h"
#include "sle_errcode.h"
#include "sle_ssap_client.h"
#include "../shared_protocol/shared_protocol.h"

#define SLE_MTU_SIZE_DEFAULT        1500
#define MY63_SLE_SEEK_INTERVAL_DEFAULT 100
#define MY63_SLE_SEEK_WINDOW_DEFAULT   100
#define MY63_SLE_SCAN_PHY_NUM          1
#define MY63_SLE_DEFAULT_CONN_INTERVAL  0x14
#define MY63_SLE_DEFAULT_TIMEOUT        0x1f4
#define MY63_SLE_DEFAULT_SCAN_INTERVAL   400
#define MY63_SLE_DEFAULT_SCAN_WINDOW     20
#define MY63_ADV_FIELD_TYPE_MANUFACTURER 0xFF
#define MY63_ADV_FIELD_TYPE_COMPLETE_NAME 0x09
#define MY63_TARGET_TAG_ID               0
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
static volatile uint32_t g_my63_scan_result_count = 0;
static volatile int g_my63_scan_active = 0;

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

        if (field_len == 0 || (uint8_t)(offset + field_len) >= length + 1U) {
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

        if (field_len == 0 || (uint8_t)(offset + field_len) >= length + 1U) {
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

        if (field_type == MY63_ADV_FIELD_TYPE_MANUFACTURER && field_data_len == SHARED_PROTO_ADV_FIELD_LEN) {
            if (shared_protocol_unpack_adv(&data[offset + 2U], field_data_len, out_field) == SHARED_PROTO_OK) {
                return 1;
            }
            osal_printk("[WS63_NET] manufacturer field found but unpack/magic failed, first 4 bytes: %02X %02X %02X %02X\r\n",
                data[offset + 2U], data[offset + 3U], data[offset + 4U], data[offset + 5U]);
        } else if (field_type == MY63_ADV_FIELD_TYPE_MANUFACTURER) {
            osal_printk("[WS63_NET] manufacturer field type=0xFF but data_len=%u expect=%u\r\n",
                (unsigned int)field_data_len, (unsigned int)SHARED_PROTO_ADV_FIELD_LEN);
        }

        offset = (uint8_t)(offset + field_len + 1U);
    }

    return 0;
}

static int my63_uuid_match(const sle_uuid_t *uuid, const uint8_t *uuid_128, uint16_t u16)
{
    if (uuid == NULL) {
        return 0;
    }

    if (uuid->len == MY63_UUID_128BIT_LEN && uuid_128 != NULL) {
        if (memcmp(uuid->uuid, uuid_128, MY63_UUID_128BIT_LEN) == 0) {
            return 1;
        }
    }

    if (uuid->len == MY63_UUID_16BIT_LEN) {
        uint16_t got = (uint16_t)(uuid->uuid[MY63_UUID_INDEX] |
            ((uint16_t)uuid->uuid[MY63_UUID_INDEX + 1U] << 8));
        return (got == u16) ? 1 : 0;
    }

    return 0;
}

static void my63_restart_scan_after_security_fail(const sle_addr_t *addr, const char *reason)
{
    osal_printk("[WS63_NET] %s, remove pair and restart scan\r\n", reason);
    if (addr != NULL) {
        sle_remove_paired_remote_device(addr);
    }

    g_my63_connecting = 0;
    g_my63_connected = 0;
    g_my63_link_lost = 0;
    g_my63_authenticated = 0;
    g_my63_ssap_ready = 0;
    g_my63_property_handle = 0;
    (void)memset_s(&g_my63_find_service_result, sizeof(ssapc_find_service_result_t), 0,
        sizeof(ssapc_find_service_result_t));
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

    if (g_my63_connected == 0 || g_my63_conn_id == 0) {
        osal_printk("[WS63_NET] skip ssap exchange connected=%d conn_id=%u\r\n",
            g_my63_connected, g_my63_conn_id);
        return;
    }

    info.mtu_size = SLE_MTU_SIZE_DEFAULT;
    info.version = 1;
    osal_printk("[WS63_NET] request ssap exchange info conn_id=%u\r\n", g_my63_conn_id);
    ssapc_exchange_info_req(1, g_my63_conn_id, &info);
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
    return (g_my63_ssap_ready != 0 && g_my63_property_handle != 0) ? 1 : 0;
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

static void my63_sle_enable_cb(errcode_t status)
{
    osal_printk("[WS63_NET] my63_sle_enable_cb status=0x%x\r\n", status);
    if (status != ERRCODE_SLE_SUCCESS) {
        osal_printk("[WS63_NET] sle enable failed\r\n");
        return;
    }

    {
        uint8_t local_addr[SLE_ADDR_LEN] = {0x13, 0x67, 0x5c, 0x07, 0x00, 0x51};
        sle_addr_t local_address;

        local_address.type = 0;
        (void)memcpy_s(local_address.addr, SLE_ADDR_LEN, local_addr, SLE_ADDR_LEN);
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
    osal_printk("[WS63_NET] conn state change conn_id=%u state=%d pair=%d reason=%d\r\n",
        conn_id, conn_state, pair_state, disc_reason);

    if (conn_state == SLE_ACB_STATE_CONNECTED) {
        g_my63_connected = 1;
        g_my63_connecting = 0;
        g_my63_link_lost = 0;
        g_my63_authenticated = 0;
        g_my63_ssap_ready = 0;
        g_my63_property_handle = 0;
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
        g_my63_property_handle = 0;
        (void)memset_s(&g_my63_find_service_result, sizeof(ssapc_find_service_result_t), 0,
            sizeof(ssapc_find_service_result_t));
        osal_printk("[WS63_NET] disconnected, reason=%d\r\n", disc_reason);
        (void)sle_network_start_scan();
    }
}

static void my63_seek_result_cb(sle_seek_result_info_t *seek_result_data)
{
    errno_t ret;
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
        if (name_matched) {
            osal_printk("[WS63_NET] local_name matched but manufacturer data invalid, connect by name\r\n");
            ret = memcpy_s(&g_my63_target_addr, sizeof(sle_addr_t), &seek_result_data->addr, sizeof(sle_addr_t));
            if (ret != EOK) {
                osal_printk("[WS63_NET] target address copy failed ret=%d\r\n", (int)ret);
                return;
            }
            g_my63_target_found = 1;
            (void)sle_network_stop_scan();
            if (!g_my63_connecting && !g_my63_connected) {
                g_my63_connecting = 1;
                osal_printk("[WS63_NET] connect target (by name) addr=%02x:%02x:%02x:%02x:%02x:%02x\r\n",
                    g_my63_target_addr.addr[0], g_my63_target_addr.addr[1], g_my63_target_addr.addr[2],
                    g_my63_target_addr.addr[3], g_my63_target_addr.addr[4], g_my63_target_addr.addr[5]);
                (void)sle_connect_remote_device(&g_my63_target_addr);
            }
            return;
        }
        osal_printk("[WS63_NET] adv payload not matched or magic invalid\r\n");
        return;
    }

    if (adv.tag_id != MY63_TARGET_TAG_ID) {
        osal_printk("[WS63_NET] adv tag_id mismatch=%u\r\n", (unsigned int)adv.tag_id);
        return;
    }

    osal_printk("[WS63_NET] adv matched tag=%u qty=%u status=%u bat=%u seq=%u name_match=%d\r\n",
        (unsigned int)adv.tag_id,
        (unsigned int)adv.qty,
        (unsigned int)adv.status,
        (unsigned int)adv.battery,
        (unsigned int)adv.seq,
        name_matched);

    osal_printk("[WS63_NET] target broadcast matched, stopping scan\r\n");
    ret = memcpy_s(&g_my63_target_addr, sizeof(sle_addr_t), &seek_result_data->addr, sizeof(sle_addr_t));
    if (ret != EOK) {
        osal_printk("[WS63_NET] target address copy failed ret=%d\r\n", (int)ret);
        return;
    }

    g_my63_target_found = 1;
    (void)sle_network_stop_scan();

    if (!g_my63_connecting && !g_my63_connected) {
        g_my63_connecting = 1;
        osal_printk("[WS63_NET] connect target addr=%02x:%02x:%02x:%02x:%02x:%02x\r\n",
            g_my63_target_addr.addr[0], g_my63_target_addr.addr[1], g_my63_target_addr.addr[2],
            g_my63_target_addr.addr[3], g_my63_target_addr.addr[4], g_my63_target_addr.addr[5]);
        (void)sle_connect_remote_device(&g_my63_target_addr);
    }
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
        return;
    }

    if (my63_uuid_match(&service->uuid, g_my63_service_uuid, MY63_SERVICE_UUID_16) == 0) {
        osal_printk("[WS63_NET] ssap service uuid not matched\r\n");
        return;
    }

    osal_printk("[WS63_NET] ssap service start=0x%04x end=0x%04x uuid_len=%u\r\n",
        service->start_hdl, service->end_hdl, service->uuid.len);
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
        return;
    }

    if (g_my63_find_service_result.start_hdl == 0 || g_my63_find_service_result.end_hdl == 0) {
        osal_printk("[WS63_NET] ssap service range invalid, skip property discovery\r\n");
        return;
    }

    prop_param.start_hdl = g_my63_find_service_result.start_hdl;
    prop_param.end_hdl = g_my63_find_service_result.end_hdl;
    prop_param.type = SSAP_FIND_TYPE_PROPERTY;
    ssapc_find_structure(0, conn_id, &prop_param);
}

static void my63_ssap_find_property_cb(uint8_t client_id, uint16_t conn_id,
    ssapc_find_property_result_t *property, errcode_t status)
{
    if (property == NULL) {
        osal_printk("[WS63_NET] ssap find property null property\r\n");
        return;
    }

    osal_printk("[WS63_NET] ssap find property client_id=%u conn_id=%u status=0x%x descriptors=%u\r\n",
        client_id, conn_id, status, property->descriptors_count);
    if (status != ERRCODE_SLE_SUCCESS) {
        return;
    }

    if (my63_uuid_match(&property->uuid, g_my63_property_uuid, MY63_PROPERTY_UUID_16) == 0) {
        osal_printk("[WS63_NET] ssap property uuid not matched\r\n");
        return;
    }

    g_my63_property_handle = property->handle;
    g_my63_ssap_ready = 1;
    osal_printk("[WS63_NET] ssap discovery ready handle=0x%04x\r\n", property->handle);
}

static void my63_ssap_write_cfm_cb(uint8_t client_id, uint16_t conn_id, ssapc_write_result_t *write_result,
    errcode_t status)
{
    unused(client_id);
    unused(conn_id);
    unused(write_result);
    osal_printk("[WS63_NET] ssap write cfm status=0x%x\r\n", status);
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
    unused(data);
    osal_printk("[WS63_NET] ssap notification status=0x%x\r\n", status);
}

static void my63_ssap_indication_cb(uint8_t client_id, uint16_t conn_id, ssapc_handle_value_t *data,
    errcode_t status)
{
    unused(client_id);
    unused(conn_id);
    unused(data);
    osal_printk("[WS63_NET] ssap indication status=0x%x\r\n", status);
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