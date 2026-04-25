#include "shared_protocol.h"
#include "soc_osal.h"

#define MY63_SHARED_PROTO_MAGIC 0xAABBCCDDU

int shared_protocol_init(void)
{
    osal_printk("[WS63_SHARED] init start\r\n");
    osal_printk("[WS63_SHARED] struct size=%u\r\n", (unsigned int)sizeof(shared_proto_adv_field_t));
    osal_printk("[WS63_SHARED] default magic=0x%08x\r\n", (unsigned int)MY63_SHARED_PROTO_MAGIC);
    osal_printk("[WS63_SHARED] init done\r\n");
    return 0;
}
