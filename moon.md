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

# TODO: Remove this!
# rm -rf /lib/modules/6.1.31-gentoo

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
GRUB_GFXPAYLOAD_LINUX=text
GRUB_TERMINAL=console
GRUB_DEFAULT=0
GRUB_TIMEOUT=1
GRUB_TIMEOUT_STYLE=hidden
GRUB_DISTRIBUTOR="Gentoo"
GRUB_DEVICE="system/root"
GRUB_DISABLE_UUID=true
GRUB_DISABLE_SUBMENU=true
GRUB_DISABLE_RECOVERY=true
GRUB_DISABLE_OS_PROBER=true
GRUB_CMDLINE_LINUX="by=id init=/usr/lib/systemd/systemd"
GRUB_CMDLINE_LINUX="${GRUB_CMDLINE_LINUX} elevator=noop net.ifnames=0"
GRUB_CMDLINE_LINUX="${GRUB_CMDLINE_LINUX} acpi_enforce_resources=lax"
GRUB_CMDLINE_LINUX_DEFAULT="iommu=pt intel_iommu=on pcie_acs_override=downstream,multifunction"
GRUB_CMDLINE_LINUX_DEFAULT="${GRUB_CMDLINE_LINUX_DEFAULT} nofb nomodeset video=vesafb:off,efifb:off"
EOF

# List IOMMU groups.
for d in /sys/kernel/iommu_groups/*/devices/*; do n=${d#*/iommu_groups/*}; n=${n%%/*}; printf 'IOMMU Group %s ' "$n"; lspci -nns "${d##*/}"; done

# IOMMU Group 1
# 00:01.0 PCI bridge [0604]: Intel Corporation 6th-10th Gen Core Processor PCIe Controller (x16) [8086:1901] (rev 07)
# 00:01.1 PCI bridge [0604]: Intel Corporation Xeon E3-1200 v5/E3-1500 v5/6th Gen Core Processor PCIe Controller (x8) [8086:1905] (rev 07)
# 01:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Ellesmere [Radeon RX 470/480/570/570X/580/580X/590] [1002:67df] (rev c7)
# 01:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] Ellesmere HDMI Audio [Radeon RX 470/480 / 570/580/590] [1002:aaf0]
# 02:00.0 VGA compatible controller [0300]: NVIDIA Corporation TU116 [GeForce GTX 1660 SUPER] [10de:21c4] (rev a1)
# 02:00.1 Audio device [0403]: NVIDIA Corporation TU116 High Definition Audio Controller [10de:1aeb] (rev a1)
# 02:00.2 USB controller [0c03]: NVIDIA Corporation TU116 USB 3.1 Host Controller [10de:1aec] (rev a1)
# 02:00.3 Serial bus controller [0c80]: NVIDIA Corporation TU116 USB Type-C UCSI Controller [10de:1aed] (rev a1)

# Add VGA PCI IDs to VFIO.
tee -a /etc/default/grub >/dev/null <<'EOF'
GRUB_CMDLINE_LINUX_DEFAULT="${GRUB_CMDLINE_LINUX_DEFAULT} vfio-pci.ids=8086:1901,8086:1905,1002:67df,1002:aaf0,10de:21c4,10de:1aeb,10de:1aec,10de:1aed"
EOF

# Install GRUB bootloader.
grub-install --efi-directory=/boot --removable

# Add "nvme" to "modules" in bliss-initramfs settings.
jq '.modules.files += [ "nvme" ]' \
  /etc/bliss-initramfs/settings.json | sponge \
  /etc/bliss-initramfs/settings.json

# Generate kernel initarmfs.
# emerge -av @module-rebuild
bliss-initramfs -k 6.1.31-gentoo
mv initrd-6.1.31-gentoo /boot/

