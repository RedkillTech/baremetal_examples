#include <types.h>

#define wfe()       asm volatile("wfe")
#define wfi()       asm volatile("wfi")
#define arch_idle() wfi()

#define raw_write32(addr, val) ({ *(volatile u32 *)(addr) = val; })
#define raw_read32(addr)       ({ *(volatile u32 *)(addr); })

#define raw_write64(addr, val) ({ *(volatile u64 *)(addr) = val; })
#define raw_read64(addr, val)  ({ *(volatile u64 *)(addr); })

#define __stringify(x) #x
#define stringify(x) __stringify(x)

#define sys_reg_write(reg, val) ({                                  \
	asm volatile("msr " stringify(reg) ", %x0" : : "rZ" (val)); \
})

#define sys_reg_read(reg) ({                                        \
	u64 __val;						    \
	asm volatile("mrs %0, " stringify(reg) : "=r" (__val));     \
	__val;							    \
})

#define set_reg_bit(reg, bit) ({                                    \
	u64 __val = sys_reg_read(reg) | (1 << bit);                 \
	sys_reg_write(reg, __val);				    \
})

/* Registers r/w ops which lack support in GAS for direct reference by name
 * reg_s is the encoded version of these registers hardcoded in appropriate places.
 * */

#define sys_reg_write_s(reg_s, val) ({                              \
	asm volatile("msr " #reg_s ", %x0" : : "rZ" (val));         \
})

#define sys_reg_read_s(reg_s) ({                                    \
	u64 __val;						    \
	asm volatile("mrs %0, " #reg_s : "=r" (__val));              \
	__val;							    \
})

#define set_reg_bit_s(reg_s, bit) ({                                \
	u64 __val = sys_reg_read_s(reg_s) | (1 << bit);             \
	sys_reg_write_s(reg_s, __val);				    \
})

#define arch_enable_irq()	asm volatile("msr daifclr, #0x2" ::: "memory")
#define arch_disable_irq()	asm volatile("msr daifset, #0x2" ::: "memory")
