#include "os.h"
#include "ch32v30x.h"

static uint32_t _SysTick_Config(uint32_t ticks)
{
    // NVIC_SetPriority(SysTicK_IRQn,0xf0);
    NVIC_SetPriority(Software_IRQn,0xf0);
    // NVIC_EnableIRQ(SysTicK_IRQn);
    NVIC_EnableIRQ(Software_IRQn);
    // SysTick->CTLR=0;
    // SysTick->SR=0;
    // SysTick->CNT=0;
    // SysTick->CMP=ticks-1;
    // SysTick->CTLR=0xF;
    return 0;
}

void sw_clearpend(void)
{
    SysTick->CTLR &= ~(1<<31);
}

void sw_setpend(void)
{
    SysTick->CTLR |= (1<<31);
}

void timer_init(void)
{
    _SysTick_Config(SystemCoreClock / 1000);
}

void SysTick_Handler(void) __attribute__((interrupt("WCH-Interrupt-fast")));
void SysTick_Handler(void)
{
    // GET_INT_SP();
    // /* enter interrupt */
    // rt_interrupt_enter();
    // SysTick->SR=0;
    // rt_tick_increase();
    // /* leave interrupt */
    // rt_interrupt_leave();
    // FREE_INT_SP();

}

void SW_Handler(void) __attribute__((interrupt(/*"WCH-Interrupt-fast"*/)));
void SW_Handler(void)
{
    sw_clearpend();
    os_schedule();
    // os_kprintf("entry sw irq\r\n");
}