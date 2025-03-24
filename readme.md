# Core
Lenovo X13 Gen 3 AMD setup instructions.

* UEFI Menu: F1
* BOOT Menu: F12

```
CPU: AMD Ryzen 7 PRO 6850U
VGA: 2560x1600
RAM: 32 GiB
```

## System
Download "Admin CD" from <https://www.gentoo.org/downloads/> and create a memory stick.

```sh
curl -L https://raw.githubusercontent.com/qis/core/master/download.sh -o download.sh
sh download.sh gpg
sh download.sh admin
```

Boot "Admin CD" image.

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
ssh root@core

# Confirm UEFI mode.
ls /sys/firmware/efi

# Synchronize time.
chronyd -q 'server ntp1.vniiftri.ru iburst'

# List block devices.
lsblk

# Partition disk.
parted -a optimal /dev/nvme0n1
```

```
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

```sh
# Create boot filesystem.
mkfs.fat -F32 /dev/nvme0n1p1

# Create swap filesystem.
mkswap /dev/nvme0n1p2

# Enable swap filesystem.
swapon /dev/nvme0n1p2

# Load ZFS kernel module.
modprobe zfs

# Create root filesystem.
zpool create -f -o ashift=12 -o cachefile= -O compression=lz4 -O atime=off -m none -R /mnt/gentoo system /dev/nvme0n1p3

# Create system datasets.
zfs create -o mountpoint=/ system/root
zfs create -o mountpoint=/home system/home
zfs create -o mountpoint=/home/qis -o encryption=aes-256-gcm -o keyformat=passphrase -o keylocation=prompt system/home/qis
zfs create -o mountpoint=/tmp -o compression=off -o sync=disabled system/tmp
zfs create -o mountpoint=/opt -o compression=off system/opt
zfs create -o mountpoint=/var/lib/libvirt/images system/images
chmod 1777 /mnt/gentoo/tmp

# Mount boot filesystem.
mkdir /mnt/gentoo/boot
mount -o defaults,noatime /dev/nvme0n1p1 /mnt/gentoo/boot

# Download and extract stage tarball.
curl -L https://raw.githubusercontent.com/qis/core/master/download.sh -o /tmp/download.sh
env --chdir=/tmp sh download.sh gpg
env --chdir=/tmp sh download.sh stage
tar xpf /tmp/stage.tar.xz --xattrs-include='*.*' --numeric-owner -C /mnt/gentoo

# Redirect /var/tmp.
rmdir /mnt/gentoo/var/tmp
ln -s ../tmp /mnt/gentoo/var/tmp

# Redirect /usr/opt.
ln -s ../opt /mnt/gentoo/usr/opt

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

# Generate locale.
tee /etc/locale.gen >/dev/null <<'EOF'
en_US.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8
EOF

locale-gen

# Load profile.
source /etc/profile
export PS1="(chroot) ${PS1}"

# Configure mouting points.
tee /etc/fstab >/dev/null <<'EOF'
/dev/nvme0n1p1 /boot vfat defaults,noatime,noauto 0 2
/dev/nvme0n1p2 none  swap sw                      0 0
EOF

# Create make.conf.
wget https://raw.githubusercontent.com/qis/core/master/make.conf -O /etc/portage/make.conf

# Synchronize portage.
cp /usr/share/portage/config/repos.conf /etc/portage/repos.conf
emerge --sync

# Mark portage news as read.
eselect news read

# Select kernel version.
emerge -s '^sys-kernel/gentoo-sources$'
echo "=sys-kernel/gentoo-sources-6.12.16 ~amd64" > /etc/portage/package.accept_keywords/kernel
echo "=sys-kernel/gentoo-sources-6.12.16 symlink" > /etc/portage/package.use/kernel

# Install kernel sources and genkernel.
USE="boot firmware redistributable systemd systemd-boot uki ukify -initramfs -policykit" \
emerge -avnuU =sys-kernel/gentoo-sources-6.12.16 sys-kernel/genkernel

# Use genkernel(8) to configure and build a kernel image.
wget https://raw.githubusercontent.com/qis/core/master/genkernel.conf -O /etc/genkernel.conf
genkernel --no-cleanup --no-install bzImage
```

