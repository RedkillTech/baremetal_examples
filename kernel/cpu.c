
#include <arch_macros.h>

void cpu_relax()
{
	while(1) arch_idle();
}
