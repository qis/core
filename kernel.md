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
make clean mrproper distclean
make menuconfig
```

**NOTE**: Press `z` to show hidden options.

### Gentoo

```
Gentoo Linux  --->

    Support for init systems, system and service managers  --->

        [ ] OpenRC, runit and other script based systems and managers
        Symbol: GENTOO_LINUX_INIT_SCRIPT

        [*] systemd
        Symbol: GENTOO_LINUX_INIT_SYSTEMD
```

### Filesystem

```
File systems  --->

    < > The Extended 4 (ext4) filesystem
    Symbol: EXT4_FS

    [ ] Quota support
    Symbol: QUOTA

    <M> FUSE (Filesystem in Userspace) support
    Symbol: FUSE_FS

    <M>   Character device in Userspace support
    Symbol: CUSE

    CD-ROM/DVD Filesystems  --->

        <M> ISO 9660 CDROM file system support
        Symbol: ISO9660_FS

        <M> UDF file system support
        Symbol: UDF_FS

    DOS/FAT/EXFAT/NT Filesystems  --->

        <*> exFAT filesystem support
        Symbol: EXFAT_FS

    -*- Native language support  --->

        (utf8) Default NLS Option
        Symbol: NLS_DEFAULT [=utf8]

        <*> NLS UTF-8
        Symbol: NLS_UTF8

    Pseudo filesystems  --->

        [ ] HugeTLB file system support
        Symbol: HUGETLBFS

    [*] Miscellaneous filesystems  --->
    Symbol: MISC_FILESYSTEMS

        <*>   SquashFS 4.0 - Squashed file system support
        Symbol: SQUASHFS

        [*]     Include support for ZLIB compressed file systems
        Symbol: SQUASHFS_ZLIB

        [*]     Include support for LZO compressed file systems
        Symbol: SQUASHFS_LZO

        [*]     Include support for XZ compressed file systems
        Symbol: SQUASHFS_XZ

    [ ] Network File Systems
    Symbol: NETWORK_FILESYSTEMS
```

### System

```
General setup  --->

    () Local version - append to kernel release
    Symbol: LOCALVERSION [=]

    [ ] Automatically append version information to the version string
    Symbol: LOCALVERSION_AUTO

    Kernel compression mode (XZ)  --->
    Symbol: KERNEL_XZ

    (/lib/systemd/systemd) Default init path
    Symbol: DEFAULT_INIT [=/lib/systemd/systemd]

    (core) Default hostname
    Symbol: DEFAULT_HOSTNAME [=core]

    BPF subsystem  --->

        [*] Enable BPF Just In Time compiler
        Symbol: BPF_JIT

        [*]   Permanently enable BPF JIT and remove BPF interpreter
        Symbol: BPF_JIT_ALWAYS_ON

    Preemption Model (Preemptible Kernel (Low-Latency Desktop))  --->
    Symbol: PREEMPT

    <M> Kernel .config support
    Symbol: IKCONFIG

    [*]   Enable access to .config through /proc/config.gz
    Symbol: IKCONFIG_PROC

    -*- Control Group support  --->
    Symbol: CGROUPS

        [ ]   Debug controller
        Symbol: CGROUP_DEBUG

    [*] Initial RAM filesystem and RAM disk (initramfs/initrd) support
    Symbol: BLK_DEV_INITRD

    [*]   Support initial ramdisk/ramfs compressed using gzip
    Symbol: RD_GZIP

    [ ]   Support initial ramdisk/ramfs compressed using bzip2
    Symbol: RD_BZIP2

    [ ]   Support initial ramdisk/ramfs compressed using LZMA
    Symbol: RD_LZMA

    [*]   Support initial ramdisk/ramfs compressed using XZ
    Symbol: RD_XZ

    [*]   Support initial ramdisk/ramfs compressed using LZO
    Symbol: RD_LZO

    [ ]   Support initial ramdisk/ramfs compressed using LZ4
    Symbol: RD_LZ4

    [ ]   Support initial ramdisk/ramfs compressed using ZSTD
    Symbol: RD_ZSTD

    [*] Configure standard kernel features (expert users)  --->
    Symbol: EXPERT

        [ ]   Enable PC-Speaker support
        Symbol: PCSPKR_PLATFORM

