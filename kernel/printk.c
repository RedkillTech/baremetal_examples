#include <types.h>
#include <uart.h>
#include <stddef.h>

void print_string(char *s)
{
	while(*s) uart_putc(*s++);
}

void print_uint(u32 num)
{
	char buf[33] = {0};
	char *cur = &buf[32];

	if (!num)
		*--cur = '0';

	while (num){
		*--cur = "0123456789"[num % 10];
		num /= 10;
	}

	while (*cur)
		uart_putc(*cur++);
}

void vprintk(va_list ap, const char *fmt)
{
	char c;
	for (u32 i = 0; fmt[i]; i++ ) {
		c = fmt[i];
		if (c == '%') {
			c =  fmt[++i];
			switch (c) {
				case 'd':
					print_uint(va_arg(ap, u32));
					break;
				case 's':
					print_string(va_arg(ap, char *));
					break;
			}
		} else {
			uart_putc(c);
		}
	}
}

void printk(const char *fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
	vprintk(ap, fmt);
	va_end(ap);
}
