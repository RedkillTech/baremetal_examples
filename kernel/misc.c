
#include <printk.h>

#ifndef BUILD_ID
#define BUILD_ID "dev temporary build"
#endif

void print_build_info()
{
	printk("Build-id: %s \n", BUILD_ID);
	printk("Booted on UP virt board, going in idle\n");
}
