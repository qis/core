# Kernel
* <https://www.kernelconfig.io/>
* <https://wiki.gentoo.org/wiki/User:Pietinger/Tutorials/Manual_kernel_configuration>

## System
List loaded kernel modules.

```sh
lsmod
```

List PCI hardware and used drivers.

```sh
lspci -k
```

List USB devices and used drivers.

```sh
usb-devices
```

## Hardware
USB devices require the following drivers.

```
USB Hub
Config: USB
Driver: hub

Generic Bluetooth USB
Config: BT_HCIBTUSB
Driver: btusb

USB Mass Storage Support
Config: USB_STORAGE
Driver: usb-storage

USB Webcam Function
Config: USB_VIDEO_CLASS
Driver: uvcvideo

USB HID Transport Layer
Config: USB_HID
Driver: usbhid

USB Audio/MIDI Driver
Config: SND_USB_AUDIO
Driver: snd-usb-audio

CDC Ethernet Support
Config: USB_NET_CDCETHER
Driver: cdc_ether
```

PCI devices require the following drivers.

```
PCIe Port
Config: PCIEPORTBUS
Driver: pcieport

SMBus: Advanced Micro Devices, Inc. [AMD] FCH SMBus Controller
Config: I2C_PIIX4
Driver: piix4_smbus

Host bridge: Advanced Micro Devices, Inc. [AMD] Rembrandt Data Fabric: Device 18h
Config: SENSORS_K10TEMP
Driver: k10temp

Network controller: Qualcomm Technologies, Inc QCNFA765 Wireless Network Adapter
Config: ATH11K_PCI
Driver: ath11k_pci

Wireless controller [0d40]: MEDIATEK Corp. Device 4d75
Config: MTK_T7XX
Driver: mtk_t7xx

Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe SSD Controller PM9A1/PM9A3/980PRO
Config: NVMEM, BLK_DEV_NVME
Driver: nvme

VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Rembrandt [Radeon 680M]
Config:
Driver: amdgpu

Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Rembrandt Radeon High Definition Audio Controller
Audio device: Advanced Micro Devices, Inc. [AMD] Family 17h/19h HD Audio Controller
Config: SND_HDA_INTEL
Driver: snd_hda_intel

Encryption controller: Advanced Micro Devices, Inc. [AMD] VanGogh PSP/CCP
Config: CRYPTO_DEV_CCP_CRYPTO
Driver: ccp

USB controller: Advanced Micro Devices, Inc. [AMD] Rembrandt USB4 XHCI controller
Config: USB_XHCI_HCD
Driver: xhci_hcd

Multimedia controller: Advanced Micro Devices, Inc. [AMD] ACP/ACP3X/ACP6x Audio Coprocessor
Config: SND_SOC_AMD_ACP6x
Driver: snd_pci_acp6x

USB controller: Advanced Micro Devices, Inc. [AMD] Rembrandt USB4/Thunderbolt NHI controller
Config: USB4
Driver: thunderbolt
```

Modules loaded during operation.

