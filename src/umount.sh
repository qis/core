#!/bin/sh
set -e

echo "umount -l /mnt/gentoo/dev{/shm,/pts,}"
umount -l /mnt/gentoo/dev{/shm,/pts,}

echo "umount -R /mnt/gentoo"
umount -R /mnt/gentoo
