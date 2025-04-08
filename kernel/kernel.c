#include <types.h>
#include <printk.h>
#include <cpu.h>
#include <uart.h>

/* dtb addr to be passed by the previous stages */
void start_kernel(u64 dtb_addr)
{
	/* initialize serial */
	uart_init();

	printk("UART initialized, core entering idle mode\n");

	cpu_relax();
}
