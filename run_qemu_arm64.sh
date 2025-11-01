#! /bin/bash

KERNEL_IMAGE="./out-arm64/kernel.bin"
CPU_OPTS="-M virt,gic-version=3 -cpu cortex-a72"
MEM_OPTS="-m 2G"
KERNEL_OPTS="-kernel ${KERNEL_IMAGE}"
GRAPHIC_OPTS="-nographic"
DEV_LOADER_OPTS="-device loader,addr=0x40100000,file=${KERNEL_IMAGE},cpu-num=0"

if [[ "$1" == "debug" ]]; then
  GDB_OPTS="-s -S"
else
  GDB_OPTS=""
fi

QEMU_OPTS="${CPU_OPTS} ${MEM_OPTS} ${DEV_LOADER_OPTS} ${GRAPHIC_OPTS} ${GDB_OPTS}"

qemu-system-aarch64 ${QEMU_OPTS}
