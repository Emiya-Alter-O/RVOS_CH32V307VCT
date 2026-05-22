/********************************** (C) COPYRIGHT *******************************
* File Name          : startup_ch32v30x_D8C.s
* Author             : WCH
* Version            : V1.0.1
* Date               : 2025/04/06
* Description        : CH32V307x-CH32V305x vector table for eclipse toolchain.
*********************************************************************************
* Copyright (c) 2021 Nanjing Qinheng Microelectronics Co., Ltd.
* Attention: This software (modified or not) and binary are used for 
* microcontroller manufactured by Nanjing Qinheng Microelectronics.
*******************************************************************************/

	.section	.init,"ax",@progbits    /*声明一个名为 .init 的段，属性为可分配（allocatable）且可执行（executable），并包含程序代码（progbits）。*/
	.global	_start                      /*将 _start 符号声明为全局符号，使其可在链接时被其他文件引用。*/
	.align	1
_start:
	j	handle_reset

    .section    .vector,"ax",@progbits  /*声明一个名为 .vector 的段，用于存放中断向量表。属性与 .init 相同*/
    .align  1
_vector_base:
    .option norvc;                      /*告诉汇编器接下来不要压缩指令（RVC，RISC-V Compressed 指令）。确保向量表中的入口是 4 字节对齐的（虽然对齐是 2 字节，但 .word 会自然对齐到 4 字节）*/
    .word   _start                      /*在向量表第一个位置存放 _start 的地址，即复位向量（当处理器复位时，PC 会跳转到该地址）。注意：RISC-V 的 mtvec 寄存器可以配置为直接基址或向量模式，此处存放的是复位入口*/
    .word   0                           /*保留，通常用于存放 NMI 或保留向量，这里填 0*/
    .word   NMI_Handler                /* NMI *//*每个 .word 在向量表中占用一个字（4 字节），存放对应中断服务程序的入口地址。这些名称都是弱符号，如果用户没有定义，则指向默认的无限循环（见后面的定义）。列表从 NMI 一直到 DMA2_Channel11_IRQHandler，覆盖了所有中断源*/
    .word   HardFault_Handler          /* Hard Fault */
    .word   0
    .word   Ecall_M_Mode_Handler       /* Ecall M Mode */
    .word   0
    .word   0
    .word   Ecall_U_Mode_Handler       /* Ecall U Mode */
    .word   Break_Point_Handler        /* Break Point */
    .word   0
    .word   0
    .word   SysTick_Handler            /* SysTick */
    .word   0
    .word   SW_Handler                 /* SW */
    .word   0
    /* External Interrupts */
    .word   WWDG_IRQHandler            /* Window Watchdog */
    .word   PVD_IRQHandler             /* PVD through EXTI Line detect */
    .word   TAMPER_IRQHandler          /* TAMPER */
    .word   RTC_IRQHandler             /* RTC */
    .word   FLASH_IRQHandler           /* Flash */
    .word   RCC_IRQHandler             /* RCC */
    .word   EXTI0_IRQHandler           /* EXTI Line 0 */
    .word   EXTI1_IRQHandler           /* EXTI Line 1 */
    .word   EXTI2_IRQHandler           /* EXTI Line 2 */
    .word   EXTI3_IRQHandler           /* EXTI Line 3 */
    .word   EXTI4_IRQHandler           /* EXTI Line 4 */
    .word   DMA1_Channel1_IRQHandler   /* DMA1 Channel 1 */
    .word   DMA1_Channel2_IRQHandler   /* DMA1 Channel 2 */
    .word   DMA1_Channel3_IRQHandler   /* DMA1 Channel 3 */
    .word   DMA1_Channel4_IRQHandler   /* DMA1 Channel 4 */
    .word   DMA1_Channel5_IRQHandler   /* DMA1 Channel 5 */
    .word   DMA1_Channel6_IRQHandler   /* DMA1 Channel 6 */
    .word   DMA1_Channel7_IRQHandler   /* DMA1 Channel 7 */
    .word   ADC1_2_IRQHandler          /* ADC1_2 */
    .word   USB_HP_CAN1_TX_IRQHandler  /* USB HP and CAN1 TX */
    .word   USB_LP_CAN1_RX0_IRQHandler /* USB LP and CAN1RX0 */
    .word   CAN1_RX1_IRQHandler        /* CAN1 RX1 */
    .word   CAN1_SCE_IRQHandler        /* CAN1 SCE */
    .word   EXTI9_5_IRQHandler         /* EXTI Line 9..5 */
    .word   TIM1_BRK_IRQHandler        /* TIM1 Break */
    .word   TIM1_UP_IRQHandler         /* TIM1 Update */
    .word   TIM1_TRG_COM_IRQHandler    /* TIM1 Trigger and Commutation */
    .word   TIM1_CC_IRQHandler         /* TIM1 Capture Compare */
    .word   TIM2_IRQHandler            /* TIM2 */
    .word   TIM3_IRQHandler            /* TIM3 */
    .word   TIM4_IRQHandler            /* TIM4 */
    .word   I2C1_EV_IRQHandler         /* I2C1 Event */
    .word   I2C1_ER_IRQHandler         /* I2C1 Error */
    .word   I2C2_EV_IRQHandler         /* I2C2 Event */
    .word   I2C2_ER_IRQHandler         /* I2C2 Error */
    .word   SPI1_IRQHandler            /* SPI1 */
    .word   SPI2_IRQHandler            /* SPI2 */
    .word   USART1_IRQHandler          /* USART1 */
    .word   USART2_IRQHandler          /* USART2 */
    .word   USART3_IRQHandler          /* USART3 */
    .word   EXTI15_10_IRQHandler       /* EXTI Line 15..10 */
    .word   RTCAlarm_IRQHandler        /* RTC Alarm through EXTI Line */
    .word   USBWakeUp_IRQHandler       /* USB Wakeup from suspend */
    .word   TIM8_BRK_IRQHandler        /* TIM8 Break */
    .word   TIM8_UP_IRQHandler         /* TIM8 Update */
    .word   TIM8_TRG_COM_IRQHandler    /* TIM8 Trigger and Commutation */
    .word   TIM8_CC_IRQHandler         /* TIM8 Capture Compare */
    .word   RNG_IRQHandler             /* RNG */
    .word   0
    .word   SDIO_IRQHandler            /* SDIO */
    .word   TIM5_IRQHandler            /* TIM5 */
    .word   SPI3_IRQHandler            /* SPI3 */
    .word   UART4_IRQHandler           /* UART4 */
    .word   UART5_IRQHandler           /* UART5 */
    .word   TIM6_IRQHandler            /* TIM6 */
    .word   TIM7_IRQHandler            /* TIM7 */
    .word   DMA2_Channel1_IRQHandler   /* DMA2 Channel 1 */
    .word   DMA2_Channel2_IRQHandler   /* DMA2 Channel 2 */
    .word   DMA2_Channel3_IRQHandler   /* DMA2 Channel 3 */
    .word   DMA2_Channel4_IRQHandler   /* DMA2 Channel 4 */
    .word   DMA2_Channel5_IRQHandler   /* DMA2 Channel 5 */
    .word   ETH_IRQHandler             /* ETH */
    .word   ETH_WKUP_IRQHandler        /* ETH WakeUp */
    .word   CAN2_TX_IRQHandler         /* CAN2 TX */
    .word   CAN2_RX0_IRQHandler        /* CAN2 RX0 */
    .word   CAN2_RX1_IRQHandler        /* CAN2 RX1 */
    .word   CAN2_SCE_IRQHandler        /* CAN2 SCE */
    .word   USBFS_IRQHandler           /* USBFS */
    .word   USBHSWakeup_IRQHandler     /* USBHS Wakeup */
    .word   USBHS_IRQHandler           /* USBHS */
    .word   DVP_IRQHandler             /* DVP */
    .word   UART6_IRQHandler           /* UART6 */
    .word   UART7_IRQHandler           /* UART7 */
    .word   UART8_IRQHandler           /* UART8 */
    .word   TIM9_BRK_IRQHandler        /* TIM9 Break */
    .word   TIM9_UP_IRQHandler         /* TIM9 Update */
    .word   TIM9_TRG_COM_IRQHandler    /* TIM9 Trigger and Commutation */
    .word   TIM9_CC_IRQHandler         /* TIM9 Capture Compare */
    .word   TIM10_BRK_IRQHandler       /* TIM10 Break */
    .word   TIM10_UP_IRQHandler        /* TIM10 Update */
    .word   TIM10_TRG_COM_IRQHandler   /* TIM10 Trigger and Commutation */
    .word   TIM10_CC_IRQHandler        /* TIM10 Capture Compare */
    .word   DMA2_Channel6_IRQHandler   /* DMA2 Channel 6 */
    .word   DMA2_Channel7_IRQHandler   /* DMA2 Channel 7 */
    .word   DMA2_Channel8_IRQHandler   /* DMA2 Channel 8 */
    .word   DMA2_Channel9_IRQHandler   /* DMA2 Channel 9 */
    .word   DMA2_Channel10_IRQHandler  /* DMA2 Channel 10 */
    .word   DMA2_Channel11_IRQHandler  /* DMA2 Channel 11 */

    .option rvc;                       /*恢复压缩指令支持，后面的代码可以使用压缩指令。*/
    .section    .text.vector_handler, "ax", @progbits   /*声明一个段，用于存放默认的中断处理程序（弱符号）*/
    .weak   NMI_Handler                /* NMI *//*将每个中断处理程序声明为弱符号。这意味着如果用户在别处定义了同名的强符号，链接时将使用用户的定义；否则使用这里的默认实现*/
    .weak   HardFault_Handler          /* Hard Fault */
    .weak   Ecall_M_Mode_Handler       /* Ecall M Mode */
    .weak   Ecall_U_Mode_Handler       /* Ecall U Mode */
    .weak   Break_Point_Handler        /* Break Point */
    .weak   SysTick_Handler            /* SysTick */
    .weak   SW_Handler                 /* SW */
    .weak   WWDG_IRQHandler            /* Window Watchdog */
    .weak   PVD_IRQHandler             /* PVD through EXTI Line detect */
    .weak   TAMPER_IRQHandler          /* TAMPER */
    .weak   RTC_IRQHandler             /* RTC */
    .weak   FLASH_IRQHandler           /* Flash */
    .weak   RCC_IRQHandler             /* RCC */
    .weak   EXTI0_IRQHandler           /* EXTI Line 0 */
    .weak   EXTI1_IRQHandler           /* EXTI Line 1 */
    .weak   EXTI2_IRQHandler           /* EXTI Line 2 */
    .weak   EXTI3_IRQHandler           /* EXTI Line 3 */
    .weak   EXTI4_IRQHandler           /* EXTI Line 4 */
    .weak   DMA1_Channel1_IRQHandler   /* DMA1 Channel 1 */
    .weak   DMA1_Channel2_IRQHandler   /* DMA1 Channel 2 */
    .weak   DMA1_Channel3_IRQHandler   /* DMA1 Channel 3 */
    .weak   DMA1_Channel4_IRQHandler   /* DMA1 Channel 4 */
    .weak   DMA1_Channel5_IRQHandler   /* DMA1 Channel 5 */
    .weak   DMA1_Channel6_IRQHandler   /* DMA1 Channel 6 */
    .weak   DMA1_Channel7_IRQHandler   /* DMA1 Channel 7 */
    .weak   ADC1_2_IRQHandler          /* ADC1_2 */
    .weak   USB_HP_CAN1_TX_IRQHandler  /* USB HP and CAN1 TX */
    .weak   USB_LP_CAN1_RX0_IRQHandler /* USB LP and CAN1RX0 */
    .weak   CAN1_RX1_IRQHandler        /* CAN1 RX1 */
    .weak   CAN1_SCE_IRQHandler        /* CAN1 SCE */
    .weak   EXTI9_5_IRQHandler         /* EXTI Line 9..5 */
    .weak   TIM1_BRK_IRQHandler        /* TIM1 Break */
    .weak   TIM1_UP_IRQHandler         /* TIM1 Update */
    .weak   TIM1_TRG_COM_IRQHandler    /* TIM1 Trigger and Commutation */
    .weak   TIM1_CC_IRQHandler         /* TIM1 Capture Compare */
    .weak   TIM2_IRQHandler            /* TIM2 */
    .weak   TIM3_IRQHandler            /* TIM3 */
    .weak   TIM4_IRQHandler            /* TIM4 */
    .weak   I2C1_EV_IRQHandler         /* I2C1 Event */
    .weak   I2C1_ER_IRQHandler         /* I2C1 Error */
    .weak   I2C2_EV_IRQHandler         /* I2C2 Event */
    .weak   I2C2_ER_IRQHandler         /* I2C2 Error */
    .weak   SPI1_IRQHandler            /* SPI1 */
    .weak   SPI2_IRQHandler            /* SPI2 */
    .weak   USART1_IRQHandler          /* USART1 */
    .weak   USART2_IRQHandler          /* USART2 */
    .weak   USART3_IRQHandler          /* USART3 */
    .weak   EXTI15_10_IRQHandler       /* EXTI Line 15..10 */
    .weak   RTCAlarm_IRQHandler        /* RTC Alarm through EXTI Line */
    .weak   USBWakeUp_IRQHandler       /* USB Wakeup from suspend */
    .weak   TIM8_BRK_IRQHandler        /* TIM8 Break */
    .weak   TIM8_UP_IRQHandler         /* TIM8 Update */
    .weak   TIM8_TRG_COM_IRQHandler    /* TIM8 Trigger and Commutation */
    .weak   TIM8_CC_IRQHandler         /* TIM8 Capture Compare */
    .weak   RNG_IRQHandler             /* RNG */
    .weak   SDIO_IRQHandler            /* SDIO */
    .weak   TIM5_IRQHandler            /* TIM5 */
    .weak   SPI3_IRQHandler            /* SPI3 */
    .weak   UART4_IRQHandler           /* UART4 */
    .weak   UART5_IRQHandler           /* UART5 */
    .weak   TIM6_IRQHandler            /* TIM6 */
    .weak   TIM7_IRQHandler            /* TIM7 */
    .weak   DMA2_Channel1_IRQHandler   /* DMA2 Channel 1 */
    .weak   DMA2_Channel2_IRQHandler   /* DMA2 Channel 2 */
    .weak   DMA2_Channel3_IRQHandler   /* DMA2 Channel 3 */
    .weak   DMA2_Channel4_IRQHandler   /* DMA2 Channel 4 */
    .weak   DMA2_Channel5_IRQHandler   /* DMA2 Channel 5 */
    .weak   ETH_IRQHandler             /* ETH */
    .weak   ETH_WKUP_IRQHandler        /* ETH WakeUp */
    .weak   CAN2_TX_IRQHandler         /* CAN2 TX */
    .weak   CAN2_RX0_IRQHandler        /* CAN2 RX0 */
    .weak   CAN2_RX1_IRQHandler        /* CAN2 RX1 */
    .weak   CAN2_SCE_IRQHandler        /* CAN2 SCE */
    .weak   USBFS_IRQHandler           /* USBFS */
    .weak   USBHSWakeup_IRQHandler     /* USBHS Wakeup */
    .weak   USBHS_IRQHandler           /* USBHS */
    .weak   DVP_IRQHandler             /* DVP */
    .weak   UART6_IRQHandler           /* UART6 */
    .weak   UART7_IRQHandler           /* UART7 */
    .weak   UART8_IRQHandler           /* UART8 */
    .weak   TIM9_BRK_IRQHandler        /* TIM9 Break */
    .weak   TIM9_UP_IRQHandler         /* TIM9 Update */
    .weak   TIM9_TRG_COM_IRQHandler    /* TIM9 Trigger and Commutation */
    .weak   TIM9_CC_IRQHandler         /* TIM9 Capture Compare */
    .weak   TIM10_BRK_IRQHandler       /* TIM10 Break */
    .weak   TIM10_UP_IRQHandler        /* TIM10 Update */
    .weak   TIM10_TRG_COM_IRQHandler   /* TIM10 Trigger and Commutation */
    .weak   TIM10_CC_IRQHandler        /* TIM10 Capture Compare */
    .weak   DMA2_Channel6_IRQHandler   /* DMA2 Channel 6 */
    .weak   DMA2_Channel7_IRQHandler   /* DMA2 Channel 7 */
    .weak   DMA2_Channel8_IRQHandler   /* DMA2 Channel 8 */
    .weak   DMA2_Channel9_IRQHandler   /* DMA2 Channel 9 */
    .weak   DMA2_Channel10_IRQHandler  /* DMA2 Channel 10 */
    .weak   DMA2_Channel11_IRQHandler  /* DMA2 Channel 11 */

