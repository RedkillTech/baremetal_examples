#! /bin/bash

KERNEL_IMAGE="./out/kernel.elf"
CPU_OPTS="-M ajit1_generic -cpu AJIT1"
MEM_OPTS="-m 2G"
GRAPHIC_OPTS="-nographic"
REMOTE_SERIAL="-serial pty -S"
KERNEL_OPTS="-kernel ${KERNEL_IMAGE}"
#DEV_LOADER_OPTS="-device loader,addr=0x40100000,file=${KERNEL_IMAGE},cpu-num=0"


QEMU_OPTS="${CPU_OPTS} ${MEM_OPTS} ${GRAPHIC_OPTS} ${KERNEL_OPTS} ${REMOTE_SERIAL} -bios none"

qemu-system-sparc ${QEMU_OPTS}
