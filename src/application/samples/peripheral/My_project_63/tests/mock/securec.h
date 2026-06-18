#ifndef SECUREC_H
#define SECUREC_H

#include <string.h>
#include <stdint.h>

/* Mock securec.h — 提供安全函数的简单实现 */

typedef int errno_t;

#define EOK 0

static inline errno_t memcpy_s(void *dest, uint32_t destMax,
    const void *src, uint32_t count) {
    if (dest == NULL || src == NULL || count > destMax) {
        return -1;
    }
    memcpy(dest, src, count);
    return EOK;
}

static inline errno_t strncpy_s(char *strDest, uint32_t destMax,
    const char *strSrc, uint32_t count) {
    if (strDest == NULL || strSrc == NULL || count > destMax) {
        return -1;
    }
    strncpy(strDest, strSrc, count);
    strDest[destMax - 1] = '\0';
    return EOK;
}

static inline errno_t memset_s(void *dest, uint32_t destMax,
    int c, uint32_t count) {
    if (dest == NULL || count > destMax) {
        return -1;
    }
    memset(dest, c, count);
    return EOK;
}

#endif /* SECUREC_H */