```
Advanced Linux Sound Architecture
Config: AC97_BUS or AC97_BUS_NEW?
Module: ac97_bus

ACPI Processor P-States driver
Config: X86_ACPI_CPUFREQ
Module: acpi_cpufreq

ACPI Time and Alarm (TAD) Device Support
Config: ACPI_TAD
Module: acpi_tad

AMD SoC PMC driver
Config: AMD_PMC
Module: amd_pmc

AMD GPU
Config: DRM_AMDGPU
Module: amdgpu

Qualcomm Technologies 802.11ax chipset support
Config: ATH11K
Module: ath11k

Atheros ath11k PCI support
Config: ATH11K_PCI
Module: ath11k_pci

Emulex 10Gbps iSCSI - BladeEngine 2
Config: BE2ISCSI
Module: be2iscsi

Kernel support for MISC binaries
Config: BINFMT_MISC
Module: binfmt_misc

Bluetooth subsystem support
Config: BT
Module: bluetooth

BNEP protocol support
Config: BT_BNEP
Module: bnep

QLogic NetXtreme II iSCSI support
Config: SCSI_BNX2_ISCSI
Module: bnx2i

Bluetooth device drivers: BCM (not configurable)
Config: BT_BCM
Module: btbcm

Bluetooth device drivers: INTEL (not configurable)
Config: BT_INTEL
Module: btintel

Bluetooth device drivers: MTK (not configurable)
Config: BT_MTK
Module: btmtk

Bluetooth device drivers: RTL (not configurable)
Config: BT_RTL
Module: btrtl

HCI USB driver
Config: BT_HCIBTUSB
Module: btusb

Secure Processor device driver
Config: CRYPTO_DEV_CCP_DD
Module: ccp

CDC Ethernet support (smart devices such as cable modems)
Config: USB_NET_CDCETHER
Module: cdc_ether

Correctable Errors Collector
Config: RAS_CEC
Module: cec

cfg80211 - wireless configuration API
Config: CFG80211
Module: cfg80211

QLogic CNIC support
Config: CNIC
Module: cnic

CRC32 (PCLMULQDQ)
Config: CRYPTO_CRC32_PCLMUL
Module: crc32_pclmul

CRC32c (SSE4.2/PCLMULQDQ)
Config: CRYPTO_CRC32C_INTEL
Module: crc32c_intel

CRCT10DIF (PCLMULQDQ)
Config: CRYPTO_CRCT10DIF_PCLMUL
Module: crct10dif_pclmul

Chelsio Communications T3 10Gb Ethernet support
Config: CHELSIO_T3
Module: cxgb3

Chelsio T3 iSCSI support
Config: SCSI_CXGB3_ISCSI
Module: cxgb3i

Chelsio Communications T4/T5/T6 Ethernet support
Config: CHELSIO_T4
Module: cxgb4

Chelsio T4 iSCSI support
Config: SCSI_CXGB4_ISCSI
Module: cxgb4i

Direct Rendering Manager (XFree86 4.1.0 and higher DRI support)
Config: DRM_BUDDY, DRM_DISPLAY_HELPER, DRM_TTM_HELPER, DRM_SCHED, DRM_TTM
Module: drm_buddy, drm_display_helper, drm_ttm_helper, gpu_sched, ttm

Decode MCEs in human-readable form (only on AMD for now)
Config: EDAC_DECODE_MCE
Module: edac_mce_amd

X86 Platform Specific Device Drivers
Config: FW_ATTR_CLASS
Module: firmware_attributes_class

FUSE (Filesystem in Userspace) support
Config: FUSE_FS
Module: fuse

Hash functions: GHASH (CLMUL-NI)
Config: CRYPTO_GHASH_CLMUL_NI_INTEL
Module: ghash_clmulni_intel

HID Multitouch panels
Config: HID_MULTITOUCH
Module: hid_multitouch

I2C HID support
Config: I2C_HID_CORE, I2C_HID_ACPI, I2C_PIIX4
Module: i2c_hid, i2c_hid_acpi, i2c_piix4

Generic powercap sysfs driver
Config: INTEL_RAPL_CORE
Module: intel_rapl_common

Intel RAPL Support via MSR Interface
Config: INTEL_RAPL
Module: intel_rapl_msr

AMD IOMMU Version 2 driver
Config: AMD_IOMMU_V2
Module: iommu_v2

IP6 tables support (required for filtering)
Config: IP6_NF_IPTABLES
Module: ip6_tables

IP set support
Config: IP_SET
Module: ip_set

IP tables support (required for filtering/masq/NAT)
Config: IP_NF_IPTABLES
Module: ip_tables

Device Drivers: IRQ BYPASS MANAGER
Config: IRQ_BYPASS_MANAGER (not configurable)
Module: irqbypass

iSCSI Boot Sysfs Interface
Config: ISCSI_BOOT_SYSFS
Module: iscsi_boot_sysfs

iSCSI Initiator over TCP/IP
Config: ISCSI_TCP
Module: iscsi_tcp

ISO 9660 CDROM file system support
Config: ISO9660_FS
Module: isofs

Joystick interface
Config: INPUT_JOYDEV
Module: joydev

AMD Family 10h+ temperature sensor
Config: SENSORS_K10TEMP
Module: k10temp

KVM Guest support (required by kvm_amd)
Config: KVM_GUEST
Module: kvm

KVM for AMD processors support
Config: KVM_AMD
Module: kvm_amd

Audio Mute LED Trigger
Config: LEDS_TRIGGERS
Module: ledtrig_audio

Crypto library routines: ARC4
Config: CRYPTO_LIB_ARC4
Module: libarc4

Ethernet driver support: CHELSIO_LIB
Config: CHELSIO_LIB
Module: libcxgb

Chelsio T4 iSCSI support
Config: SCSI_CXGB4_ISCSI
Module: libcxgbi

Emulex 10Gbps iSCSI - BladeEngine 2
Config: BE2ISCSI
Module: libiscsi

iSCSI Initiator over TCP/IP
Config: ISCSI_TCP
Module: libiscsi_tcp

Loopback device support
Config: BLK_DEV_LOOP
Module: loop

Generic IEEE 802.11 Networking Stack (mac80211)
Config: MAC80211
Module: mac80211

Media Controller
Config: (will be requested by audio/video drivers)
Module: mc

Ethernet driver support: MDIO
Config: MDIO
Module: mdio

Modem Host Interface (MHI) bus
Config: MHI_BUS
Module: mhi

Network device support: MII
Config: MII
Module: mii

MediaTek PCIe 5G WWAN modem T7xx device
Config: MTK_T7XX
Module: mtk_t7xx

Netfilter connection tracking support
Config: NF_CONNTRACK
Module: nf_conntrack

Core Netfilter Configuration: Broadcast
Config: NF_CONNTRACK_BROADCAST (not configurable)
Module: nf_conntrack_broadcast

NetBIOS name service protocol support
Config: NF_CONNTRACK_NETBIOS_NS
Module: nf_conntrack_netbios_ns

IP: Netfilter Configuration
Config: NF_DEFRAG_IPV4
Module: nf_defrag_ipv4

Network packet filtering framework (Netfilter)
Config: NF_DEFRAG_IPV6
Module: nf_defrag_ipv6

Network Address Translation support
Config: NF_NAT
Module: nf_nat

IPv4 packet rejection
Config: NF_REJECT_IPV4
Module: nf_reject_ipv4

IPv6 packet rejection
Config: NF_REJECT_IPV6
Module: nf_reject_ipv6

Netfilter nf_tables support
Config: NF_TABLES
Module: nf_tables

Core Netfilter Configuration: Netlink
Config: NETFILTER_NETLINK
Module: nfnetlink

Netfilter nf_tables nat module
Config: Netfilter nf_tables nat module
Module: nft_chain_nat

Netfilter nf_tables conntrack module
Config: NFT_CT
Module: nft_ct

Core Netfilter Configuration: FIB
Config: NFT_FIB
Module: nft_fib

Netfilter nf_tables fib inet support
Config: NFT_FIB_INET
Module: nft_fib_inet

nf_tables fib / ip route lookup support
Config: NFT_FIB_IPV4
Module: nft_fib_ipv4

nf_tables fib / ipv6 route lookup support
Config: NFT_FIB_IPV6
Module: nft_fib_ipv6

Netfilter nf_tables reject support
Config: NFT_REJECT
Module: nft_reject

Core Netfilter Configuration: Reject
Config: NFT_REJECT_INET
Module: nft_reject_inet

NVM Express block device
Config: BLK_DEV_NVME
Module: nvme

NVME Support
Config: NVME_COMMON, NVME_CORE
Module: nvme_common, nvme_core

PC Speaker support (DISABLE)
Config: INPUT_PCSPKR (NO)
Module: pcspkr

ACPI (Advanced Configuration and Power Interface) Support
Config: ACPI_PLATFORM_PROFILE
Module: platform_profile

Hash functions: POLYVAL (CLMUL-NI)
Config: CRYPTO_POLYVAL_CLMUL_NI
Module: polyval_clmulni

Hashes, digests, and MACs
Config: CRYPTO_POLYVAL
Module: polyval_generic

QLogic ISP4XXX and ISP82XX host adapter family support
Config: SCSI_QLA_ISCSI
Module: qla4xxx

Qualcomm SoC drivers: QMI Helpers
Config: QCOM_QMI_HELPERS
Module: qmi_helpers

Qualcomm IPC Router support
Config: QRTR
Module: qrtr

MHI IPC Router channels
Config: QRTR_MHI
Module: qrtr_mhi

Intel/AMD rapl performance events
Config: PERF_EVENTS_INTEL_RAPL
Module: rapl

RFCOMM protocol support
Config: BT_RFCOMM
Module: rfcomm

RF switch subsystem support
Config: RFKILL
Module: rfkill

iSCSI Transport Attributes
Config: SCSI_ISCSI_ATTRS
Module: scsi_transport_iscsi

Raw access to serio ports
Config: SERIO_RAW
Module: serio_raw

Hash functions: SHA-384 and SHA-512 (SSSE3/AVX/AVX2)
Config: CRYPTO_SHA512_SSSE3
Module: sha512_ssse3

Advanced Linux Sound Architecture
Config: SND
Module: snd

AMD Audio Coprocessor-v6.x Yellow Carp support
Config: SND_SOC_AMD_ACP6x
Module: snd_acp6x_pdm_dma

AMD ACP configuration selection
Config: SND_AMD_ACP_CONFIG
Module: snd_acp_config

Advanced Linux Sound Architecture: OFFLOAD
Config: SND_COMPRESS_OFFLOAD
Module: snd_compress

Advanced Linux Sound Architecture: LED
Config: SND_CTL_LED
Module: snd_ctl_led

HD-Audio
Config: SND_HDA
Module: snd_hda_codec

Enable generic HD-audio codec parser
Config: SND_HDA_GENERIC
Module: snd_hda_codec_generic

Build HDMI/DisplayPort HD-audio codec support
Config: SND_HDA_CODEC_HDMI
Module: snd_hda_codec_hdmi

Build Realtek HD-audio codec support
Config: SND_HDA_CODEC_REALTEK
Module: snd_hda_codec_realtek

Advanced Linux Sound Architecture: Core
Config: SND_HDA_CORE
Module: snd_hda_core

HD Audio PCI
Config: SND_HDA_INTEL
Module: snd_hda_intel

HR-timer backend support
Config: SND_HRTIMER
Module: snd_hrtimer

Advanced Linux Sound Architecture: HWDEP
Config: SND_HWDEP
Module: snd_hwdep

Advanced Linux Sound Architecture: Intel DSP Config
Config: SND_INTEL_DSP_CONFIG
Module: snd_intel_dspcfg

Advanced Linux Sound Architecture: Intel SDW ACPI
Config: SND_INTEL_SOUNDWIRE_ACPI
Module: snd_intel_sdw_acpi

AMD Audio Coprocessor-v3.x support
Config: SND_SOC_AMD_ACP3x
Module: snd_pci_acp3x

AMD Audio Coprocessor-v5.x I2S support
Config: SND_SOC_AMD_ACP5x
Module: snd_pci_acp5x

AMD Audio Coprocessor-v6.x Yellow Carp support
Config: SND_SOC_AMD_ACP6x
Module: snd_pci_acp6x

AMD Audio Coprocessor-v6.3 Pink Sardine support
Config: SND_SOC_AMD_PS
Module: snd_pci_ps

Advanced Linux Sound Architecture: PCM
Config: SND_PCM
Module: snd_pcm

Advanced Linux Sound Architecture: PCM DMA Engine
Config: SND_DMAENGINE_PCM
Module: snd_pcm_dmaengine

Advanced Linux Sound Architecture: RAW MIDI
Config: SND_RAWMIDI
Module: snd_rawmidi

AMD Audio Coprocessor - Renoir support
Config: SND_SOC_AMD_RENOIR
Module: snd_rn_pci_acp3x

AMD Audio Coprocessor-v6.2 RPL support
Config: SND_SOC_AMD_RPL_ACP6x
Module: snd_rpl_pci_acp6x

Advanced Linux Sound Architecture: Sequencer support
Config: SND_SEQUENCER
Module: snd_seq

Advanced Linux Sound Architecture: SEQ Device
Config: SND_SEQ_DEVICE
Module: snd_seq_device

Advanced Linux Sound Architecture: Sequencer dummy client
Config: SND_SEQ_DUMMY
Module: snd_seq_dummy

AMD YC support for DMIC
Config: SND_SOC_AMD_YC_MACH
Module: snd_soc_acp6x_mach

ALSA for SoC audio support: ACPI
Config: SND_SOC_ACPI
Module: snd_soc_acpi

ALSA for SoC audio support
Config: SND_SOC
Module: snd_soc_core

Generic Digital Microphone CODEC
Config: SND_SOC_DMIC
Module: snd_soc_dmic

Sound Open Firmware Support
Config: SND_SOC_SOF
Module: snd_sof

Sound Open Firmware Support: AMD
Config: SND_SOC_SOF_AMD_COMMON
Module: snd_sof_amd_acp

Sound Open Firmware Support: SOF support for REMBRANDT
Config: SND_SOC_SOF_AMD_REMBRANDT
Module: snd_sof_amd_rembrandt

Sound Open Firmware Support: SOF support for RENOIR
Config: SND_SOC_SOF_AMD_RENOIR
Module: snd_sof_amd_renoir

Sound Open Firmware Support: PCI
Config: SND_SOC_SOF_PCI_DEV
Module: snd_sof_pci

Sound Open Firmware Support: SOC
Config: SND_SOC_SOF
Module: snd_sof_utils

Sound Open Firmware Support: XTENSA
Config: SND_SOC_SOF_XTENSA
Module: snd_sof_xtensa_dsp

Advanced Linux Sound Architecture: Timer
Config: SND_TIMER
Module: snd_timer

USB Audio/MIDI driver
Config: SND_USB_AUDIO
Module: snd_usb_audio

Edirol UA-101/UA-1000 driver
Config: SND_USB_UA101
Module: snd_usbmidi_lib

Sound card support
Config: SOUND
Module: soundcore

AMD/ATI SP5100 TCO Timer/Watchdog
Config: SP5100_TCO
Module: sp5100_tco

SquashFS 4.0 - Squashed file system support
Config: SQUASHFS
Module: squashfs

Network File Systems: SUN RPC
Config: SUNRPC
Module: sunrpc

Lenovo WMI-based systems management driver
Config: THINKPAD_LMI
Module: think_lmi

ThinkPad ACPI Laptop Extras
Config: THINKPAD_ACPI
Module: thinkpad_acpi

Unified support for USB4 and Thunderbolt
Config: USB4
Module: thunderbolt

Transport Layer Security support
Config: TLS
Module: tls

USB Type-C Support
Config: TYPEC
Module: typec

USB Type-C Connector System Software Interface driver
Config: TYPEC_UCSI
Module: typec_ucsi

USB Attached SCSI
Config: USB_UAS
Module: uas

UCSI ACPI Interface Driver
Config: UCSI_ACPI
Module: ucsi_acpi

User level driver support
Config: INPUT_UINPUT
Module: uinput

Userspace I/O drivers
Config: UIO
Module: uio

USB Mass Storage support
Config: USB_STORAGE
Module: usb_storage

Multi-purpose USB Networking Framework
Config: USB_USBNET
Module: usbnet

USB Video Class (UVC)
Config: USB_VIDEO_CLASS
Module: uvcvideo

ACPI (Advanced Configuration and Power Interface) Support: Video
Config: ACPI_VIDEO
Module: video

Media drivers: VIDEOBUF2
Config: VIDEOBUF2_CORE
Module: videobuf2_common

Media drivers: VIDEOBUF2: MEMOPS
Config: VIDEOBUF2_MEMOPS
Module: videobuf2_memops

Media drivers: VIDEOBUF2: V4L2
Config: VIDEOBUF2_V4L2
Module: videobuf2_v4l2

Media drivers: VIDEOBUF2: VMALLOC
Config: VIDEOBUF2_VMALLOC
Module: videobuf2_vmalloc

Video4Linux core
Config: VIDEO_DEV
Module: videodev

WMI
Config: ACPI_WMI
Module: wmi

WMI embedded Binary MOF driver
Config: WMI_BMOF
Module: wmi_bmof

Compressed RAM block device support
Config: ZRAM
Module: zram
```