```
Gentoo Linux  --->

    Support for init systems, system and service managers  --->

        [ ] OpenRC, runit and other script based systems and managers
        Symbol: GENTOO_LINUX_INIT_SCRIPT

        [*] systemd
        Symbol: GENTOO_LINUX_INIT_SYSTEMD

General setup  --->

    (/lib/systemd/systemd) Default init path
    Symbol: DEFAULT_INIT

    (core) Default hostname
    Symbol: DEFAULT_HOSTNAME

    Preemption Model (Preemptible Kernel (Low-Latency Desktop))  --->
    Symbol: PREEMPT

    [*] Configure standard kernel features (expert users)  --->
    Symbol: EXPERT

        [ ]   Enable PC-Speaker support
        Symbol: PCSPKR_PLATFORM

Processor type and features  --->

    [ ] Support for extended (non-PC) x86 platforms
    Symbol: X86_EXTENDED_PLATFORM

    [*] Supported processor vendors  --->
    Symbol: PROCESSOR_SELECT

        [*]   Support AMD processors
        Symbol: CPU_SUP_AMD

        Disable everything else.

    [ ] Enable Maximum number of SMP Processors and NUMA Nodes
    Symbol: MAXSMP

    (16) Maximum number of CPUs
    Symbol: NR_CPUS

    [ ] Enable 5-level page tables support
    Symbol: X86_5LEVEL

    Timer frequency (1000 HZ)  --->
    Symbol: HZ_1000

Power management and ACPI options  --->

    (/dev/nvme0n1p2) Default resume partition
    Symbol: PM_STD_PARTITION

File systems  --->

    DOS/FAT/EXFAT/NT Filesystems  --->

        <*> MSDOS fs support
        Symbol: MSDOS_FS

        <*> VFAT (Windows-95) fs support
        Symbol: VFAT_FS

        <*> exFAT filesystem support
        Symbol: EXFAT_FS

        < > NTFS file system support
        Symbol: NTFS_FS

        < > NTFS Read-Write file system support
        Symbol: NTFS3_FS

    -*- Native language support  --->

        {*}   NLS UTF-8
        Symbol: NLS_UTF8

Device Drivers  --->

    NVME Support  --->

        <*> NVM Express block device
        Symbol: BLK_DEV_NVME

        [*] NVMe multipath support
        Symbol: NVME_MULTIPATH

        [*] NVMe hardware monitoring
        Symbol: NVME_HWMON

        Disable everything else.

    Graphics support  --->

        Frame buffer Devices  --->

            <*> Support for frame buffer device drivers  --->
            Symbol: FB

                [*]   EFI-based Framebuffer Support
                Symbol: FB_EFI

                Disable everything else.

            Disable everything else.

Library routines  --->

    [*] Select compiled-in fonts
    Symbol: FONTS

        [ ]   VGA 8x16 font
        Symbol: FONT_8x16

        [ ]   Medium-size 6x10 font
        Symbol: FONT_6x10

        [*] Terminus 16x32 font (not supported by all drivers)
        Symbol: FONT_TER16x32

[*] Mitigations for CPU vulnerabilities  --->
Symbol: CPU_MITIGATIONS

    [*]   Remove the kernel mapping in user mode
    Symbol: MITIGATION_PAGE_TABLE_ISOLATION

    [*]   Mitigate SPECTRE V1 hardware bug
    Symbol: MITIGATION_SPECTRE_V1

    Disable unwanted mitigations.
```

