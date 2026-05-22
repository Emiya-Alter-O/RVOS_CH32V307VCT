# RVOS简介

此项目为汪辰老师公开课[《循序渐进，学习开发一个RISC-V上的操作系统》](https://www.bilibili.com/video/BV1Q5411w7z5)在一个具体硬件上的实现，使用的芯片为沁恒(WCH)的[ch32v307](https://www.wch.cn/products/CH32V307.html),[硬件原理图](https://oshwhub.com/emiyaakuma/ch32v307board)见嘉立创,调试器为wch-linkE

项目使用[MounRiver Studio(MRS)](https://www.mounriver.com/)进行开发，不涉及工具链配置，下载安装即可使用，接下来将按照课程章节顺序对代码进行说明

- [0. Hello RVOS](#0-hello-rvos)
- [1. 内存管理](#1-内存管理)
- [2. 上下文切换和协作式多任务](#2上下文切换和协作式多任务)

# 0. Hello RVOS
在mrs生成的启动文件[startup_ch32v30x_D8C.S](Startup\startup_ch32v30x_D8C.S)中已经对芯片做了初始化配置，一般没有修改的必要，此项目进入start_kernel函数的方法是直接修改mepc，这样mret之后芯片的特权模式将会根据mstatus中的值进行变更。
```asm
    jal  SystemInit
    la t0, start_kernel
    csrw mepc, t0
    mret
```
进入[start_kernel](os\kernel\kernel.c)后调用芯片的外设库对串口进行初始化，随后打印系统信息。

# 1. 内存管理

与课程原方案不同，此项目没有使用增加一个section的方式，而是采用全局数组的方式生成一个内存池进行管理

在[mem.c](os\kernel\mem.c)文件中定义了一个结构体：
```c
static struct
{
    uint32_t mem[OS_HEAP_SIZE]; // heap default size: 4K(1024 * 4)
    uint8_t  is_used[OS_HEAP_STATE_INDEX];
    uint8_t  is_last[OS_HEAP_STATE_INDEX];
}os_heap;
```
其中mem数组是用于分配的的动态内存，以32位为最小单位进行分配，is_used数组是内存是否使用标志位，一个bit对应mem中一个元素，is_last数组用于判断当前内存块是否是最后一个，同样一个bit对应mem中一个元素。

alloc和free函数与原课程代码类似，只是最小单位不同。

# 2.上下文切换和协作式多任务

在首次提交版本的代码中，采用与原课程不同的方式进行上下文切换，此工程不使用mscratch保存当前任务上下文的起始地址，而是在上下文切换时使用两个参数传递要保存的上下文和要切换的上下文地址，具体见代码：
```c
    extern void os_switch(struct context *from, struct context *to); //切换上下文的汇编函数的声明，from是要保存的上下文，to是要切换的上下文

    .globl os_switch
    .balign 4
    os_switch:
        reg_save 	a0 //reg_save和reg_restore宏与原教程一致

        mv			t6,a1
        reg_restore t6

        ret
```

此种方式虽然简化了汇编函数中的流程，但是在中断环境中使用时会出现问题，后续版本已放弃使用

此工程完成了练习 9-1的内容，改进了[task_create()](os\kernel\sched.c#L58)以及增加任务退出接⼝[task_exit()](os\kernel\sched.c#L47)

- 改进task_create()

    此工程实现的[task_create()](os\kernel\sched.c#L58)函数传参添加了任务入口函数参数以及任务优先级，支持任务按照优先级调度，代码如下：
    ```c
        int task_create(void (*entry)(void *), void *param, uint8_t priority)
        {
            if(_top < MAX_TASKS) 
            {
                ctx_tasks[_top].sp      = (reg_t) &task_stack[_top][STACK_SIZE];
                ctx_tasks[_top].mepc    = (reg_t) os_task_wrapper;
                ctx_tasks[_top].ra      = (reg_t) os_task_wrapper;
                ctx_tasks[_top].a0      = (reg_t) entry;
                ctx_tasks[_top].a1      = (reg_t) param;
                os_task_priority[_top]  = priority;
                _top++;
                return 0;
            }
            else 
            {
                return -1;
            }
        }
    ```
    为了实现在任务函数返回后执行task_exit()函数的功能，在原有的任务函数之外增加了一个封装函数，任务创建时将封装函数的地址赋给任务上下文的ra或mepc，真正的任务入口函数地址以及任务参数通过函数调用的方式传参给封装函数，在调度到一个任务时，首先执行封装函数,封装函数再调用任务函数并在任务函数返回之后执行task_exit()函数，代码如下：
    ```c
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
    ```

# 3.Trap和Exception

此工程使用的芯片拥有独立的中断管理外设，内核处理中断和异常的方式和课程中略有不同,具体可参考[《QingKeV4_Processor_Manual.PDF》](https://www.wch.cn/downloads/QingKeV3_Processor_Manual_PDF.html)。

# 4.外部设备中断

使用mrs开发WCH系列芯片时，中断处理函数已经在启动文件中定义了不同中断函数的入口，使用C语言重写对应函数并声明__attribute__((interrupt("WCH-Interrupt-fast")))即可编译出与普通函数不同的中断函数，查看c程序编译出的汇编文件时可以发现，最明显的差异就是声明过的中断函数返回使用的都是mret指令，大部分中断处理函数都可用C语言实现，但后续使用的软中断函数中，由于调用的切换上下文函数最终会由mret返回，如果用C语言实现软中断函数，则可能会出现mret之后cpu退出机器模式然后又执行mret指令导致非法指令的异常，所以本章节会单独使用汇编实现软中断函数以防止此问题，代码如下：
```asm
    .global SW_Handler
    .align 2
    SW_Handler:
        # save context(registers).
        csrrw		t6, mscratch, t6	# swap t6 and mscratch
        reg_save 	t6

        # Save the actual t6 register, which we swapped into
        # mscratch
        mv			t5, t6			# t5 points to the context of current task
        csrr		t6, mscratch		# read t6 back from mscratch
        STORE		t6, 30*SIZE_REG(t5)	# save t6 with t5 as base

        # save mepc to context of current task
        csrr		a0, mepc
        STORE		a0, 31*SIZE_REG(t5)

        call		sw_clearpend
        mret
```

# 5.硬件定时器

CH32V系列芯片中实现了一个64位滴答定时器，此工程通过外设库配置了一个1ms的定时器并用C语言实现中断处理函数
```c
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

void SysTick_Handler(void) __attribute__((interrupt("WCH-Interrupt-fast")));
void SysTick_Handler(void)
{
    os_tick++;
    SysTick->SR=0;
    os_task_yield();
}
```

# 6.抢占式多任务

不同于原课程在任意中断中都可以执行调度的处理方式，此工程只能在软中断中调度，在其他中断中需要调度时会触发软件中断进行调度，由于软中断的优先级最低，因此不会抢占原中断函数的执行，切换上下文的代码如下：
```asm
.globl os_switch_to
.balign 4
os_switch_to:

	li   t0,    0x20
	csrs 0x804, t0

	csrw	mscratch, a0
	# set mepc to the pc of the next task
	LOAD	a1, 31*SIZE_REG(a0)
	csrw	mepc, a1

	# Restore all GP registers
	# Use t6 to point to the context of the new task
	mv	t6, a0
	reg_restore t6

	# Do actual context switching.
	# Notice this will enable global interrupt
	mret
.end
```
由于在进入软中断处理函数时已经保存过上下文，因此在此函数中只加载需要切换的任务的上下文，同时会关闭硬件出栈防止异常。

# 7.任务同步和锁