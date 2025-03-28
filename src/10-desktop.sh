#!/bin/sh
set -e

echo "Adding desktop section to make.conf ..."
tee -a /etc/portage/make.conf >/dev/null <<'EOF'

# Desktop
USE="${USE} alsa -ao -jack -oss -pipewire -pulseaudio -sndio"
USE="${USE} aac encode flac id3tag mad mp3 mp4 mpeg ogg opus sound theora vorbis x264 x265"
USE="${USE} X egl opengl truetype vulkan wayland"
EOF

echo "Creating @desktop set ..."
wget https://raw.githubusercontent.com/qis/core/master/package.accept_keywords/desktop \
  -O /etc/portage/package.accept_keywords/desktop
wget https://raw.githubusercontent.com/qis/core/master/package.mask/desktop \
  -O /etc/portage/package.mask/desktop
wget https://raw.githubusercontent.com/qis/core/master/package.use/desktop \
  -O /etc/portage/package.use/desktop
wget https://raw.githubusercontent.com/qis/core/master/sets/desktop \
  -O /etc/portage/sets/desktop

echo "Updating @world set ..."
emerge -uUD @world

echo "Uninstalling unwanted packages ..."
emerge -c

echo "Installing @desktop set ..."
emerge -vn @desktop

echo "Uninstalling unwanted packages ..."
emerge -c

echo "Installing hyprland desktop portal ..."
git clone -b v1.3.9 --recurse https://github.com/hyprwm/xdg-desktop-portal-hyprland /tmp/hyprland

cmake -GNinja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -DCMAKE_INSTALL_LIBEXECDIR=/usr/lib \
  -B build /tmp/hyprland

cmake --build /tmp/hyprland/build --target install

echo "Installing hyprland wallpaper utility ..."
git clone -b v0.7.1 --recurse https://github.com/hyprwm/hyprpaper /tmp/hyprpaper

cmake -GNinja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -B build /tmp/hyprpaper

cmake --build /tmp/hyprpaper/build --target install

echo "Adding user to new groups ..."
gpasswd -a qis pipewire
gpasswd -a qis rtkit

echo "Configuring GTK theme ..."
tee /etc/gtk-3.0/settings.ini >/dev/null <<'EOF'
[Settings]
gtk-theme-name = Adwaita
gtk-icon-theme-name = Adwaita
gtk-cursor-theme-name = Adwaita
gtk-application-prefer-dark-theme = true
EOF

echo "Configuring display manager ..."
systemctl enable greetd

tee /etc/greetd/config.toml >/dev/null <<'EOF'
[terminal]
vt = 7

[default_session]
command = "tuigreet -w 24 -r -c 'dbus-run-session Hyprland' --asterisks --theme 'action=black;border=black;prompt=green' --kb-command 13 --kb-sessions 14"
user = "greetd"
EOF

echo "Configuring input devices ..."
systemctl enable ratbagd
gpasswd -a qis plugdev

echo "Creating image viewer symlink ..."
ln -s chafa /usr/bin/view

echo "Configuring flatpak ..."
flatpak config --system --set languages en

echo "Rebooting system ..."
sleep 3
reboot