```sh
# Save kernel config.
cat /usr/src/linux/.config > /boot/config

# Exit chroot environment.
exit

# Unmount filesystems.
umount -l /mnt/gentoo/dev{/shm,/pts,}
umount -R /mnt/gentoo

# Delete root filesystem.
zpool destroy system

# Create root filesystem.
zpool create -f -o ashift=12 -o cachefile= -O compression=lz4 -O atime=off -m none -R /mnt/gentoo system /dev/nvme0n1p3

# Create system datasets.
zfs create -o mountpoint=/ system/root
zfs create -o mountpoint=/home system/home
zfs create -o mountpoint=/home/qis -o encryption=aes-256-gcm -o keyformat=passphrase -o keylocation=prompt system/home/qis
zfs create -o mountpoint=/tmp -o compression=off -o sync=disabled system/tmp
zfs create -o mountpoint=/opt -o compression=off system/opt
zfs create -o mountpoint=/var/lib/libvirt/images system/images
chmod 1777 /mnt/gentoo/tmp

# Mount boot filesystem.
mkdir /mnt/gentoo/boot
mount -o defaults,noatime /dev/nvme0n1p1 /mnt/gentoo/boot

# Download and extract stage tarball.
tar xpf /tmp/stage.tar.xz --xattrs-include='*.*' --numeric-owner -C /mnt/gentoo

# Redirect /var/tmp.
rmdir /mnt/gentoo/var/tmp
ln -s ../tmp /mnt/gentoo/var/tmp

# Redirect /usr/opt.
ln -s ../opt /mnt/gentoo/usr/opt

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

# Generate locale.
tee /etc/locale.gen >/dev/null <<'EOF'
en_US.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8
EOF

locale-gen

# Load profile.
source /etc/profile
export PS1="(chroot) ${PS1}"

# Configure mouting points.
tee /etc/fstab >/dev/null <<'EOF'
/dev/nvme0n1p1 /boot vfat defaults,noatime,noauto 0 2
/dev/nvme0n1p2 none  swap sw                      0 0
EOF

# Create make.conf.
# Add `vmware` to the `VIDEO_CARDS` list for VMWare guest.
wget https://raw.githubusercontent.com/qis/core/master/make.conf -O /etc/portage/make.conf

# Synchronize portage.
cp /usr/share/portage/config/repos.conf /etc/portage/repos.conf
emerge --sync

# Mark portage news as read.
eselect news read

# Create sets directory.
mkdir /etc/portage/sets

# Create @core set.
wget https://raw.githubusercontent.com/qis/core/master/package.accept_keywords/core \
  -O /etc/portage/package.accept_keywords/core
wget https://raw.githubusercontent.com/qis/core/master/package.mask/core \
  -O /etc/portage/package.mask/core
wget https://raw.githubusercontent.com/qis/core/master/package.use/core \
  -O /etc/portage/package.use/core
wget https://raw.githubusercontent.com/qis/core/master/sets/core \
  -O /etc/portage/sets/core

# Select kernel version.
echo "=sys-kernel/gentoo-sources-6.12.16 ~amd64" > /etc/portage/package.accept_keywords/kernel
echo "=sys-kernel/gentoo-sources-6.12.16 symlink" > /etc/portage/package.use/kernel

# Install kernel sources.
emerge -avnuU =sys-kernel/gentoo-sources-6.12.16 sys-kernel/linux-firmware

# Build kernel.
# curl -L https://raw.githubusercontent.com/qis/core/master/.config -o /usr/src/linux/.config
# gzip -dc /proc/config.gz > /usr/src/linux/.config
cat /boot/config > /usr/src/linux/.config
cd /usr/src/linux
make clean
make oldconfig
make menuconfig
make -j17
make modules_prepare
make modules_install

# Install curl and freetype without circular dependencies.
USE="-harfbuzz" emerge -1 net-misc/curl media-libs/freetype

# Install harfbuzz and rebuild freetype with harfbuzz support.
emerge media-libs/harfbuzz && emerge media-libs/freetype

# Rebuild @world set.
emerge -ave @world
emerge -ac

# Install @core set.
emerge -avn @core
emerge -ac

# Remount NVRAM variables (efivars) with read/write access.
mount -o remount,rw /sys/firmware/efi/efivars

# Install systemd-boot to ESP.
bootctl install

# Configure systemd-boot loader.
tee /boot/loader/loader.conf >/dev/null <<'EOF'
timeout 3
default @saved
console-mode keep
auto-firmware false
auto-entries true
editor false
beep false
EOF

# Configure installkernel(8).
echo gentoo > /etc/kernel/entry-token

tee /etc/kernel/install.conf >/dev/null <<'EOF'
layout=bls
initrd_generator=none
uki_generator=ukify
EOF

# Install kernel.
cd /usr/src/linux
make install

# Install kernel initarmfs.
bliss-initramfs -k 6.12.16-gentoo
mv initrd-6.12.16-gentoo /boot/gentoo/6.12.16-gentoo/initrd

# Copy kernel config.
cat /usr/src/linux/.config > /boot/gentoo/6.12.16-gentoo/config

# Configure systemd-boot loader entry.
rm -f /boot/loader/entries/gentoo-6.12.16-gentoo.conf

tee /boot/loader/entries/linux.conf >/dev/null <<'EOF'
title Linux
linux /gentoo/6.12.16-gentoo/linux
initrd /gentoo/6.12.16-gentoo/microcode-amd
initrd /gentoo/6.12.16-gentoo/initrd
options root=system/root ro acpi_enforce_resources=lax quiet
EOF

# Enable filesystem services.
systemctl enable zfs.target
systemctl enable zfs-import-cache
systemctl enable zfs-mount
systemctl enable zfs-import.target

# Install tools for VMWare guest.
# emerge -avn app-emulation/open-vm-tools
# systemctl enable vmtoolsd

# Create editor symlinks.
ln -s nvim /usr/bin/vim
ln -s nvim /usr/bin/vi

# Configure editor.
echo "EDITOR=/usr/bin/vim" > /etc/env.d/01editor

# Configure time zone.
ln -snf /usr/share/zoneinfo/Europe/Moscow /etc/localtime

# Configure virtual memory.
mkdir -p /etc/sysctl.d && tee /etc/sysctl.d/vm.conf >/dev/null <<'EOF'
vm.max_map_count=2147483642
vm.swappiness=1
EOF

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

# Configure wireless.
emerge -avn net-wireless/iw net-wireless/wpa_supplicant

tee /etc/systemd/network/wlan0.network >/dev/null <<'EOF'
[Match]
Name=wlan0

[Network]
DHCP=yes
EOF

rfkill unblock all

tee /etc/wpa_supplicant/wpa_supplicant-wlan0.conf >/dev/null <<'EOF'
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel
device_name=core
update_config=0
eapol_version=1
fast_reauth=1
country=DE
ap_scan=1
autoscan=exponential:3:60

network={
  priority=1
  scan_ssid=1
  ssid="......."
  psk="........"
  proto=RSN
  key_mgmt=WPA-PSK
  pairwise=CCMP
  group=CCMP
}
EOF

chmod 0640 /etc/wpa_supplicant/wpa_supplicant-wlan0.conf

ln -s /lib/systemd/system/wpa_supplicant@.service \
  /etc/systemd/system/multi-user.target.wants/wpa_supplicant@wlan0.service

systemctl enable wpa_supplicant@wlan0

tee /lib/systemd/system-sleep/wifi.sh >/dev/null <<'EOF'
#!/bin/bash
if [ "${1}" = "pre" ]; then
  exec /sbin/rmmod mtk_t7xx
elif [ "${1}" = "post" ]; then
  exec /sbin/modprobe mtk_t7xx
fi
exit 0
EOF

chmod +x /lib/systemd/system-sleep/wifi.sh

# Configure sensors and fan.
emerge -avn app-laptop/thinkfan
systemctl enable thinkfan

tee /etc/modprobe.d/thinkpad.conf >/dev/null <<'EOF'
options thinkpad_acpi fan_control=1
EOF

tee /etc/thinkfan.conf >/dev/null <<'EOF'
sensors:
  - tpacpi: /proc/acpi/ibm/thermal
    indices: [0]

fans:
  - tpacpi: /proc/acpi/ibm/fan

levels:
  - ["level auto", 0, 60]
  - [4, 60, 70]
  - [5, 70, 75]
  - [6, 75, 85]
  - [7, 85, 95]
  - ["level full-speed", 95, 32767]
EOF

# Configure power button and lid switch.
tee -a /etc/systemd/logind.conf >/dev/null <<'EOF'
HandlePowerKey=suspend
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
EOF

# Configure shell.
curl -L https://raw.githubusercontent.com/qis/core/master/bash.sh -o /etc/bash/bashrc.d/core

# Configure tmux.
curl -L https://raw.githubusercontent.com/qis/core/master/tmux.conf -o /etc/tmux.conf

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

# Configure git.
git config --global core.eol lf
git config --global core.autocrlf false
git config --global core.filemode false
git config --global pull.rebase false

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

# Create home directory mount script.
tee /sbin/mount-zfs-home >/dev/null <<'EOF'
#!/bin/bash
set -eu

# Receive password via stdin.
PASS=$(cat -)

# List the "local" value of the "canmount" property for each zfs dataset.
zfs get canmount -s local -H -o name,value | while read line; do
  # Filter on canmount == 'noauto'. Filesystems marked 'noauto'
  # can be mounted, but is not done so automatically during boot.
  canmount=$(echo $line | awk '{print $2}')
  [[ $canmount = 'noauto' ]] || continue

  # Filter on user property core.encrypt.automount:user.
  # It should match the user that we are logging in as ($PAM_USER).
  volname=$(echo $line | awk '{print $1}')
  user=$(zfs get core.encrypt.automount:user -s local -H -o value $volname)
  [[ $user = $PAM_USER ]] || continue

  # Unlock and mount the volume.
  zfs load-key "$volname" <<< "$PASS" || continue
  zfs mount "$volname" || true # ignore erros
done
EOF

chmod +x /sbin/mount-zfs-home

echo "auth            optional        pam_exec.so expose_authtok /sbin/mount-zfs-home" >> /etc/pam.d/system-auth

# Set home directory properties.
zfs set canmount=noauto system/home/qis
zfs set core.encrypt.automount:user=qis system/home/qis

# Configure desktop runtime directory.
tee /etc/profile.d/xdg.sh >/dev/null <<'EOF'
XDG_RUNTIME_DIR=/run/user/${UID}
EOF

# Configure desktop user directories.
emerge -avn x11-misc/xdg-user-dirs

tee /etc/xdg/user-dirs.defaults >/dev/null <<'EOF'
DOWNLOAD=downloads
DOCUMENTS=documents
DESKTOP=.local/desktop
PUBLICSHARE=.local/public
TEMPLATES=.local/templates
PICTURES=.local/pictures
VIDEOS=.local/videos
MUSIC=.local/music
EOF

# Link resolv.conf to systemd.
ln -snf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

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
umount -l /mnt/gentoo/dev{/shm,/pts,}
umount -R /mnt/gentoo

# Halt system and remove installation media.
halt -p
```

