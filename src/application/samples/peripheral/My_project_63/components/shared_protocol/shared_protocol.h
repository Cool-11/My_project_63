#ifndef MY63_SHARED_PROTOCOL_H
#define MY63_SHARED_PROTOCOL_H

#include <stdint.h>
#include <stdbool.h>

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
#define SHARED_PROTO_MAGIC_BE 0xDDCCBBAA

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
#define SSAP_CMD_UNBIND_TAG     0x21

#define SSAP_RSP_INVENTORY      0x82
#define SSAP_RSP_BIND_OK        0xA0
#define SSAP_RSP_UNBIND_OK      0xA1
#define SSAP_RSP_BIND_FAIL      0xAF  /* bind/unbind 失败复用 */

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

/* ========== 扫描表 + 白名单 packed 结构体 ========== */

/* SLE 广播原始消息（入队用，约 80B） */
#define SLE_ADV_RAW_MAX  64

struct __attribute__((packed)) sle_adv_msg {
    uint8_t  raw[SLE_ADV_RAW_MAX];  /* 原始广播字节 */
    uint16_t raw_len;                /* 有效字节长度 */
    uint8_t  addr[6];               /* 发送方 MAC */
    int8_t   rssi;                  /* 信号强度 */
    uint64_t ts_ms;                 /* 入队时间戳 */
};

/* 扫描表条目（21B，精准无浪费） */
struct __attribute__((packed)) TagState {
    uint16_t tag_id;        /* 2B */
    uint8_t  mac[6];        /* 6B */
    uint8_t  battery;       /* 1B */
    uint16_t qty;           /* 2B */
    uint8_t  status;        /* 1B: 0=空闲 1=寻物 2=使用中 3=未配网 */
    uint64_t last_seen_ms;  /* 8B */
    bool     used;          /* 1B */
};  /* 总计 21B */

_Static_assert(sizeof(struct TagState) == 21, "TagState must be 21 bytes");

/* 白名单 + 去重条目（27B） */
#define TAG_LIST_MAX  32

struct __attribute__((packed)) TagListEntry {
    uint8_t  mac[6];            /* 6B — 主键 */
    uint16_t tag_id;            /* 2B */
    uint64_t last_publish_ms;   /* 8B — 上次 MQTT 上云时间戳 */
    uint64_t last_seen_ms;      /* 8B — 最后扫描时间戳 */
    int8_t   rssi;              /* 1B */
    bool     whitelisted;       /* 1B — 是否已注册 */
    bool     used;              /* 1B — 条目有效 */
};  /* 27B × 32 = 864B */

_Static_assert(sizeof(struct TagListEntry) == 27, "TagListEntry must be 27 bytes");

/* 去重窗口（毫秒） */
#define DEDUP_WINDOW_MS  3000

#ifdef __cplusplus
}
#endif

#endif
