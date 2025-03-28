#!/bin/sh
set -e

echo "Synchronizing time ..."
chronyd -q 'server ntp1.vniiftri.ru iburst'

echo ""
echo "Listing block devices ..."
lsblk

echo ""
echo "Listing EFI variables directory ..."
ls /sys/firmware/efi

echo ""
echo "Enabling swap filesystem ..."
swapon /dev/nvme0n1p2

echo ""
echo "Loading ZFS kernel module ..."
modprobe zfs
