# Virtualization

```sh
# Configure virtualization ports.
tee /etc/portage/package.use/virtualization >/dev/null <<'EOF'
# System
app-emulation/qemu qemu_softmmu_targets_x86_64
app-emulation/qemu qemu_softmmu_targets_i386
app-emulation/qemu qemu_softmmu_targets_aarch64
app-emulation/qemu qemu_softmmu_targets_arm

# User Targets
app-emulation/qemu qemu_user_targets_x86_64
app-emulation/qemu qemu_user_targets_i386
app-emulation/qemu qemu_user_targets_aarch64
app-emulation/qemu qemu_user_targets_arm

# Global Options
app-emulation/qemu filecaps gtk lzo vnc

# Local Options
app-emulation/qemu aio bpf curl fdt fuse gnutls io-uring ncurses
app-emulation/qemu pin-upstream-blobs sdl sdl-image spice slirp usb
app-emulation/qemu usbredir vhost-net virgl virtfs vte xattr

# Virt-Manager
app-crypt/swtpm gnutls
net-dns/dnsmasq script
net-libs/gnutls pkcs11 tools
net-misc/spice-gtk gtk3 usbredir lz4
app-emulation/libvirt fuse libvirtd pcap qemu virt-network zfs
app-emulation/virt-viewer libvirt spice
EOF

# Install virtualization ports.
emerge -avn app-emulation/{qemu,virt-manager,virt-viewer} app-crypt/swtpm

# Configure qemu binary formats.
grep -E '^:qemu-(aarch64|arm):' /usr/share/qemu/binfmt.d/qemu.conf > /etc/binfmt.d/qemu.conf

# Configure qemu user.
echo 'user = "qis"' >> /etc/libvirt/qemu.conf

# Add user to virtualization groups.
gpasswd -a qis kvm
gpasswd -a qis libvirt

# Reset udev ownership and permissions.
udevadm trigger -c add /dev/kvm

# Enable libvirt services.
systemctl enable libvirtd
systemctl enable libvirt-guests

# Change permissions.
chown -R qis:qemu /var/lib/libvirt/images

# Reboot system.
reboot
```

Restore virtual machines as user.

```sh
# Create vm script.
tee ~/.local/bin/vm >/dev/null <<'EOF'
#!/bin/sh
if [ "${1}" = "view" ]; then
  name="${2}"
  if [ -z "${name}" ]; then
    name=$(virsh -c qemu:///system list --name | head -1)
    if [ -z "${name}" ]; then
      echo "error: no virtual machine running" 1>&2
      exit 1
    fi
  fi
  name=$(virsh -c qemu:///system list --name | grep -E "^${name}$")
  if [ -z "${name}" ]; then
    echo "error: virtual machine not running" 1>&2
    exit 1
  fi
  hyprctl dispatch exec "virt-viewer -c qemu:///system -daf --spice-preferred-compression=off ${name}" >/dev/null
else
  virsh -c qemu:///system $*
fi
EOF
chmod +x ~/.local/bin/vm

# Restore virtual machine.
vm define /var/lib/libvirt/images/windows.xml

# Backup virtual machine.
vm dumpxml windows > /var/lib/libvirt/images/windows.xml
```

Create virtual machines.

```sh
# Download image.
curl -L https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.0.0-amd64-netinst.iso \
     -o /var/lib/libvirt/images/debian.iso

# Create virtual machine.
virt-manager
```

```
Overview
+ Basic Details
  Title: Debian
CPUs
+ Configuration
  [x] Copy host CPU configuration (host-passthrough)
+ Topology
  [x] Manually set CPU topology
  Sockets: 1
  Cores: 16
  Threads: 1
Video Virtio
+ Video
  3D acceleration: [x]
Display Spice
+ Spice Server
  Listen type: None
  OpenGL: [x]
```

```sh
# Log in as root.
su -

# Update system.
apt update
apt upgrade -y
apt autoremove -y --purge

# Install packages.
apt install -y spice-vdagent vim

# Configure GDM scaling factor.
# Find the [org/gnome/desktop/interface] section and append:
# scaling-factor=uint32 2
vim /etc/gdm3/greeter.dconf-defaults

# Show IP address.
ip addr

# Restart virtual machine.
reboot

# Configure SSH.
scp .ssh/id_rsa.pub debian:.ssh/authorized_keys

# Connect to VM.
ssh debian

# Log in as root.
su -

# Install system packages.
apt install -y --no-install-recommends apt-file ca-certificates curl file git \
  htop man-db openssh-client p7zip-full pv symlinks tmux tree tzdata xz-utils

# Download apt-file(1) database.
apt-file update

# Configure sudo.
EDITOR=tee visudo >/dev/null <<'EOF'
Defaults env_keep += "LANG LANGUAGE LINGUAS LC_* MM_CHARSET _XKB_CHARSET"
Defaults env_keep += "EDITOR PAGER LS_COLORS TERM TMUX SESSION USERPROFILE"

root  ALL=(ALL:ALL) ALL
qis   ALL=(ALL:ALL) NOPASSWD: ALL

@includedir /etc/sudoers.d
EOF

# Configure virtual memory.
tee /etc/sysctl.d/vm.conf >/dev/null <<'EOF'
vm.max_map_count=2147483642
vm.swappiness=1
EOF

# Configure editor.
echo "EDITOR=/usr/bin/vim" > /etc/profile.d/editor.sh

# Configure application path.
tee /etc/profile.d/path.sh >/dev/null <<'EOF'
export PATH="${HOME}/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
EOF

# Configure shell.
curl -L https://raw.githubusercontent.com/qis/core/master/bash.sh -o /etc/bash/bashrc.d/99-core.bash
rm -f /root/.bashrc /home/qis/.bashrc

# Configure git.
git config --global core.eol lf
git config --global core.autocrlf false
git config --global core.filemode false
git config --global pull.rebase false

# Log out as root.
exit

# Configure git.
git config --global core.eol lf
git config --global core.autocrlf false
git config --global core.filemode false
git config --global pull.rebase false

# Close SSH connection.
exit
```

Manage virtual machines.

```sh
# Start virtual machine.
vm start windows

# Connect to rivtual machine.
vm view windows

# Shutdown virtual machine.
vm shutdown windows
```

Enable dual-monitor support.

1. Replace `-daf` with `-da` in `~/.local/bin/vm`.
2. On Windows, add a second "Video QXL" device.
3. On Linux, change "Video Virtio" XML from `heads="1"` to `heads="2"`.
