#!/bin/bash
set -e

color_red="\e[1;31m"
color_log="\e[1;32m"
color_clr="\e[0m"

log() {
  echo -e "${color_clr}"
  echo -e "${color_log}${*}${color_clr}" 1>&2
}

if [ "$(id -u)" = "0" ]; then
  log "${color_red}Must be run as user."
  exit 1
fi

log "Checking camera ..."
mpv --demuxer-lavf-o=input_format=mjpeg,video_size=1920x1080,framerate=30 \
  av://v4l2:/dev/video0 --profile=low-latency --untimed

if [ -e /dev/video4 ]; then
  mpv --demuxer-lavf-o=input_format=mjpeg,video_size=1920x1080,framerate=30 \
    av://v4l2:/dev/video4 --profile=low-latency --untimed
fi

log "Checking config files ..."
find etc -type f | while read file; do
  if ! sudo cmp -s -- "/${file}" "${file}"; then
    sudo diff -uN --label "core: /${file}" --label "root: /${file}" --color=always "${file}" "/${file}" || true
  fi
done

log "Checking real time clock ..."
timedatectl

log "Checking real time clock device driver ..."
ls -l --color=always /sys/class/rtc/rtc0/device/driver

log "Checking network device drivers ..."
ls -l --color=always /sys/class/net/wlan/device/driver
if [ -e /sys/class/net/dock ]; then
  ls -l --color=always /sys/class/net/dock/device/driver
fi
if [ -e /sys/class/net/eth0 ]; then
  ls -l --color=always /sys/class/net/eth0/device/driver
fi

log "Checking regulatory information ..."
iw reg get

log "Checking dmesg microcode ..."
sudo dmesg | grep "microcode:"

log "Checking dmesg errors ..."
sudo dmesg | grep -iE --color=always "(error|fail)[a-Z]*"

log "Checking journalctl errors ..."
sudo journalctl -b -p err

log "Creating ${color_red}/tmp/pci.txt${color_log} and ${color_red}/tmp/usb.txt${color_log} ..."
sudo lspci -v | tee /tmp/pci.txt >/dev/null || true
sudo usb-devices | tee /tmp/usb.txt >/dev/null || true
