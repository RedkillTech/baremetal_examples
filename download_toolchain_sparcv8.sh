#!/bin/bash

# Script to download and set up Sparcv8 cross-compiling toolchain
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
TOOLCHAIN_DIR="$CURRENT_DIR/toolchain/sparc"
DOWNLOAD_DIR="/tmp"

mkdir -p "$TOOLCHAIN_DIR"

# Download the Redkill Sparcv8 AJIT embedded toolchain
TOOLCHAIN_PACKAGE='sparc-ajit.gcc.14.3.0.tar.gz'
TOOLCHAIN_URL='https://drive.usercontent.google.com/download?export=download&id=1bcMbS7DwVdmZBLvHi36oGN6nFpaQdSdq&confirm=t'

echo -e "${BLUE}Downloading toolchain from Redkill...${NC}"
cd "$DOWNLOAD_DIR"

WGET_CMD="wget -q --show-progress --progress=bar:force:noscroll \"$TOOLCHAIN_URL\" -O $TOOLCHAIN_PACKAGE"

wget -q --show-progress --progress=bar:force:noscroll "$TOOLCHAIN_URL" -O $TOOLCHAIN_PACKAGE || {
    echo -e "${RED}Failed to download toolchain. Please check the URL and your internet connection.${NC}"
    exit 1
}

echo -e "${BLUE}Extracting toolchain...${NC}"
tar xzf "$TOOLCHAIN_PACKAGE" -C "$TOOLCHAIN_DIR"

# Set path to toolchain binaries
TOOLCHAIN_BIN_PATH="$TOOLCHAIN_DIR/sparc-ajit1-elf/bin"

# Test if toolchain works
echo -e "${BLUE}Testing toolchain installation...${NC}"
if "$TOOLCHAIN_BIN_PATH/sparc-ajit1-elf-gcc" --version > /dev/null; then
    echo "Toolchain version: $("$TOOLCHAIN_BIN_PATH/sparc-ajit1-elf-gcc" --version | head -n 1)"
    echo "Installation directory: $TOOLCHAIN_BIN_PATH"
else
    echo -e "${RED}Toolchain installation failed. Please check for errors.${NC}"
    exit 1
fi

# Provide instructions for using the toolchain
echo -e "${GREEN}Sparcv8 baremetal toolchain installation completed successfully.${NC}"

# Return to original directory
cd "$CURRENT_DIR"
