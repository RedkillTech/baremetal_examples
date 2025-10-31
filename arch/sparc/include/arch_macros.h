#include <types.h>
#include <arch_cpu.h>

#define arch_idle()

#define raw_write32(addr, val) ({ *(volatile u32 *)(addr) = val; })
#define raw_read32(addr)       ({ *(volatile u32 *)(addr); })

#define raw_write64(addr, val) ({ *(volatile u64 *)(addr) = val; })
#define raw_read64(addr, val)  ({ *(volatile u64 *)(addr); })

#define arch_disable_irq()		arch_local_irq_save()
#define get_cpu_num()			arch_get_cpu_num()
