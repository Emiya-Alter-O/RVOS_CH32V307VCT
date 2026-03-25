#include "os.h"

extern void USART_Printf_Init(uint32_t baudrate);
extern void Delay_Init(void);

void start_kernel(void)
{
	USART_Printf_Init(115200);	
	uart_puts("Hello, RVOS!\r\n");

	Delay_Init();

	os_heap_init();

	os_sched_init();

	os_main();

	while (1)
    {

    }
}

extern void Delay_Ms(uint32_t n);

void user_task0(void *param)
{
	os_kprintf("Task 0: Created!\n");
	while (1) {
		os_kprintf("Task 0: Running...\n");
		Delay_Ms(1000);
		os_task_yield();
	}
}

void user_task1(void *param)
{
	os_kprintf("Task 1: Created!\n");
	while (1) {
		os_kprintf("Task 1: Running...\n");
		Delay_Ms(1000);
		os_task_yield();
	}
}