Configure system.

```sh
# Install SSH config.
scp -r .ssh core:

# Log in as user.
ssh core

# Configure ssh.
chmod 0755 .ssh
chmod 0644 .ssh/*
chmod 0600 .ssh/id_rsa
cp .ssh/id_rsa.pub .ssh/authorized_keys
rm -f .ssh/.known_hosts* .ssh/known_hosts

# Log in as root.
sudo su -

# Set hostname.
hostnamectl hostname core

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

# Configure time synchronization.
mkdir -p /etc/systemd/timesyncd.conf.d

tee /etc/systemd/timesyncd.conf.d/vniiftri.conf >/dev/null <<'EOF'
[Time]
NTP=ntp1.vniiftri.ru
FallbackNTP=ntp2.vniiftri.ru ntp3.vniiftri.ru ntp4.vniiftri.ru ntp5.vniiftri.ru
EOF

systemd-analyze cat-config systemd/timesyncd.conf
systemctl enable systemd-timesyncd

# Log out as root.
exit

# Reboot system.
sudo reboot
```

Used disk space:
* `/dev/nvme0n1p1` 30M
* `/dev/nvme0n1p3` 10G

## Desktop
Install and configure desktop packages.

```sh
# Log in as root.
sudo su -

tee /etc/portage/package.mask/desktop >/dev/null <<'EOF'
# Sound
media-sound/pulseaudio-daemon
media-libs/libpulse
media-sound/jack2
media-sound/pulseaudio
media-video/pipewire

# Toolkits
dev-python/pyqt5
dev-qt/qtwebengine
gui-libs/gtk
EOF

tee /etc/portage/package.use/desktop >/dev/null <<'EOF'
# Sound
media-libs/libsndfile minimal
EOF

emerge -avn media-libs/alsa-lib media-sound/alsa-utils

aplay -l
aplay -D hw:0,0 /dev/zero --dump-hw-params

mkdir -p /etc/pipewire/pipewire.conf.d

tee /etc/pipewire/pipewire.conf.d/rates.conf >/dev/null <<'EOF'
context.properties = {
  default.clock.rate = 48000
  default.clock.allowed-rates = [ 48000 44100 ]
  default.clock.quantum = 2048
  default.clock.min-quantum = 1024
  default.clock.max-quantum = 4096
  default.clock.quantum-floor = 1024
  default.clock.quantum-limit = 4096
}
EOF
```

