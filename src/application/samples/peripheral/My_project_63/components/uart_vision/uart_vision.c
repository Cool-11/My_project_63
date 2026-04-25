#include "uart_vision.h"
#include "soc_osal.h"

int uart_vision_init(void)
{
    osal_printk("[WS63_UART] init start\r\n");
    osal_printk("[WS63_UART] protocol: JSON line mode with LF terminator\r\n");
    osal_printk("[WS63_UART] init done\r\n");
    return 0;
}
