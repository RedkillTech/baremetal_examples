
ARCH = arm64
CPU = armv8-a+nofp
ARCH_CFLAGS = -march=$(CPU)
ARCH_ASM_OBJS += boot.o

CROSS_COMPILE := ${KERNEL_ROOT}/toolchain/arm64/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-elf/bin/aarch64-none-elf
