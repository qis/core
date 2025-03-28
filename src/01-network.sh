#!/bin/sh
set -e

echo "Loading WiFi kernel module ..."
modprobe mtk_t7xx

echo "Configuring network ..."
net-setup wlp1s0