NMI_Handler:                            /*一系列标签连续排列，共享同一个无限循环代码。每个标签对应一个中断入口，如果用户未重定义，则执行下面的 1: j 1b 死循环*/
HardFault_Handler:
Ecall_M_Mode_Handler:
Ecall_U_Mode_Handler:
Break_Point_Handler:
SysTick_Handler:
SW_Handler:
WWDG_IRQHandler:
PVD_IRQHandler:
TAMPER_IRQHandler:
RTC_IRQHandler:
FLASH_IRQHandler:
RCC_IRQHandler:
EXTI0_IRQHandler:
EXTI1_IRQHandler:
EXTI2_IRQHandler:
EXTI3_IRQHandler:
EXTI4_IRQHandler:
DMA1_Channel1_IRQHandler:
DMA1_Channel2_IRQHandler:
DMA1_Channel3_IRQHandler:
DMA1_Channel4_IRQHandler:
DMA1_Channel5_IRQHandler:
DMA1_Channel6_IRQHandler:
DMA1_Channel7_IRQHandler:
ADC1_2_IRQHandler:
USB_HP_CAN1_TX_IRQHandler:
USB_LP_CAN1_RX0_IRQHandler:
CAN1_RX1_IRQHandler:
CAN1_SCE_IRQHandler:
EXTI9_5_IRQHandler:
TIM1_BRK_IRQHandler:
TIM1_UP_IRQHandler:
TIM1_TRG_COM_IRQHandler:
TIM1_CC_IRQHandler:
TIM2_IRQHandler:
TIM3_IRQHandler:
TIM4_IRQHandler:
I2C1_EV_IRQHandler:
I2C1_ER_IRQHandler:
I2C2_EV_IRQHandler:
I2C2_ER_IRQHandler:
SPI1_IRQHandler:
SPI2_IRQHandler:
USART1_IRQHandler:
USART2_IRQHandler:
USART3_IRQHandler:
EXTI15_10_IRQHandler:
RTCAlarm_IRQHandler:
USBWakeUp_IRQHandler:
TIM8_BRK_IRQHandler:
TIM8_UP_IRQHandler:
TIM8_TRG_COM_IRQHandler:
TIM8_CC_IRQHandler:
RNG_IRQHandler:
SDIO_IRQHandler:
TIM5_IRQHandler:
SPI3_IRQHandler:
UART4_IRQHandler:
UART5_IRQHandler:
TIM6_IRQHandler:
TIM7_IRQHandler:
DMA2_Channel1_IRQHandler:
DMA2_Channel2_IRQHandler:
DMA2_Channel3_IRQHandler:
DMA2_Channel4_IRQHandler:
DMA2_Channel5_IRQHandler:
ETH_IRQHandler:
ETH_WKUP_IRQHandler:
CAN2_TX_IRQHandler:
CAN2_RX0_IRQHandler:
CAN2_RX1_IRQHandler:
CAN2_SCE_IRQHandler:
USBFS_IRQHandler:
USBHSWakeup_IRQHandler:
USBHS_IRQHandler:
DVP_IRQHandler:
UART6_IRQHandler:
UART7_IRQHandler:
UART8_IRQHandler:
TIM9_BRK_IRQHandler:
TIM9_UP_IRQHandler:
TIM9_TRG_COM_IRQHandler:
TIM9_CC_IRQHandler:
TIM10_BRK_IRQHandler:
TIM10_UP_IRQHandler:
TIM10_TRG_COM_IRQHandler:
TIM10_CC_IRQHandler:
DMA2_Channel6_IRQHandler:
DMA2_Channel7_IRQHandler:
DMA2_Channel8_IRQHandler:
DMA2_Channel9_IRQHandler:
DMA2_Channel10_IRQHandler:
DMA2_Channel11_IRQHandler:
1:
	j 1b

	.section	.text.handle_reset,"ax",@progbits   /*声明复位处理程序段*/
	.weak	handle_reset                            /*将 handle_reset 声明为弱符号，允许用户重定义复位处理*/
	.align	1
