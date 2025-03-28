#!/bin/sh
set -e

echo "Mounting virtual filesystems ..."
mount --types proc /proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev
mount --bind /run /mnt/gentoo/run
mount --make-slave /mnt/gentoo/run

echo "Copying network settings ..."
cp -L /etc/resolv.conf /mnt/gentoo/etc/

echo "Copying backup files ..."
mkdir -p /mnt/gentoo/backup
cp -R /mnt/backup/* /mnt/gentoo/backup/

echo "Configuring CPU flags ..."
echo "*/* `cpuid2cpuflags`" > /mnt/gentoo/etc/portage/package.use/flags

echo "Chrooting into system ..."
chroot /mnt/gentoo /bin/bash
