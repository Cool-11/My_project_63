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
    SHARED_PROTO_ERR_RANGE = -4
} shared_proto_ret_t;

int shared_protocol_init(void);
int shared_protocol_pack_adv(const shared_proto_adv_field_t *field, uint8_t *out_buf, uint16_t out_len);
int shared_protocol_unpack_adv(const uint8_t *in_buf, uint16_t in_len, shared_proto_adv_field_t *field);
int shared_protocol_validate(const shared_proto_adv_field_t *field);

#ifdef __cplusplus
}
#endif

#endif
