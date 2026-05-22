#include "os.h"

uint32_t spin_lock(void)
{
    uint32_t ret;
    asm volatile("csrrw %0, 0x800, %1":"=r"(ret):"r"(0x7800));
    asm volatile ("fence.i");
    return ret;
}

void spin_unlock(uint32_t reg)
{
    asm volatile("csrw 0x800, %0": :"r"(reg));
    return ;
}