# TODO: Remove this!
rm -f /boot/*.old

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

# Verify that IOMMU is enabled.
dmesg | grep 'IOMMU enabled'

# List VGA modules.
dmesg | grep -i vga

# List PCI devices.
lspci -tv

# Verify PCI devices driver assignment.
lspci -vs 00:01.0  # Kernel driver in use: pcieport
lspci -vs 00:01.1  # Kernel driver in use: pcieport
lspci -vs 01:00.0  # Kernel driver in use: vfio-pci
lspci -vs 01:00.1  # Kernel driver in use: vfio-pci
lspci -vs 02:00.0  # Kernel driver in use: vfio-pci
lspci -vs 02:00.1  # Kernel driver in use: vfio-pci
lspci -vs 02:00.2  # Kernel driver in use: vfio-pci
lspci -vs 02:00.3  # Kernel driver in use: vfio-pci

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

* Create a virtual machine.
  - RAM: 24576 MiB
  - CPU: 12
  - HDD: 20 GiB (64 GiB for Windows 10, 128 GiB for Windows 11)
  - Name: `${os}-${version}` (major version or no version for rolling release)
  - [x] Customize configuration before install
  - Network selection: Isolated network (for Windows)
  - Enter Overview/Title.
  - Select Overview/Firmware:
    - UEFI x8_64: `/usr/share/edk2-ovmf/OVMF_CODE.fd`
    - UEFI x8_64: `/usr/share/edk2-ovmf/OVMF_CODE.secboot.fd` (for Windows 11)
  - Change CPUs/Topology:
    - Sockets: 1
    - Cores: 6
    - Threads: 2
  - Remove "USB Redirector" devices.
  - Apply Windows specific changes.
    - Add CDROM "Storage" device and mount `VirtIO.iso`.
    - Change "Disk 1" device type to VirtIO.
    - Change "TPM" device model to TIS v2.0.

* Install virtual machine.
  - Use `E:\amd64\win10\vioscsi.inf` SCSI driver on Windows 10.
  - Use `E:\amd64\win11\vioscsi.inf` SCSI driver on Windows 11.
  - Make sure the system time is correct across reboots.
    - Set `HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation\RealTimeIsUniversal`.
    - Disable NTP.
  - Activate Windows with WIN+R and `SLUI 4`.
  - Shutdown virtual machine.

* Configure virtual machine.
  - Execute `zfs rename system/qemu/${os}-${version}.qcow2 system/qemu/${os}-${version}`.
  - Change "Disk 1" XML `system/qemu/${os}-${version}.qcow2` to `system/qemu/${os}-${version}`.
  - Change "Overview" XML `<audio id="1" type="spice"/>` to `<audio id="1" type="none"/>`.
  - Add "USB Host Device" for connected keyboard and mouse.
  - Remove "Channel (spice)" device.

* Create "clean" snapshot.
  - Execute `zfs snapshot system/qemu/${os}-${version}@clean`.

* Clone virtual machine with name `${os}-${version}-${gpu}`.
  - Do not clone any storage devices.

* Synchronize virtual machine clone settings.
  - Execute `diff <(vm dumpxml ${os}-${version}) <(vm dumpxml ${os}-${version}-${gpu})`.
  - Everything except `<name>`, `<uuid>` and `<title>` must match.

* Configure virtual machine clone.
  - Execute `zfs snapshot system/qemu/${os}-${version}@$(date +%F)`.
  - Execute `zfs clone system/qemu/${os}-${version}@$(date +%F) system/qemu/${os}-${version}-${gpu}`.
  - Change "Disk 1" XML `system/qemu/${os}-${version}` to `system/qemu/${os}-${version}-${gpu}`.
  - Add "PCI Host Device" for each GPU related device.

* Start virtual machine clone and install drivers.
  - Reboot host before using an AMD GPU a second time.
  - If the device isn't recognized on Windows:
    - Make sure the device is enabled in "Device Manager".
    - Install official drivers from the vendor website.
  - Shutdown virtual machine clone.
  - Remove "Display" and "Graphics" devices.

* Create "drivers" snapshot.
  - Execute `zfs snapshot system/qemu/${os}-${version}-${gpu}@drivers`.

<!--

Change Windows 10 and 11 settings before re-creating virtual machine clones.

* Configure Edge.
* Accept `ssh moon` known key.
* Change mouse pointer speed to 6.

-->

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

-> IOMMU Hardware Support (IOMMU_SUPPORT [=y])
  -> AMD IOMMU support (AMD_IOMMU [=y])
    -> AMD IOMMU Version 2 driver (AMD_IOMMU_V2 [=y])
  -> Support for Intel IOMMU using DMA Remapping Devices (INTEL_IOMMU [=y])
    -> Support for Shared Virtual Memory with Intel IOMMU (INTEL_IOMMU_SVM [=y])
    -> Enable Intel DMA Remapping Devices by default (INTEL_IOMMU_DEFAULT_ON [=y])
  -> Support for Interrupt Remapping (IRQ_REMAP [=y])

-> VFIO Non-Privileged userspace driver framework (VFIO [=y])
  -> VFIO No-IOMMU support (VFIO_NOIOMMU [=y])
  -> Generic VFIO support for any PCI device (VFIO_PCI [=y])
    -> Generic VFIO PCI support for VGA devices (VFIO_PCI_VGA [=y])
    -> Generic VFIO PCI extensions for Intel graphics (GVT-d) (VFIO_PCI_IGD [=y])
  -> VFIO support for MLX5 PCI devices (MLX5_VFIO_PCI [=n])
  -> Mediated device driver framework (VFIO_MDEV [=n])
```
