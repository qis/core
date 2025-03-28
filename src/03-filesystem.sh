#!/bin/sh
set -e

stage=/mnt/backup/stage3-amd64-nomultilib-systemd-20250322T105044Z.tar.xz

echo "Importing Genoo GPG key ..."
curl -L https://qa-reports.gentoo.org/output/service-keys.gpg -o - | gpg --import

echo ""
echo "Verifying ${stage} ..."
gpg --verify ${stage}.asc

echo ""
echo "Creating a new ZFS pool in /dev/nvme0n1p3 ..."
echo -n "All data will be destroyed! Are you sure? [y|N]: "
read answer

if [ "x$answer" != "xy" ] && [ "x$answer" != "xY" ]; then
  echo "Aborted."
  exit 1
fi

echo ""
echo "Creating root filesystem ..."
zpool create -f -o ashift=12 -o cachefile= -O compression=lz4 -O atime=off -m none -R /mnt/gentoo system /dev/nvme0n1p3

echo "Creating system datasets ..."
zfs create -o mountpoint=/ system/root
zfs create -o mountpoint=/home system/home
zfs create -o mountpoint=/home/qis -o encryption=aes-256-gcm -o keyformat=passphrase -o keylocation=prompt system/home/qis
zfs create -o mountpoint=/tmp -o compression=off -o sync=disabled system/tmp
zfs create -o mountpoint=/opt -o compression=off system/opt
zfs create -o mountpoint=/var/lib/libvirt/images system/images

echo "Setting /tmp sticky bit ..."
chmod 1777 /mnt/gentoo/tmp

echo "Mounting boot filesystem ..."
mkdir -p /mnt/gentoo/boot
mount -o defaults,noatime /dev/nvme0n1p1 /mnt/gentoo/boot

echo ""
echo "Extracting ${stage} ..."
tar xpf ${stage} --xattrs-include='*.*' --numeric-owner -C /mnt/gentoo

echo "Redirecting /var/tmp ..."
if [ -d /mnt/gentoo/var/tmp ]; then
  rmdir /mnt/gentoo/var/tmp
fi
ln -s ../tmp /mnt/gentoo/var/tmp

echo "Redirecting /usr/opt ..."
if [ -d /mnt/gentoo/usr/opt ]; then
  rmdir /mnt/gentoo/usr/opt
fi
ln -s ../opt /mnt/gentoo/usr/opt

echo "Copying zpool cache ..."
mkdir -p /mnt/gentoo/etc/zfs
cp -L /etc/zfs/zpool.cache /mnt/gentoo/etc/zfs/
