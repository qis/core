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
/core/bin/core-install-kernel 6.12.21

# Copy kernel config.
cat /core/config > /usr/src/linux/.config

# Build kernel and system.
# NOTE: Skip the "boot" parameter if systemd-boot was already installed to the boot filesystem.
# NOTE: Kernel 6.13 CONFIG_PREEMPT_LAZY might improve audio performance.
# TODO: Append ".zst" to all amdgpu filenames in CONFIG_EXTRA_FIRMWARE.
# TODO: Enable MEDIA_TEST_SUPPORT and V4L_TEST_DRIVERS.
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
# Log in as user.
ssh core

# Update cached fonts.
fc-cache

# Verify cached fonts.
fc-list | grep "Font Awesome 6 Pro"

# Configure desktop user directories.
xdg-user-dirs-update --set DOWNLOAD    ~/downloads
xdg-user-dirs-update --set DOCUMENTS   ~/documents
xdg-user-dirs-update --set MUSIC       ~/documents/music
xdg-user-dirs-update --set PICTURES    ~/documents/image
xdg-user-dirs-update --set VIDEOS      ~/documents/video
xdg-user-dirs-update --set DESKTOP     ~/.local/desktop
xdg-user-dirs-update --set PUBLICSHARE ~/.local/public
xdg-user-dirs-update --set TEMPLATES   ~/.local/templates

# Create missing desktop user directories.
mkdir -p $(xdg-user-dir RUNTIME)
mkdir -p $(xdg-user-dir DOWNLOAD)
mkdir -p $(xdg-user-dir DOCUMENTS)
mkdir -p $(xdg-user-dir MUSIC)
mkdir -p $(xdg-user-dir PICTURES)
mkdir -p $(xdg-user-dir VIDEOS)
mkdir -p $(xdg-user-dir DESKTOP)
mkdir -p $(xdg-user-dir PUBLICSHARE)
mkdir -p $(xdg-user-dir TEMPLATES)

# Enable pipewire services.
systemctl --user enable --now pipewire pipewire-pulse wireplumber

# Verify pipewire services status.
systemctl --user status pipewire pipewire-pulse wireplumber

# Configure system.
sudo /core/bin/core-install-configure

# Reboot system.
sudo reboot
```

## Desktop
Install and configure desktop packages.

```sh
# Install desktop.
sudo /core/bin/core-install-desktop

# Configure GTK theme.
mkdir -p /etc/gtk-3.0; tee /etc/gtk-3.0/settings.ini >/dev/null <<'EOF'
[Settings]
gtk-theme-name = Adwaita
gtk-icon-theme-name = Adwaita
gtk-cursor-theme-name = Adwaita
gtk-application-prefer-dark-theme = true
EOF

mkdir -p /etc/gtk-4.0; tee /etc/gtk-4.0/settings.ini >/dev/null <<'EOF'
[Settings]
gtk-theme-name = Adwaita
gtk-icon-theme-name = Adwaita
gtk-cursor-theme-name = Adwaita
gtk-application-prefer-dark-theme = true
EOF

# Configure display manager.
systemctl enable greetd

tee /etc/greetd/config.toml >/dev/null <<'EOF'
[terminal]
vt = 7

[default_session]
user = "greetd"
command = "tuigreet -w 24 -r -c 'dbus-run-session Hyprland >/var/log/hyprland.log 2>&1' --asterisks --theme 'action=black;border=black;prompt=green' --kb-command 13 --kb-sessions 14"
EOF

touch /var/log/hyprland.log
chown qis:qis /var/log/hyprland.log

# Configure flatpak.
flatpak config --system --set languages en
flatpak config --system

# Configure flatpak overrides.
flatpak override --system --socket=wayland
flatpak override --system --filesystem=/etc/gtk-3.0:ro
flatpak override --system --filesystem=/etc/gtk-4.0:ro
flatpak override --system --show

# Reboot system.
reboot
```

Configure installed packages as user.

```sh
# Verify desktop portal configuration.
/usr/libexec/xdg-desktop-portal -v 2>&1 | grep -E '(hyprland|gtk)'

# Verify hyprland desktop portal service status.
systemctl --user status xdg-desktop-portal-hyprland

# Configure GTK applications.
gsettings set org.gnome.desktop.interface scaling-factor 1
gsettings set org.gnome.desktop.interface text-scaling-factor 0.8
gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
gsettings set org.gnome.desktop.interface cursor-size 24

# Configure Qt applications.
qt6ct

