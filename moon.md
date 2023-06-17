# Moon
QEMU virtualization server setup instructions.

* UEFI Menu: F2 or DEL (CTRL+ALT+DEL after POST)
* BOOT Menu: F1 or ESC

```
CPU: Intel Core i7-8700K
GPU: AMD Radeon RX 480 (HDMI1)
GPU: NVIDIA GeForce GTX 1660 SUPER (DisplayPort)
VGA: 2560x1080 (74.991 Hz)
RAM: 32 GiB
```

## Benchmarks
1. [Unigine](https://benchmark.unigine.com/)
2. [GravityMark](https://gravitymark.tellusim.com/)
3. [PassMark](https://www.passmark.com/products/performancetest/download.php)
4. [Geekbench](https://www.geekbench.com/download/)

Use "Admin CD" from <https://www.gentoo.org/downloads/> to create a memory stick.

```sh
# Change root password.
passwd

# Start SSH service.
rc-service sshd start

# Get IP address.
ip addr
```

SSH into live environment.

```sh
# Log in as root.
ssh root@moon

# Confirm UEFI mode.
ls /sys/firmware/efi

# Synchronize time.
chronyd -q 'server 0.gentoo.pool.ntp.org iburst'

# List block devices.
lsblk

# Partition disk 0.
parted -a optimal /dev/nvme0n1
```

```
unit mib
mklabel gpt
mkpart boot 1 513
mkpart swap linux-swap 513 16897
mkpart root 16897 953857
set 1 boot on
set 2 swap on
print
quit
```

```sh
# Partition disk 1.
parted -a optimal /dev/nvme1n1
```

```
unit mib
mklabel gpt
mkpart boot 1 513
mkpart swap linux-swap 513 16897
mkpart root 16897 953857
set 1 boot on
set 2 swap on
print
quit
```

Install system.

```sh
# Create boot filesystems.
mkfs.fat -F32 /dev/nvme0n1p1
dd if=/dev/nvme0n1p1 of=/dev/nvme1n1p1 bs=8M

# Enable swap filesystem.
mkswap /dev/nvme0n1p2
mkswap /dev/nvme1n1p2
swapon /dev/nvme0n1p2
swapon /dev/nvme1n1p2

# Create root filesystem.
modprobe zfs
zpool create -f -o ashift=12 -o cachefile= -O compression=lz4 -O atime=off -m none \
  -R /mnt/gentoo system /dev/nvme0n1p3 /dev/nvme1n1p3

# Create system datasets.
zfs create -o mountpoint=/ system/root
zfs create -o mountpoint=/home system/home
zfs create -o mountpoint=/tmp -o compression=off -o sync=disabled system/tmp
chmod 1777 /mnt/gentoo/tmp

# Mount boot filesystem.
mkdir /mnt/gentoo/boot
mount -o defaults,noatime /dev/nvme0n1p1 /mnt/gentoo/boot

# Download and extract stage 3 tarball using a mirror from https://www.gentoo.org/downloads/mirrors/.
export stage3=20230611T170207Z
export remote=releases/amd64/autobuilds/current-admincd-amd64
export mirror=https://mirror.yandex.ru/gentoo-distfiles
curl -L ${mirror}/${remote}/stage3-amd64-nomultilib-systemd-${stage3}.tar.xz -o /mnt/gentoo/stage.tar.xz
tar xpf /mnt/gentoo/stage.tar.xz --xattrs-include='*.*' --numeric-owner -C /mnt/gentoo
rm -f /mnt/gentoo/stage.tar.xz

# Redirect /var/tmp.
rmdir /mnt/gentoo/var/tmp
ln -s ../tmp /mnt/gentoo/var/tmp

# Copy zpool cache.
mkdir /mnt/gentoo/etc/zfs
cp -L /etc/zfs/zpool.cache /mnt/gentoo/etc/zfs/

# Mount virtual filesystems.
mount --types proc /proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev
mount --bind /run /mnt/gentoo/run
mount --make-slave /mnt/gentoo/run

# Copy network settings.
cp -L /etc/resolv.conf /mnt/gentoo/etc/

# Configure CPU flags.
echo "*/* `cpuid2cpuflags`" > /mnt/gentoo/etc/portage/package.use/flags

# Chroot into system.
chroot /mnt/gentoo /bin/bash
source /etc/profile
export PS1="(chroot) ${PS1}"

# Generate locale.
tee /etc/locale.gen >/dev/null <<'EOF'
en_US.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8
EOF

locale-gen
source /etc/profile
export PS1="(chroot) ${PS1}"

# Configure mouting points.
tee /etc/fstab >/dev/null <<'EOF'
/dev/nvme0n1p1 /boot vfat defaults,noatime,noauto 0 2
/dev/nvme0n1p2 none  swap sw                      0 0
/dev/nvme1n1p2 none  swap sw                      0 0
EOF

# Create make.conf.
tee /etc/portage/make.conf >/dev/null <<'EOF'
# Compiler
CFLAGS="-march=skylake -O2 -pipe"
CXXFLAGS="${CFLAGS}"
FCFLAGS="${CFLAGS}"
FFLAGS="${CFLAGS}"
MAKEOPTS="-j13"

# Locale
LC_MESSAGES=C
LINGUAS="en en_US"
L10N="en en-US"

# Portage
FEATURES="buildpkg"
GRUB_PLATFORMS="efi-64"
ACCEPT_LICENSE="* -@EULA"
CONFIG_PROTECT="/var/bind"
EMERGE_DEFAULT_OPTS="--with-bdeps=y --keep-going=y --quiet-build=y"
GENTOO_MIRRORS="https://mirror.eu.oneandone.net/linux/distributions/gentoo/gentoo/"
LUA_SINGLE_TARGET="luajit"
VIDEO_CARDS="fbdev"

# System
USE="alsa bash-completion caps dbus encode icu idn -nls opencl policykit -sendmail udev unicode xml"
USE="${USE} -X -gui -gnome -gtk -cairo -pango -kde -kwallet -plasma -qt5 -qml -sdl -xcb"
USE="${USE} -branding -doc -examples -test -handbook -telemetry"
EOF

# Synchronize portage.
cp /usr/share/portage/config/repos.conf /etc/portage/repos.conf
emerge --sync

# Read portage news.
eselect news read

# Create sets directory.
mkdir /etc/portage/sets

# Create @moon set.
curl -L https://raw.githubusercontent.com/qis/core/master/package.mask/moon \
     -o /etc/portage/package.mask/moon
curl -L https://raw.githubusercontent.com/qis/core/master/package.use/moon \
     -o /etc/portage/package.use/moon
curl -L https://raw.githubusercontent.com/qis/core/master/sets/moon \
     -o /etc/portage/sets/moon

# Verify that the @world set has no conflicts.
emerge -pve @world

# Install kernel sources.
emerge -s '^sys-kernel/gentoo-sources$'
echo "=sys-kernel/gentoo-sources-6.1.31 ~amd64" > /etc/portage/package.accept_keywords/kernel
echo "=sys-kernel/gentoo-sources-6.1.31 symlink" > /etc/portage/package.use/kernel
emerge -avnuU =sys-kernel/gentoo-sources-6.1.31 sys-kernel/linux-firmware

# Configure kernel (see "Kernel" section for more details).
curl -L https://raw.githubusercontent.com/qis/core/master/.moon -o /usr/src/linux/.config
cd /usr/src/linux
make menuconfig

# Build and install kernel.
make -j13
make modules_prepare
make modules_install
make install

# Rebuild @world set.
emerge -ave @world
emerge -ac

# Install @core set.
emerge -avn @moon
emerge -ac

# Enable filesystem services.
systemctl enable zfs.target
systemctl enable zfs-import-cache
systemctl enable zfs-mount
systemctl enable zfs-import.target

# Check if GRUB can detect the FAT filesystem.
grub-probe /boot

# Remount NVRAM variables (efivars) with read/write access.
mount -o remount,rw /sys/firmware/efi/efivars/

# Create GRUB config.
tee /etc/default/grub >/dev/null <<'EOF'
GRUB_DISTRIBUTOR="Gentoo"
GRUB_SAVEDEFAULT=true
GRUB_DEFAULT=0
GRUB_TIMEOUT=1
GRUB_TIMEOUT_STYLE=menu
GRUB_DEVICE="system/root"
GRUB_CMDLINE_LINUX="by=id init=/usr/lib/systemd/systemd"
GRUB_CMDLINE_LINUX="${GRUB_CMDLINE_LINUX} elevator=noop net.ifnames=0"
GRUB_CMDLINE_LINUX="${GRUB_CMDLINE_LINUX} acpi_enforce_resources=lax"
GRUB_CMDLINE_LINUX_DEFAULT="quiet"
GRUB_DISABLE_LINUX_PARTUUID=true
GRUB_DISABLE_LINUX_UUID=true
GRUB_DISABLE_OS_PROBER=true
GRUB_DISABLE_RECOVERY=true
GRUB_DISABLE_SUBMENU=true
EOF

# Install GRUB bootloader.
grub-install --efi-directory=/boot --removable

# Add "nvme" to "modules" in bliss-initramfs settings.
jq '.modules.files += [ "nvme" ]' \
  /etc/bliss-initramfs/settings.json | sponge \
  /etc/bliss-initramfs/settings.json

# Generate kernel initarmfs.
bliss-initramfs -k 6.1.31-gentoo
mv initrd-6.1.31-gentoo /boot/

# Update GRUB config.
grub-mkconfig -o /boot/grub/grub.cfg
sed 's; root=ZFS=[^ ]*; root=system/root;' -i /boot/grub/grub.cfg
grep vmlinuz /boot/grub/grub.cfg

# Unmount boot filesystem.
umount /boot

# Synchronize boot filesystems.
dd if=/dev/nvme0n1p1 of=/dev/nvme1n1p1 bs=8M

# Configure modules.
mkdir /etc/modprobe.d
tee /etc/modprobe.d/blacklist.conf >/dev/null <<'EOF'
blacklist pcspkr
EOF

# Configure virtual memory.
tee /etc/sysctl.d/vm.conf >/dev/null <<'EOF'
vm.max_map_count=2147483642
vm.swappiness=1
EOF

# Configure editor.
echo "EDITOR=/usr/bin/vim" > /etc/env.d/01editor

# Configure time zone.
ln -snf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

# Configure shell.
curl -L https://raw.githubusercontent.com/qis/core/master/bash.sh -o /etc/bash/bashrc.d/core

# Configure tmux.
curl -L https://raw.githubusercontent.com/qis/core/master/tmux.conf -o /etc/tmux.conf

# Configure seatd.
systemctl enable seatd

# Configure ethernet.
systemctl enable sshd
systemctl enable dhcpcd
systemctl enable systemd-networkd
systemctl enable systemd-resolved
tee /etc/systemd/network/eth0.network >/dev/null <<'EOF'
[Match]
Name=eth0

[Network]
Address=10.0.0.10/24
Gateway=10.0.0.1
DNS=10.0.0.1
EOF

# Configure python.
pip config set global.target ~/.pip
tee /etc/profile.d/pip.sh >/dev/null <<'EOF'
export PATH="${PATH}:${HOME}/.pip/bin"
export PYTHONPATH="${HOME}/.pip"
EOF

# Configure desktop runtime directory.
tee /etc/profile.d/xdg.sh >/dev/null <<'EOF'
XDG_RUNTIME_DIR=/run/user/${UID}
EOF

# Update environment.
env-update
source /etc/profile
export PS1="(chroot) ${PS1}"

# Update @world set.
emerge -auUD @world
emerge -ac

# Read portage news.
eselect news read

# Add user.
useradd -m -G users,seat,wheel,audio,input,usb,video -s /bin/bash qis
chown -R qis:qis /home/qis
passwd qis

# Configure sudo.
EDITOR=tee visudo >/dev/null <<'EOF'
Defaults env_keep += "LANG LANGUAGE LINGUAS LC_* MM_CHARSET _XKB_CHARSET"
Defaults env_keep += "EDITOR PAGER LS_COLORS TERM TMUX SESSION USERPROFILE"

root  ALL=(ALL:ALL) ALL
qis   ALL=(ALL:ALL) NOPASSWD: ALL

@includedir /etc/sudoers.d
EOF

# Link resolv.conf to systemd.
ln -snf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

# Merge config changes.
# Press 'q' to quit pager.
# Press 'n' to skip patch.
dispatch-conf

# Set root password.
passwd

# Exit chroot environment.
exit

# Unmount filesystems.
umount -l /mnt/gentoo/dev{/shm,/pts,}
umount -R /mnt/gentoo

# Halt system and remove installation media.
halt -p
```

Configure system.

```sh
# Install SSH config.
scp -r .ssh moon:

# Log in as user.
ssh moon

# Configure ssh.
chmod 0755 .ssh
chmod 0644 .ssh/*
chmod 0600 .ssh/id_rsa
cp .ssh/id_rsa.pub .ssh/authorized_keys
rm -f .ssh/.known_hosts* .ssh/known_hosts

# Log in as root.
sudo su -

# Set hostname.
hostnamectl hostname moon

# Configure locale.
localectl list-locales
localectl set-locale LANG=en_US.UTF-8
localectl set-locale LC_TIME=C.UTF-8
localectl set-locale LC_CTYPE=C.UTF-8
localectl set-locale LC_COLLATE=C.UTF-8
localectl set-locale LC_NUMERIC=C.UTF-8
localectl set-locale LC_MESSAGES=C.UTF-8
localectl set-locale LC_PAPER=ru_RU.UTF-8
localectl set-locale LC_NAME=ru_RU.UTF-8
localectl set-locale LC_ADDRESS=ru_RU.UTF-8
localectl set-locale LC_TELEPHONE=ru_RU.UTF-8
localectl set-locale LC_MONETARY=ru_RU.UTF-8
localectl set-locale LC_MEASUREMENT=ru_RU.UTF-8
localectl set-locale LC_IDENTIFICATION=ru_RU.UTF-8

# Update environment.
env-update
source /etc/profile

# Configure systemd.
systemd-firstboot --prompt --setup-machine-id

# Configure systemd services.
systemctl preset-all --preset-mode=enable-only

# Enable time synchronization.
systemctl enable systemd-timesyncd

# Create vm script.
tee /usr/bin/vm >/dev/null <<'EOF'
#!/bin/sh
if [ "${1}" = "view" ]; then
  name="${2}"
  if [ -z "${name}" ]; then
    name=$(virsh -c qemu:///system list --name | head -1)
    if [ -z "${name}" ]; then
      echo "error: no virtual machine running" 1>&2
      exit 1
    fi
  fi
  name=$(virsh -c qemu:///system list --name | grep -E "^${name}$")
  if [ -z "${name}" ]; then
    echo "error: virtual machine not running" 1>&2
    exit 1
  fi
  hyprctl dispatch exec "virt-viewer -c qemu:///system -daf --spice-preferred-compression=off ${name}" >/dev/null
else
  virsh -c qemu:///system $*
fi
EOF
chmod +x /usr/bin/vm

# Log out as root.
exit
```

## User
Configure user settings.

```sh
# Configure pip.
rm -rf ~/.pip; mkdir ~/.pip
pip config set global.target ~/.pip

# Create downloads directory.
mkdir ~/downloads

# Download windows virtio drivers.
curl -L https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso -o downloads/VirtIO.iso

# Reboot system.
sudo reboot
```

## Virtualization
Install virtualization.

```sh
# Configure virtualization ports.
tee /etc/portage/package.use/virtualization >/dev/null <<'EOF'
# System
app-emulation/qemu qemu_softmmu_targets_x86_64
app-emulation/qemu qemu_softmmu_targets_i386
app-emulation/qemu qemu_softmmu_targets_aarch64
app-emulation/qemu qemu_softmmu_targets_arm

# User Targets
app-emulation/qemu qemu_user_targets_x86_64
app-emulation/qemu qemu_user_targets_i386
app-emulation/qemu qemu_user_targets_aarch64
app-emulation/qemu qemu_user_targets_arm

# Global Options
app-emulation/qemu filecaps lzo vnc

# Local Options
app-emulation/qemu aio alsa bpf curl fdt fuse gnutls io-uring ncurses
app-emulation/qemu pin-upstream-blobs spice slirp usb usbredir vhost-net virtfs xattr

# Virt-Manager
app-crypt/swtpm gnutls
net-dns/dnsmasq script
net-libs/gnutls pkcs11 tools
app-emulation/libvirt fuse libvirtd pcap qemu virt-network zfs
app-emulation/virt-viewer libvirt spice
EOF

# Install virtualization ports.
emerge -avn app-emulation/{qemu,libvirt} app-crypt/swtpm

# Configure qemu binary formats.
grep -E '^:qemu-(aarch64|arm):' /usr/share/qemu/binfmt.d/qemu.conf > /etc/binfmt.d/qemu.conf

# Configure qemu user.
echo 'user = "qis"' >> /etc/libvirt/qemu.conf

# Add user to virtualization groups.
gpasswd -a qis kvm
gpasswd -a qis libvirt

# Reset udev ownership and permissions.
udevadm trigger -c add /dev/kvm

# Enable libvirt services.
systemctl enable libvirtd
systemctl enable libvirt-guests

# Create qemu dataset.
zfs create -o mountpoint=none system/qemu

# Reboot system.
reboot
```

Open "Virtual Machine Manager" on another machine.

```
File > Add Connection...
Hypervisor: Custom URI...
Autoconnect: [x]
Custom URI: qemu+ssh://qis@moon/system
QEMU/KVM: moon: Right Click > Details
+ Overview
  Name: moon
+ Virtual Networks
  + default
    Stop Network
    XML: 10.0.10.1/24 (.100 - .200)
    Apply
    Start Network
+ Storage
  + default
    Stop Pool
    Delete Pool
  + Add Pool
    Name: default
    Type: zfs: ZFS Pool
    Source Name: system/qemu
  + default
    Autostart: [x] On Boot
  + Add Pool
    Name: downloads
    Type: dir: Filesystem Directory
    Target Path: /home/qis/downloads
```

```sh
# Reboot system.
reboot
```

## Administration
Update virtual machine.

```sh
# Shutdown virtual machines.
vm shutdown windows-10-amd
vm shutdown windows-10-nvidia

# Destroy cloned drives.
sudo zfs destroy system/qemu/windows-10-amd
sudo zfs destroy system/qemu/windows-10-nvidia

# Start virtual machine and install updates.
vm start windows-10

# Shutdown virtual machine.
vm shutdown windows-10

# Create virtual machine snapshot.
sudo zfs snapshot system/qemu/windows-10@`date +%F`

# Clone virtual machine drive.
sudo zfs clone system/qemu/windows-10@`date +%F` system/qemu/windows-10-amd
sudo zfs clone system/qemu/windows-10@`date +%F` system/qemu/windows-10-nvidia

# Start AMD virtual machine and re-install drivers.
vm start windows-10-amd

# Shutdown AMD virtual machine.
vm shutdown windows-10-amd

# Start NVIDIA virtual machine and re-install drivers.
vm start windows-10-nvidia

# Shutdown NVIDIA virtual machine.
vm shutdown windows-10-nvidia
```

## Kernel
Configuration based on `dist-kernel` with the following changes.

```
General setup
-> Local version (LOCALVERSION [=])
-> Default hostname (DEFAULT_HOSTNAME [=moon])

Device Drivers
-> Network device support (NETDEVICES [=y])
  -> Wireless WAN
    -> WWAN Driver Core (WWAN [=y])
      -> MediaTek PCIe 5G WWAN modem T7xx device (MTK_T7XX [=m])
-> USB support (USB_SUPPORT [=y])
  -> OTG support (USB_OTG [=y])
  -> USB Gadget Support (USB_GADGET [=y])
    -> USB Gadget functions configurable through configfs (USB_CONFIGFS [=y])
      -> HID function (USB_CONFIGFS_F_HID [=y])
    -> USB Gadget precomposed configurations
      -> USB Raw Gadget (USB_RAW_GADGET [=y])
-> X86 Platform Specific Device Drivers (X86_PLATFORM_DEVICES [=y])
  -> ThinkPad ACPI Laptop Extras (THINKPAD_ACPI [=m])
```
