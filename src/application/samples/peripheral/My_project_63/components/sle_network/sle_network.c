#include "sle_network.h"
#include "soc_osal.h"

int sle_network_init(void)
{
    osal_printk("[WS63_NET] init start\r\n");
    osal_printk("[WS63_NET] scan api chain: sle_set_seek_param + sle_start_seek\r\n");
    osal_printk("[WS63_NET] role plan: 63->G, 21e->T\r\n");
    osal_printk("[WS63_NET] init done\r\n");
    return 0;
}