handle_reset:
.option push                                        /*保存当前汇编选项状态。*/
.option	norelax                                     /*禁止链接器重定位放松（relaxation），确保接下来的 la gp, __global_pointer$ 生成确定的指令序列，避免因放松导致 gp 初始化错误*/
	la gp, __global_pointer$                        /*加载全局指针（gp）的地址。__global_pointer$ 是链接器脚本定义的符号，通常指向数据段的某个位置，用于 gp 相对寻址（访问小数据更快）*/
.option	pop                                         /*恢复之前保存的汇编选项*/

	la sp, _eusrstack                               /*加载栈指针（sp）为 _eusrstack 的地址。_eusrstack 在链接脚本定义，表示用户栈的结束地址（即栈顶，栈向下生长）*/

/* Load data section from flash to RAM */
	la a0, _data_lma                                /*加载 _data_lma 地址到 a0，这是数据段在 Flash 中的加载地址（LMA）*/
	la a1, _data_vma                                /*加载 _data_vma 地址到 a1，这是数据段在 RAM 中的运行地址（VMA）*/
	la a2, _edata                                   /*加载 _edata 地址到 a2，这是数据段在 RAM 中的结束地址*/
	bgeu a1, a2, 2f                                 /*如果 a1 >= a2（即数据段为空或无需复制），则跳转到标签 2 处*/   
