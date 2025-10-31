#include "asm_macros.S"
#include <arch.h>
#include <sysreg.h>

.section ".text.boot"

.global system_start

system_start:
	/*
	 * Initial State
	 *
	 * CWP:   7 (Start Window)
	 * ET:    1 (Traps enabled)
	 * S:     1 (Supervisor Mode)
	 * PIL: 0xf (Interrupts disabled)
	 * WIM:   1  (Window 0 is invalid)
	 */
	mov		(7 | 1 << 5 | 1<< 7 | 0xf << 8), %psr
	mov		WIM(0), %wim
	/*
	 * 3 NOPs after PSR and WIM updates to ensure that the updated
	 * state is observed by next instructions.
	 */
	nop3
	/*
	 * Setup fp, sp after windows have been initialized above.
	 */
	set		0, %fp
	set		__stack_end, %sp
	add		%sp, -96, %sp			! Reserved a stack frame
	set		clear_bss, %l0
	call		%l0
	nop						! Delay slot
	set		start_kernel, %l0
	jmp		%l0
	nop						! Delay slot

clear_bss:
	set		bss_start, %l0			! Start
	set		bss_end, %l2			! End
.Lclear_loop:
	clr		[%l0]
	add		%l0, 4, %l0
	cmp		%l0, %l2
	bne		.Lclear_loop
	nop						! Delay slot
	jmp		%o7 + 8
	nop						! Delay slot

.section .bss.prebss.stack
	.align	8
__stack_start:
.skip DEFAULT_STACK_SIZE
__stack_end:
