#include "os.h"
#include "ch32v30x.h"

static volatile uint32_t os_tick = 0;

static uint32_t _SysTick_Config(uint32_t ticks)
{
    NVIC_SetPriority(SysTicK_IRQn,0xf0);
    NVIC_SetPriority(Software_IRQn,0xf0);
    NVIC_EnableIRQ(SysTicK_IRQn);
    NVIC_EnableIRQ(Software_IRQn);
    SysTick->CTLR=0;
    SysTick->SR=0;
    SysTick->CNT=0;
    SysTick->CMP=ticks-1;
    SysTick->CTLR=0xF;
    return 0;
}

void sw_clearpend(void)
{
    SysTick->CTLR &= ~(1<<31);
    os_schedule();
}

void sw_setpend(void)
{
    SysTick->CTLR |= (1<<31);
}

void os_timer_init(void)
{
    _SysTick_Config(SystemCoreClock / 1000);
}

uint32_t os_get_tick(void)
{
    return os_tick;
}

void os_delay_ms(uint32_t ms)
{
    uint32_t start_tick = os_get_tick();
    while ((os_get_tick() - start_tick) < ms) {
        // Optionally, you can put the CPU to sleep here to save power
        // __WFI(); // Wait For Interrupt
    }
}

void SysTick_Handler(void) __attribute__((interrupt("WCH-Interrupt-fast")));
void SysTick_Handler(void)
{
    os_tick++;
    // GET_INT_SP();
    // /* enter interrupt */
    // rt_interrupt_enter();
    SysTick->SR=0;
    os_task_yield();
    // rt_tick_increase();
    // /* leave interrupt */
    // rt_interrupt_leave();
    // FREE_INT_SP();

}

// void SW_Handler(void) __attribute__((interrupt("WCH-Interrupt-fast")));
// void SW_Handler(void)
// {
//     sw_clearpend();
//     os_schedule();
//     // os_kprintf("entry sw irq\r\n");
// }