Configure installed packages as user.

```sh
# Configure pipewire(1).
systemctl --user enable --now pipewire pipewire-pulse wireplumber

EDITOR=vim systemctl --user edit pipewire.service
# [Service]
# Nice=-20
# CPUSchedulingPolicy=rr
# CPUSchedulingPriority=20

systemctl --user daemon-reload
systemctl --user restart pipewire pipewire-pulse wireplumber

pw-dump
wpctl status
wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+
```

Test installed packages as user.

```sh
wget https://raw.githubusercontent.com/qis/core/master/test.wav

# Test alsa.
sudo aplay test.wav

# Test pipewire.
pw-play test.wav

# Test pulseaudio.
paplay test.wav
```




















































```sh
# Configure nvim.
git clone --recursive https://github.com/qis/vim /etc/xdg/nvim

# Build nvim telescope fzf plugin.
cd /etc/xdg/nvim/pack/plugins/opt/telescope-fzf-native
cmake -DCMAKE_BUILD_TYPE=Release -B build
cmake --build build

# Create nvim config symlink.
mkdir -p /root/.config
ln -s ../../etc/xdg/nvim /root/.config/nvim
```

**Option 1**: Repeat the last step without `genkernel(8)`.

```sh
# Boot system and back up working kernel config.
mount /boot
modprobe configs
gzip -dc /proc/config.gz > /usr/src/linux/.config

# Disable systemd-boot entries.
mv /boot/loader/entries/linux.conf /boot/genkernel-6.12.16-gentoo.conf

# Halt system and boot from installation media to repeat the process withoout genkernel(8).
halt -p
```

