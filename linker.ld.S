#include <memory_layout.h>

ENTRY(system_start)

MEMORY
{
	ROM (rx): ORIGIN = ROM_BASE, LENGTH = ROM_SIZE
	RAM (rx): ORIGIN = RAM_BASE, LENGTH = RAM_SIZE
}

SECTIONS
{
	. = ROM_BASE;

	.text.boot : {
		*(.text.boot)
	} > ROM

	.text : {
		*(.text)
	} > ROM

	.rodata : { *(.rodata) } > ROM
	.data : { *(.data) } > RAM

	. = ALIGN(8);

	.bss : {
		bss_start = .;
		KEEP(*(.bss.prebss.*))
		. = ALIGN(8);
		*(.bss)
		. = ALIGN(8);
		bss_end = .;
	} > RAM

	. = ALIGN(4096);
	kend = .;

	/DISCARD/ : {
		*(.comment)
	}
}
