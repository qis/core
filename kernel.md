# Kernel
<https://www.kernelconfig.io/>

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
Config: LEDS_TRIGGER_AUDIO
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
make clean mrproper distclean
make tinyconfig
time make -j17  # 00:33

make clean mrproper distclean
make tinyconfig
make menuconfig
```

Enable 64-bit support.

```
[*] 64-bit kernel
```

Enable gentoo support.

```
Gentoo Linux  --->

    [*] Gentoo Linux support
    Symbol: GENTOO_LINUX

    Support for init systems, system and service managers  --->

        [ ] OpenRC, runit and other script based systems and managers
        Symbol: GENTOO_LINUX_INIT_SCRIPT

        [*] systemd
        Symbol: GENTOO_LINUX_INIT_SYSTEMD
```

Enable loadable modules support.

```
[*] Enable loadable module support  --->
Symbol: MODULES

    [*]   Module unloading
    Symbol: MODULE_UNLOAD
```

Enable filesystems support.

```
File systems  --->

    [*] Validate filesystem parameter description
    Symbol: VALIDATE_FS_PARSER

    [*] Enable filesystem export operations for block IO
    Symbol: EXPORTFS_BLOCK_OPS

    <*> FUSE (Filesystem in Userspace) support
    Symbol: FUSE_FS

    <*>   Character device in Userspace support
    Symbol: CUSE

    CD-ROM/DVD Filesystems  --->

        <M> ISO 9660 CDROM file system support
        Symbol: ISO9660_FS

        [*]   Microsoft Joliet CDROM extensions
        Symbol: JOLIET

        [*]   Transparent decompression extension
        Symbol: ZISOFS

        <M> UDF file system support
        Symbol: UDF_FS

    DOS/FAT/EXFAT/NT Filesystems  --->

        <*> MSDOS fs support
        Symbol: MSDOS_FS

        <*> VFAT (Windows-95) fs support
        Symbol: VFAT_FS

        (ascii) Default iocharset for FAT
        Symbol: FAT_DEFAULT_IOCHARSET [=ascii]

        <*> exFAT filesystem support
        Symbol: EXFAT_FS

    Pseudo filesystems  --->

        <*> Userspace-driven configuration filesystem
        Symbol: CONFIGFS_FS

    -*- Native language support  --->

        (utf8) Default NLS Option
        Symbol: NLS_DEFAULT [=utf8]

        <*> NLS UTF-8
        Symbol: NLS_UTF8

    <M> Distributed Lock Manager (DLM)  --->
    Symbol: DLM

    <M> UTF-8 normalization and casefolding support
    Symbol: UNICODE