Processor type and features  --->

    [*] Supported processor vendors  --->
    Symbol: PROCESSOR_SELECT

        Disable everything.

        [*]   Support AMD processors
        Symbol: CPU_SUP_AMD

    (16) Maximum number of CPUs
    Symbol: NR_CPUS [=16]

    [*] Machine Check / overheating reporting
    Symbol: X86_MCE

        [ ]   Intel MCE features
        Symbol: X86_MCE_INTEL

        [*]   AMD MCE features
        Symbol: X86_MCE_AMD

    Performance monitoring  --->

        <*> AMD Processor Power Reporting Mechanism
        Symbol: PERF_EVENTS_AMD_POWER

        [*] AMD Zen3 Branch Sampling support
        Symbol: PERF_EVENTS_AMD_BRS

    [ ] Enable 5-level page tables support
    Symbol: X86_5LEVEL

    [*] AMD Secure Memory Encryption (SME) support
    Symbol: AMD_MEM_ENCRYPT

    [*] EFI runtime service support
    Symbol: EFI

    [*]   EFI stub support
    Symbol: EFI_STUB

    [ ]     EFI handover protocol (DEPRECATED)
    Symbol: EFI_HANDOVER_PROTOCOL

    [ ]     EFI mixed-mode support
    Symbol: EFI_MIXED

    [*] Built-in kernel command line
    Symbol: CMDLINE_BOOL

    (root=system/root) Built-in kernel command string
    Symbol: CMDLINE [=root=system/root]


Power management and ACPI options  --->

    [*] Hibernation (aka 'suspend to disk')
    Symbol: HIBERNATION

    (/dev/nvme0n1p2) Default resume partition
    Symbol: PM_STD_PARTITION [=/dev/nvme0n1p2]

    CPU Frequency scaling  --->

        -*- CPU Frequency scaling
        Symbol: CPU_FREQ

        Default CPUFreq governor (ondemand)  --->
        Symbol: CPU_FREQ_DEFAULT_GOV_ONDEMAND

        <*>   ACPI Processor P-States driver
        Symbol: X86_ACPI_CPUFREQ

        <*>   AMD frequency sensitivity feedback powersave bias
        Symbol: X86_AMD_FREQ_SENSITIVITY


[*] Virtualization  --->

    <M>   Kernel-based Virtual Machine (KVM) support
    Symbol: KVM

    <M>     KVM for AMD processors support
    Symbol: KVM_AMD


-*- Enable the block layer  --->
    Symbol: BLOCK

    [*]   Enable support for block device writeback throttling
    Symbol: BLK_WBT

    Partition Types  --->

        [*] Advanced partition selection
        Symbol: PARTITION_ADVANCED

        [*]   PC BIOS (MSDOS partition tables) support
        Symbol: MSDOS_PARTITION

        [*]   EFI GUID Partition support
        Symbol: EFI_PARTITION


Memory Management options  --->

    [*] Disable heap randomization
    Symbol: COMPAT_BRK

    [*] Allow for memory compaction
    Symbol: COMPACTION


[*] Networking support  --->
Symbol: NET

    Networking options  --->

        <*> Transport Layer Security support
        Symbol: TLS

        [*]   Transport Layer Security HW offload
        Symbol: TLS_DEVICE

        [*]   Transport Layer Security TCP stack bypass
        Symbol: TLS_TOE

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

            <*>   IP set support  --->
            Symbol: IP_SET

        <M> 802.1Q/802.1ad VLAN Support
        Symbol: VLAN_8021Q

        [*]   GVRP (GARP VLAN Registration Protocol) support
        Symbol: VLAN_8021Q_GVRP

        [*]   MVRP (Multiple VLAN Registration Protocol) support
        Symbol: VLAN_8021Q_MVRP

        <M> Virtual Socket protocol
        Symbol: VSOCKETS

    <M>   Bluetooth subsystem support  --->
    Symbol: BT

        [*]   Bluetooth Classic (BR/EDR) features
        Symbol: BT_BREDR

        <M>     RFCOMM protocol support
        Symbol: BT_RFCOMM

        <M>     BNEP protocol support
        Symbol: BT_BNEP

        <M>     HIDP protocol support
        Symbol: BT_HIDP

        [*]   Enable Microsoft extensions
        Symbol: BT_MSFTEXT

        [*]   Enable Android Open Source Project extensions
        Symbol: BT_AOSPEXT

        Bluetooth device drivers  --->

            <M> HCI USB driver
            Symbol: BT_HCIBTUSB

            Enable all HCI USB driver options.
