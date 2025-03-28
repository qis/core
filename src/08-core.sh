#!/bin/sh
set -e

echo "Installing curl and freetype without circular dependencies ..."
USE="-harfbuzz" emerge -1 net-misc/curl media-libs/freetype

echo ""
echo "Installing harfbuzz and rebuild freetype with harfbuzz support."
emerge media-libs/harfbuzz && emerge media-libs/freetype

echo ""
echo "Rebuilding @world set ..."
emerge -ave @world

echo ""
echo "Uninstalling unwanted packages ..."
emerge -ac

echo ""
echo "Installing @core set ..."
emerge -avn @core

echo ""
echo "Uninstalling unwanted packages ..."
emerge -ac

echo "Remounting NVRAM variables (efivars) with read/write access ..."
mount -o remount,rw /sys/firmware/efi/efivars

# echo "Installing systemd-boot to ESP ..."
# bootctl install

echo "Configuring installkernel(8) ..."
echo gentoo > /etc/kernel/entry-token
tee /etc/kernel/install.conf >/dev/null <<'EOF'
layout=bls
initrd_generator=none
uki_generator=ukify
EOF

echo "Configuring dracut(1) ..."
# TODO: Create /etc/dracut.coonf.d/core.conf.

echo ""
echo "Installing kernel ..."
cd /usr/src/linux
make install

echo "Installing kernel initarmfs ..."
env --chdir=/boot dracut gentoo/6.12.16-gentoo/initrd

echo "Copying kernel config ..."
cat /usr/src/linux/.config > /boot/gentoo/6.12.16-gentoo/config

echo "Configuring systemd-boot loader entry ..."
rm -f /boot/loader/entries/gentoo-6.12.16-gentoo.conf
tee /boot/loader/entries/linux.conf >/dev/null <<'EOF'
title Linux
linux /gentoo/6.12.16-gentoo/linux
initrd /gentoo/6.12.16-gentoo/microcode-amd
initrd /gentoo/6.12.16-gentoo/initrd
options root=system/root ro acpi_enforce_resources=lax net.ifnames=0 quiet
EOF

echo "Enabling filesystem services ..."
systemctl enable zfs.target
systemctl enable zfs-import-cache
systemctl enable zfs-mount
systemctl enable zfs-import.target

echo "Creating editor symlink ..."
ln -s hx /usr/bin/vi

echo "Configuring editor ..."
mkdir -p /etc/helix /root/.config
wget https://raw.githubusercontent.com/qis/core/master/helix/config.toml -O /etc/helix/config.toml
wget https://raw.githubusercontent.com/qis/core/master/helix/languages.toml -O /etc/helix/languages.toml
echo "EDITOR=/usr/bin/hx" > /etc/env.d/99editor
ln -s /etc/helix /root/.config/helix

echo "Configuring time zone ..."
ln -snf /usr/share/zoneinfo/Europe/Moscow /etc/localtime

echo "Configuring virtual memory ..."
mkdir -p /etc/sysctl.d && tee /etc/sysctl.d/vm.conf >/dev/null <<'EOF'
vm.max_map_count=2147483642
vm.swappiness=1
EOF

echo ""
echo "Enabling services ..."
systemctl enable seatd
systemctl enable sshd
systemctl enable dhcpcd
systemctl enable systemd-networkd
systemctl enable systemd-resolved

echo ""
echo "Configuring network ..."

tee /etc/systemd/network/eth0.network >/dev/null <<'EOF'
[Match]
Name=eth0

[Network]
DHCP=yes
EOF

emerge -vn net-wireless/iw net-wireless/wpa_supplicant

tee /etc/systemd/network/wlan0.network >/dev/null <<'EOF'
[Match]
Name=wlan0

[Network]
DHCP=yes
EOF

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
  ssid="..."
  psk="D4MHeCGA"
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

echo ""
echo "Configuring sensors and fan ..."
emerge -vn app-laptop/thinkfan
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

echo ""
echo "Configuring power button and lid switch ..."
tee -a /etc/systemd/logind.conf >/dev/null <<'EOF'
HandlePowerKey=suspend
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
EOF

echo "Configuring shell ..."
wget https://raw.githubusercontent.com/qis/core/master/bash.sh -O /etc/bash/bashrc.d/99-core.bash

echo "Configuring tmux ..."
wget https://raw.githubusercontent.com/qis/core/master/tmux.conf -O /etc/tmux.conf

echo "Configuring git ..."
git config --global core.eol lf
git config --global core.autocrlf false
git config --global core.filemode false
git config --global pull.rebase false

echo ""
echo "Adding user ..."
useradd -m -G users,seat,wheel,audio,input,usb,video -s /bin/bash qis
chown -R qis:qis /home/qis
passwd qis

EDITOR=tee visudo >/dev/null <<'EOF'
Defaults env_keep += "LANG LANGUAGE LINGUAS LC_* MM_CHARSET _XKB_CHARSET"
Defaults env_keep += "EDITOR PAGER LS_COLORS TERM TMUX SESSION USERPROFILE"

root  ALL=(ALL:ALL) ALL
qis   ALL=(ALL:ALL) NOPASSWD: ALL

@includedir /etc/sudoers.d
EOF

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

zfs set canmount=noauto system/home/qis
zfs set core.encrypt.automount:user=qis system/home/qis

tee /etc/profile.d/xdg.sh >/dev/null <<'EOF'
XDG_RUNTIME_DIR=/run/user/${UID}
EOF

emerge -vn x11-misc/xdg-user-dirs

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

ln -snf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

echo ""
echo " Merge config changes."
echo " Press 'q' to quit pager."
echo " Press 'n' to skip patch."
echo " Press 'z' to drop patch."
echo "dispatch-conf"
echo ""
echo "Set root password."
echo "passwd"
echo ""
