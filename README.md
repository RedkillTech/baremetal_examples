# Build instructions

- Just do `make`.
- If you need compilation database then do `compiledb make`.

# Running instructions

- Make sure you have `qemu-system-aarch64` on your machine
- If yes, then just run `./run_qemu.sh`
- Tested on qemu version 9.2.2

# Status

- Boots fine, printing stuff works.
- UART & Timer irq works.
- 2 level page table and translation works.
- Dynamic memory allocator works

# Roadmap

- [x] UP minimal boot
- [x] UART printing with minimal printk
    - [x] Implement string printing with `%s`
    - [x] Implement unsigned int printing with `%d`
- [x] GICV3 support
    - [x] SPI & PPI support
    - [ ] Write gdb script to figure out if some interrupt is configured correctly or not.
- [x] UART irq support for console implementation
- [x] Implement a minimal console over UART
- [x] Implement generic r/w register routines
- [x] Implement a minimal shell
    - [ ] Memory r/w cmds
    - [ ] CPU info cmds
    - [ ] CPU regs r/w cmds
- [x] Implement timer ISR
- [x] Implement page table setup & enable translation
    - [ ] Cleanup addresses and virtual memory contants
    - [ ] Generalize page table setup routine to make it configurable from plat
    - [ ] Write gdb scripts to debug mmu and dump pgts.
- [x] Implement library routines like memset
    - [x] basic implementation of memset
- [x] Implement a minimal dynamic memory allocator
    - [x] Implement a constant chunk sized allocator
    - [ ] Extend it to efficiently allocate memory based on requested size
- [ ] Implement better printk support with proper fmts
    - [ ] Implement printing hex numbers with `%x`
    - [ ] Implement printing u64 numbers with `%l`
    - [ ] Implementing printing chars with `%c`
    - [ ] Implement printing pointers with `%p`
    - Won't implement format specifiers for signed types, don't see the usecase for it.
- [ ] Implement locking primitives
    - [ ] spinlocks
    - [ ] mutex
- [ ] Implement thread context which can be executed & scheduled
- [ ] Implement a minimal scheduler
- [ ] Implement SMP support for 2-4 cores
- [ ] Implement transition to userspace
- [ ] Implement svc call interface
- [ ] Setup separate irq stack if needed
- [ ] Boot the kernel with u-boot

# Open issues

- Getting a sync exception when converting distributor and redistributor bases to `uintptr_t`
- Also converting gicd base ptr to `uintptr_t` results in irqs not responding.

## Past issues

- Just fyi, pressing backspace at uart generates the ascii code for delete i.e. 127
- Was seeing UART interrupt triggered repeatedly
    - UART RX & TX irqs were not cleared from the PL011 interface UART_ICR register
- Stack getting corrupted when returning from irq handler
    - Wrong sp was provided to irq handler after saving required registers hence irq handler
    corrupted the saved values like `elr_el1`
- GIC was not receiving interrupts
    - Was writing to gic offsets without adding the base & qemu did not complain about it. :/
- Writing to sp was hanging qemu
    - Hacked it to match LK alignments to make it bootable
    - Need to trim it down to minimal things to keep it clear
    - Find out what `STT_OBJECT` means
- Take care of RAM addresses for each platform
    - Writing to sp was not working because the ram base was not mentioned correctly & I was trying
      to write to an address below the ram base which for some reason qemu did not complain about.
    - Since writing to sp was not working so lr store/restore was leading to zeros during function calls.
    - Hence the core jumped to 0x0 address as soon as it returned from `uart_init()`
- ld prints warning of loadable sections with rwx permission
    - WA: provided different memory sections in linker script for text, data sections
- printk had issues with variadic arguments, saw assembly generate q registers based ldr/str, so
disabled floating point support with `-mcpu=armv8-a+nofp`
    - It generates a sync exception when call jumps to printk

## Boot

- The kernel image needs to have a boot header to make it loadable with linux
  loaders like u-boot.
    - The format of the header is mentioned in booting.rst of arm64 and can be looked at in head.S
    - This header need not be part of the kernel image, this can be prepended to the image with
    mkimage utility provided in package `u-boot-tools`.
- kernel image should be placed on a 2MB aligned base address.
- The same file mentions the things bootloader needs to take care of like:-
	- setting up and initializing ram
	- setting up device tree blob
	- decompressing and loading kernel image
- dtb blob must be placed at an 8-byte boundary and its size should not exceed 2MB
- dtb blob will be mapped cacheable
- system registers initial value is also mentioned in the same document.
- Also mentions all the conditions to be met before jumping into the kernel.
- initrd should lie within 32 GB of the kernel image and should be less than 1
  GB of size(needs to be confirmed).

## Kernel elf

- Can convert elf to binary with objcopy. The binary file would just be a
  memory dump of the elf starting at the load address of the lowest section in
  the elf.

## Qemu Platform

- Choosing `virt` as the platform for now.(no reason, just for simplicity)
- Can write a uart driver for pl011 to enable logging.
- Peripheral programming can be done by mmios to `mmio_base+reg` addresses.
- Can find out all physical addresses from qemu source or dts.
- Can use `qemu-system-aarch64 -machine virt,dumpdtb=virt.dtb -smp 1 -nographic` to dump the virt dtb.
	- Convert to dts with: `dtc -I dtb -O dts -o virt.dts virt.dtb`

## Linker

- Can have the kernel and irq stack at the end of the kernel image.
- Use mold for faster link time when codebase grows.

## Filesystem

- Can create a simple binary file with `dd if=/dev/zero of=fs.img count=10000`
- And write a ext2 filesystem on it with `mkfs.ext2 -d os_dev -v fs.img -b 1024`
- As per qemu docs I can use this img file to directly boot the kernel image.
