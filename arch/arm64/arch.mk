
ARCH = arm64
CPU = armv8-a+nofp
ARCH_CFLAGS = -march=$(CPU)
ARCH_ASM_OBJS += boot.o