```

Configure system.

```
General setup  --->

    () Local version - append to kernel release
    Symbol: LOCALVERSION [=]

    (/lib/systemd/systemd) Default init path
    Symbol: DEFAULT_INIT [=/lib/systemd/systemd]

    (core) Default hostname
    Symbol: DEFAULT_HOSTNAME [=core]

    [*] General notification queue
    Symbol: WATCH_QUEUE

    [*] Enable process_vm_readv/writev syscalls
    Symbol: CROSS_MEMORY_ATTACH

    Timers subsystem  --->

        Timer tick handling (Idle dynticks system (tickless idle))  --->
        Symbol: NO_HZ_IDLE

        [*] High Resolution Timer Support
        Symbol: HIGH_RES_TIMERS

    BPF subsystem  --->

        [*] Enable BPF Just In Time compiler
        Symbol: BPF_JIT

        [*]   Permanently enable BPF JIT and remove BPF interpreter
        Symbol: BPF_JIT_ALWAYS_ON

        [*] Preload BPF file system with kernel specific program and map iterators  --->
        Symbol: BPF_PRELOAD

    Preemption Model (Preemptible Kernel (Low-Latency Desktop))  --->
    Symbol: PREEMPT

    [*] Preemption behaviour defined on boot
    Symbol: BPF_PRELOAD_UMD

    CPU/Task time and stats accounting  --->

        Cputime accounting (Full dynticks CPU time accounting)  --->
        Symbol: VIRT_CPU_ACCOUNTING_GEN

    <M> Kernel .config support
    Symbol: IKCONFIG

    [*]   Enable access to .config through /proc/config.gz
    Symbol: IKCONFIG_PROC

    -*- Control Group support  --->
    Symbol: CGROUPS

        [*]   Memory controller
        Symbol: MEMCG

        [*]   IO controller
        Symbol: BLK_CGROUP

        [*]   CPU controller  --->
        Symbol: CGROUP_SCHED

            [*]     CPU bandwidth provisioning for FAIR_GROUP_SCHED
            Symbol: CFS_BANDWIDTH

        [*]   PIDs controller
        Symbol: CGROUP_PIDS

        [*]   Freezer controller
        Symbol: CGROUP_FREEZER

        [*]   Device controller
        Symbol: CGROUP_DEVICE

        [*]   Simple CPU accounting controller
        Symbol: CGROUP_CPUACCT

        [*]   Perf controller
        Symbol: CGROUP_PERF

        [*]   Misc resource controller
        Symbol: CGROUP_MISC

    [*] Automatic process group scheduling
    Symbol: SCHED_AUTOGROUP

    [*] Kernel->user space relay support (formerly relayfs)
    Symbol: RELAY

    [*] Initial RAM filesystem and RAM disk (initramfs/initrd) support
    Symbol: BLK_DEV_INITRD

    [ ]   Support initial ramdisk/ramfs compressed using gzip
    [ ]   Support initial ramdisk/ramfs compressed using bzip2
    [ ]   Support initial ramdisk/ramfs compressed using LZMA
    [*]   Support initial ramdisk/ramfs compressed using XZ
    [ ]   Support initial ramdisk/ramfs compressed using LZO
    [ ]   Support initial ramdisk/ramfs compressed using LZ4
    [ ]   Support initial ramdisk/ramfs compressed using ZSTD

    Compiler optimization level (Optimize for performance (-O2))  --->
    Symbol: CC_OPTIMIZE_FOR_PERFORMANCE

    [*] Enable rseq() system call
    Symbol: RSEQ

    [*] Profiling support
    Symbol: PROFILING


Power management and ACPI options  --->

    [*] ACPI (Advanced Configuration and Power Interface) Support  --->
    Symbol: ACPI


Device Drivers  --->

    [*] PCI support  --->
    Symbol: PCI

        [*]   PCI Express Port Bus support
        Symbol: PCIEPORTBUS

        [*]   PCI Express Precisiono Time Measurement support
        Symbol: PCIE_PTM

        [*]   Message Signaled Interrupts (MSI and MSI-X)
        Symbol: PCI_MSI

        [*]   PCI IOV support
        Symbol: PCI_IOV

        [*]   Enable PCI resource re-allocation detection
        Symbol: PCI_REALLOC_ENABLE_AUTO

        <M>   PCI Stub driver
        Symbol: PCI_STUB

        <M>   PCI PF Stub driver
        Symbol: PCI_PF_STUB

        [*]   PCI PRI support
        Symbol: PCI_PRI

        [*]   Support for PCI Hotplug  --->
        Symbol: HOTPLUG_PCI

            [*]   ACPI PCI Hotplug driver
            Symbol: HOTPLUG_PCI_ACPI

        [*]   PCI Express Hotplug driver
        Symbol: HOTPLUG_PCI_PCIE

    SCSI device support  --->

        <*> SCSI device support
        Symbol: SCSI

        <*> SCSI disk support
        Symbol: BLK_DEV_SD

        <M> SCSI CDROM support
        Symbol: BLK_DEV_SR

        <M> SCSI generic support
        Symbol: BLK_DEV_SG

    [*] USB support  --->
    Symbol: USB_SUPPORT

        <*>   Support for Host-side USB
        Symbol: USB

        [*]   PCI based USB host interface
        Symbol: USB_PCI

        [*]    AMD PCI USB host support
        Symbol: USB_PCI_AMD

        <*>   xHCI HCD (USB 3.0) support
        Symbol: USB_XHCI_HCD

        <*>     Generic xHCI driver for a platform device
        Symbol: USB_XHCI_PLATFORM

        <*>   EHCI HCD (USB 2.0) support
        Symbol: USB_EHCI_HCD

        [*]     Root Hub Trasnaction Translators
        Symbol: USB_EHCI_ROOT_HUB_IT

        <*>     Generic EHCI driver for a platform device
        Symbol: USB_EHCI_PLATFORM



        <M>   USB Mass Storage support
        Symbol: USB_STORAGE

        Enable all USB Mass Storage devices as modules.

    [*] USB support  --->
    Symbol: USB_SUPPORT


