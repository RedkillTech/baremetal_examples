#! /bin/bash

KERNEL_IMAGE="./out/kernel.bin"
CPU_OPTS="-M virt,gic-version=3 -cpu cortex-a72"
MEM_OPTS="-m 2G"
KERNEL_OPTS="-kernel ${KERNEL_IMAGE}"
GDB_OPTS="-s -S"
GRAPHIC_OPTS="-nographic"
REMOTE_SERIAL="-serial telnet:localhost:1234,server"
DEV_LOADER_OPTS="-device loader,addr=0x40100000,file=${KERNEL_IMAGE},cpu-num=0"
QEMU_OPTS="${CPU_OPTS} ${MEM_OPTS} ${DEV_LOADER_OPTS} ${GRAPHIC_OPTS}"

qemu-system-aarch64 ${QEMU_OPTS}
