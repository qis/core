#!/bin/sh
set -e

echo "Generating locale ..."
tee /etc/locale.gen >/dev/null <<'EOF'
en_US.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8
EOF

locale-gen

echo ""
echo "Load profile:"
echo "source /etc/profile"
echo 'export PS1="(chroot) ${PS1}"'