**Option 2**: Finish installation.

```sh
# Update environment.
env-update
source /etc/profile
export PS1="(chroot) ${PS1}"

# Configure pulseaudio.
emerge -avn media-sound/pulseaudio media-sound/sox
systemctl --global enable pulseaudio pulseaudio.socket

tee -a /etc/pulse/daemon.conf >/dev/null <<'EOF'
default-sample-rate = 44100
alternate-sample-rate = 48000
EOF

# Install multimedia utilities.
emerge -avn media-sound/{ncpamixer,pulseaudio-ctl}
ln -s ncpamixer /usr/bin/mixer



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
scp -r .ssh core:

# Log in as user.
ssh core

# Configure ssh.
chmod 0755 .ssh
chmod 0644 .ssh/*
chmod 0600 .ssh/id_rsa
cp .ssh/id_rsa.pub .ssh/authorized_keys
rm -f .ssh/.known_hosts* .ssh/known_hosts

# Log in as root.
sudo su -

# Set hostname.
hostnamectl hostname core

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

## Desktop
Install desktop ports.

```sh
# Log in as root.
sudo su -

# Add desktop section to make.conf.
tee -a /etc/portage/make.conf >/dev/null <<'EOF'

# Desktop
USE="${USE} X acpi cairo cups dri egl exif fontconfig gif gles2 gpm gui"
USE="${USE} jpeg lcms libinput libnotify mng opengl pango pdf png ppds sdl"
USE="${USE} spell svg truetype upower vaapi vulkan wayland webp xcb xft xv"
EOF

# Create @desktop set.
curl -L https://raw.githubusercontent.com/qis/core/master/package.accept_keywords/desktop \
     -o /etc/portage/package.accept_keywords/desktop
curl -L https://raw.githubusercontent.com/qis/core/master/package.mask/desktop \
     -o /etc/portage/package.mask/desktop
curl -L https://raw.githubusercontent.com/qis/core/master/package.use/desktop \
     -o /etc/portage/package.use/desktop
curl -L https://raw.githubusercontent.com/qis/core/master/sets/desktop \
     -o /etc/portage/sets/desktop

# Update @world set.
emerge -auUD @world
emerge -ac

# Install @desktop set.
emerge -avn @desktop
emerge -ac

# Configure ratbag.
systemctl enable ratbagd
gpasswd -a qis plugdev

# Create view script.
tee /etc/bash_completion.d/view >/dev/null <<'EOF'
complete -f view
EOF

tee /usr/local/bin/view >/dev/null <<'EOF'
#!/bin/sh
convert -auto-orient "${1}" sixel:-
EOF
chmod +x /usr/local/bin/view

# Install hyprpaper.
# https://github.com/hyprwm/hyprpaper
curl -L https://github.com/hyprwm/hyprpaper/archive/refs/tags/v0.3.0.tar.gz -o hyprpaper.tar.gz
mkdir hyprpaper; tar xf hyprpaper.tar.gz -C hyprpaper -m --strip-components=1
make -C hyprpaper all
install -D -m 0755 hyprpaper/build/hyprpaper /usr/local/bin/hyprpaper

# Add user to printer and scanner groups.
gpasswd -a qis lp
gpasswd -a qis lpadmin
gpasswd -a qis scanner

# Configure desktop manager.
tee /etc/cdmrc >/dev/null <<'EOF'
#!/bin/bash
flaglist=(C)
namelist=('Hyperland')
binlist=('dbus-run-session Hyprland')
dialogrc=/usr/share/cdm/themes/blackandwhite
consolekit=yes
cktimeout=10
EOF

# Set desktop environment variables.
tee /etc/env.d/99desktop >/dev/null <<'EOF'
GDK_SCALE=1
GDK_DPI_SCALE=1
GTK_USE_PORTAL=1
GTK_THEME=Adwaita:dark
QT_FONT_DPI=96
QT_SCALE_FACTOR=1
QT_QPA_PLATFORM=wayland
QT_QPA_PLATFORMTHEME=qt5ct
QT_ENABLE_HIGHDPI_SCALING=0
QT_SCREEN_SCALE_FACTORS="1;1"
PLASMA_USE_QT_SCALING=1
WINIT_X11_SCALE_FACTOR=1
XCURSOR_THEME=Adwaita
XCURSOR_SIZE=24
EOF