# Configure wofi.
mkdir ~/.config/wofi

tee ~/.config/wofi/config >/dev/null <<'EOF'
term=footclient
allow-images=true
allow-markup=true
matching=fuzzy
EOF

tee ~/.config/wofi/style.css >/dev/null <<'EOF'
* { border-radius: 0; }
EOF
```

Install software using flatpak.

```sh
# Delete user directories.
# rm -rf ~/.cache/flatpak ~/.local/share/flatpak ~/.var

# Configure permissions.
flatpak override --user --reset
flatpak override --user --filesystem=${HOME}/.cache/fontconfig:ro
flatpak override --user --filesystem=${HOME}/.config/qt6ct:ro
flatpak override --user --filesystem=${HOME}/.config/user-dirs.dirs:ro
flatpak override --user --filesystem=${HOME}/.config/user-dirs.locale:ro
flatpak override --user --filesystem=${HOME}/.fonts:ro
flatpak override --user --show

# Add flathub repository.
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Find application by name.
flatpak search floorp

# Install browser.
flatpak install one.ablaze.floorp
flatpak run one.ablaze.floorp

# Install chat client.
flatpak install org.telegram.desktop
flatpak run org.telegram.desktop

# Install office suite.
flatpak install org.libreoffice.LibreOffice
flatpak run org.libreoffice.LibreOffice

# Install audio recorder.
flatpak install org.tenacityaudio.Tenacity
flatpak run org.tenacityaudio.Tenacity

# Install digital audio workstation.
# Version 1.0.0 can't record audio.
# flatpak install org.zrythm.Zrythm
# flatpak override --user org.zrythm.Zrythm --filesystem="$(xdg-user-dir MUSIC)"
# flatpak run org.zrythm.Zrythm

# Uninstall Zrythm digital audio workstation.
# flatpak uninstall --delete-data org.zrythm.Zrythm
# flatpak uninstall --unused
```

Test native software.

```sh
# Monitor system resources.
# Press `p` to cycle through presets.
btop

# Lock screen.
lock

# Unlock screen in TTY 2-6.
unlock

# Take screenshot of the active screen.
screenshot screen

# Take screenshot of the active window.
screenshot window

# Take screenshot of a screen region.
screenshot region

# Show image in the terminal.
view documents/image/test.png

# Show image in a wayland window.
imv documents/image/test.png

# Play audio using SoX.
play documents/audio/test.flac
play documents/audio/test.mp3
play documents/audio/test.ogg

# Play audio using MPV.
mpv documents/audio/test.flac
mpv documents/audio/test.mp3
mpv documents/audio/test.ogg

# Play video using MPV.
mpv documents/video/test.mp4

# Record screen to a specific file.
record ~/test.mkv

# Record screen to a file in $(xdg-user-dir VIDEOS).
record
```

Test emulated software.

```sh
# Create game directory.
export WINEPREFIX="${HOME}/.local/games/poe"
mkdir -p "${WINEPREFIX}/drive_c/PoE"

# Configure wine settings.
# * Set Graphics > Screen resolution to 216 DPI.
# * Set Applications > Default Settings > Windows Version to Windows 11.
# * Set Desktop Integration > WinRT theme to Dark.
winecfg

# Install vulkan-based d3d9/10/11 support.
setup_dxvk.sh install --symlink

# Install vulkan-based d3d12 support.
setup_vkd3d_proton.sh install --symlink

# Install game.
# * Set installation directory to "C:\PoE" in "Options".
env --chdir="${WINEPREFIX}/drive_c/PoE" wine64 ~/downloads/PathOfExileInstaller.exe
env --chdir="${WINEPREFIX}/drive_c/PoE" wine64 PathOfExile.exe

# Create game launcher.
tee ~/.local/bin/poe >/dev/null <<'EOF'
#!/bin/sh
set -e
export WINEPREFIX="${HOME}/.local/games/poe"
cd "${WINEPREFIX}/drive_c/PoE"

if [ -z "${1}" ]; then
  wine PathOfExile.exe
  exit $?
fi

if [ "${1}" != "drm" ] && [ "${1}" != "wayland" ]; then
  echo "usage: poe [drm|wayland]"
  exit 1
fi

gamescope -w 1280 -h 800 -W 2560 -H 1600 -b -f -F fsr -r 60 -o 30 -s 0.5 -g \
  --adaptive-sync --rt --backend "${1}" --force-windows-fullscreen -- wine PathOfExile.exe
EOF

