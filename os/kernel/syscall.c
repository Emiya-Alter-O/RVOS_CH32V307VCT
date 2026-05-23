#include "os.h"

int gethid(uint32_t param)
{
    asm volatile("li a7, %0"
                  :
                  : "i"(SYS_gethid)
                  : "a7");
    asm volatile("ecall");
    asm volatile("ret");

    return -1;
}

void Ecall_U_Mode_Handler(void) __attribute__((interrupt(/*"WCH-Interrupt-fast"*/)));
void Ecall_U_Mode_Handler(void)
{
    uint32_t r_mepc;
    register uint32_t r_a0 asm("a0");
    register uint32_t r_a7 asm("a7");

    asm volatile("" : "=r"(r_a0), "=r"(r_a7));
    os_kprintf("Ecall_U_Mode_Handler, a0: %p, a7:%p\n", r_a0, r_a7);

    switch(r_a7)
    {
        case SYS_gethid:
            asm volatile("csrr a0, marchid");
            asm volatile("sw	a0,60(sp)");
            // sw	a0,60(sp)
            break;
    
        default:
            
            break;
    }

    asm volatile("csrs 0x804, %0": :"r"(0x20));

    asm volatile("csrr %0, mepc" : "=r"(r_mepc));
    r_mepc += 4;
    asm volatile("csrw mepc, %0" : : "r"(r_mepc));
}