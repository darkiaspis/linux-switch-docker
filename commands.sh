#!/bin/sh

#Let clone fail0verflow repositories
cd /opt/
#Grab a coffee... downloading quite massive amount of bytes!
git clone https://github.com/fail0verflow/shofel2.git & \
git clone --recursive https://github.com/fail0verflow/switch-coreboot.git coreboot & \
git clone https://github.com/fail0verflow/switch-u-boot.git u-boot & \
git clone https://github.com/fail0verflow/switch-linux.git linux & \
#Albeit we are not going to compile the usb-loader, we just clone it from the container by exploiting the git command \
git clone https://github.com/boundarydevices/imx_usb_loader.git

#Build the shofEL2
cd /opt/shofel2/exploit
make

#Build the u-boot
cd ../../u-boot
export CROSS_COMPILE=aarch64-linux-gnu-
make nintendo-switch_defconfig
make -j4

#Then the coreboot turn
cd ../coreboot
make nintendo_switch_defconfig
make iasl
make -j4

#Grab a shorter coffee... it's the time for the linux kernel

cd ../linux
export ARCH=arm64
make nintendo-switch_defconfig
make -j4

#Make the final image
cd ../shofel2/usb_loader
../../u-boot/tools/mkimage -A arm64 -T script -C none -n "boot.scr" -d switch.scr switch.scr.img