1:
	lw t0, (a0)                                     /*从 a0 指向的 Flash 地址加载一个字（32 位）到 t0*/
	sw t0, (a1)                                     /*将 t0 存储到 a1 指向的 RAM 地址*/
	addi a0, a0, 4                                  /*a0 加 4，指向下一个源地址*/
	addi a1, a1, 4                                  /*a1 加 4，指向下一个目标地址*/
	bltu a1, a2, 1b                                 /*如果 a1 小于 a2（未复制完），则跳回标签 1 继续复制*/
2:
/* Clear bss section */
	la a0, _sbss                                    /*加载 _sbss 地址到 a0，这是 BSS 段的起始地址*/
	la a1, _ebss                                    /*加载_ebss 地址到 a1，这是 BSS 段的结束地址*/
	bgeu a0, a1, 2f                                 /*如果 a0 >= a1（BSS 段为空），跳转到标签 2*/
1:
	sw zero, (a0)                                   /*将零写入 a0 指向的地址（清 4 字节）*/
	addi a0, a0, 4
	bltu a0, a1, 1b                                 /*如果 a0 小于 a1，继续循环*/
2:                                                  /*清 BSS 完成*/
/* Configure pipelining and instruction prediction */
    li t0, 0x1f
    csrw 0xbc0, t0                                  /*配置corecfgr*/
/* Enable interrupt nesting and hardware stack */
	li t0, 0x0b
	csrw 0x804, t0      /*配置中断系统控制寄存器（INTSYSCR）， 设置为4级嵌套，使能中断嵌套和硬件压栈*/
/* Enable floating point and global interrupt, configure privileged mode */
   	li t0, 0x6088           
   	csrw mstatus, t0
/* Configure the interrupt vector table recognition mode and entry address mode */
 	la t0, _vector_base                             #加载向量表基地址到 t0。
    ori t0, t0, 3                                   #将 t0 的低 2 位置 1（ori 按位或）
	csrw mtvec, t0

    jal  SystemInit
    j    start_kernel
	la t0, start_kernel
	csrw mepc, t0
	mret


