#include "sle_network.h"
#include "soc_osal.h"
#include "securec.h"
#include "common_def.h"

#include "sle_device_discovery.h"
#include "sle_connection_manager.h"
#include "sle_errcode.h"
#include "sle_ssap_client.h"

#define SLE_MTU_SIZE_DEFAULT        1500
#define MY63_SLE_SEEK_INTERVAL_DEFAULT 100
#define MY63_SLE_SEEK_WINDOW_DEFAULT   100
#define MY63_SLE_SCAN_PHY_NUM          1
#define MY63_SLE_DEFAULT_CONN_INTERVAL  0x14
#define MY63_SLE_DEFAULT_TIMEOUT        0x1f4
#define MY63_SLE_DEFAULT_SCAN_INTERVAL   400
#define MY63_SLE_DEFAULT_SCAN_WINDOW     20

static sle_announce_seek_callbacks_t g_my63_seek_cbk = {0};
static sle_connection_callbacks_t g_my63_conn_cbk = {0};
static ssapc_callbacks_t g_my63_ssapc_cbk = {0};
static sle_addr_t g_my63_target_addr = {0};
static int g_my63_target_found = 0;
static int g_my63_connecting = 0;
static int g_my63_connected = 0;
static int g_my63_authenticated = 0;
static uint16_t g_my63_conn_id = 0;
static ssapc_find_service_result_t g_my63_find_service_result = {0};

static int my63_sle_is_target_mac(const uint8_t *addr)
{
    const uint8_t target_mac[SLE_ADDR_LEN] = {0x11, 0x22, 0x33, 0x44, 0x55, 0x66};

    if (addr == NULL) {
        return 0;
    }

    return (memcmp(addr, target_mac, SLE_ADDR_LEN) == 0) ? 1 : 0;
}

static void my63_restart_scan_after_security_fail(const sle_addr_t *addr, const char *reason)
{
    osal_printk("[WS63_NET] %s, remove pair and restart scan\r\n", reason);
    if (addr != NULL) {
        sle_remove_paired_remote_device(addr);
    }

    g_my63_connecting = 0;
    g_my63_connected = 0;
    g_my63_authenticated = 0;
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
    param.seek_type[0] = 0;
    param.seek_interval[0] = MY63_SLE_SEEK_INTERVAL_DEFAULT;
    param.seek_window[0] = MY63_SLE_SEEK_WINDOW_DEFAULT;

    ret = sle_set_seek_param(&param);
    osal_printk("[WS63_NET] sle_set_seek_param ret=0x%x\r\n", ret);
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

    osal_printk("[WS63_NET] sle_network_start_scan done\r\n");
    return 0;
}

int sle_network_stop_scan(void)
{
    errcode_t ret;

    osal_printk("[WS63_NET] sle_network_stop_scan start\r\n");
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

int sle_network_is_authenticated(void)
{
    return g_my63_authenticated;
}

const sle_addr_t *sle_network_get_target_addr(void)
{
    return &g_my63_target_addr;
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
        my63_start_ssap_exchange();
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
        g_my63_authenticated = 0;
        g_my63_conn_id = conn_id;
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
        g_my63_authenticated = 0;
        osal_printk("[WS63_NET] disconnected, reason=%d\r\n", disc_reason);
        (void)sle_network_start_scan();
    }
}

static void my63_seek_result_cb(sle_seek_result_info_t *seek_result_data)
{
    errno_t ret;

    if (seek_result_data == NULL) {
        osal_printk("[WS63_NET] my63_seek_result_cb null result\r\n");
        return;
    }

    osal_printk("[WS63_NET] seek result rssi=%d, addr=%02x:%02x:%02x:%02x:%02x:%02x\r\n",
        (int)seek_result_data->rssi,
        seek_result_data->addr.addr[0],
        seek_result_data->addr.addr[1],
        seek_result_data->addr.addr[2],
        seek_result_data->addr.addr[3],
        seek_result_data->addr.addr[4],
        seek_result_data->addr.addr[5]);

    if (my63_sle_is_target_mac(seek_result_data->addr.addr) == 0) {
        return;
    }

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

    osal_printk("[WS63_NET] ssap exchange info client_id=%u conn_id=%u status=0x%x mtu=%u version=%u\r\n",
        client_id, conn_id, status, param->mtu_size, param->version);
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
    if (service == NULL) {
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

    osal_printk("[WS63_NET] ssap find structure cmp client_id=%u conn_id=%u status=0x%x type=%u uuid_len=%u\r\n",
        client_id, conn_id, status, structure_result->type, structure_result->uuid.len);
    prop_param.start_hdl = g_my63_find_service_result.start_hdl;
    prop_param.end_hdl = g_my63_find_service_result.end_hdl;
    prop_param.type = SSAP_FIND_TYPE_PROPERTY;
    ssapc_find_structure(0, conn_id, &prop_param);
}

static void my63_ssap_find_property_cb(uint8_t client_id, uint16_t conn_id,
    ssapc_find_property_result_t *property, errcode_t status)
{
    osal_printk("[WS63_NET] ssap find property client_id=%u conn_id=%u status=0x%x descriptors=%u\r\n",
        client_id, conn_id, status, property->descriptors_count);
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
    g_my63_authenticated = 0;
    memset_s(&g_my63_target_addr, sizeof(sle_addr_t), 0, sizeof(sle_addr_t));

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