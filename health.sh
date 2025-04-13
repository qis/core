#!/bin/bash
set -e

color_red="\e[1;31m"
color_log="\e[1;32m"
color_clr="\e[0m"

log() {
  echo -e "${color_clr}"
  echo -e "${color_log}${*}${color_clr}" 1>&2
}

find etc -type f | while read file; do
  if ! sudo cmp -s -- "/${file}" "${file}"; then
    sudo diff -uN --label "core: /${file}" --label "root: /${file}" --color=always "${file}" "/${file}" || true
  fi
done

log "Checking dmesg errors ..."
sudo dmesg | grep -iE --color=always "(error|fail)[a-Z]*"

log "Checking journalctl errors ..."
sudo journalctl -b -p err
