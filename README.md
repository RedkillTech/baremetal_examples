# Build instructions

- Run `./download_toolchain.sh` to download the arm64 baremetal toolchain.
- Run `make` to build the kernel.

# Running instructions

- Make sure you have `qemu-system-aarch64` on your machine. If not install with `sudo apt install qemu-system-arm`
- Once qemu is installed, then just run `./run_qemu.sh`
- Tested on qemu version 9.2.2

# Status

- Boots fine, printing stuff works.
