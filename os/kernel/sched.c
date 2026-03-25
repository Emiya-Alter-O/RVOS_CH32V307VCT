#include "os.h"

/* defined in entry.S */
extern void os_switch_to(struct context *next);
extern void os_switch(struct context *from, struct context *to);

#define MAX_TASKS 16
#define STACK_SIZE 1024

#if MAX_TASKS > 256
    #define MAX_TASKS (256)
#endif
/*
 * In the standard RISC-V calling convention, the stack pointer sp
 * is always 16-byte aligned.
 */
uint8_t __attribute__((aligned(16))) task_stack[MAX_TASKS][STACK_SIZE];
struct context ctx_tasks[MAX_TASKS];
static uint8_t os_task_priority[MAX_TASKS] = {255};

/*
 * _top is used to mark the max available position of ctx_tasks
 * _current is used to point to the context of current task
 */
static int _top = 0;
static int _current = -1;

static void w_mscratch(reg_t x)
{
	asm volatile("csrw mscratch, %0" : : "r" (x));
}

void os_sched_init()
{
	//w_mscratch(0);
}

void task_exit(void)
{
	os_kprintf("task_exit: %d\r\n", _current);
	return ;
}

void os_task_wrapper(void (*entry)(void*), void *arg)
{
    entry(arg);     
    task_exit();  
}

/*
 * DESCRIPTION
 * 	Create a task.
 * 	- start_routin: task routine entry
 * RETURN VALUE
 * 	0: success
 * 	-1: if error occured
 */
int task_create(void (*entry)(void *), void *param, uint8_t priority)
{
	if (_top < MAX_TASKS) {
		ctx_tasks[_top].sp		= (reg_t) &task_stack[_top][STACK_SIZE];
		ctx_tasks[_top].ra 		= (reg_t) os_task_wrapper;
		ctx_tasks[_top].a0		= (reg_t) entry;
		ctx_tasks[_top].a1		= (reg_t) param;
		os_task_priority[_top]	= priority;
		_top++;
		return 0;
	} else {
		return -1;
	}
}

/*
 * DESCRIPTION
 * 	Create default task.
 */
void os_main(void)
{
	_current++;
	extern void user_task0(void *param);
	task_create(user_task0, &_current, 200);
	extern void user_task1(void *param);
	task_create(user_task1, &_current, 100);

	struct context  *to = &(ctx_tasks[0]);
	os_switch_to(to);
}

void os_schedule()
{
	if (_top <= 0) {
		os_panic("Num of task should be greater than zero!");
		return;
	}

	uint8_t top_priority 		= 255;
	uint8_t top_priority_index 	= 0;
	struct context *from, *to;

	from = &(ctx_tasks[_current]);

	for(uint8_t i = 0; i < _top; i++)
	{
		if(_current == i) continue;
		if(os_task_priority[i] < top_priority)
		{
			top_priority 		= os_task_priority[i];
			top_priority_index	= i;
		}
	}

	_current = top_priority_index;
	to = &(ctx_tasks[_current]);
	os_switch(from, to);
}

/*
 * DESCRIPTION
 * 	task_yield()  causes the calling task to relinquish the CPU and a new 
 * 	task gets to run.
 */
void os_task_yield(void)
{
	os_schedule();
}