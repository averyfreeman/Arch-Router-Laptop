#!/bin/bash

# this is for Unbreakable Enterprise Kernel

# echo "Enter the version (tag) you want to clone"
# read TAG

# pacman -S python-pytest  # for make testconfig 

export TAG='ueknext-v6.8.0'

git clone --depth 1 -b "${TAG}" \
		https://github.com/oracle/linux-uek.git \
		linux-uek-"${TAG}"

cd linux-uek-"${TAG}"

make defconfig

RELEASE="$(make kernelrelease)"

sed -i 's/# CONFIG_LOCALVERSION is not set/CONFIG_LOCALVERSION="'${TAG}'"/g' .config
sed -i 's/# CONFIG_CRYPTO_DEFLATE is not set/CONFIG_CRYPTO_DEFLATE=y/g' .config
sed -i 's/# CONFIG_CRYPTO_LZO is not set/CONFIG_CRYPTO_LZO=y/g' .config
sed -i 's/# CONFIG_CRYPTO_842 is not set/CONFIG_CRYPTO_842=y/g' .config
sed -i 's/# CONFIG_CRYPTO_LZ4 is not set/CONFIG_CRYPTO_LZ4=y/g' .config
sed -i 's/# CONFIG_CRYPTO_LZ4HC is not set/CONFIG_CRYPTO_LZ4HC=y/g' .config
sed -i 's/# CONFIG_CRYPTO_ZSTD is not set/CONFIG_CRYPTO_ZSTD=y/g' .config

sed -i 's/# CONFIG_MODULE_COMPRESS_ZSTD is not set/CONFIG_MODULE_COMPRESS_ZSTD=y/g' .config

make testconfig

read -p "hit ctrl-c to cancel, enter to continue"

make savedefconfig
make
make all
make  


# make prepare
make tarzst-pkg
# make localconfig
# make ctf
# make nsdeps
# make modules_prepare
make all
make checkstack
make bzImage
make tarzst-pkg
make modules_install
make headers_install

sudo cp arch/x86/boot/bzImage /usr/lib/modules/$RELEASE/vmlinuz

sudo kernel-install add $RELEASE /usr/lib/modules/$RELEASE/vmlinuz