```











TODO








```

Processor type and features  --->

    [*] Symmetric multi-processing support
    Symbol: SMP

    [*] x86 CPU resource control support
    Symbol: X86_CPU_RESCTRL

    [*] Single-depth WCHAN output
    Symbol: SCHED_OMIT_FRAME_POINTER

    [*] Supported processor vendors  --->
    Symbol: PROCESSOR_SELECT

        [ ]   Support Intel processors
        Symbol: CPU_SUP_INTEL

        [*]   Support AMD processors
        Symbol: CPU_SUP_AMD

        [ ]   Support Hygon processors
        Symbol: CPU_SUP_HYGON

        [ ]   Support Centaur processors
        Symbol: CPU_SUP_CENTAUR

        [ ]   Support Zhaoxin processors
        Symbol: CPU_SUP_ZHAOXIN

    [*] Enable DMI scanning
    Symbol: DMI

    (16) Maximum number of CPUs
    Symbol: NR_CPUS [=16]

    [*] Reroute for broken boot IRQs
    Symbol: X86_REROUTE_FOR_BROKEN_BOOT_IRQS

    [*] Machine Check / overheating reporting
    Symbol: X86_MCE

    Performance monitoring  --->

        <*> AMD Uncore performance events
        Symbol: PERF_EVENTS_AMD_UNCORE

        [*] AMD Zen3 Branch Sampling support
        Symbol: PERF_EVENTS_AMD_BRS

    [ ] Enable vsyscall emulation
    Symbol: X86_VSYSCALL_EMULATION

    [ ] Enable 5-level page tables support
    Symbol: X86_5LEVEL

    [*] EFI runtime service support
    Symbol: EFI

    [*]   EFI stub support
    Symbol: EFI_STUB

    [ ]     EFI handover protocol (DEPRECATED)
    Symbol: EFI_HANDOVER_PROTOCOL

    [*] AMD Secure Memory Encryption (SME) support
    Symbol: AMD_MEM_ENCRYPT

    [*] NUMA Memory Allocation and Scheduler Support
    Symbol: NUMA

    [*]   ACPI NUMA detection
    Symbol: ACPI_NUMA

    [*] User Mode Instruction Prevention
    Symbol: X86_UMIP

    Timer frequency (1000 HZ)  --->
    Symbol: HZ_1000

    vsyscall table for legacy applications (None)  --->
    Symbol: LEGACY_VSYSCALL_NONE

    [*] Built-in kernel command line
    Symbol: CMDLINE_BOOL

    (root=system/root) Built-in kernel command string
    Symbol: CMDLINE [=root=system/root]


