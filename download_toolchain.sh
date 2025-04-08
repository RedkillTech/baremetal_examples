#!/bin/bash

# Script to download and set up ARM64 (aarch64) cross-compiling toolchain
# for baremetal development on x86_64 Linux host
# Downloads and installs to a 'toolchain' directory in the current working directory

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Create directories in current working directory
CURRENT_DIR="$(pwd)"
TOOLCHAIN_DIR="$CURRENT_DIR/toolchain"
DOWNLOAD_DIR="/tmp"

mkdir -p "$TOOLCHAIN_DIR"

# Download the GNU ARM embedded toolchain
TOOLCHAIN_VERSION="14.2.rel1"
TOOLCHAIN_PACKAGE="arm-gnu-toolchain-$TOOLCHAIN_VERSION-x86_64-aarch64-none-elf.tar.xz"
TOOLCHAIN_URL="https://developer.arm.com/-/media/Files/downloads/gnu/$TOOLCHAIN_VERSION/binrel/$TOOLCHAIN_PACKAGE"

echo -e "${BLUE}Downloading toolchain from ARM...${NC}"
cd "$DOWNLOAD_DIR"
wget -q --show-progress --progress=bar:force:noscroll "$TOOLCHAIN_URL" || {
    echo -e "${RED}Failed to download toolchain. Please check the URL and your internet connection.${NC}"
    exit 1
}

echo -e "${BLUE}Extracting toolchain...${NC}"
tar xf "$TOOLCHAIN_PACKAGE" -C "$TOOLCHAIN_DIR"

# Set path to toolchain binaries
TOOLCHAIN_BIN_PATH="$TOOLCHAIN_DIR/arm-gnu-toolchain-$TOOLCHAIN_VERSION-x86_64-aarch64-none-elf/bin"

# Test if toolchain works
echo -e "${BLUE}Testing toolchain installation...${NC}"
if "$TOOLCHAIN_BIN_PATH/aarch64-none-elf-gcc" --version > /dev/null; then
    echo "Toolchain version: $("$TOOLCHAIN_BIN_PATH/aarch64-none-elf-gcc" --version | head -n 1)"
    echo "Installation directory: $TOOLCHAIN_BIN_PATH"
else
    echo -e "${RED}Toolchain installation failed. Please check for errors.${NC}"
    exit 1
fi

# Provide instructions for using the toolchain
echo -e "${GREEN}ARM64 baremetal toolchain installation completed successfully.${NC}"

# Return to original directory
cd "$CURRENT_DIR"
