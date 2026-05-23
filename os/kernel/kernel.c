#include "os.h"
#include "ch32v30x.h"

void start_kernel(void)
{
	USART_Printf_Init(115200);	
	uart_puts("Hello, RVOS!\r\n");

	// Delay_Init();

	os_heap_init();

	os_timer_init();

	os_sched_init();

	os_main();

	while (1)
    {

    }
}

void user_task0(void *param)
{
	uint32_t r_marchid = 0;
	os_kprintf("Task 0: Created!\n");
	r_marchid = gethid(0x12345678);
	os_kprintf("r_marchid : %p\r\n", r_marchid);
	while (1) {
		os_kprintf("Task 0: Running...\n");
		os_delay_ms(1000);
	}
}

void user_task1(void *param)
{
	os_kprintf("Task 1: Created!\n");
	while (1) {
		os_kprintf("Task 1: Running...\n");
		os_delay_ms(1000);
	}
}