# Configure cups.
systemctl enable cups

# Update environment.
env-update
source /etc/profile

# Configure flatpak.
flatpak config --system --set languages en

# Merge config changes.
# Press 'q' to quit pager.
# Press 'n' to skip patch.
dispatch-conf

# Read portage news.
eselect news read

# Reboot system.
reboot
```

## User Desktop
Install and configure user desktop applications.

```sh
# Configure GTK applications.
gsettings set org.gnome.desktop.interface scaling-factor 1
gsettings set org.gnome.desktop.interface text-scaling-factor 0.9
gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
gsettings set org.gnome.desktop.interface cursor-size 24

# Configure Qt5 applications.
qt5ct

# Configure webcam.
qv4l2

# Configure flatpak permissions.
flatpak override --user --show
flatpak override --user --reset
flatpak override --user --filesystem=${HOME}/.icons:ro
flatpak override --user --socket=wayland

# Configure flatpak repository.
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install flatpak apps.
flatpak install flathub \
  com.brave.Browser \
  org.blender.Blender \
  org.inkscape.Inkscape \
  org.libreoffice.LibreOffice \
  org.audacityteam.Audacity \
  org.keepassxc.KeePassXC \
  org.telegram.desktop \
  net.scribus.Scribus \
  org.kde.krita

flatpak install flathub \
  org.openmw.OpenMW

# Connect to http://localhost:631/admin and add printer.
# [Find New Printers]
#  Connection: socket://10.0.0.99
#  Name: Note
#  Description: Canon MF244dw
#  Location: Local Printer
#  Make: Generic
#  Model: Generic PCL Laser Printer
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

Restore virtual machines as user.

```sh
# Create vm script.
tee ~/.local/bin/vm >/dev/null <<'EOF'
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
chmod +x ~/.local/bin/vm

# Restore virtual machine.
vm define /var/lib/libvirt/images/windows.xml

# Backup virtual machine.
vm dumpxml windows > /var/lib/libvirt/images/windows.xml
```

Create virtual machines.

```sh
# Download image.
curl -L https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.0.0-amd64-netinst.iso \
     -o /var/lib/libvirt/images/debian.iso

# Create virtual machine.
virt-manager
```

```
Overview
+ Basic Details
  Title: Debian
CPUs
+ Configuration
  [x] Copy host CPU configuration (host-passthrough)
+ Topology
  [x] Manually set CPU topology
  Sockets: 1
  Cores: 16
  Threads: 1
Video Virtio
+ Video
  3D acceleration: [x]
Display Spice
+ Spice Server
  Listen type: None
  OpenGL: [x]
```

```sh
# Log in as root.
su -

# Update system.
apt update
apt upgrade -y
apt autoremove -y --purge

# Install packages.
apt install -y spice-vdagent vim

# Configure GDM scaling factor.
# Find the [org/gnome/desktop/interface] section and append:
# scaling-factor=uint32 2
vim /etc/gdm3/greeter.dconf-defaults

# Show IP address.
ip addr

# Restart virtual machine.
reboot

# Configure SSH.
scp .ssh/id_rsa.pub debian:.ssh/authorized_keys

# Connect to VM.
ssh debian

# Log in as root.
su -

# Install system packages.
apt install -y --no-install-recommends apt-file ca-certificates curl file git \
  htop man-db openssh-client p7zip-full pv symlinks tmux tree tzdata xz-utils

# Download apt-file(1) database.
apt-file update

# Configure sudo.
EDITOR=tee visudo >/dev/null <<'EOF'
Defaults env_keep += "LANG LANGUAGE LINGUAS LC_* MM_CHARSET _XKB_CHARSET"
Defaults env_keep += "EDITOR PAGER LS_COLORS TERM TMUX SESSION USERPROFILE"

root  ALL=(ALL:ALL) ALL
qis   ALL=(ALL:ALL) NOPASSWD: ALL

@includedir /etc/sudoers.d
EOF

# Configure virtual memory.
tee /etc/sysctl.d/vm.conf >/dev/null <<'EOF'
vm.max_map_count=2147483642
vm.swappiness=1
EOF

# Configure editor.
echo "EDITOR=/usr/bin/vim" > /etc/profile.d/editor.sh

# Configure application path.
tee /etc/profile.d/path.sh >/dev/null <<'EOF'
export PATH="${HOME}/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
EOF

# Configure shell.
curl -L https://raw.githubusercontent.com/qis/core/master/bash.sh -o /etc/profile.d/bash.sh
rm -f /root/.bashrc /home/qis/.bashrc

# Configure git.
git config --global core.eol lf
git config --global core.autocrlf false
git config --global core.filemode false
git config --global pull.rebase false

# Log out as root.
exit

# Configure shell.
ln -snf /etc/profile.d/bash.sh /home/qis/.bashrc

# Configure git.
git config --global core.eol lf
git config --global core.autocrlf false
git config --global core.filemode false
git config --global pull.rebase false

# Close SSH connection.
exit
```

