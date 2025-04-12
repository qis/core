# Backup
Boot the "Admin CD" installation media.

```sh
# Mount backup partition.
mkdir /mnt/backup
mount /dev/sda5 /mnt/backup

# Create system directory structure.
/mnt/backup/core/bin/core-system-import

# Unmount backup partition.
umount /mnt/backup

# Mount backup partition.
mkdir -p /mnt/gentoo/mnt/backup
mount /dev/sda5 /mnt/gentoo/mnt/backup

# Chroot into system.
/mnt/gentoo/mnt/backup/core/bin/core-system-chroot

# Load profile.
source /etc/profile
export PS1="(chroot) ${PS1}"

# TODO

# Exit chroot environment.
exit

# Unmount backup partition.
umount /mnt/gentoo/mnt/backup

# Mount backup partition.
mount /dev/sda5 /mnt/backup

# Unmount filesystems.
/mnt/backup/core/bin/core-system-umount

# Unmount backup partition.
umount /mnt/backup

# Halt system and remove installation media.
halt -p
```






Create backup pool on "Admin CD" memory stick.

```sh
# List block devices.
lsblk

# Partition USB drive.
parted -a optimal /dev/sda
```

```sh
unit mib
mkpart backup 1024 -1
quit
```

```sh
# Create mount point.
mkdir /mnt/backup

# Create filesystem.
zpool create -f -o ashift=12 -o cachefile= -O compression=lz4 -O atime=off -m none -R /mnt/backup backup /dev/sda5
zfs create -o encryption=aes-256-gcm -o keyformat=passphrase -o keylocation=prompt backup/home

# Disconnect pool.
zpool export backup

# Eject drive.
eject /dev/sda
```

Backup user directory.

```sh
# Import backup pool.
zpool import -d /dev/sda5 -fR /mnt/backup backup
zfs load-key -r backup/home

# List snapshots.
zfs list -t snapshot backup/home/qis

# Create backup.
export date=`date '+%F'`
zfs snapshot system/home/qis@${date}
zfs send system/home/qis@${date} | sudo zfs receive backup/home/qis@${date}
zfs destroy system/home/qis@${date}

# Export backup pool.
zpool export backup

# Eject drive.
eject /dev/sda
```

## Remote

Create remote backup.

```sh
# Set snapshot name.
snapshot=`date '+%F'`

# Mount boot partition.
sudo mount /boot

# Create boot partition archive.
sudo tar cvJf /var/boot-${snapshot}.tar.xz -C / boot

# Create snapshots.
sudo zfs snapshot -r system@${snapshot}

# Send snapshots.
sudo zfs send -Rw system@${snapshot} | ssh -o compression=no moon sudo zfs recv system/core

# Destroy snapshots.
sudo zfs destroy -r system@${snapshot}

# Delete boot partition archive.
sudo rm -f /var/boot-${snapshot}.tar.xz

# Connect to backup host.
ssh moon

# Fix mount points.
sudo zfs list -o name,mountpoint
sudo zfs set mountpoint=/core system/core/root
sudo zfs set mountpoint=/core/home system/core/home
sudo zfs set mountpoint=/core/home/qis system/core/home/qis
sudo zfs set mountpoint=/core/opt system/core/opt
sudo zfs set mountpoint=/core/opt/data system/core/opt/data
sudo zfs set mountpoint=/core/tmp system/core/tmp
sudo zfs load-key -r system/core/home/qis
sudo zfs mount system/core/home/qis

# Destroy snapshots.
sudo zfs destroy -r system/core@2023-12-12
```

</details>

<details>
<summary>Remote Restore</summary>

Restore remote backup.

```sh
TODO
```
