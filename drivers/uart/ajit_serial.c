
#include <ajit_serial.h>
#include <arch_macros.h>
#include <math.h>
#include <uart.h>

#define ASI_MMU_BYPASS 0x20

#define AJIT_UART_STORE_WORD(addr, value) {	\
        __asm__ __volatile__("sta %0, [%1] %2\n\t" : : "r"(value), "r"(addr), "i"(ASI_MMU_BYPASS) : "memory");}

#define AJIT_UART_LOAD_WORD(addr) ({	\
	u32 value;			\
        __asm__ __volatile__("lda [%1] %2, %0\n\t" : "=r"(value) : "r"(addr), "i"(ASI_MMU_BYPASS));	\
	value;	\
	})

#define AJIT_UART_LOAD_UBYTE(addr) ({	\
	u8 value;	\
        __asm__ __volatile__("lduba [%1] %2, %0\n\t" : "=r"(value) : "r"(addr), "i"(ASI_MMU_BYPASS)); \
	value;	\
	})

#define AJIT_UART_STORE_UBYTE(addr, value) {	\
	__asm__ __volatile__("stuba %0, [%1] %2\n\t" : : "r"(value), "r"(addr), "i"(ASI_MMU_BYPASS) : "memory");}

void disable_uart()
{
	AJIT_UART_STORE_WORD(UART_CTL_ADDR, 0);
}

void uart_putc(char c)
{
	while (AJIT_UART_LOAD_WORD(UART_CTL_ADDR) & UART_TX_FULL) {
	}

	AJIT_UART_STORE_UBYTE(UART_TX_ADDR, c);
}

char uart_getc()
{
	if (!(AJIT_UART_LOAD_WORD(UART_CTL_ADDR) & UART_RX_FULL))
		return -1;
	return AJIT_UART_LOAD_UBYTE(UART_RX_ADDR);
}

static int calc_baud_freq_limit(u32 baud_rate, u32 clock_freq, u32 *freq, u32 *limit)
{
	int _gcd = gcd(16 * baud_rate, clock_freq);

	if (_gcd == -1)
		return -1;

	*freq = 16 * baud_rate / _gcd;
	*limit = clock_freq / _gcd - *freq;

	return 0;
}

void enable_uart()
{
	u32 baud_freq, baud_limit, val;
	int res;

	AJIT_UART_STORE_WORD(UART_CTL_ADDR, UART_TX_ENABLE | UART_RX_ENABLE | UART_RX_INTR);

	res = calc_baud_freq_limit(AJIT_UART_BAUD_RATE, AJIT_UART_CLK_FREQ,
				   &baud_freq, &baud_limit);
	if (res != -1) {
		AJIT_UART_STORE_WORD(UART_BAUD_LIMIT_ADDR, baud_limit);
		AJIT_UART_STORE_WORD(UART_BAUD_FREQ_ADDR, baud_freq);
	}

	val = AJIT_UART_LOAD_WORD(UART_CTL_ADDR);
	AJIT_UART_STORE_WORD(UART_CTL_ADDR, 8);		// Soft reset
	AJIT_UART_STORE_WORD(UART_CTL_ADDR, val);
}

void uart_init()
{
	disable_uart();
	enable_uart();
}
