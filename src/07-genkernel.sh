#!/bin/sh
set -e

echo "Selecting kernel version ..."
emerge -s '^sys-kernel/gentoo-sources$'
echo "=sys-kernel/gentoo-sources-6.12.16 ~amd64" > /etc/portage/package.accept_keywords/kernel
echo "=sys-kernel/gentoo-sources-6.12.16 symlink" > /etc/portage/package.use/kernel

echo "Installing kernel sources and genkernel ..."
USE="boot firmware redistributable systemd systemd-boot uki ukify -initramfs -policykit" \
emerge -avnuU =sys-kernel/gentoo-sources-6.12.16 sys-kernel/genkernel

echo "Using genkernel(8) to configure and build a kernel image ..."
wget https://raw.githubusercontent.com/qis/core/master/genkernel.conf -O /etc/genkernel.conf
genkernel --no-cleanup --no-install bzImage

echo ""
echo "Savinig kernel config ..."
cat /usr/src/linux/.config > /boot/config

echo ""
echo "Exit chroot before executing the next script!"
