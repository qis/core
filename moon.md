# Moon
QEMU virtualization server setup instructions.

* UEFI Menu: F2 or DEL (CTRL+ALT+DEL after POST)
* BOOT Menu: ESC

```
CPU: Intel Core i7-8700K
GPU: AMD Radeon RX 480 (HDMI1)
GPU: NVIDIA GeForce GTX 1660 SUPER (DisplayPort)
VGA: 2560x1080 (74.991 Hz)
RAM: 32 GiB
```

## Benchmarks
1. [Unigine](https://benchmark.unigine.com/)

```
Unigine Sanctuary 2.3
Unigine Tropics 1.3
Unigine Heaven 4.0
Unigine Valley 1.0
Unigine Superposition 1.1
```

2. [PassMark](https://www.passmark.com/products/performancetest/download.php)

```
PassMark PerformanceTest 11.01002
```

3. [Geekbench](https://www.geekbench.com/download/)

```
Geekbench 6.1.0
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

# Partition disk.
parted -a optimal /dev/nvme0n1
```

Partition disk using `parted`.

```sh
unit mib
mklabel gpt
mkpart boot 1 1025
mkpart swap linux-swap 1025 41985
mkpart root 41985 -1
set 1 boot on
set 2 swap on
print
quit
```

Install system.

```sh
# Create boot filesystem.
mkfs.fat -F32 /dev/nvme0n1p1

# Enable swap filesystem.
mkswap /dev/nvme0n1p2
swapon /dev/nvme0n1p2

# Create root filesystem.
modprobe zfs
zpool create -f -o ashift=12 -o cachefile= -O compression=lz4 -O atime=off -m none -R /mnt/gentoo system /dev/nvme0n1p3

# Create system datasets.
zfs create -o mountpoint=/ system/root
zfs create -o mountpoint=/home system/home
zfs create -o mountpoint=/tmp -o compression=off -o sync=disabled system/tmp
zfs create -o mountpoint=/opt -o compression=off system/opt
zfs create -o mountpoint=/var/lib/libvirt/images system/images
chmod 1777 /mnt/gentoo/tmp

# Mount filesystems.
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

# Configure mouting points.
tee /etc/fstab >/dev/null <<'EOF'
/dev/nvme0n1p1 /boot vfat defaults,noatime,noauto 0 2
/dev/nvme0n1p2 none  swap sw                      0 0
EOF

# Create make.conf.
tee /etc/portage/make.conf >/dev/null <<'EOF'
# Compiler
CFLAGS="-march=znver3 -O2 -pipe"
CXXFLAGS="${CFLAGS}"
FCFLAGS="${CFLAGS}"
FFLAGS="${CFLAGS}"
MAKEOPTS="-j17"

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
USE="alsa bash-completion caps dbus encode icu idn -nls opencl policykit -sendmail udev unicode"
USE="${USE} aac flac id3tag mad mp3 mp4 mpeg ogg opus pulseaudio sound theora vorbis x264 x265 xml"
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

# Create @core set.
curl -L https://raw.githubusercontent.com/qis/core/master/package.accept_keywords/core \
     -o /etc/portage/package.accept_keywords/core
curl -L https://raw.githubusercontent.com/qis/core/master/package.mask/core \
     -o /etc/portage/package.mask/core
curl -L https://raw.githubusercontent.com/qis/core/master/package.use/core \
     -o /etc/portage/package.use/core
curl -L https://raw.githubusercontent.com/qis/core/master/sets/core \
     -o /etc/portage/sets/core

# Install freetype and hafbuzz.
USE="-harfbuzz" emerge -1 media-libs/freetype
emerge media-libs/harfbuzz && emerge media-libs/freetype

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
make -j17
make modules_prepare
make modules_install
make install

# Rebuild @world set.
emerge -ave @world
emerge -ac

# Install @core set.
emerge -avn @core
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
GRUB_FONT="/boot/grub/fonts/terminus.pf2"
GRUB_CMDLINE_LINUX="by=id init=/usr/lib/systemd/systemd"
GRUB_CMDLINE_LINUX="${GRUB_CMDLINE_LINUX} elevator=noop net.ifnames=0"
GRUB_CMDLINE_LINUX="${GRUB_CMDLINE_LINUX} acpi_enforce_resources=lax"
GRUB_CMDLINE_LINUX="${GRUB_CMDLINE_LINUX} amdgpu.gpu_recovery=1"
GRUB_CMDLINE_LINUX_DEFAULT="quiet"
GRUB_DISABLE_LINUX_PARTUUID=true
GRUB_DISABLE_LINUX_UUID=true
GRUB_DISABLE_OS_PROBER=true
GRUB_DISABLE_RECOVERY=true
GRUB_DISABLE_SUBMENU=true
EOF

# Install GRUB bootloader.
grub-install --efi-directory=/boot --removable
grub-mkfont -s 32 -o /boot/grub/fonts/terminus.pf2 /usr/share/fonts/terminus/ter-u32b.otb

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

# Generate locale.
tee /etc/locale.gen >/dev/null <<'EOF'
en_US.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8
EOF

locale-gen

# Configure git.
git config --global core.eol lf
git config --global core.autocrlf false
git config --global core.filemode false
git config --global pull.rebase false

# Configure nvim.
git clone --recursive https://github.com/qis/vim /etc/xdg/nvim

# Build nvim telescope fzf plugin.
cd /etc/xdg/nvim/pack/plugins/opt/telescope-fzf-native
cmake -DCMAKE_BUILD_TYPE=Release -B build
cmake --build build

# Create nvim symlinks.
ln -s ../../etc/xdg/nvim /root/.config/nvim
ln -s nvim /usr/bin/vim

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
DHCP=yes
EOF
# TODO: Switch to static IP address!

# Configure python.
pip config set global.target ~/.pip
tee /etc/profile.d/pip.sh >/dev/null <<'EOF'
export PATH="${PATH}:${HOME}/.pip/bin"
export PYTHONPATH="${HOME}/.pip"
EOF

# Configure application path.
tee /etc/profile.d/path.sh >/dev/null <<'EOF'
export PATH="${HOME}/.local/bin:${PATH}"
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

# Log out as root.
exit
```

## User
Configure user settings.

```sh
# Create user directories.
LC_ALL=C xdg-user-dirs-update --force
mkdir -p ~/.local/bin

# Configure pip.
rm -rf ~/.pip; mkdir ~/.pip
pip config set global.target ~/.pip

# Configure npm.
rm -rf ~/.npm; mkdir ~/.npm
npm config set prefix ~/.npm

# Install npm packages.
npm install -g npm
npm install -g \
  typescript typescript-language-server eslint prettier terser \
  rollup @rollup/plugin-typescript rollup-plugin-terser \
  rollup-plugin-serve rollup-plugin-livereload neovim

# Configure git.
git config --global core.eol lf
git config --global core.autocrlf false
git config --global core.filemode false
git config --global pull.rebase false

# Configure nvim.
git clone --recursive git@github.com:qis/vim ~/.config/nvim

# Build nvim telescope fzf plugin.
cd ~/.config/nvim/pack/plugins/opt/telescope-fzf-native
cmake -DCMAKE_BUILD_TYPE=Release -B build
cmake --build build

# Build nvim treesitter libraries.
nvim
```

```
:TSInstall c
:TSInstall cpp
:TSInstall lua
:TSInstall javascript
:TSInstall typescript
```

```sh
# Configure audio output.
mixer

# Test audio output.
play ~/.local/music/consciousness.mp3

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
app-emulation/qemu filecaps gtk lzo vnc

# Local Options
app-emulation/qemu aio bpf curl fdt fuse gnutls io-uring ncurses
app-emulation/qemu pin-upstream-blobs sdl sdl-image spice slirp usb
app-emulation/qemu usbredir vhost-net virgl virtfs vte xattr

# Virt-Manager
app-crypt/swtpm gnutls
net-dns/dnsmasq script
net-libs/gnutls pkcs11 tools
net-misc/spice-gtk gtk3 usbredir lz4
app-emulation/libvirt fuse libvirtd pcap qemu virt-network zfs
app-emulation/virt-viewer libvirt spice
EOF

# Install virtualization ports.
emerge -avn app-emulation/{qemu,virt-manager,virt-viewer} app-crypt/swtpm

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

# Change permissions.
chown -R qis:qemu /var/lib/libvirt/images

# Reboot system.
reboot
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
