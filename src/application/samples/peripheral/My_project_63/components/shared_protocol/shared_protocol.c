#include "shared_protocol.h"
#include "soc_osal.h"

static uint16_t read_le16(const uint8_t *buf)
{
    return (uint16_t)(buf[0] | ((uint16_t)buf[1] << 8));
}

static uint32_t read_le32(const uint8_t *buf)
{
    return (uint32_t)(buf[0] |
        ((uint32_t)buf[1] << 8) |
        ((uint32_t)buf[2] << 16) |
        ((uint32_t)buf[3] << 24));
}

static uint32_t read_be32(const uint8_t *buf)
{
    return (uint32_t)(((uint32_t)buf[0] << 24) |
        ((uint32_t)buf[1] << 16) |
        ((uint32_t)buf[2] << 8) |
        buf[3]);
}

static uint16_t read_be16(const uint8_t *buf)
{
    return (uint16_t)(((uint16_t)buf[0] << 8) | buf[1]);
}

static void write_le16(uint8_t *buf, uint16_t value)
{
    buf[0] = (uint8_t)(value & 0xFFU);
    buf[1] = (uint8_t)((value >> 8) & 0xFFU);
}

static void write_le32(uint8_t *buf, uint32_t value)
{
    buf[0] = (uint8_t)(value & 0xFFU);
    buf[1] = (uint8_t)((value >> 8) & 0xFFU);
    buf[2] = (uint8_t)((value >> 16) & 0xFFU);
    buf[3] = (uint8_t)((value >> 24) & 0xFFU);
}

static void write_be16(uint8_t *buf, uint16_t value)
{
    buf[0] = (uint8_t)((value >> 8) & 0xFFU);
    buf[1] = (uint8_t)(value & 0xFFU);
}

int shared_protocol_validate(const shared_proto_adv_field_t *field)
{
    if (field == NULL) {
        osal_printk("[WS63_SHARED] validate failed: null field\r\n");
        return SHARED_PROTO_ERR_NULL;
    }

    if (field->magic != SHARED_PROTO_MAGIC && field->magic != SHARED_PROTO_MAGIC_BE) {
        osal_printk("[WS63_SHARED] validate failed: bad magic=0x%08x\r\n", (unsigned int)field->magic);
        return SHARED_PROTO_ERR_MAGIC;
    }

    if (field->battery > 100U) {
        osal_printk("[WS63_SHARED] validate failed: battery out of range=%u\r\n", (unsigned int)field->battery);
        return SHARED_PROTO_ERR_RANGE;
    }

    return SHARED_PROTO_OK;
}

int shared_protocol_pack_adv(const shared_proto_adv_field_t *field, uint8_t *out_buf, uint16_t out_len)
{
    int ret;

    osal_printk("[WS63_SHARED] pack start\r\n");
    if ((field == NULL) || (out_buf == NULL)) {
        osal_printk("[WS63_SHARED] pack failed: null input\r\n");
        return SHARED_PROTO_ERR_NULL;
    }

    if (out_len < SHARED_PROTO_ADV_FIELD_LEN) {
        osal_printk("[WS63_SHARED] pack failed: out_len=%u < %u\r\n",
            (unsigned int)out_len, (unsigned int)SHARED_PROTO_ADV_FIELD_LEN);
        return SHARED_PROTO_ERR_LEN;
    }

    ret = shared_protocol_validate(field);
    if (ret != SHARED_PROTO_OK) {
        osal_printk("[WS63_SHARED] pack failed: validate ret=%d\r\n", ret);
        return ret;
    }

    write_le32(&out_buf[0], field->magic);
    write_le16(&out_buf[4], field->tag_id);
    write_le16(&out_buf[6], field->qty);
    out_buf[8] = field->status;
    out_buf[9] = field->battery;
    write_le16(&out_buf[10], field->seq);

    osal_printk("[WS63_SHARED] pack done: tag=%u qty=%u status=%u bat=%u seq=%u\r\n",
        (unsigned int)field->tag_id,
        (unsigned int)field->qty,
        (unsigned int)field->status,
        (unsigned int)field->battery,
        (unsigned int)field->seq);
    return SHARED_PROTO_OK;
}

