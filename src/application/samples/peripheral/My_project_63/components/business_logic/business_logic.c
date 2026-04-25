#include "business_logic.h"
#include "soc_osal.h"

int business_logic_init(void)
{
    osal_printk("[WS63_BIZ] init start\r\n");
    osal_printk("[WS63_BIZ] mode: decision only, no direct hardware operations\r\n");
    osal_printk("[WS63_BIZ] init done\r\n");
    return 0;
}
