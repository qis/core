#!/bin/bash
if [ "${1}" = "pre" ]; then
  exec /sbin/rmmod ath11k_pci ath11k
elif [ "${1}" = "post" ]; then
  exec /sbin/modprobe ath11k_pci
fi
exit 0
