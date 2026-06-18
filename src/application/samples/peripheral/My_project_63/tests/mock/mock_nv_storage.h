#ifndef MOCK_NV_STORAGE_H
#define MOCK_NV_STORAGE_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

/* ========== Mock LiteOS 类型 ========== */
typedef int errcode_t;
#define ERRCODE_SUCC 0

/* ========== Mock NV 存储 ========== */
#define MOCK_NV_MAX_ENTRIES 16
#define MOCK_NV_MAX_DATA_SIZE 2048

typedef struct {
    uint16_t key;
    uint8_t data[MOCK_NV_MAX_DATA_SIZE];
    uint16_t data_len;
    bool used;
} mock_nv_entry_t;

static mock_nv_entry_t g_mock_nv[MOCK_NV_MAX_ENTRIES];

/* Mock 函数：重置 */
static inline void mock_nv_reset(void) {
    memset(g_mock_nv, 0, sizeof(g_mock_nv));
}

/* Mock API：NV 写入 */
static inline errcode_t uapi_nv_write(uint16_t key, const uint8_t *data, uint16_t len) {
    if (data == NULL || len == 0 || len > MOCK_NV_MAX_DATA_SIZE) {
        return -1;
    }
    for (int i = 0; i < MOCK_NV_MAX_ENTRIES; i++) {
        if (g_mock_nv[i].used && g_mock_nv[i].key == key) {
            memcpy(g_mock_nv[i].data, data, len);
            g_mock_nv[i].data_len = len;
            return ERRCODE_SUCC;
        }
    }
    for (int i = 0; i < MOCK_NV_MAX_ENTRIES; i++) {
        if (!g_mock_nv[i].used) {
            g_mock_nv[i].used = true;
            g_mock_nv[i].key = key;
            memcpy(g_mock_nv[i].data, data, len);
            g_mock_nv[i].data_len = len;
            return ERRCODE_SUCC;
        }
    }
    return -1;
}

/* Mock API：NV 读取 */
static inline errcode_t uapi_nv_read(uint16_t key, uint16_t len,
    uint8_t *data, uint16_t *out_len) {
    if (data == NULL || out_len == NULL) {
        return -1;
    }
    for (int i = 0; i < MOCK_NV_MAX_ENTRIES; i++) {
        if (g_mock_nv[i].used && g_mock_nv[i].key == key) {
            if (len < g_mock_nv[i].data_len) {
                return -1;
            }
            memcpy(data, g_mock_nv[i].data, g_mock_nv[i].data_len);
            *out_len = g_mock_nv[i].data_len;
            return ERRCODE_SUCC;
        }
    }
    return -1;
}

#endif /* MOCK_NV_STORAGE_H */
