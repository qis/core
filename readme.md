# Core
Lenovo X13 Gen 3 AMD setup instructions.

* UEFI Menu: F1
* BOOT Menu: F12

```
CPU: AMD Ryzen 7 PRO 6850U
VGA: 2560x1600
RAM: 32 GiB
```

1. Download "Admin CD" from <https://www.gentoo.org/downloads/>.
2. Use [etcher](https://www.balena.io/etcher) to create a memory stick.
3. Boot from memory stick.
4. Configure live environment.

```sh
# Change root password.
passwd

# Start SSH service.
rc-service sshd start

# Get IP address.
ip addr
```

5. SSH into live environment.

```sh
# Log in as root.
ssh root@core

# Confirm UEFI mode.
ls /sys/firmware/efi

# Synchronize time.
chronyd -q 'server 0.gentoo.pool.ntp.org iburst'

# Partition disk.
parted -a optimal /dev/nvme0n1
```

6. Partition disk using `parted`.

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

7. Install system.

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
zfs create -o mountpoint=/home/qis -o encryption=aes-256-gcm -o keyformat=passphrase -o keylocation=prompt system/home/qis
zfs create -o mountpoint=/tmp -o compression=off -o sync=disabled system/tmp
zfs create -o mountpoint=/opt -o compression=off system/opt
zfs create -o mountpoint=/opt/data -o casesensitivity=insensitive system/opt/data
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
VIDEO_CARDS="fbdev amdgpu radeon radeonsi r600"
INPUT_DEVICES="libinput synaptics wacom"
LUA_SINGLE_TARGET="luajit"
SANE_BACKENDS="net pixma"

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
curl -L https://raw.githubusercontent.com/qis/core/master/.config -o /usr/src/linux/.config
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

# Configure wireless.
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

systemctl enable thinkfan

# Configure power button and lid switch.
tee -a /etc/systemd/logind.conf >/dev/null <<'EOF'
HandlePowerKey=suspend
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
EOF

# Configure pulseaudio.
systemctl --global enable pulseaudio pulseaudio.socket
tee -a /etc/pulse/daemon.conf >/dev/null <<'EOF'
default-sample-rate = 44100
alternate-sample-rate = 48000
EOF

# Configure python.
pip config set global.target ~/.pip
tee /etc/profile.d/pip.sh >/dev/null <<'EOF'
export PATH="${PATH}:${HOME}/.pip/bin"
export PYTHONPATH="${HOME}/.pip"
EOF

# Configure node.
npm config set prefix ~/.npm
tee /etc/profile.d/npm.sh >/dev/null <<'EOF'
export PATH="${PATH}:${HOME}/.npm/bin"
EOF

# Configure application path.
tee /etc/profile.d/path.sh >/dev/null <<'EOF'
export PATH="${HOME}/.local/bin:${PATH}"
EOF

# Configure desktop runtime directory.
tee /etc/profile.d/xdg.sh >/dev/null <<'EOF'
XDG_RUNTIME_DIR=/run/user/${UID}
EOF

# Configure desktop user directories.
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

# Update environment.
env-update
source /etc/profile
export PS1="(chroot) ${PS1}"

# Enable GURU repository.
emerge -avn app-eselect/eselect-repository
eselect repository enable guru
emaint sync -r guru

# Read portage news.
eselect news read

# Install multimedia utilities.
emerge -avn media-sound/{ncpamixer,pulseaudio-ctl}
ln -s ncpamixer /usr/bin/mixer

# Update @world set.
emerge -auUD @world
emerge -ac

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

8. Configure system.

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
  org.audacityteam.Audacity \
  org.keepassxc.KeePassXC \
  org.telegram.desktop \
  io.github.Qalculate \
  org.kde.krita

flatpak install flathub \
  org.openmw.OpenMW
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

# Configure bootloader.
sed -E 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=1/g' -i /etc/default/grub
sed -E 's/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="video=Virtual-1:2560x1600@75 quiet"/g' -i /etc/default/grub
update-grub2

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

# List files installed by a specific package.
equery f --tree app-shells/bash

# List ports that depend on a specific package.
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
echo "=sys-kernel/gentoo-sources-X.Y.ZZ ~amd64" > /etc/portage/package.accept_keywords/kernel
echo "=sys-kernel/gentoo-sources-X.Y.ZZ symlink" > /etc/portage/package.use/kernel
emerge -avn =sys-kernel/gentoo-sources-X.Y.ZZ

# Update linux kernel sources symlink.
eselect kernel list
eselect kernel set linux-X.Y.ZZ-gentoo
eselect kernel show
readlink /usr/src/linux

# Configure kernel (see "Kernel" section for more details).
gzip -dc /proc/config.gz > /usr/src/linux/.config
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
bliss-initramfs -k X.Y.ZZ-gentoo
mv initrd-X.Y.ZZ-gentoo /boot/

# Update GRUB config.
grub-mkconfig -o /boot/grub/grub.cfg
sed 's; root=ZFS=[^ ]*; root=system/root;' -i /boot/grub/grub.cfg
grep vmlinuz /boot/grub/grub.cfg

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
