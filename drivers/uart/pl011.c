
#include <pl011.h>
#include <arch_macros.h>
#include <uart.h>

void disable_uart()
{
	raw_write32(UART_CR, 0);
}

void uart_putc(char c)
{
	while(raw_read32(UART_FR) & FR_TXFF);
	raw_write32(UART_DR, c);
}

char uart_getc()
{
	if (raw_read32(UART_FR) & FR_RXFE)
		return -1;
	return raw_read32(UART_DR);
}

void enable_uart()
{
	raw_write32(UART_IMSC, UART_IMSC_RXIM|UART_IMSC_TXIM);
}

void configure_uart()
{
	raw_write32(UART_LCRH, LCRH_FEN|LCRH_WLEN_8BIT);
	raw_write32(UART_CR, UART_EN|UART_TXE|UART_RXE);
}

void uart_init()
{
	disable_uart();
	configure_uart();
	enable_uart();
}
