#include <arch.h>
#include <asm_macros.h>

.section ".text.boot"

.global system_start
.global mmu_on

// x0 has physical address of FDT blob passed from the bootloader
func system_start
	// entering at EL1 by default for now
	ldr    x5, =__stack_end
	mov    sp, x5

	ldr    x1, =clear_bss
	blr    x1               // x1 contains the addr of clear_bss

	b      start_kernel
	b      .
endfunc system_start

func clear_bss
	ldr    x5, =bss_start
	ldr    x6, =bss_end
1:
	str    xzr, [x5], #8
	cmp    x5, x6
	b.ne   1b
	ret
endfunc clear_bss

.section .bss.prebss.stack
	.align 4
DATA(__stack)
	// only for single core for now
	.skip DEFAULT_STACK_SIZE
END_DATA(__stack)
DATA(__stack_end)
