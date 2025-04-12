# Administration
Common administrative tasks.

```sh
# Show dmesg errors.
dmesg | grep -iE "error|fail"

# Show journalctl errors.
journalctl -b -p err

# Watch journalctl output.
journalctl -b -n all -f

# Watch journalctl output from service.
journalctl -b -n all -f -u thinkfan

# List ports in world set.
equery l @world

# List installed packages and their dependencies.
emerge -pte @world

# List installed packages and their USE flags.
emerge -pve @world

# Show global USE flags.
portageq envvar USE | xargs -n 1

# Rebuild world set after sync or cahnges to USE flags.
emerge -avtuUD @world

# Remove port from world set.
emerge -W app-admin/sudo

# Uninstall removed ports.
emerge -ac

# Merge config changes.
# Press 'q' to quit pager.
# Press 'n' to skip patch.
# Press 'z' to drop patch.
dispatch-conf

# Remove build directories.
rm -rf /var/tmp/portage

# List files installed by a port.
equery f --tree app-shells/bash

# List ports that depend on a port.
equery d app-shells/bash

# Show port that installed a specific file.
equery b `which btop`

# Find ports by name.
equery w sudo

# List ZFS

# Create ZFS snapshot.

# Mount ZFS snapshot.
mount -t zfs system/home/qis@<date> /mnt
```

## Update
Update system.

```sh
# Mount boot partition.
mount /boot

# Backup boot partition.
tar cvJf /var/boot-`date '+%F'`.tar.xz -C / boot

# List snapshots.
zfs list -t snapshot

# Destroy old snapshots.
# zfs destroy system/root@<name>
# zfs destroy system/var@<name>

# Create new snapshots.
zfs snapshot system/root@`date '+%F'`
zfs snapshot system/var@`date '+%F'`

# Synchronize portage repositories.
emaint sync -a

# Read portage news.
eselect news read

# Update linux kernel sources.
emerge -s '^sys-kernel/gentoo-sources$'
emerge -avn =sys-kernel/gentoo-sources-X.YY.ZZ

# Update linux kernel sources symlink.
eselect kernel list
eselect kernel set linux-X.YY.ZZ-gentoo
eselect kernel show
readlink /usr/src/linux

# Configure kernel.
modprobe configs
gzip -dc /proc/config.gz > /usr/src/linux/.config

# Build and install kernel.
/core/kernel.sh









cd /usr/src/linux
make oldconfig
make menuconfig

# Build and install kernel.
make -j17
make modules_prepare
make modules_install
make install

# Rebuild kernel modules.
emerge -av @module-rebuild

# Generate kernel initarmfs.
bliss-initramfs -k X.YY.ZZ-gentoo
mv initrd-X.YY.ZZ-gentoo /boot/

# Reboot system.
reboot

# Check kernel version.
uname -r

# Uninstall old kernel sources.
emerge -W =sys-kernel/gentoo-sources-6.1.31
emerge -ac

# Remove old kernel binaries.
rm -f /boot/*-6.1.31-*

# Remove old kernel modules.
rm -rf /lib/modules/6.1.31-gentoo

# Delete old kernel sources.
rm -rf /usr/src/linux-6.1.31-gentoo

# Update GRUB config.
grub-mkconfig -o /boot/grub/grub.cfg
sed 's; root=ZFS=[^ ]*; root=system/root;' -i /boot/grub/grub.cfg
grep vmlinuz /boot/grub/grub.cfg

# Reboot system.
reboot

# Update @world set.
emerge -auUD @world
emerge -ac

# Reboot system.
reboot
```

Update user applications.

```sh
# Update flatpak applications.
flatpak update
```
