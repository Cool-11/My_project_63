#include "cloud_storage.h"
#include "soc_osal.h"

int cloud_storage_init(void)
{
    osal_printk("[WS63_CLOUD] init start\r\n");
    osal_printk("[WS63_CLOUD] mode: offline cache first, online upload later\r\n");
    osal_printk("[WS63_CLOUD] init done\r\n");
    return 0;
}