int shared_protocol_unpack_adv(const uint8_t *in_buf, uint16_t in_len, shared_proto_adv_field_t *field)
{
    int ret;

    osal_printk("[WS63_SHARED] unpack start\r\n");
    if ((in_buf == NULL) || (field == NULL)) {
        osal_printk("[WS63_SHARED] unpack failed: null input\r\n");
        return SHARED_PROTO_ERR_NULL;
    }

    if (in_len != SHARED_PROTO_ADV_FIELD_LEN) {
        osal_printk("[WS63_SHARED] unpack failed: in_len=%u expect=%u\r\n",
            (unsigned int)in_len, (unsigned int)SHARED_PROTO_ADV_FIELD_LEN);
        return SHARED_PROTO_ERR_LEN;
    }

    field->magic = read_le32(&in_buf[0]);
    if (field->magic == SHARED_PROTO_MAGIC) {
        field->tag_id = read_le16(&in_buf[4]);
        field->qty = read_le16(&in_buf[6]);
        field->status = in_buf[8];
        field->battery = in_buf[9];
        field->seq = read_le16(&in_buf[10]);
        osal_printk("[WS63_SHARED] unpack LE ok\r\n");
    } else {
        uint32_t be_magic = read_be32(&in_buf[0]);
        osal_printk("[WS63_SHARED] LE magic=0x%08x mismatch, try BE raw=0x%08x\r\n",
            (unsigned int)field->magic, (unsigned int)be_magic);
        if (be_magic == SHARED_PROTO_MAGIC_BE) {
            field->magic = be_magic;
            field->tag_id = read_be16(&in_buf[4]);
            field->qty = read_be16(&in_buf[6]);
            field->status = in_buf[8];
            field->battery = in_buf[9];
            field->seq = read_be16(&in_buf[10]);
            osal_printk("[WS63_SHARED] unpack BE ok\r\n");
        } else {
            osal_printk("[WS63_SHARED] unpack failed: magic LE=0x%08x BE=0x%08x both mismatch\r\n",
                (unsigned int)field->magic, (unsigned int)be_magic);
            return SHARED_PROTO_ERR_MAGIC;
        }
    }

    ret = shared_protocol_validate(field);
    if (ret != SHARED_PROTO_OK) {
        osal_printk("[WS63_SHARED] unpack failed: validate ret=%d\r\n", ret);
        return ret;
    }

    osal_printk("[WS63_SHARED] unpack done: tag=%u qty=%u status=%u bat=%u seq=%u\r\n",
        (unsigned int)field->tag_id,
        (unsigned int)field->qty,
        (unsigned int)field->status,
        (unsigned int)field->battery,
        (unsigned int)field->seq);
    return SHARED_PROTO_OK;
}

int shared_protocol_init(void)
{
    uint8_t payload[SHARED_PROTO_ADV_FIELD_LEN] = {0};
    shared_proto_adv_field_t tx = {
        .magic = SHARED_PROTO_MAGIC,
        .tag_id = 1,
        .qty = 10,
        .status = 0,
        .battery = 100,
        .seq = 1
    };
    shared_proto_adv_field_t rx = {0};
    int ret;

    osal_printk("[WS63_SHARED] init start\r\n");
    osal_printk("[WS63_SHARED] struct size=%u\r\n", (unsigned int)sizeof(shared_proto_adv_field_t));
    osal_printk("[WS63_SHARED] default magic=0x%08x\r\n", (unsigned int)SHARED_PROTO_MAGIC);

    if (sizeof(shared_proto_adv_field_t) != SHARED_PROTO_ADV_FIELD_LEN) {
        osal_printk("[WS63_SHARED] init failed: packed size mismatch\r\n");
        return SHARED_PROTO_ERR_LEN;
    }

    ret = shared_protocol_pack_adv(&tx, payload, (uint16_t)sizeof(payload));
    osal_printk("[WS63_SHARED] selftest pack ret=%d\r\n", ret);
    if (ret != SHARED_PROTO_OK) {
        return ret;
    }

    ret = shared_protocol_unpack_adv(payload, (uint16_t)sizeof(payload), &rx);
    osal_printk("[WS63_SHARED] selftest unpack ret=%d\r\n", ret);
    if (ret != SHARED_PROTO_OK) {
        return ret;
    }

    osal_printk("[WS63_SHARED] init done\r\n");
    return SHARED_PROTO_OK;
}

