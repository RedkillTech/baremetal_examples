
# Baremetal Example

A minimal baremetal kernel that demonstrates basic hardware initialization and UART output on
multiple architectures. This project supports both ARM64 (AArch64) and SPARC v8 (AJIT) platforms,
providing a foundation for bare-metal systems programming and hardware experimentation.

## ARM64 (AArch64)

### Build instructions

- Run `./download_toolchain_arm64.sh` to download the ARM64 baremetal toolchain.
- Run `make` or `make ARCH=arm64` to build the kernel for ARM64.

### Running instructions

- Make sure you have `qemu-system-aarch64` on your machine. If not, install with `sudo apt install qemu-system-arm`
- Once qemu is installed, run `./run_qemu_arm64.sh`
- For debugging, run `./run_qemu_arm64.sh debug` to start QEMU with GDB server enabled
- Tested on qemu version v10.1.0

### Status

- Arm64 virt board boots fine & printing stuff through PL011 UART works.

## SPARC v8 (AJIT)

### Build instructions

- Download the SPARC AJIT toolchain and QEMU model from [here](https://drive.google.com/drive/folders/12qGzPdSFeEtWKQpH7LTiR0DAp3RGdAIO)
- Set up the SPARC AJIT toolchain at `toolchain/sparc/sparc-ajit1-elf/bin/sparc-ajit1-elf`
- Run `make ARCH=sparc` to build the kernel for SPARC v8.

### Running instructions

- Ensure the custom `qemu-system-sparc` binary is in your PATH
- Once qemu is installed, run `./run_qemu_ajit.sh`
- For debugging, run `./run_qemu_ajit.sh debug` to start QEMU with GDB server enabled
- Note: The AJIT machine uses a remote serial connection (PTY). The serial device path will be displayed when QEMU starts.

### Status

- SPARC v8 AJIT model with UART, Timer, & Interrupt controller works.
- The dummy kernel code just tests the UART TX though by printing stuff.
