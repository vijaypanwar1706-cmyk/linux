#!/bin/bash

set -e

echo "==============================================="
echo "   Raspberry Pi 4 Custom Kernel Installer"
echo "==============================================="
echo ""

# Auto detect bootfs and rootfs
BOOT=$(lsblk -o MOUNTPOINT | grep bootfs | head -n 1)
ROOT=$(lsblk -o MOUNTPOINT | grep rootfs | head -n 1)

if [ -z "$BOOT" ] || [ -z "$ROOT" ]; then
    echo "ERROR: bootfs or rootfs not mounted!"
    echo "SD card ko insert karke mount hoga to /media/.../bootfs aur rootfs dikhega."
    exit 1
fi

echo "BOOT partition: $BOOT"
echo "ROOT partition: $ROOT"
echo ""

# Check required files
if [ ! -f arch/arm64/boot/Image ]; then
    echo "ERROR: arch/arm64/boot/Image not found. Run 'make Image' first."
    exit 1
fi

# Kernel copy
echo "Copying kernel Image → kernel8.img ..."
sudo cp arch/arm64/boot/Image "$BOOT/kernel8.img"

# DTB copy for Raspberry Pi 4
echo "Copying bcm2711-rpi-4-b.dtb ..."
sudo cp arch/arm64/boot/dts/broadcom/bcm2711-rpi-4-b.dtb "$BOOT/"

# Overlays copy
echo "Copying Overlays (*.dtbo) ..."
sudo cp arch/arm64/boot/dts/overlays/*.dtbo "$BOOT/overlays/"

# Module install
echo "Installing kernel modules to rootfs ..."
sudo make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- \
    modules_install INSTALL_MOD_PATH="$ROOT"

# Sync and unmount
echo "Syncing files..."
sync

echo ""
echo "==============================================="
echo "✅ Custom Raspberry Pi Kernel Installed"
echo "✅ Ab SD card ko safely remove karo"
echo "✅ Raspberry Pi 4 me insert karke boot karo"
echo "==============================================="