```

### Generic Drivers

```
Device Drivers  --->

    [*] PCI support  --->
    Symbol: PCI

        <*>   PCI Stub driver
        Symbol: PCI_STUB

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

        Firmware loader  --->

            [*]   Enable compressed firmware support
            Symbol: FW_LOADER_COMPRESS

            [*]     Enable XZ-compressed firmware support
            Symbol: FW_LOADER_COMPRESS_XZ

            [*]     Enable ZSTD-compressed firmware support
            Symbol: FW_LOADER_COMPRESS_ZSTD

    [*] Block devices  --->
    Symbol: BLK_DEV

        <*>   Compressed RAM block device support
        Symbol: ZRAM

        [*]     lz4 compression support
        Symbol: ZRAM_BACKEND_LZ4

        [*]     lz4hc compression support
        Symbol: ZRAM_BACKEND_LZ4HC

        [*]     zstd compression support
        Symbol: ZRAM_BACKEND_ZSTD

        [*]     deflate compression support
        Symbol: ZRAM_BACKEND_DEFLATE

        [*]     lzo and lzo-rle compression support
        Symbol: ZRAM_BACKEND_LZO

        <*>   Loopback device support
        Symbol: BLK_DEV_LOOP

        (0)     Number of loop devices to pre-create at init time
        Symbol: BLK_DEV_LOOP_MIN_COUNT [=0]

    NVME Support  --->

        <*> NVM Express block device
        Symbol: BLK_DEV_NVME

        [*] NVMe multipath support
        Symbol: NVME_MULTIPATH

        [*] NVMe hardware monitoring
        Symbol: NVME_HWMON

    SCSI device support  --->

        <*> SCSI disk support
        Symbol: BLK_DEV_SD

        <M> SCSI CDROM support
        Symbol: BLK_DEV_SR

        <M> SCSI generic support
        Symbol: BLK_DEV_SG

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

        <*>   USB Network Adapters  --->
        Symbol: USB_NET_DRIVERS

            Disable everything.

        [*]   Wireless LAN  --->
        Symbol: WLAN

            Disable everything.

        [*]   Wan interfaces support  --->
        Symbol: WAN

            Disable everything.

    Input device support  --->

        -*- Generic input layer (needed for keyboard, mouse, ...)
        Symbol: INPUT

        [*]   Miscellaneous devices  --->
        Symbol: INPUT_MISC

            <*>   User level driver support
            Symbol: INPUT_UINPUT

    [*] USB support  --->
    Symbol: USB_SUPPORT

        <*>   USB Mass Storage support
        Symbol: USB_STORAGE

        <*>     USB Attached SCSI
        Symbol: USB_UAS

        <*>   USB Type-C Support  --->
        Symbol: TYPEC

            <*>   USB Type-C Connector System Software Interface driver
            Symbol: TYPEC_UCSI

            <*>     UCSI ACPI Interface Driver
            Symbol: UCSI_ACPI

    {*} Userspace I/O drivers  --->
    Symbol: UIO
```

### Hardware Drivers

```
Memory Management options  --->

    [*] Enable recovery from hardware memory errors
    Symbol: MEMORY_FAILURE