chmod +x ~/.local/bin/poe

# Test game using protin wine.
# This will not accept mouse clicks.
poe

# Test game using gamescope on wayland.
# This will not accept mouse clicks.
poe wayland

# Test game using gamescope in a TTY.
# This will not accept mouse clicks.
poe drm
```

```sh
# Enter game directory.
cd ~/.local/games/transistor

# Configure wine prefix.
export WINEPREFIX="${HOME}/.local/games/transistor/wine"

# Configure wine settings.
# 1. Set Graphics > Screen resolution to 216 DPI.
# 2. Set Applications > Default Settings > Windows Version to Windows 11.
# 3. Set Desktop Integration > WinRT theme to Dark.
winecfg

# Install vulkan-based d3d9/10/11 support.
setup_dxvk.sh install --symlink

# Install vulkan-based d3d12 support.
setup_vkd3d_proton.sh install --symlink

# Create launcher.
tee ~/.local/bin/transistor >/dev/null <<'EOF'
#!/bin/sh
set -e
export WINEPREFIX="${HOME}/.local/games/transistor/wine"
cd ${HOME}/.local/games/transistor

if [ -z "${1}" ]; then
  echo "usage: transistor drm|wayland|wine"
  exit 1
fi

case "${1}" in
wine)
  wine Transistor.exe
  exit $?
  ;;
*)
  ;;
esac

gamescope -w 1280 -h 800 -W 2560 -H 1600 -b -f -F fsr -r 60 -o 30 -s 0.5 -g \
  --adaptive-sync --rt --backend "${1}" --force-windows-fullscreen -- wine Transistor.exe
EOF

chmod +x ~/.local/bin/transistor

# Test game using protin wine.
# This will not accept mouse clicks.
transistor wine

# Test game using gamescope on wayland.
# This will not accept mouse clicks.
transistor wayland

# Test game using gamescope in a TTY.
# This will not accept mouse clicks.
transistor drm
```

<!--
Configure applications menu.

```sh
# List data directories.
# echo "${XDG_DATA_DIRS}"

# Hide desktop files.
ls -lh /usr/share/applications
for i in \
  Helix \
  assistant6-qttools-6 \
  blender-4.3 \
  btop \
  ca.desrt.dconf-editor \
  foot \
  footclient \
  foot-server \
  htop \
  io.github.Qalculate.qalculate-qt \
  linguist6-qttools-6 \
  mpv \
  org.fontforge.FontForge \
  org.kde.krita.desktop \
  org.keepassxc.KeePassXC \
  org.pulseaudio.pavucontrol \
  pavucontrol-qt \
  qdbusviewer6-qttools-6 \
  qt5ct \
  qt6ct \
  qv4l2 \
  qvidcap \
  scribus-1.7 \
  wpa_gui \
; do
  cat "/usr/share/applications/${i}.desktop" > "${HOME}/.local/share/applications/${i}.desktop"
  echo "Hidden=true" >> "${HOME}/.local/share/applications/${i}.desktop"
done

# Hide desktop files, that don't end with a "[Desktop Entry]" entry.
for i in one.ablaze.floorp; do
  cat "${HOME}/.local/share/flatpak/exports/share/applications/${i}.desktop" \
    > "${HOME}/.local/share/applications/${i}.desktop"
  hx  "${HOME}/.local/share/applications/${i}.desktop"
done

# Copy desktop files.
cat /usr/share/applications/io.github.Qalculate.qalculate-qt.desktop > ~/.local/share/applications/core-calculator.desktop
cat /usr/share/applications/org.kde.krita.desktop > ~/.local/share/applications/core-krita.desktop
cat /usr/share/applications/org.keepassxc.KeePassXC.desktop > ~/.local/share/applications/core-keepass.desktop
cat /usr/share/applications/org.pulseaudio.pavucontrol.desktop > ~/.local/share/applications/core-volume.desktop
cat /usr/share/applications/qv4l2.desktop > ~/.local/share/applications/core-webcam.desktop
cat /usr/share/applications/wpa_gui.desktop > ~/.local/share/applications/core-wireless.desktop

cat ~/.local/share/flatpak/exports/share/applications/one.ablaze.floorp.desktop \
  > ~/.local/share/applications/core-browser.desktop

cat ~/.local/share/flatpak/exports/share/applications/org.libreoffice.LibreOffice.desktop \
  > ~/.local/share/applications/org.libreoffice.LibreOffice.desktop

