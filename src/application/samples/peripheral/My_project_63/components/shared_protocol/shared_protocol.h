#ifndef MY63_SHARED_PROTOCOL_H
#define MY63_SHARED_PROTOCOL_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct __attribute__((packed)) {
    uint32_t magic;
    uint16_t tag_id;
    uint16_t qty;
    uint8_t status;
    uint8_t battery;
    uint16_t seq;
} shared_proto_adv_field_t;

#define SHARED_PROTO_ADV_FIELD_LEN 12U
#define SHARED_PROTO_MAGIC 0xAABBCCDDU

_Static_assert(sizeof(shared_proto_adv_field_t) == SHARED_PROTO_ADV_FIELD_LEN,
    "shared_proto_adv_field_t must be 12 bytes");

typedef enum {
    SHARED_PROTO_OK = 0,
    SHARED_PROTO_ERR_NULL = -1,
    SHARED_PROTO_ERR_LEN = -2,
    SHARED_PROTO_ERR_MAGIC = -3,
    SHARED_PROTO_ERR_RANGE = -4,
    SHARED_PROTO_ERR_CMD = -5
} shared_proto_ret_t;

#define SSAP_CMD_STOP_FIND      0x00
#define SSAP_CMD_FIND           0x01
#define SSAP_CMD_INVENTORY      0x02
#define SSAP_CMD_UPDATE_QTY     0x10
#define SSAP_CMD_BIND_TAG       0x20

#define SSAP_RSP_INVENTORY      0x82
#define SSAP_RSP_BIND_OK        0xA0
#define SSAP_RSP_BIND_FAIL      0xAF

#define SSAP_CCCD_NOTIFY_EN     0x0001

typedef struct __attribute__((packed)) {
    uint8_t  cmd;
    uint16_t tag_id;
    uint16_t qty;
    uint8_t  status;
    uint8_t  battery;
    uint16_t seq;
} ssap_inventory_rsp_t;

#define SSAP_INVENTORY_RSP_LEN 9U

_Static_assert(sizeof(ssap_inventory_rsp_t) == SSAP_INVENTORY_RSP_LEN,
    "ssap_inventory_rsp_t must be 9 bytes");

typedef struct __attribute__((packed)) {
    uint8_t  cmd;
    uint16_t tag_id;
} ssap_bind_rsp_t;

#define SSAP_BIND_RSP_LEN 3U

_Static_assert(sizeof(ssap_bind_rsp_t) == SSAP_BIND_RSP_LEN,
    "ssap_bind_rsp_t must be 3 bytes");

int shared_protocol_init(void);
int shared_protocol_pack_adv(const shared_proto_adv_field_t *field, uint8_t *out_buf, uint16_t out_len);
int shared_protocol_unpack_adv(const uint8_t *in_buf, uint16_t in_len, shared_proto_adv_field_t *field);
int shared_protocol_validate(const shared_proto_adv_field_t *field);
int shared_protocol_unpack_inventory(const uint8_t *buf, uint16_t len, ssap_inventory_rsp_t *out);
int shared_protocol_unpack_bind_rsp(const uint8_t *buf, uint16_t len, ssap_bind_rsp_t *out);
int shared_protocol_pack_write_cmd(uint8_t cmd, uint16_t param, uint8_t *out_buf, uint16_t out_len);

#ifdef __cplusplus
}
#endif

#endif
