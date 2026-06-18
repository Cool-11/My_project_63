#ifndef MOCK_OSAL_H
#define MOCK_OSAL_H

#include <stdio.h>
#include <stdint.h>

/* Mock osal_printk → printf */
#define osal_printk(fmt, ...) printf(fmt, ##__VA_ARGS__)

/* Mock 其他 osal 函数（如果需要） */
static inline void osal_msleep(uint32_t ms) {
    (void)ms;
}

#endif /* MOCK_OSAL_H */
