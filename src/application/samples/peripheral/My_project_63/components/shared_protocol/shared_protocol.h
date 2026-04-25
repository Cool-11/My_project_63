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

int shared_protocol_init(void);

#ifdef __cplusplus
}
#endif

#endif
