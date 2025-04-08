
#ifndef ASM_MACROS_S
#define ASM_MACROS_S

.macro func _name, _align=2
	.section .text
	.type \_name, %function
	.align \_align
	\_name:
.endm

.macro endfunc _name
	.size \_name, . - \_name
.endm

#endif
