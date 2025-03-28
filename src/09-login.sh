#!/bin/sh
set -e

echo "Setting hostname ..."
hostnamectl hostname core

echo "Configuring locale ..."
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

echo "Updating environment ..."
env-update

echo "Configuring systemd ..."
systemd-firstboot --prompt --setup-machine-id

echo "Configuring systemd services ..."
systemctl preset-all --preset-mode=enable-only

echo "Configuring time synchronization ..."
mkdir -p /etc/systemd/timesyncd.conf.d

tee /etc/systemd/timesyncd.conf.d/vniiftri.conf >/dev/null <<'EOF'
[Time]
NTP=ntp1.vniiftri.ru
FallbackNTP=ntp2.vniiftri.ru ntp3.vniiftri.ru ntp4.vniiftri.ru ntp5.vniiftri.ru
EOF

#systemd-analyze cat-config systemd/timesyncd.conf

systemctl enable systemd-timesyncd

echo "Rebooting system ..."
sleep 3
reboot
