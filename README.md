
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

## SPARCv8 (AJIT)

### Build instructions

- Download the custom AJIT QEMU model from [here](https://drive.google.com/drive/folders/12qGzPdSFeEtWKQpH7LTiR0DAp3RGdAIO)
- Run `./download_toolchain_sparcv8.sh` to download the SPARCv8 baremetal toolchain.
- Run `make ARCH=sparc` to build the kernel for SPARCv8.

### Running instructions

- Ensure the custom `qemu-system-sparc` binary is in your PATH
- Once qemu is installed, run `./run_qemu_ajit.sh`. Enter `c` at the qemu monitor.
- For debugging, run `./run_qemu_ajit.sh debug` to start QEMU with GDB server enabled
- Note: The AJIT machine uses a remote serial connection (PTY). The serial device path will be displayed when QEMU starts.

### Connecting to the serial console

The AJIT QEMU model uses a PTY (pseudo-terminal) for serial communication. To view the output:

1. Start QEMU with `./run_qemu_ajit.sh` - note the PTY device path in the output (e.g., `/dev/pts/X`)
2. In a separate terminal, connect using minicom:
   ```bash
   minicom -D /dev/pts/X
   ```
   Replace `X` with the actual PTY number from QEMU's output
3. If minicom is not installed, install it with: `sudo apt install minicom`
4. To exit minicom, press `Ctrl-A` followed by `X`

### Status

- SPARC v8 AJIT model with UART, Timer, & Interrupt controller works.
- The dummy kernel code just tests the UART TX though by printing stuff.

## Debugging with GDB

GDB debugging is available for both architectures. The process is the same:

1. Start QEMU in debug mode:
   - For ARM64: `./run_qemu_arm64.sh debug`
   - For SPARCv8: `./run_qemu_ajit.sh debug`
2. In a separate terminal, start GDB and connect using:
   ```bash
   gdb-multiarch -x connect.gdb
   ```
3. Set breakpoints and debug as needed.
