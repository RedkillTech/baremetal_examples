#! /bin/bash

KERNEL_IMAGE="./out-sparc/kernel.elf"
CPU_OPTS="-M ajit1_generic -cpu AJIT1"
MEM_OPTS="-m 2G"
GRAPHIC_OPTS="-nographic"
REMOTE_SERIAL="-serial pty -S"
KERNEL_OPTS="-kernel ${KERNEL_IMAGE}"

if [[ "$1" == "debug" ]]; then
  GDB_OPTS="-s"
else
  GDB_OPTS=""
fi

QEMU_OPTS="${CPU_OPTS} ${MEM_OPTS} ${GRAPHIC_OPTS} ${KERNEL_OPTS} ${REMOTE_SERIAL} ${GDB_OPTS} -bios none"

qemu-system-sparc ${QEMU_OPTS}
