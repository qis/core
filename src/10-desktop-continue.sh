#!/bin/sh
set -e

cmake -GNinja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -DCMAKE_INSTALL_LIBEXECDIR=/usr/lib \
  -B /tmp/hyprland/build /tmp/hyprland

cmake --build /tmp/hyprland/build --target install

echo "Installing hyprland wallpaper utility ..."
git clone -b v0.7.1 --recurse https://github.com/hyprwm/hyprpaper /tmp/hyprpaper

cmake -GNinja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -B /tmp/hyprpaper/build /tmp/hyprpaper

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
