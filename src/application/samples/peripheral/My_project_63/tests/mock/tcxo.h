#ifndef TCXO_H
#define TCXO_H

#include <stdint.h>

/* Mock tcxo.h — 提供定时器函数的简单实现 */

static inline uint64_t uapi_tcxo_get_ms(void) {
    return 0;  /* Mock: 返回 0 */
}

static inline uint64_t uapi_tcxo_get_us(void) {
    return 0;  /* Mock: 返回 0 */
}

#endif /* TCXO_H */