Device Drivers  --->

    SCSI device support  --->

        [*] SCSI low-level drivers  --->
        Symbol: SCSI_LOWLEVEL

            <M>   Chelsio T3 iSCSI support
            Symbol: SCSI_CXGB3_ISCSI

            <M>   Chelsio T4 iSCSI support
            Symbol: SCSI_CXGB4_ISCSI

            <M>   QLogic NetXtreme II iSCSI support
            Symbol: SCSI_BNX2_ISCSI

            <M>   Emulex 10Gbps iSCSI - BladeEngine 2
            Symbol: BE2ISCSI

    SCSI device support  --->

        [*] SCSI low-level drivers  --->
        Symbol: SCSI_LOWLEVEL

            <*>   QLogic ISP4XXX and ISP82XX host adapter family support
            Symbol: SCSI_QLA_ISCSI

    [*] Network device support
    Symbol: NETDEVICES

        -*-   Ethernet driver support  --->
        Symbol: ETHERNET

            [*]   Chelsio devices
            Symbol: NET_VENDOR_CHELSIO

            <M>     Chelsio Communications T3 10Gb Ethernet support
            Symbol: CHELSIO_T3

            <M>     Chelsio Communications T4/T5/T6 Ethernet support
            Symbol: CHELSIO_T4

        <M>   USB Network Adapters  --->
        Symbol: USB_NET_DRIVERS

            <M>   Multi-purpose USB Networking Framework
            Symbol: USB_USBNET

            Disable all "USB Network Adapters" entries.

            <M>     CDC Ethernet support (smart devices such as cable modems)
            Symbol: USB_NET_CDCETHER

        [*]   Wireless LAN  --->
        Symbol: WLAN

            [*]   Atheros/Qualcomm devices
            Symbol: WLAN_VENDOR_ATH

            <M>     Qualcomm Technologies 802.11ax chipset support
            Symbol: ATH11K

            <M>       Atheros ath11k PCI support
            Symbol: ATH11K_PCI

        Wireless WAN  --->

            <M> WWAN Driver Core
            Symbol: WWAN

            <M>   MediaTek PCIe 5G WWAN modem T7xx device
            Symbol: MTK_T7XX

    Input device support  --->

        -*- Generic input layer (needed for keyboard, mouse, ...)
        Symbol: INPUT

        <*>   Joystick interface
        Symbol: INPUT_JOYDEV

        Hardware I/O ports  --->

            <*> Raw access to serio ports
            Symbol: SERIO_RAW

    I2C support  --->

        -*- I2C support
        Symbol: I2C

        I2C Hardware Bus support  --->

            <*> Intel PIIX4 and compatible (ATI/AMD/Serverworks/Broadcom/SMSC)
            Symbol: I2C_PIIX4

    -*- Hardware Monitoring support  --->
    Symbol: HWMON

        <*>   AMD Family 10h+ temperature sensor
        Symbol: SENSORS_K10TEMP

    [*] Watchdog Timer Support  --->
    Symbol: WATCHDOG

        <*>   AMD/ATI SP5100 TCO Timer/Watchdog
        Symbol: SP5100_TCO

    <M> Multimedia support  --->
    Symbol: MEDIA_SUPPORT

        Media core support  --->

            <M> Video4Linux core
            Symbol: VIDEO_DEV

        Media drivers  --->

            [*] Media USB Adapters  --->
            Symbol: MEDIA_USB_SUPPORT

                <M>   USB Video Class (UVC)
                Symbol: USB_VIDEO_CLASS

    Graphics support  --->

        <*> Direct Rendering Manager (XFree86 4.1.0 and higher DRI support)  --->
        Symbol: DRM

            <*>   AMD GPU
            Symbol: DRM_AMDGPU

    <*> Sound card support  --->
    Symbol: SOUND

        <*>   Advanced Linux Sound Architecture  --->
        Symbol: SND

            HD-Audio  --->

                <*> HD Audio PCI
                Symbol: SND_HDA_INTEL

                <*> Build Realtek HD-audio codec support
                Symbol: SND_HDA_CODEC_REALTEK

                <*> Build HDMI/DisplayPort HD-audio codec support
                Symbol: SND_HDA_CODEC_HDMI

                <*> Enable generic HD-audio codec parser
                Symbol: SND_HDA_GENERIC

                Build HDMI/DisplayPort HD-audio codec support

            [*]   USB sound devices  --->
            Symbol: SND_USB

                <*>   USB Audio/MIDI driver
                Symbol: SND_USB_AUDIO

                <*>   Edirol UA-101/UA-1000 driver
                Symbol: SND_USB_UA101

            <*>   ALSA for SoC audio support  --->
            Symbol: SND_SOC

                <*>   AMD Audio Coprocessor-v3.x support
                Symbol: SND_SOC_AMD_ACP3x

                <*>   AMD Audio Coprocessor - Renoir support
                Symbol: SND_SOC_AMD_RENOIR

                <*>   AMD Audio Coprocessor-v5.x I2S support
                Symbol: SND_SOC_AMD_ACP5x

                <*>   AMD Audio Coprocessor-v6.x Yellow Carp support
                Symbol: SND_SOC_AMD_ACP6x

                <*>     AMD YC support for DMIC
                Symbol: SND_SOC_AMD_YC_MACH

                <*>   AMD Audio Coprocessor-v6.2 RPL support
                Symbol: SND_SOC_AMD_RPL_ACP6x

                <*>   support for AMD platforms with ACP version >= 6.3
                Symbol: SND_SOC_AMD_ACP63_TOPLEVEL

                <*>     AMD Audio Coprocessor-v6.3 Pink Sardine support
                Symbol: SND_SOC_AMD_PS

                <*>       AMD PINK SARDINE support for DMIC
                Symbol: SND_SOC_AMD_PS_MACH

                [ ]   Intel ASoC SST drivers
                Symbol: SND_SOC_INTEL_SST_TOPLEVEL

                [*]   Sound Open Firmware Support  --->
                Symbol: SND_SOC_SOF_TOPLEVEL

                    <*>   SOF PCI enumeration support
                    Symbol: SND_SOC_SOF_PCI

                    <*>   SOF support for AMD audio DSPs
                    Symbol: SND_SOC_SOF_AMD_TOPLEVEL

                    <*>     SOF support for RENOIR
                    Symbol: SND_SOC_SOF_AMD_RENOIR

                    <*>     SOF support for REMBRANDT
                    Symbol: SND_SOC_SOF_AMD_REMBRANDT

                CODEC drivers  --->

                    <*> Build generic ASoC AC97 CODEC driver
                    Symbol: SND_SOC_AC97_CODEC

    [*] HID bus support  --->
    Symbol: HID_SUPPORT

        -*-   HID bus core support
        Symbol: HID

        Special HID drivers  --->

            <*> HID Multitouch panels
            Symbol: HID_MULTITOUCH

        <*>   I2C HID support  --->
        Symbol: I2C_HID

            <*>   HID over I2C transport layer ACPI driver
            Symbol: I2C_HID_ACPI

    <*> EDAC (Error Detection And Correction) reporting  --->
    Symbol: EDAC

        <*>   Decode MCEs in human-readable form (only on AMD for now)
        Symbol: EDAC_DECODE_MCE

    [ ] Microsoft Surface Platform-Specific Device Drivers  ----
    Symbol: SURFACE_PLATFORMS

    -*- X86 Platform Specific Device Drivers  --->
    Symbol: X86_PLATFORM_DEVICES

        <*>   ThinkPad ACPI Laptop Extras
        Symbol: THINKPAD_ACPI

        <*>   Lenovo WMI-based systems management driver
        Symbol: THINKPAD_LMI

        Search for "FW_ATTR_CLASS" and make sure it's also enabled.

    [*] Generic powercap sysfs driver  --->
    Symbol: POWERCAP

        <*>   Intel RAPL Support via MSR Interface
        Symbol: INTEL_RAPL

    [*] Reliability, Availability and Serviceability (RAS) features  --->
    Symbol: RAS

        [*]   Correctable Errors Collector
        Symbol: RAS_CEC

        <*>   AMD Address Translation Library
        Symbol: AMD_ATL

    <*> Unified support for USB4 and Thunderbolt  --->
    Symbol: USB4

Library routines  --->

    <*> CRC calculation for the T10 Data Integrity Field
    Symbol: CRC_T10DIF

-*- Cryptographic API  --->
Symbol: CRYPTO

    Accelerated Cryptographic Algorithms for CPU (x86)  --->

        Enable everything.

    [*]   Hardware crypto devices  --->
    Symbol: CRYPTO_HW

        [*]   Support for AMD Secure Processor
        Symbol: CRYPTO_DEV_CCP

        <*>     Secure Processor device driver
        Symbol: CRYPTO_DEV_CCP_DD

[*] Mitigations for CPU vulnerabilities  --->
Symbol: CPU_MITIGATIONS

    Decide on options based on internet connectivity requirements.
```

```sh
time make -j17
```
