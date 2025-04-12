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
# Mount boot filesystem.
mount /boot

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

# Create loader entry.
cp /boot/loader/entries/linux.conf /boot/loader/entries/linux-test.conf
hx /boot/loader/entries/linux-test.conf

# Configure kernel.
modprobe configs
gzip -dc /proc/config.gz > /usr/src/linux/.config

# Install kernel.
/core/kernel.sh update

# Reboot system.
reboot

# Check kernel version.
uname -r

# Uninstall old kernel sources.
emerge -W =sys-kernel/gentoo-sources-6.12.21
emerge -ac

# Remove old kernel binaries.
rm -rf /boot/gentoo/6.12.21-gentoo

# Remove old kernel modules.
rm -rf /lib/modules/6.12.21-gentoo

# Delete old kernel sources.
rm -rf /usr/src/linux-6.12.21-gentoo

# Update loader entry.
mv /boot/loader/entries/linux-test.conf /boot/loader/entries/linux.conf
hx /boot/loader/entries/linux.conf

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