int shared_protocol_unpack_inventory(const uint8_t *buf, uint16_t len, ssap_inventory_rsp_t *out)
{
    osal_printk("[WS63_SHARED] unpack_inventory start\r\n");
    if ((buf == NULL) || (out == NULL)) {
        osal_printk("[WS63_SHARED] unpack_inventory failed: null input\r\n");
        return SHARED_PROTO_ERR_NULL;
    }

    if (len < SSAP_INVENTORY_RSP_LEN) {
        osal_printk("[WS63_SHARED] unpack_inventory failed: len=%u expect>=%u\r\n",
            (unsigned int)len, (unsigned int)SSAP_INVENTORY_RSP_LEN);
        return SHARED_PROTO_ERR_LEN;
    }

    if (buf[0] != SSAP_RSP_INVENTORY) {
        osal_printk("[WS63_SHARED] unpack_inventory failed: cmd=0x%02X expect=0x%02X\r\n",
            buf[0], SSAP_RSP_INVENTORY);
        return SHARED_PROTO_ERR_CMD;
    }

    out->cmd = buf[0];
    out->tag_id = read_be16(&buf[1]);
    out->qty = read_be16(&buf[3]);
    out->status = buf[5];
    out->battery = buf[6];
    out->seq = read_be16(&buf[7]);

    osal_printk("[WS63_SHARED] unpack_inventory done: tag=%u qty=%u status=%u bat=%u seq=%u\r\n",
        (unsigned int)out->tag_id, (unsigned int)out->qty,
        (unsigned int)out->status, (unsigned int)out->battery, (unsigned int)out->seq);
    return SHARED_PROTO_OK;
}

int shared_protocol_unpack_bind_rsp(const uint8_t *buf, uint16_t len, ssap_bind_rsp_t *out)
{
    osal_printk("[WS63_SHARED] unpack_bind_rsp start\r\n");
    if ((buf == NULL) || (out == NULL)) {
        osal_printk("[WS63_SHARED] unpack_bind_rsp failed: null input\r\n");
        return SHARED_PROTO_ERR_NULL;
    }

    if (len < SSAP_BIND_RSP_LEN) {
        osal_printk("[WS63_SHARED] unpack_bind_rsp failed: len=%u expect>=%u\r\n",
            (unsigned int)len, (unsigned int)SSAP_BIND_RSP_LEN);
        return SHARED_PROTO_ERR_LEN;
    }

    if (buf[0] != SSAP_RSP_BIND_OK && buf[0] != SSAP_RSP_BIND_FAIL) {
        osal_printk("[WS63_SHARED] unpack_bind_rsp failed: cmd=0x%02X expect 0xA0/0xAF\r\n", buf[0]);
        return SHARED_PROTO_ERR_CMD;
    }

    out->cmd = buf[0];
    out->tag_id = read_be16(&buf[1]);

    osal_printk("[WS63_SHARED] unpack_bind_rsp done: cmd=0x%02X tag=%u %s\r\n",
        out->cmd, (unsigned int)out->tag_id,
        (out->cmd == SSAP_RSP_BIND_OK) ? "OK" : "FAIL");
    return SHARED_PROTO_OK;
}

int shared_protocol_pack_write_cmd(uint8_t cmd, uint16_t param, uint8_t *out_buf, uint16_t out_len)
{
    osal_printk("[WS63_SHARED] pack_write_cmd start cmd=0x%02X param=%u\r\n",
        (unsigned int)cmd, (unsigned int)param);
    if (out_buf == NULL) {
        osal_printk("[WS63_SHARED] pack_write_cmd failed: null output\r\n");
        return SHARED_PROTO_ERR_NULL;
    }

    if (cmd == SSAP_CMD_FIND || cmd == SSAP_CMD_STOP_FIND || cmd == SSAP_CMD_INVENTORY) {
        if (out_len < 1) {
            osal_printk("[WS63_SHARED] pack_write_cmd failed: out_len=%u need 1\r\n", (unsigned int)out_len);
            return SHARED_PROTO_ERR_LEN;
        }
        out_buf[0] = cmd;
        osal_printk("[WS63_SHARED] pack_write_cmd done: [0x%02X] 1-byte cmd\r\n", cmd);
        return 1;
    }

    if (cmd == SSAP_CMD_UPDATE_QTY || cmd == SSAP_CMD_BIND_TAG) {
        if (out_len < 3) {
            osal_printk("[WS63_SHARED] pack_write_cmd failed: out_len=%u need 3\r\n", (unsigned int)out_len);
            return SHARED_PROTO_ERR_LEN;
        }
        out_buf[0] = cmd;
        write_be16(&out_buf[1], param);
        osal_printk("[WS63_SHARED] pack_write_cmd done: [0x%02X 0x%02X 0x%02X] 3-byte cmd+param\r\n",
            cmd, out_buf[1], out_buf[2]);
        return 3;
    }

    osal_printk("[WS63_SHARED] pack_write_cmd failed: unknown cmd=0x%02X\r\n", (unsigned int)cmd);
    return SHARED_PROTO_ERR_CMD;
}
