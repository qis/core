#!/bin/sh
set -e

echo "Creating sets directory ..."
mkdir -p /etc/portage/sets

echo "Creating @core set ..."
wget https://raw.githubusercontent.com/qis/core/master/profile/package.use.force/core \
  -O /etc/portage/profile/package.use.force/core
wget https://raw.githubusercontent.com/qis/core/master/package.mask/core \
  -O /etc/portage/package.mask/core
wget https://raw.githubusercontent.com/qis/core/master/package.use/core \
  -O /etc/portage/package.use/core
wget https://raw.githubusercontent.com/qis/core/master/sets/core \
  -O /etc/portage/sets/core

echo ""
echo "Selecting kernel version ..."
emerge -s '^sys-kernel/gentoo-sources$'
echo "=sys-kernel/gentoo-sources-6.12.16 ~amd64" > /etc/portage/package.accept_keywords/kernel
echo "=sys-kernel/gentoo-sources-6.12.16 symlink" > /etc/portage/package.use/kernel

echo "Installing kernel sources ..."
emerge -avnuU =sys-kernel/gentoo-sources-6.12.16 sys-kernel/linux-firmware

echo ""
echo "Restoring kernel config ..."
# curl -L https://raw.githubusercontent.com/qis/core/master/.config -o /usr/src/linux/.config
# gzip -dc /proc/config.gz > /usr/src/linux/.config
cat /boot/config > /usr/src/linux/.config

echo "Building kernel ..."
cd /usr/src/linux
make clean
make oldconfig
make menuconfig
make -j17

echo ""
echo "Installing kernel modules ..."
make modules_prepare
make modules_install
