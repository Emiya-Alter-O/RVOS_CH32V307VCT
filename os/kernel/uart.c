#include "ch32v30x.h"

int uart_putc(char ch)
{

    while(USART_GetFlagStatus(USART1, USART_FLAG_TC) == RESET);
    USART_SendData(USART1, ch);

    return 0;
}

void uart_puts(char *s)
{
	while (*s) {
		uart_putc(*s++);
	}
}