## Configure
Configure kernel.

```sh
# Clean kernel.
cd /usr/src/linux
make clean mrproper distclean

# Restore kernel config.
modprobe configs
gzip -dc /proc/config.gz > /usr/src/linux/.config

# Clean up kernel config.
sed -i '/CONFIG_NR_CPUS.*/d' .config

# Update kernel config.
make oldconfig

# Enable all modules.
# make allmodconfig

# Configure kernel.
make menuconfig
```

**NOTE**: Press `z` to show hidden options.

### Init System

```
Gentoo Linux  --->

    Support for init systems, system and service managers  --->

        [ ] OpenRC, runit and other script based systems and managers
        Symbol: GENTOO_LINUX_INIT_SCRIPT

        [*] systemd
        Symbol: GENTOO_LINUX_INIT_SYSTEMD
```

### Debugging

```
Kernel hacking  --->

    Kernel Testing and Coverage  --->

        [ ] Runtime Testing  ----
        Symbol: RUNTIME_TESTING_MENU

        [ ] Memtest
        Symbol: MEMTEST
```

### Filesystem

```
File systems  --->

    Disable all "... filesystem support" entries.

    [ ] Quota support
    Symbol: QUOTA

    DOS/FAT/EXFAT/NT Filesystems  --->

        <*> MSDOS fs support
        Symbol: MSDOS_FS

        <*> VFAT (Windows-95) fs support
        Symbol: VFAT_FS

        <*> exFAT filesystem support
        Symbol: EXFAT_FS

        < > NTFS file system support
        Symbol: NTFS_FS

        < > NTFS Read-Write file system support
        Symbol: NTFS3_FS

    [ ] Network File Systems
    Symbol: NETWORK_FILESYSTEMS

    -*- Native language support  --->

        (utf8) Default NLS Option
        Symbol: NLS_DEFAULT

        <*>   Codepage 437 (United States, Canada)
        Symbol: NLS_CODEPAGE_437

        <*>   ASCII (United States)
        Symbol: NLS_ASCII

        <*>   NLS UTF-8
        Symbol: NLS_UTF8
```