cat ~/.local/share/flatpak/exports/share/applications/org.libreoffice.LibreOffice.base.desktop \
  > ~/.local/share/applications/org.libreoffice.LibreOffice.base.desktop

cat ~/.local/share/flatpak/exports/share/applications/org.libreoffice.LibreOffice.draw.desktop \
  > ~/.local/share/applications/org.libreoffice.LibreOffice.draw.desktop

cat ~/.local/share/flatpak/exports/share/applications/org.libreoffice.LibreOffice.impress.desktop \
  > ~/.local/share/applications/org.libreoffice.LibreOffice.impress.desktop

cat ~/.local/share/flatpak/exports/share/applications/org.libreoffice.LibreOffice.math.desktop \
  > ~/.local/share/applications/org.libreoffice.LibreOffice.math.desktop

hx ~/.local/share/applications/org.libreoffice.LibreOffice*.desktop

# Edit desktop files.
# 1. Fix up "Name" entries.
# 2. Remove "Categories", "Comment" and "Keywords" entries.
# 4. Add "-style Adwaita-dark" to Qt applications "Exec" entries.
# 5. Add "env KRITA_NO_STYLE_OVERRIDE=1 QT_SCALE_FACTOR=2 ..." to the Krita "Exec" entry.
# 6. Add "env QT_SCALE_FACTOR=2 ..." for the Scribus "Exec" entry and remove the "TryExec" entry.
hx ~/.local/share/applications/core-*.desktop

for i in $(ls ~/.local/share/applications/); do
  if [ ! -f /usr/share/applications/${i} ] && [ ! -f ~/.local/share/flatpak/exports/share/applications/${i} ]; then
    echo "~/.local/share/applications/${i}"
  fi
done
```
-->

<!--
Configure printing support.

```
Connect to http://localhost:631/admin and add printer.
[Find New Printers]
  Connection: socket://10.0.0.99
  Name: Note
  Description: Canon MF244dw
  Location: Local Printer
  Make: Generic
  Model: Generic PCL Laser Printer
```
-->

<!--
flatpak install flathub one.ablaze.floorp \
  org.libreoffice.LibreOffice \
  net.scribus.Scribus \
  org.keepassxc.KeePassXC \
  org.telegram.desktop \
  org.kde.krita \
  org.blender.Blender \
  org.zrythm.Zrythm
-->

















































```sh
# Configure nvim.
git clone --recursive https://github.com/qis/vim /etc/xdg/nvim

# Build nvim telescope fzf plugin.
cd /etc/xdg/nvim/pack/plugins/opt/telescope-fzf-native
cmake -DCMAKE_BUILD_TYPE=Release -B build
cmake --build build

# Create nvim config symlink.
mkdir -p /root/.config
ln -snf ../../etc/xdg/nvim /root/.config/nvim
```

Finish installation.

```sh
# Configure pulseaudio.
emerge -avn media-sound/pulseaudio media-sound/sox
systemctl --global enable pulseaudio pulseaudio.socket

tee -a /etc/pulse/daemon.conf >/dev/null <<'EOF'
default-sample-rate = 44100
alternate-sample-rate = 48000
EOF

# Install multimedia utilities.
emerge -avn media-sound/{ncpamixer,pulseaudio-ctl}
ln -snf ncpamixer /usr/bin/mixer



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

# Install

# Enable guru repository.
eselect repository enable guru
emaint sync -r guru

# Add desktop section to make.conf.
tee -a /etc/portage/make.conf >/dev/null <<'EOF'

# Desktop
USE="${USE} alsa -ao -jack -oss -pipewire -pulseaudio -sndio"
USE="${USE} aac encode flac id3tag mad mp3 mp4 mpeg ogg opus sound theora vorbis x264 x265"
USE="${USE} wayland"
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
flatpak override --user --filesystem=${HOME}/.config/qt5ct:ro
flatpak override --user --filesystem=${HOME}/.config/qt6ct:ro
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
curl -L https://raw.githubusercontent.com/qis/core/master/bash.sh -o /etc/bash/bashrc.d/99-core.bash
rm -f /root/.bashrc /home/qis/.bashrc

# Configure git.
git config --global core.eol lf
git config --global core.autocrlf false
git config --global core.filemode false
git config --global pull.rebase false

# Log out as root.
exit

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

# Show USE flags.
portageq envvar USE | xargs -n 1

# Rebuild world set after sync or cahnged USE flags.
emerge -avtDUu @world

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
git update-index --chmod=+x bin/*
-->