Manage virtual machines.

```sh
# Start virtual machine.
vm start windows

# Connect to rivtual machine.
vm view windows

# Shutdown virtual machine.
vm shutdown windows
```

Enable dual-monitor support.

1. Replace `-daf` with `-da` in `~/.local/bin/vm`.
2. On Windows, add a second "Video QXL" device.
3. On Linux, change "Video Virtio" XML from `heads="1"` to `heads="2"`.

## Kernel
Configuration based on `dist-kernel` with the following changes.

```
General setup
-> Local version (LOCALVERSION [=])
-> Default hostname (DEFAULT_HOSTNAME [=core])

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

## Administration
Common administrative tasks.

```sh
# List ports in world set.
equery l @world

# List world set and dependencies.
emerge -epv @world

# Rebuild world set after sync or cahnged USE flags.
emerge -auUD @world

# Remove port from world set.
emerge -W app-admin/sudo

# Uninstall removed ports.
emerge -ac

# Merge config changes in response to emerge warnings.
# IMPORTANT: config file '...' needs updating.
# Press 'q' to quit pager.
# Press 'n' to skip patch.
dispatch-conf

# Remove build directories.
rm -rf /var/tmp/portage

# List files installed by a port.
equery f --tree app-shells/bash

# List ports that depend on a port.
equery d app-shells/bash

# Show port that installed a specific file.
equery b `which bash`

# Find ports by name.
equery w sudo

# Find ports by file.
e-file nvim

# List hardware.
lshw -c display

# Watch log output.
sudo journalctl -b -n all -f -u thinkfan

# Mount snapshot.
# mount -t zfs system/home/qis@<date> /mnt
```

<details>
<summary>Update</summary>

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
# zfs destroy system/home/qis@<name>

# Create new snapshots.
zfs snapshot system/root@`date '+%F'`
zfs snapshot system/home/qis@`date '+%F'`

# Synchronize portage repositories.
emaint sync -a

# Read portage news.
eselect news read

# Update linux kernel sources.
emerge -s '^sys-kernel/gentoo-sources$'
echo "=sys-kernel/gentoo-sources-X.YY.ZZ ~amd64" > /etc/portage/package.accept_keywords/kernel
echo "=sys-kernel/gentoo-sources-X.YY.ZZ symlink" > /etc/portage/package.use/kernel
emerge -avn =sys-kernel/gentoo-sources-X.YY.ZZ

# Update linux kernel sources symlink.
eselect kernel list
eselect kernel set linux-X.YY.ZZ-gentoo
eselect kernel show
readlink /usr/src/linux

# Configure kernel (see "Kernel" section for more details).
modprobe configs
gzip -dc /proc/config.gz > /usr/src/linux/.config
modprobe -r configs
cd /usr/src/linux
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

</details>

<details>
<summary>Rescue</summary>

Boot "Admin CD" memory stick.

```sh
# Enable swap.
swapon /dev/nvme0n1p2

# Mount filesystems.
zpool import -fR /mnt/gentoo system
mount -o defaults,noatime /dev/nvme0n1p1 /mnt/gentoo/boot
zfs load-key -r system/home/qis
zfs mount system/home/qis

# Restore snapshot.
# zfs list -t snapshot
# zfs rollback system/root@<date>
# zfs rollback system/home/qis@<date>

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

# Chroot into system.
chroot /mnt/gentoo /bin/bash
source /etc/profile
export PS1="(chroot) ${PS1}"

# Link resolv.conf to systemd.
ln -snf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

# Exit chroot environment.
exit

# Unmount filesystems.
umount -l /mnt/gentoo/dev{/shm,/pts,}
umount -R /mnt/gentoo

# Halt system and remove installation media.
halt -p
```

</details>

<details>
<summary>Backup</summary>

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

</details>

<details>
<summary>Remote Backup</summary>

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

</details>


<!--
# Add GURU repository.
emerge -avn app-eselect/eselect-repository
eselect repository enable guru
emaint sync -r guru

# Update @world set.
emerge -auUD @world
emerge -ac
-->
