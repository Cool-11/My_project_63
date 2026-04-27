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

int shared_protocol_validate(const shared_proto_adv_field_t *field)
{
    if (field == NULL) {
        osal_printk("[WS63_SHARED] validate failed: null field\r\n");
        return SHARED_PROTO_ERR_NULL;
    }

    if (field->magic != SHARED_PROTO_MAGIC) {
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
    field->tag_id = read_le16(&in_buf[4]);
    field->qty = read_le16(&in_buf[6]);
    field->status = in_buf[8];
    field->battery = in_buf[9];
    field->seq = read_le16(&in_buf[10]);

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
