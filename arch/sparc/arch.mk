ARCH = sparc
CPU = v8

# Use dwarf-4 format as Ajit uses GDB7, which only supports till
# dwarf-4. Remove this once Ajit toolchains are updated.

ARCH_CFLAGS = -mcpu=$(CPU) -ffixed-g7 -ffixed-g6 -gdwarf-4

ARCH_ASM_OBJS += boot.o
