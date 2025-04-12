# Core
Lenovo X13 Gen 3 AMD setup instructions.

* UEFI Menu: F1
* BOOT Menu: F12

```
CPU: AMD Ryzen 7 PRO 6850U
VGA: 2560x1600
RAM: 32 GiB
```

## Install
Download [admin][admin] image and [stage][stage] archive.

[admin]: https://distfiles.gentoo.org/releases/amd64/autobuilds/current-admincd-amd64/
[stage]: https://distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64-nomultilib-systemd/

```sh
# Set mirror.
export HTTPS="https://distfiles.gentoo.org/releases/amd64/autobuilds"
export STAGE="${HTTPS}/current-stage3-amd64-nomultilib-systemd"
export ADMIN="${HTTPS}/current-admincd-amd64"

# Download image.
wget "${ADMIN}/admincd-amd64-20250302T170343Z.iso" -O admin.iso
wget "${ADMIN}/admincd-amd64-20250302T170343Z.iso.asc" -O admin.iso.asc

# Download stage.
wget "${STAGE}/stage3-amd64-nomultilib-systemd-20250406T165023Z.tar.xz" -O stage.tar.xz
wget "${STAGE}/stage3-amd64-nomultilib-systemd-20250406T165023Z.tar.xz.asc" -O stage.tar.xz.asc

# Import Genoo GPG key.
mkdir gnupg; chmod 0700 gnupg
wget https://qa-reports.gentoo.org/output/service-keys.gpg -O - 2>/dev/null | gpg --homedir gnupg --import
gpg --homedir gnupg -k --with-colons | grep ^fpr | awk -F: '{print $10 ":6:"}' | gpg --homedir gnupg --import-ownertrust

# Verify file signatures.
gpg --homedir gnupg --verify admin.iso.asc
gpg --homedir gnupg --verify stage.tar.xz.asc

# Create installation media.
sudo dd if=admin.iso of=/dev/sda bs=4M
sudo head -c $(du -b admin.iso | cut -f -1) /dev/sda | gpg --homedir gnupg --verify admin.iso.asc -

# Add backup partition.
sudo parted -a optimal /dev/sda
```

```
unit mib
print
fix
mkpart backup fat32 801 -1
quit
```

```sh
# Format backup partition.
sudo mkfs.exfat -L "Backup" /dev/sda5

# Mount backup partition.
sudo mkdir -p /mnt/backup
sudo mount /dev/sda5 /mnt/backup

# Copy stage file.
sudo cp -R gnupg stage.tar.xz stage.tar.xz.asc /mnt/backup/
env --chdir=/mnt/backup gpg --homedir gnupg --verify stage.tar.xz.asc

# Create backup.
env --chdir=/home/qis tar cpJf /tmp/qis.tar.xz --numeric-owner .
sudo cp /tmp/qis.tar.xz /mnt/backup/qis.tar.xz
env --chdir=/tmp sha512sum qis.tar.xz | sudo tee /mnt/backup/qis.tar.xz.sha512 >/dev/null
env --chdir=/mnt/backup sha512sum -c qis.tar.xz.sha512

# Copy Wi-Fi settings (if applicable).
cat /etc/wpa_supplicant/wpa_supplicant-wlan.conf > /mnt/backup/wpa_supplicant-wlan.conf

# Clone this repository.
sudo git clone https://github.com/qis/core /mnt/backup/core

# Unmount backup partition.
sudo umount /mnt/backup

# Eject installation media.
sudo eject /dev/sda
```

Boot from the memory stick.

```sh
# Set root password.
passwd

# Load wireless interface kernel module.
modprobe ath11k_pci

# Configure network.
net-setup

# Start SSH service.
rc-service sshd start

# Show IP address.
ip addr
```

SSH into live environment.

```sh
# Log in as root.
ssh root@core

# Confirm UEFI mode.
ls /sys/firmware/efi

# List block devices.
lsblk

# Partition disk.
parted -a optimal /dev/nvme0n1
```

```
unit mib
mklabel gpt
mkpart boot 1 257
mkpart swap linux-swap 257 61697
mkpart root 61697 426684
set 1 boot on
set 2 swap on
print
quit
```

```sh
# Create boot filesystem.
mkfs.fat -F32 /dev/nvme0n1p1

# Mount backup partition.
mkdir /mnt/backup
mount /dev/sda5 /mnt/backup

# Create system directory structure.
/mnt/backup/core/bin/core-system-create

# Chroot into system.
/mnt/backup/core/bin/core-system-chroot

# Generate locale.
/core/bin/core-install-locale

# Load profile.
source /etc/profile
export PS1="(chroot) ${PS1}"

# Configure mount points.
/core/bin/core-install-fstab

# Configure portage.
# Add "lavapipe vmware" to the "VIDEO_CARDS" variable in /etc/portage/make.conf for VMWare guests.
/core/bin/core-install-portage

# Read portage news.
eselect news read

# Select kernel version.
emerge -s '^sys-kernel/gentoo-sources$'

# Install kernel sources.
# TODO: Test upgrade with 6.12.16.
/core/bin/core-install-kernel 6.12.21

# Copy kernel config.
cat /core/config > /usr/src/linux/.config

# Build kernel and system.
# NOTE: Skip the "boot" parameter if systemd-boot was already installed to the boot filesystem.
# NOTE: Kernel 6.13 CONFIG_PREEMPT_LAZY might improve audio performance.
/core/bin/core-install-system boot

# Load profile.
source /etc/profile
export PS1="(chroot) ${PS1}"

# Verify kernel version and network interfaces.
hx /boot/loader/entries/linux.conf

# Verify installed python version.
emerge -pe @world | grep dev-lang/python

# Install VMWare guest tools.
# emerge -avn app-emulation/open-vm-tools
# systemctl disable wpa_supplicant@wlan
# systemctl disable thinkfan
# systemctl enable vmtoolsd

# Merge config changes.
# Press 'q' to quit pager.
# Press 'n' to skip patch.
# Press 'z' to drop patch.
dispatch-conf

# Set root password.
passwd

# Exit chroot environment.
exit

# Unmount filesystems.
/mnt/backup/core/bin/core-system-umount

# Unmount backup partition.
umount /mnt/backup

# Halt system and remove installation media.
halt -p
```

Configure system.

```sh
# Configure user.
/core/bin/core-install-configure

# Log in as root.
sudo su -

# Configure system.
/core/bin/core-install-configure

# Reboot system.
reboot
```

## Desktop
Install and configure desktop packages.

```sh
# Log in as root.
sudo su -

# Install desktop.
/core/bin/core-install-desktop

# Reboot system.
reboot

# Check system health.
/core/health.sh
```

<!--
git update-index --chmod=+x bin/* health.sh kernel.sh
-->