Power management and ACPI options  --->

    [*] Suspend to RAM and standby
    Symbol: SUSPEND

    [*] Hibernation (aka 'suspend to disk')
    Symbol: HIBERNATION

    (/dev/nvme0n1p2) Default resume partition
    Symbol: PM_STD_PARTITION [=/dev/nvme0n1p2]

    [*] ACPI (Advanced Configuration and Power Interface) Support  --->
    Symbol: ACPI

        [*]   ACPI Firmware Performance Data Table (FPDT) support
        Symbol: ACPI_FPDT

        <*>   ACPI Time and Alarm (TAD) Device Support
        Symbol: ACPI_TAD

        [*]   Dock
        Symbol: ACPI_DOCK

        <*>   Smart Battery System
        Symbol: ACPI_SBS

        <*>   Hardware Error Device
        Symbol: ACPI_HED

        [*]     ACPI Heterogeneous Memory Attribute Table Support
        Symbol: ACPI_HMAT

        [*]   ACPI Platform Error Interface (APEI)
        Symbol: ACPI_APEI

        [*]     APEI Generic Hardware Error Source
        Symbol: ACPI_APEI_GHES

        <*>   ACPI configfs support
        Symbol: ACPI_CONFIGFS

        [*]   PMIC (Power Management Integrated Circuit) operation region support  ----
        Symbol: PMIC_OPREGION

    CPU Frequency scaling  --->

        -*- CPU Frequency scaling
        Symbol: CPU_FREQ

        Default CPUFreq governor (schedutil)  --->
        Symbol: CPU_FREQ_DEFAULT_GOV_SCHEDUTIL

        -*-   AMD Processor P-State driver
        Symbol: X86_AMD_PSTATE

        <*>   ACPI Processor P-States driver
        Symbol: X86_ACPI_CPUFREQ


[*] Virtualization  --->

    <M>   Kernel-based Virtual Machine (KVM) support
    Symbol: KVM

    <M>     KVM for AMD processors support
    Symbol: KVM_AMD


General architecture-dependent options  --->

    [*] Optimize very unlikely/likely branches
    Symbol: JUMP_LABEL

    [*] Provide system calls for 32-bit time_t
    Symbol: COMPAT_32BIT_TIME

    [ ] Use a virtually-mapped stack
    Symbol: VMAP_STACK


-*- Enable the block layer  --->
    Symbol: BLOCK

    [ ]   Legacy autoloading support
    Symbol: BLOCK_LEGACY_AUTOLOAD

    [*]   Block layer data integrity support
    Symbol: BLK_DEV_INTEGRITY

    [*]   Zoned block device support
    Symbol: BLK_DEV_ZONED

    [*]   Enable support for block device writeback throttling
    Symbol: BLK_WBT

    Partition Types  --->

        [*] Advanced partition selection
        Symbol: PARTITION_ADVANCED

        [*]   PC BIOS (MSDOS partition tables) support
        Symbol: MSDOS_PARTITION

        [*]   EFI GUID Partition support
        Symbol: EFI_PARTITION

    IO Schedulers  --->

        <*> BFQ I/O scheduler
        Symbol: IOSCHED_BFQ

        [*]   BFQ hierarchical scheduling support
        Symbol: BFQ_GROUP_IOSCHED


Executable file formats  --->

    [*] Kernel support for ELF binaries
    Symbol: BINFMT_ELF

    <*> Kernel support for scripts starting with #!
    Symbol: BINFMT_SCRIPT


Memory Management options  --->

    [*] Page allocator randomization
    Symbol: SHUFFLE_PAGE_ALLOCATOR

    [*] Disable heap randomization
    Symbol: COMPAT_BRK

    [*] Allow for memory compaction
    Symbol: COMPACTION

    [*] Free page reporting
    Symbol: PAGE_REPORTING

    [*] Enable KSM for page merging
    Symbol: KSM

    (65536) Low address space to protect from user allocation
    Symbol: DEFAULT_MMAP_MIN_ADDR [=65536]

    [*] Transparent Hugepage Support  --->
    Symbol: TRANSPARENT_HUGEPAGE

        Transparent Hugepage Support sysfs defaults (madvise)  --->
        Symbol: TRANSPARENT_HUGEPAGE_MADVISE

    [*] Contiguous Memory Allocator
    Symbol: CMA

    [*] Support DMA zone
    Symbol: ZONE_DMA

    [*] Enable userfaultfd() system call
    Symbol: USERFAULTFD

    [*] Multi-Gen LRU
    Symbol: LRU_GEN

    [*]   Enable by default
    Symbol: LRU_GEN_ENABLED


