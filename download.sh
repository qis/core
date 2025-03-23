#!/bin/sh
set -e

mirror=https://mirror.yandex.ru/gentoo-distfiles

case ${1} in
gpg|pgp)
  curl -L https://qa-reports.gentoo.org/output/service-keys.gpg -o - | gpg --import
  exit 0
  ;;
admin)
  dir=releases/amd64/autobuilds/current-admincd-amd64
  src=admincd-amd64-20250302T170343Z.iso
  dst=admin.iso
  ;;
stage)
  dir=releases/amd64/autobuilds/current-stage3-amd64-nomultilib-systemd
  src=stage3-amd64-nomultilib-systemd-20250315T023326Z.tar.xz
  dst=stage.tar.xz
  ;;
*)
  echo "usage: download.sh gpg|admin|stage"
  exit 1
  ;;
esac

if [ ! -f "${dst}" ]; then
  curl -L ${mirror}/${dir}/${src} -o ${dst}
fi

if [ ! -f "${dst}.asc" ]; then
  curl -L ${mirror}/${dir}/${src}.asc -o ${dst}.asc
fi

gpg --verify ${dst}.asc