### System

```
General setup  --->

    (/lib/systemd/systemd) Default init path
    Symbol: DEFAULT_INIT

    (core) Default hostname
    Symbol: DEFAULT_HOSTNAME

    Preemption Model (Preemptible Kernel (Low-Latency Desktop))  --->
    Symbol: PREEMPT

    <M> Kernel .config support
    Symbol: IKCONFIG

    [*]   Enable access to .config through /proc/config.gz
    Symbol: IKCONFIG_PROC

    [*] Configure standard kernel features (expert users)  --->
    Symbol: EXPERT

        [ ]   Enable PC-Speaker support
        Symbol: PCSPKR_PLATFORM

Processor type and features  --->

    [ ] Support for extended (non-PC) x86 platforms
    Symbol: X86_EXTENDED_PLATFORM

    [*] Supported processor vendors  --->
    Symbol: PROCESSOR_SELECT

        [*]   Support AMD processors
        Symbol: CPU_SUP_AMD

        Disable everything else.

    [ ] Enable Maximum number of SMP Processors and NUMA Nodes
    Symbol: MAXSMP

    (16) Maximum number of CPUs
    Symbol: NR_CPUS

    [ ] Enable 5-level page tables support
    Symbol: X86_5LEVEL

    Timer frequency (1000 HZ)  --->
    Symbol: HZ_1000

    [*] Built-in kernel command line
    Symbol: CMDLINE_BOOL

    (root=system/root) Built-in kernel command string
    Symbol: CMDLINE

Power management and ACPI options  --->

    [*] Hibernation (aka 'suspend to disk')
    Symbol: HIBERNATION

    (/dev/nvme0n1p2) Default resume partition
    Symbol: PM_STD_PARTITION
```

### Mitigations

```
[*] Mitigations for CPU vulnerabilities  --->
Symbol: CPU_MITIGATIONS

    [*]   Remove the kernel mapping in user mode
    Symbol: MITIGATION_PAGE_TABLE_ISOLATION

    [*]   Mitigate SPECTRE V1 hardware bug
    Symbol: MITIGATION_SPECTRE_V1

    Disable everything else.
```

```sh
# Mount UEFI boot partition.
mount /boot

# Build and install kernel.
time make -j17
make modules_prepare
make modules_install
make install

# Create and install initramfs.
bliss-initramfs -k X.Y.ZZ-gentoo
mv initrd-X.Y.ZZ-gentoo /boot/
```