[*] Networking support  --->
Symbol: NET

    Networking options  --->

        <*> Packet socket
        Symbol: PACKET

        <*> Transport Layer Security support
        Symbol: TLS

        [*]   Transport Layer Security HW offload
        Symbol: TLS_DEVICE

        [*]   Transport Layer Security TCP stack bypass
        Symbol: TLS_TOE

        [*]   IP: advanced router
        Symbol: IP_ADVANCED_ROUTER

        <*>   IP: tunneling
        Symbol: NET_IPIP

        [*]   IP: TCP syncookie support
        Symbol: SYN_COOKIES

        <*>     UDP: socket monitoring interface
        Symbol: INET_UDP_DIAG

        <*>     RAW: socket monitoring interface
        Symbol: INET_RAW_DIAG

        [*]     INET: allow privileged process to administratively close sockets
        Symbol: INET_DIAG_DESTROY

        -*-   The IPv6 protocol  --->
        Symbol: IPV6

            [*]   IPv6: Router Preference (RFC 4191) support
            Symbol: IPV6_ROUTER_PREF

            [*]     IPv6: Route Information (RFC 4191) support
            Symbol: IPV6_ROUTE_INFO

            [*]   IPv6: Enable RFC 4429 Optimistic DAD
            Symbol: IPV6_OPTIMISTIC_DAD

            [*]   IPv6: Multiple Routing Tables
            Symbol: IPV6_MULTIPLE_TABLES

            [*]     IPv6: source address based routing
            Symbol: IPV6_SUBTREES

            [*]   IPv6: multicast routing
            Symbol: IPV6_MROUTE

            [*]     IPv6: multicast policy routing
            Symbol: IPV6_MROUTE_MULTIPLE_TABLES

            [*]     IPv6: PIM-SM version 2 support
            Symbol: IPV6_PIMSM_V2

        [*] Network packet filtering framework (Netfilter)  --->
        Symbol: NETFILTER

            Core Netfilter Configuration  --->

                <*> Netfilter LOG over NFNETLINK interface
                Symbol: NETFILTER_NETLINK_LOG

                <*> Netfilter connection tracking support
                Symbol: NF_CONNTRACK

                [*] Connection tracking zones
                Symbol: NF_CONNTRACK_ZONES

                [*] Connection tracking timeout
                Symbol: NF_CONNTRACK_TIMEOUT

                [*] Connection tracking timestamping
                Symbol: NF_CONNTRACK_TIMESTAMP

                <*> FTP protocol support
                Symbol: NF_CONNTRACK_FTP

                <*> H.323 protocol support
                Symbol: NF_CONNTRACK_H323

                <*> IRC protocol support
                Symbol: NF_CONNTRACK_IRC

                <*> NetBIOS name service protocol support
                Symbol: NF_CONNTRACK_NETBIOS_NS

                <*> SNMP service protocol support
                Symbol: NF_CONNTRACK_SNMP

                <*> SANE protocol support
                Symbol: NF_CONNTRACK_SANE

                <*> SIP protocol support
                Symbol: NF_CONNTRACK_SIP

                <*> TFTP protocol support
                Symbol: NF_CONNTRACK_TFTP

                <*> Connection tracking netlink interface
                Symbol: NF_CT_NETLINK

                <*> Connection tracking timeout tuning via Netlink
                Symbol: NF_CT_NETLINK_TIMEOUT

                [*] NFQUEUE and NFLOG integration with Connection Tracking
                Symbol: NETFILTER_NETLINK_GLUE_CT

                <*> Network Address Translation support
                Symbol: NF_NAT

                <*> Netfilter nf_tables support
                Symbol: NF_TABLES

                [*]   Netfilter nf_tables mixed IPv4/IPv6 tables support
                Symbol: NF_TABLES_INET

                [*]   Netfilter nf_tables netdev tables support
                Symbol: NF_TABLES_NETDEV

                <M>   Netfilter nf_tables *

                <M> Netfilter flow table module
                Symbol: NF_FLOW_TABLE

                <M> Netfilter flow table mixed IPv4/IPv6 module
                Symbol: NF_FLOW_TABLE_INET

                [*]   Supply flow table statistics in procfs
                Symbol: NF_FLOW_TABLE_PROCFS

            IP: Netfilter Configuration  --->

                [*] ARP nf_tables support
                Symbol: NF_TABLES_ARP

            <M>   IPv4/IPV6 bridge connection tracking support
            Symbol: NF_CONNTRACK_BRIDGE

        <*> 802.1d Ethernet Bridging
        Symbol: BRIDGE

        <*> 802.1Q/802.1ad VLAN Support
        Symbol: VLAN_8021Q

        [*]   GVRP (GARP VLAN Registration Protocol) support
        Symbol: VLAN_8021Q_GVRP

        [*]   MVRP (Multiple VLAN Registration Protocol) support
        Symbol: VLAN_8021Q_MVRP

        <M> Virtual Socket protocol
        Symbol: VSOCKETS

        <*> NETLINK: socket monitoring interface
        Symbol: NETLINK_DIAG

    <*>   Bluetooth subsystem support  --->
    Symbol: BT

        Enable everything (preferably as module) that
        is not related to testing or debugging.

        Bluetooth device drivers  --->

            <*> HCI USB driver
            Symbol: BT_HCIBTUSB

            Enable all HCI USB driver options.

    [*]   Wireless  --->
    Symbol: WIRELESS

        <*>   cfg80211 - wireless configuration API
        Symbol: CFG80211

        [*]     cfg80211 wireless extensions compatibility
        Symbol: CFG80211_WEXT

        <*>   Generic IEEE 802.11 Networking Stack (mac80211)
        Symbol: MAC80211

        [*]   Enable mac80211 mesh networking support
        Symbol: MAC80211_MESH

    <*>   RF switch subsystem support  ----
    Symbol: RFKILL

    <M>   NFC subsystem support  --->
    Symbol: NFC

        Enable everything (preferably as module) that
        is not related to testing or debugging.
