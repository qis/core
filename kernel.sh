#!/bin/bash
set -e

color_red="\e[1;31m"
color_log="\e[1;32m"
color_clr="\e[0m"

log() {
  echo -e "${color_log}${*}${color_clr}" 1>&2
}

if [ $(id -u) -ne 0 ]; then
  log "${color_red}This script must be executed as root."
  exit 1
fi

if [ ! -f /usr/src/linux/.config ]; then
  log "${color_red}Missing kernel config."
  exit 1
fi

log "Mounting boot directory ..."
mount /boot

if [ ! -f /boot/loader/entries/linux.conf ]; then
  log "${color_red}Missing loader entry."
  exit 1
fi

log "Entering kernel sources directory ..."
cd /usr/src/linux

if [ "x${1}" = "xupdate" ]; then
  log "Updating kernel config ..."
  make oldconfig
fi

core_kernel_install="$(cat /etc/kernel/entry-token)"
if [ -z "${core_kernel_install}" ]; then
  log "${color_red}Could not determine kernel entry token."
  exit 1
fi

log "Configuring kernel ..."
make menuconfig
log ""

log "Building kernel in ${color_red}3${color_log} seconds ..."
sleep 3
make -j17

core_kernel_version="$(make -s kernelrelease)"
if [ -z "${core_kernel_version}" ]; then
  log "${color_red}Could not determine kernel version."
  exit 1
fi

log "Installing kernel modules ..."
rm -rf /lib/modules/${core_kernel_version}
make modules_prepare
make modules_install

log "Installing kernel ..."
make install

log "Copying kernel config ..."
cat .config > /boot/${core_kernel_install}/${core_kernel_version}/config

log "Removing auto-generated systemd-boot loader entry ..."
rm -f /boot/loader/entries/${core_kernel_install}-${core_kernel_version}.conf

log "Rebuilding external kernel modules ..."
emerge @module-rebuild

log "Generating initial RAM disk ..."
env --chdir=/boot dracut --force --kver "${core_kernel_version}" \
  "${core_kernel_install}/${core_kernel_version}/initrd"

core_kernel_backup="/var/kernel/$(date +'%Y-%m-%d-%H%M%S').tar.xz"
log "Creating backup in ${color_red}${core_kernel_backup}${color_log} ..."
mkdir -p /var/kernel; env --chdir=/ tar cpJf "${core_kernel_backup}" \
  boot/loader/entries/linux.conf \
  boot/${core_kernel_install}/${core_kernel_version} \
  lib/modules/${core_kernel_version} \
  usr/src/linux/.config
