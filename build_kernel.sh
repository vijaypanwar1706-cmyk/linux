#!/bin/bash
# Simple Raspberry Pi Kernel Build Script
# Usage: ./build_kernel.sh

set -e

# 1) Export KERNEL variable
export KERNEL=kernel8
echo "[1] KERNEL set to: $KERNEL"

# 2) Configure kernel for Raspberry Pi 4 (bcm2711)
echo "[2] Running defconfig..."
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- bcm2711_defconfig

# 3) Build Image, modules and DTBs
echo "[3] Building kernel Image, modules, and dtbs..."
make -j$(nproc) ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image modules dtbs

echo "✅ Kernel build complete!"
