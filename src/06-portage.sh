#!/bin/sh
set -e

echo "Configuring mount points ..."
tee /etc/fstab >/dev/null <<'EOF'
/dev/nvme0n1p1 /boot vfat defaults,noatime,noauto 0 2
/dev/nvme0n1p2 none  swap sw                      0 0
EOF

echo "Creating make.conf ..."
wget https://raw.githubusercontent.com/qis/core/master/make.conf -O /etc/portage/make.conf

echo "Synchronize portage ..."
cp /usr/share/portage/config/repos.conf /etc/portage/repos.conf
emerge --sync
