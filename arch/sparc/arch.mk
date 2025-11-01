
ARCH = sparc
CPU = v8

# Use dwarf-4 format as Ajit uses GDB7, which only supports till
# dwarf-4. Remove this once Ajit toolchains are updated.

ARCH_CFLAGS = -mcpu=$(CPU) -ffixed-g7 -ffixed-g6 -gdwarf-4

CROSS_COMPILE := ${KERNEL_ROOT}/toolchain/sparc/sparc-ajit1-elf/bin/sparc-ajit1-elf

ARCH_ASM_OBJS += boot.o
