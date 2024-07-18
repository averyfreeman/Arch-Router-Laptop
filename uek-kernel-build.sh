#!/bin/bash

# this is for Unbreakable Enterprise Kernel

# echo "Enter the version (tag) you want to clone"
# read TAG

# pacman -S python-pytest

export TAG='v5.15.0-209.161.4'

git clone --depth 1 -b "${TAG}" \
		https://github.com/oracle/linux-uek.git \
		linux-uek-"${TAG}"


make prepare
make localconfig
make testconfig
RELEASE="$(make kernelrelease)"
make all
make ctf
make nsdeps
make modules_prepare
make bzImage
make tarzst-pkg
make modules_install
make headers_install

sudo cp arch/x86/boot/bzImage /usr/lib/modules/$RELEASE/vmlinuz

sudo kernel-install add $RELEASE /usr/lib/modules/$RELEASE/vmlinuz