```

Enable device drivers.

```
Device Drivers  --->

    [*] PCI support  --->
    Symbol: PCI

        [*]   PCI Express Port Bus support
        Symbol: PCIEPORTBUS

        [*]     PCI Express Advanced Error Reporting support
        Symbol: PCIEAER

        <*>       PCI Express error injection support
        Symbol: PCIEAER_INJECT

        [*]       PCI Express ECRC settings control
        Symbol: PCIE_ECRC

        [*]   PCI Express Downstream Port Containment support
        Symbol: PCIE_DPC

        [*]   PCI Express Precision Time Measurement support
        Symbol: PCIE_PTM

        [*]   PCI Express Error Disconnect Recover support
        Symbol: PCIE_EDR

        [*]   Message Signaled Interrupts (MSI and MSI-X)
        Symbol: PCI_MSI

        <*>   PCI Stub driver
        Symbol: PCI_STUB

        [*]   PCI IOV support
        Symbol: PCI_IOV

        [*]   Enable PCI resource re-allocation detection
        Symbol: PCI_REALLOC_ENABLE_AUTO

        [*]   PCI PRI support
        Symbol: PCI_PRI

        [*]   PCI PASID support
        Symbol: PCI_PASID

        [*]   Support for PCI Hotplug  --->
        Symbol: HOTPLUG_PCI

            [*]   ACPI PCI Hotplug driver
            Symbol: HOTPLUG_PCI_ACPI

            <*>     ACPI PCI Hotplug driver IBM extensions
            Symbol: HOTPLUG_PCI_ACPI_IBM

            [*]   CompactPCI Hotplug driver
            Symbol: HOTPLUG_PCI_CPCI

            <M>     Ziatech ZT550 CompactPCI Hotplug driver
            Symbol: HOTPLUG_PCI_CPCI_ZT5550

            <M>     Generic port I/O CompactPCI Hotplug driver
            Symbol: HOTPLUG_PCI_CPCI_GENERIC

            [*]   SHPC PCI Hotplug driver
            Symbol: HOTPLUG_PCI_SHPC

        [*]     PCI Express Hotplug driver
        Symbol: HOTPLUG_PCI_PCIE

    Generic Driver Options  --->

        [*]   Automount devtmpfs at /dev, after the kernel mounted the rootfs
        Symbol: DEVTMPFS_MOUNT

        [*]   Use nosuid,noexec mount options on devtmpfs
        Symbol: DEVTMPFS_SAFE

        [*] Select only drivers that don't need compile-time external firmware
        Symbol: STANDALONE

        [*] Disable drivers features which enable custom firmware building
        Symbol: PREVENT_FIRMWARE_BUILD

        Firmware loader  --->

            [*]   Enable the firmware sysfs fallback mechanism
            Symbol: FW_LOADER_USER_HELPER

            [*]   Enable compressed firmware support
            Symbol: FW_LOADER_COMPRESS

            [*]     Enable XZ-compressed firmware support
            Symbol: FW_LOADER_COMPRESS_XZ

            [*]     Enable ZSTD-compressed firmware support
            Symbol: FW_LOADER_COMPRESS_ZSTD

            [*]   Enable users to initiate firmware updates using sysfs
            Symbol: FW_UPLOAD

    Bus devices  --->

        Enable everything (preferably as module).

    <*> Connector - unified userspace <-> kernelspace linker  --->
    Symbol: CONNECTOR

    Firmware Drivers  --->

        [*] Add firmware-provided memory map to sysfs
        Symbol: FIRMWARE_MEMMAP

        <*> DMI table support in sysfs
        Symbol: DMI_SYSFS

    -*- Plug and Play support  --->
    Symbol: PNP

    [*] Block devices  --->
    Symbol: BLK_DEV

        <*>   Loopback device support
        Symbol: BLK_DEV_LOOP

        (0)     Number of loop devices to pre-create at init time
        Symbol: BLK_DEV_LOOP_MIN_COUNT [=0]

    NVME Support  --->

        <*> NVM Express block device
        Symbol: BLK_DEV_NVME

        [*] NVMe multipath support
        Symbol: NVME_MULTIPATH

    SCSI device support  --->

        <*> SCSI device support
        Symbol: SCSI

        <*> SCSI disk support
        Symbol: BLK_DEV_SD

        <M> SCSI CDROM support
        Symbol: BLK_DEV_SR

        <M> SCSI generic support
        Symbol: BLK_DEV_SG

        SCSI Transports  --->

            Enable everything (preferably as module).

        [*] SCSI low-level drivers  --->
        Symbol: SCSI_LOWLEVEL

            Enable everything (preferably as module).
            Do not compile in debug mode.

        [*] Device Handlers  --->
        Symbol: SCSI_DH

            Enable everything (preferably as module).

    [*] Multiple devices driver support (RAID and LVM)  --->
    Symbol: MD

        <M>   Device mapper support
        Symbol: BLK_DEV_DM

    -*- Network device support  --->
    Symbol: NETDEVICES

        [*]   Network core driver support
        Symbol: NET_CORE

        <M>     MAC-VLAN support
        Symbol: MACVLAN

        <M>     IP-VLAN support
        Symbol: IPVLAN

        <M>     Virtual eXtensible Local Area Network (VXLAN)
        Symbol: VXLAN

        <M>     Generic Network Virtualization Encapsulation
        Symbol: GENEVE

        <M>     Universal TUN/TAP device driver support
        Symbol: TUN

        -*-   Ethernet driver support
        Symbol: ETHERNET

            Disable everything.

        [*]   Wireless LAN  --->
        Symbol: WLAN
    
            Disable everything.

Device Drivers  --->

    -*- Network device support  --->
    Symbol: NETDEVICES

        <M>   USB Network Adapters  --->
        Symbol: USB_NET_DRIVERS

            <M>   Multi-purpose USB Networking Framework
            Symbol: USB_USBNET

            -M-     CDC Ethernet support (smart devices such as cable modems)
            Symbol: USB_NET_CDCETHER

        [*]   Wireless LAN  --->
        Symbol: WLAN
    
            [*] Atheros/Qualcomm devices
            Symbol: WLAN_VENDOR_ATH

                <*> Qualcomm Technologies 802.11ax chipset support
                Symbol: ATH11K

                    <*> Atheros atk11k PCI support
                    Symbol: ATH11K_PCI
```

```sh
time make -j17
```
