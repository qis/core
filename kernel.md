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
Config: CONFIG_USB
Driver: hub

Generic Bluetooth USB
Config: BT_HCIBTUSB
Driver: btusb

USB Mass Storage Support
Config: USB_STORAGE
Driver: usb-storage

USB Webcam Function
Config: CONFIG_USB_VIDEO_CLASS
Driver: uvcvideo

USB HID Transport Layer
Config: USB_HID
Driver: usbhid

USB Audio/MIDI Driver
Config: SND_USB_AUDIO
Driver: snd-usb-audio

CDC Ethernet Support
Config: CONFIG_USB_NET_CDCETHER
Driver: cdc_ether
```

PCI devices require the following drivers.

```
PCIe Port
Config: CONFIG_PCIEPORTBUS
Driver: pcieport

SMBus: Advanced Micro Devices, Inc. [AMD] FCH SMBus Controller
Config: CONFIG_I2C_PIIX4
Driver: piix4_smbus

Host bridge: Advanced Micro Devices, Inc. [AMD] Rembrandt Data Fabric: Device 18h
Config: CONFIG_SENSORS_K10TEMP
Driver: k10temp

Network controller: Qualcomm Technologies, Inc QCNFA765 Wireless Network Adapter
Config: CONFIG_ATH11K_PCI
Driver: ath11k_pci

Wireless controller [0d40]: MEDIATEK Corp. Device 4d75
Config: CONFIG_MTK_T7XX
Driver: mtk_t7xx

Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe SSD Controller PM9A1/PM9A3/980PRO
Config: CONFIG_NVMEM, CONFIG_BLK_DEV_NVME
Driver: nvme

VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Rembrandt [Radeon 680M]
Config:
Driver: amdgpu

Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Rembrandt Radeon High Definition Audio Controller
Audio device: Advanced Micro Devices, Inc. [AMD] Family 17h/19h HD Audio Controller
Config: CONFIG_SND_HDA_INTEL
Driver: snd_hda_intel

Encryption controller: Advanced Micro Devices, Inc. [AMD] VanGogh PSP/CCP
Config: CONFIG_CRYPTO_DEV_CCP_CRYPTO
Driver: ccp

USB controller: Advanced Micro Devices, Inc. [AMD] Rembrandt USB4 XHCI controller
Config: CONFIG_USB_XHCI_HCD
Driver: xhci_hcd

Multimedia controller: Advanced Micro Devices, Inc. [AMD] ACP/ACP3X/ACP6x Audio Coprocessor
Config: CONFIG_SND_SOC_AMD_ACP6x
Driver: snd_pci_acp6x

USB controller: Advanced Micro Devices, Inc. [AMD] Rembrandt USB4/Thunderbolt NHI controller
Config: CONFIG_USB4
Driver: thunderbolt
```

Modules loaded during operation.

```
Advanced Linux Sound Architecture
Config: CONFIG_AC97_BUS or CONFIG_AC97_BUS_NEW?
Module: ac97_bus

ACPI Processor P-States driver
Config: CONFIG_X86_ACPI_CPUFREQ
Module: acpi_cpufreq

ACPI Time and Alarm (TAD) Device Support
Config: CONFIG_ACPI_TAD
Module: acpi_tad

AMD SoC PMC driver
Config: CONFIG_AMD_PMC
Module: amd_pmc

AMD GPU
Config: CONFIG_DRM_AMDGPU
Module: amdgpu

Qualcomm Technologies 802.11ax chipset support
Config: CONFIG_ATH11K
Module: ath11k

Atheros ath11k PCI support
Config: CONFIG_ATH11K_PCI
Module: ath11k_pci

Emulex 10Gbps iSCSI - BladeEngine 2
Config: CONFIG_BE2ISCSI
Module: be2iscsi

Kernel support for MISC binaries
Config: CONFIG_BINFMT_MISC
Module: binfmt_misc

Bluetooth subsystem support
Config: CONFIG_BT
Module: bluetooth

BNEP protocol support
Config: CONFIG_BT_BNEP
Module: bnep

QLogic NetXtreme II iSCSI support
Config: CONFIG_SCSI_BNX2_ISCSI
Module: bnx2i

Bluetooth device drivers: BCM (not configurable)
Config: CONFIG_BT_BCM
Module: btbcm

Bluetooth device drivers: INTEL (not configurable)
Config: CONFIG_BT_INTEL
Module: btintel

Bluetooth device drivers: MTK (not configurable)
Config: CONFIG_BT_MTK
Module: btmtk

Bluetooth device drivers: RTL (not configurable)
Config: CONFIG_BT_RTL
Module: btrtl

HCI USB driver
Config: CONFIG_BT_HCIBTUSB
Module: btusb

Secure Processor device driver
Config: CONFIG_CRYPTO_DEV_CCP_DD
Module: ccp

CDC Ethernet support (smart devices such as cable modems)
Config: CONFIG_USB_NET_CDCETHER
Module: cdc_ether

Correctable Errors Collector
Config: CONFIG_RAS_CEC
Module: cec

cfg80211 - wireless configuration API
Config: CONFIG_CFG80211
Module: cfg80211

QLogic CNIC support
Config: CONFIG_CNIC
Module: cnic

CRC32 (PCLMULQDQ)
Config: CONFIG_CRYPTO_CRC32_PCLMUL
Module: crc32_pclmul

CRC32c (SSE4.2/PCLMULQDQ)
Config: CONFIG_CRYPTO_CRC32C_INTEL
Module: crc32c_intel

CRCT10DIF (PCLMULQDQ)
Config: CONFIG_CRYPTO_CRCT10DIF_PCLMUL
Module: crct10dif_pclmul

Chelsio Communications T3 10Gb Ethernet support
Config: CONFIG_CHELSIO_T3
Module: cxgb3

Chelsio T3 iSCSI support
Config: CONFIG_SCSI_CXGB3_ISCSI
Module: cxgb3i

Chelsio Communications T4/T5/T6 Ethernet support
Config: CONFIG_CHELSIO_T4
Module: cxgb4

Chelsio T4 iSCSI support
Config: CONFIG_SCSI_CXGB4_ISCSI
Module: cxgb4i

Direct Rendering Manager (XFree86 4.1.0 and higher DRI support)
Config: CONFIG_DRM_BUDDY, CONFIG_DRM_DISPLAY_HELPER, CONFIG_DRM_TTM_HELPER, CONFIG_DRM_SCHED, CONFIG_DRM_TTM
Module: drm_buddy, drm_display_helper, drm_ttm_helper, gpu_sched, ttm

Decode MCEs in human-readable form (only on AMD for now)
Config: CONFIG_EDAC_DECODE_MCE
Module: edac_mce_amd

X86 Platform Specific Device Drivers
Config: CONFIG_FW_ATTR_CLASS
Module: firmware_attributes_class

FUSE (Filesystem in Userspace) support
Config: CONFIG_FUSE_FS
Module: fuse

Hash functions: GHASH (CLMUL-NI)
Config: CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL
Module: ghash_clmulni_intel

HID Multitouch panels
Config: CONFIG_HID_MULTITOUCH
Module: hid_multitouch

I2C HID support
Config: CONFIG_I2C_HID_CORE, CONFIG_I2C_HID_ACPI, CONFIG_I2C_PIIX4
Module: i2c_hid, i2c_hid_acpi, i2c_piix4

Generic powercap sysfs driver
Config: CONFIG_INTEL_RAPL_CORE
Module: intel_rapl_common

Intel RAPL Support via MSR Interface
Config: CONFIG_INTEL_RAPL
Module: intel_rapl_msr

AMD IOMMU Version 2 driver
Config: CONFIG_AMD_IOMMU_V2
Module: iommu_v2

IP6 tables support (required for filtering)
Config: CONFIG_IP6_NF_IPTABLES
Module: ip6_tables

IP set support
Config: CONFIG_IP_SET
Module: ip_set

IP tables support (required for filtering/masq/NAT)
Config: CONFIG_IP_NF_IPTABLES
Module: ip_tables

Device Drivers: IRQ BYPASS MANAGER
Config: CONFIG_IRQ_BYPASS_MANAGER (not configurable)
Module: irqbypass

iSCSI Boot Sysfs Interface
Config: CONFIG_ISCSI_BOOT_SYSFS
Module: iscsi_boot_sysfs

iSCSI Initiator over TCP/IP
Config: CONFIG_ISCSI_TCP
Module: iscsi_tcp

ISO 9660 CDROM file system support
Config: CONFIG_ISO9660_FS
Module: isofs

Joystick interface
Config: CONFIG_INPUT_JOYDEV
Module: joydev

AMD Family 10h+ temperature sensor
Config: CONFIG_SENSORS_K10TEMP
Module: k10temp

KVM Guest support (required by kvm_amd)
Config: CONFIG_KVM_GUEST
Module: kvm

KVM for AMD processors support
Config: CONFIG_KVM_AMD
Module: kvm_amd

Audio Mute LED Trigger
Config: CONFIG_LEDS_TRIGGER_AUDIO
Module: ledtrig_audio

Crypto library routines: ARC4
Config: CONFIG_CRYPTO_LIB_ARC4
Module: libarc4

Ethernet driver support: CHELSIO_LIB
Config: CONFIG_CHELSIO_LIB
Module: libcxgb

Chelsio T4 iSCSI support
Config: CONFIG_SCSI_CXGB4_ISCSI
Module: libcxgbi

Emulex 10Gbps iSCSI - BladeEngine 2
Config: CONFIG_BE2ISCSI
Module: libiscsi

iSCSI Initiator over TCP/IP
Config: CONFIG_ISCSI_TCP
Module: libiscsi_tcp

Loopback device support
Config: CONFIG_BLK_DEV_LOOP
Module: loop

Generic IEEE 802.11 Networking Stack (mac80211)
Config: CONFIG_MAC80211
Module: mac80211

Media Controller
Config: (will be requested by audio/video drivers)
Module: mc

Ethernet driver support: MDIO
Config: CONFIG_MDIO
Module: mdio

Modem Host Interface (MHI) bus
Config: CONFIG_MHI_BUS
Module: mhi

Network device support: MII
Config: CONFIG_MII
Module: mii

MediaTek PCIe 5G WWAN modem T7xx device
Config: CONFIG_MTK_T7XX
Module: mtk_t7xx

Netfilter connection tracking support
Config: CONFIG_NF_CONNTRACK
Module: nf_conntrack

Core Netfilter Configuration: Broadcast
Config: CONFIG_NF_CONNTRACK_BROADCAST (not configurable)
Module: nf_conntrack_broadcast

NetBIOS name service protocol support
Config: CONFIG_NF_CONNTRACK_NETBIOS_NS
Module: nf_conntrack_netbios_ns

IP: Netfilter Configuration
Config: CONFIG_NF_DEFRAG_IPV4
Module: nf_defrag_ipv4

Network packet filtering framework (Netfilter)
Config: CONFIG_NF_DEFRAG_IPV6
Module: nf_defrag_ipv6

Network Address Translation support
Config: CONFIG_NF_NAT
Module: nf_nat

IPv4 packet rejection
Config: CONFIG_NF_REJECT_IPV4
Module: nf_reject_ipv4

IPv6 packet rejection
Config: CONFIG_NF_REJECT_IPV6
Module: nf_reject_ipv6

Netfilter nf_tables support
Config: CONFIG_NF_TABLES
Module: nf_tables

Core Netfilter Configuration: Netlink
Config: CONFIG_NETFILTER_NETLINK
Module: nfnetlink

Netfilter nf_tables nat module
Config: Netfilter nf_tables nat module
Module: nft_chain_nat

Netfilter nf_tables conntrack module
Config: CONFIG_NFT_CT
Module: nft_ct

Core Netfilter Configuration: FIB
Config: CONFIG_NFT_FIB
Module: nft_fib

Netfilter nf_tables fib inet support
Config: CONFIG_NFT_FIB_INET
Module: nft_fib_inet

nf_tables fib / ip route lookup support
Config: CONFIG_NFT_FIB_IPV4
Module: nft_fib_ipv4

nf_tables fib / ipv6 route lookup support
Config: CONFIG_NFT_FIB_IPV6
Module: nft_fib_ipv6

Netfilter nf_tables reject support
Config: CONFIG_NFT_REJECT
Module: nft_reject

Core Netfilter Configuration: Reject
Config: CONFIG_NFT_REJECT_INET
Module: nft_reject_inet

NVM Express block device
Config: CONFIG_BLK_DEV_NVME
Module: nvme

NVME Support
Config: CONFIG_NVME_COMMON, CONFIG_NVME_CORE
Module: nvme_common, nvme_core

PC Speaker support (DISABLE)
Config: CONFIG_INPUT_PCSPKR (NO)
Module: pcspkr

ACPI (Advanced Configuration and Power Interface) Support
Config: CONFIG_ACPI_PLATFORM_PROFILE
Module: platform_profile

Hash functions: POLYVAL (CLMUL-NI)
Config: CONFIG_CRYPTO_POLYVAL_CLMUL_NI
Module: polyval_clmulni

Hashes, digests, and MACs
Config: CONFIG_CRYPTO_POLYVAL
Module: polyval_generic

QLogic ISP4XXX and ISP82XX host adapter family support
Config: CONFIG_SCSI_QLA_ISCSI
Module: qla4xxx

Qualcomm SoC drivers: QMI Helpers
Config: CONFIG_QCOM_QMI_HELPERS
Module: qmi_helpers

Qualcomm IPC Router support
Config: CONFIG_QRTR
Module: qrtr

MHI IPC Router channels
Config: CONFIG_QRTR_MHI
Module: qrtr_mhi

Intel/AMD rapl performance events
Config: CONFIG_PERF_EVENTS_INTEL_RAPL
Module: rapl

RFCOMM protocol support
Config: CONFIG_BT_RFCOMM
Module: rfcomm

RF switch subsystem support
Config: CONFIG_RFKILL
Module: rfkill

iSCSI Transport Attributes
Config: CONFIG_SCSI_ISCSI_ATTRS
Module: scsi_transport_iscsi

Raw access to serio ports
Config: CONFIG_SERIO_RAW
Module: serio_raw

Hash functions: SHA-384 and SHA-512 (SSSE3/AVX/AVX2)
Config: CONFIG_CRYPTO_SHA512_SSSE3
Module: sha512_ssse3

Advanced Linux Sound Architecture
Config: CONFIG_SND
Module: snd

AMD Audio Coprocessor-v6.x Yellow Carp support
Config: CONFIG_SND_SOC_AMD_ACP6x
Module: snd_acp6x_pdm_dma

AMD ACP configuration selection
Config: CONFIG_SND_AMD_ACP_CONFIG
Module: snd_acp_config

Advanced Linux Sound Architecture: OFFLOAD
Config: CONFIG_SND_COMPRESS_OFFLOAD
Module: snd_compress

Advanced Linux Sound Architecture: LED
Config: CONFIG_SND_CTL_LED
Module: snd_ctl_led

HD-Audio
Config: CONFIG_SND_HDA
Module: snd_hda_codec

Enable generic HD-audio codec parser
Config: CONFIG_SND_HDA_GENERIC
Module: snd_hda_codec_generic

Build HDMI/DisplayPort HD-audio codec support
Config: CONFIG_SND_HDA_CODEC_HDMI
Module: snd_hda_codec_hdmi

Build Realtek HD-audio codec support
Config: CONFIG_SND_HDA_CODEC_REALTEK
Module: snd_hda_codec_realtek

Advanced Linux Sound Architecture: Core
Config: CONFIG_SND_HDA_CORE
Module: snd_hda_core

HD Audio PCI
Config: CONFIG_SND_HDA_INTEL
Module: snd_hda_intel

HR-timer backend support
Config: CONFIG_SND_HRTIMER
Module: snd_hrtimer

Advanced Linux Sound Architecture: HWDEP
Config: CONFIG_SND_HWDEP
Module: snd_hwdep

Advanced Linux Sound Architecture: Intel DSP Config
Config: CONFIG_SND_INTEL_DSP_CONFIG
Module: snd_intel_dspcfg

Advanced Linux Sound Architecture: Intel SDW ACPI
Config: CONFIG_SND_INTEL_SOUNDWIRE_ACPI
Module: snd_intel_sdw_acpi

AMD Audio Coprocessor-v3.x support
Config: CONFIG_SND_SOC_AMD_ACP3x
Module: snd_pci_acp3x

AMD Audio Coprocessor-v5.x I2S support
Config: CONFIG_SND_SOC_AMD_ACP5x
Module: snd_pci_acp5x

AMD Audio Coprocessor-v6.x Yellow Carp support
Config: CONFIG_SND_SOC_AMD_ACP6x
Module: snd_pci_acp6x

AMD Audio Coprocessor-v6.3 Pink Sardine support
Config: CONFIG_SND_SOC_AMD_PS
Module: snd_pci_ps

Advanced Linux Sound Architecture: PCM
Config: CONFIG_SND_PCM
Module: snd_pcm

Advanced Linux Sound Architecture: PCM DMA Engine
Config: CONFIG_SND_DMAENGINE_PCM
Module: snd_pcm_dmaengine

Advanced Linux Sound Architecture: RAW MIDI
Config: CONFIG_SND_RAWMIDI
Module: snd_rawmidi

AMD Audio Coprocessor - Renoir support
Config: CONFIG_SND_SOC_AMD_RENOIR
Module: snd_rn_pci_acp3x

AMD Audio Coprocessor-v6.2 RPL support
Config: CONFIG_SND_SOC_AMD_RPL_ACP6x
Module: snd_rpl_pci_acp6x

Advanced Linux Sound Architecture: Sequencer support
Config: CONFIG_SND_SEQUENCER
Module: snd_seq

Advanced Linux Sound Architecture: SEQ Device
Config: CONFIG_SND_SEQ_DEVICE
Module: snd_seq_device

Advanced Linux Sound Architecture: Sequencer dummy client
Config: CONFIG_SND_SEQ_DUMMY
Module: snd_seq_dummy

AMD YC support for DMIC
Config: CONFIG_SND_SOC_AMD_YC_MACH
Module: snd_soc_acp6x_mach

ALSA for SoC audio support: ACPI
Config: CONFIG_SND_SOC_ACPI
Module: snd_soc_acpi

ALSA for SoC audio support
Config: CONFIG_SND_SOC
Module: snd_soc_core

Generic Digital Microphone CODEC
Config: CONFIG_SND_SOC_DMIC
Module: snd_soc_dmic

Sound Open Firmware Support
Config: CONFIG_SND_SOC_SOF
Module: snd_sof

Sound Open Firmware Support: AMD
Config: CONFIG_SND_SOC_SOF_AMD_COMMON
Module: snd_sof_amd_acp

Sound Open Firmware Support: SOF support for REMBRANDT
Config: CONFIG_SND_SOC_SOF_AMD_REMBRANDT
Module: snd_sof_amd_rembrandt

Sound Open Firmware Support: SOF support for RENOIR
Config: CONFIG_SND_SOC_SOF_AMD_RENOIR
Module: snd_sof_amd_renoir

Sound Open Firmware Support: PCI
Config: CONFIG_SND_SOC_SOF_PCI_DEV
Module: snd_sof_pci

Sound Open Firmware Support: SOC
Config: CONFIG_SND_SOC_SOF
Module: snd_sof_utils

Sound Open Firmware Support: XTENSA
Config: CONFIG_SND_SOC_SOF_XTENSA
Module: snd_sof_xtensa_dsp

Advanced Linux Sound Architecture: Timer
Config: CONFIG_SND_TIMER
Module: snd_timer

USB Audio/MIDI driver
Config: CONFIG_SND_USB_AUDIO
Module: snd_usb_audio

Edirol UA-101/UA-1000 driver
Config: CONFIG_SND_USB_UA101
Module: snd_usbmidi_lib

Sound card support
Config: CONFIG_SOUND
Module: soundcore

AMD/ATI SP5100 TCO Timer/Watchdog
Config: CONFIG_SP5100_TCO
Module: sp5100_tco

SquashFS 4.0 - Squashed file system support
Config: CONFIG_SQUASHFS
Module: squashfs

Network File Systems: SUN RPC
Config: CONFIG_SUNRPC
Module: sunrpc

Lenovo WMI-based systems management driver
Config: CONFIG_THINKPAD_LMI
Module: think_lmi

ThinkPad ACPI Laptop Extras
Config: CONFIG_THINKPAD_ACPI
Module: thinkpad_acpi

Unified support for USB4 and Thunderbolt
Config: CONFIG_USB4
Module: thunderbolt

Transport Layer Security support
Config: CONFIG_TLS
Module: tls

USB Type-C Support
Config: CONFIG_TYPEC
Module: typec

USB Type-C Connector System Software Interface driver
Config: CONFIG_TYPEC_UCSI
Module: typec_ucsi

USB Attached SCSI
Config: CONFIG_USB_UAS
Module: uas

UCSI ACPI Interface Driver
Config: CONFIG_UCSI_ACPI
Module: ucsi_acpi

User level driver support
Config: CONFIG_INPUT_UINPUT
Module: uinput

Userspace I/O drivers
Config: CONFIG_UIO
Module: uio

USB Mass Storage support
Config: CONFIG_USB_STORAGE
Module: usb_storage

Multi-purpose USB Networking Framework
Config: CONFIG_USB_USBNET
Module: usbnet

USB Video Class (UVC)
Config: CONFIG_USB_VIDEO_CLASS
Module: uvcvideo

ACPI (Advanced Configuration and Power Interface) Support: Video
Config: CONFIG_ACPI_VIDEO
Module: video

Media drivers: VIDEOBUF2
Config: CONFIG_VIDEOBUF2_CORE
Module: videobuf2_common

Media drivers: VIDEOBUF2: MEMOPS
Config: CONFIG_VIDEOBUF2_MEMOPS
Module: videobuf2_memops

Media drivers: VIDEOBUF2: V4L2
Config: CONFIG_VIDEOBUF2_V4L2
Module: videobuf2_v4l2

Media drivers: VIDEOBUF2: VMALLOC
Config: CONFIG_VIDEOBUF2_VMALLOC
Module: videobuf2_vmalloc

Video4Linux core
Config: CONFIG_VIDEO_DEV
Module: videodev

WMI
Config: CONFIG_ACPI_WMI
Module: wmi

WMI embedded Binary MOF driver
Config: CONFIG_WMI_BMOF
Module: wmi_bmof

Compressed RAM block device support
Config: CONFIG_ZRAM
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
    Symbol: GENTOO_LINUX [=y]

    Support for init systems, system and service managers  --->

        [ ] OpenRC, runit and other script based systems and managers
        Symbol: GENTOO_LINUX_INIT_SCRIPT [=n]

        [*] systemd
        Symbol: GENTOO_LINUX_INIT_SYSTEMD [=y]
```

Enable loadable modules support.

```
[*] Enable loadable module support  --->
Symbol: MODULES [=y]

    [*]   Module unloading
    Symbol: MODULE_UNLOAD [=y]
```

Enable filesystems support.

```
File systems  --->

    [*] Validate filesystem parameter description
    Symbol: VALIDATE_FS_PARSER [=y]

    [*] Enable filesystem export operations for block IO
    Symbol: EXPORTFS_BLOCK_OPS [=y]

    <*> FUSE (Filesystem in Userspace) support
    Symbol: FUSE_FS [=y]

    <*>   Character device in Userspace support
    Symbol: CUSE [=y]

    CD-ROM/DVD Filesystems  --->

        <M> ISO 9660 CDROM file system support
        Symbol: ISO9660_FS [=m]

        [*]   Microsoft Joliet CDROM extensions
        Symbol: JOLIET [=y]

        [*]   Transparent decompression extension
        Symbol: ZISOFS [=y]

        <M> UDF file system support
        Symbol: UDF_FS [=m]

    DOS/FAT/EXFAT/NT Filesystems  --->

        <*> MSDOS fs support
        Symbol: MSDOS_FS [=y]

        <*> VFAT (Windows-95) fs support
        Symbol: VFAT_FS [=y]

        (ascii) Default iocharset for FAT
        Symbol: FAT_DEFAULT_IOCHARSET [=ascii]

        <*> exFAT filesystem support
        Symbol: EXFAT_FS [=y]

        <M> NTFS file system support
        Symbol: NTFS_FS [=m]

    Pseudo filesystems  --->

        [*]   Include /proc/<pid>/task/<tid>/children file
        Symbol: PROC_CHILDREN [=y]

        <*> Userspace-driven configuration filesystem
        Symbol: CONFIGFS_FS [=y]

    -*- Native language support  --->

        (utf8) Default NLS Option
        Symbol: NLS_DEFAULT [=utf8]

        <M> [everything else]

    <M> Distributed Lock Manager (DLM)  --->
    Symbol: DLM [=m]

    <*> UTF-8 normalization and casefolding support
    Symbol: UNICODE [=y]
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
    Symbol: WATCH_QUEUE [=y]

    [*] Enable process_vm_readv/writev syscalls
    Symbol: CROSS_MEMORY_ATTACH [=y]

    Timers subsystem  --->

        Timer tick handling (Idle dynticks system (tickless idle))  --->
        Symbol: NO_HZ_IDLE [=y]

        [*] High Resolution Timer Support
        Symbol: HIGH_RES_TIMERS [=y]

    BPF subsystem  --->

        [*] Enable BPF Just In Time compiler
        Symbol: BPF_JIT [=y]

        [*]   Permanently enable BPF JIT and remove BPF interpreter
        Symbol: BPF_JIT_ALWAYS_ON [=y]

        [*] Preload BPF file system with kernel specific program and map iterators  --->
        Symbol: BPF_PRELOAD [=y]

    Preemption Model (Voluntary Kernel Preemption (Desktop))  --->
    Symbol: PREEMPT_VOLUNTARY [=y]

    [*] Preemption behaviour defined on boot
    Symbol: BPF_PRELOAD_UMD [=y]

    CPU/Task time and stats accounting  --->

        Cputime accounting (Full dynticks CPU time accounting)  --->
        Symbol: VIRT_CPU_ACCOUNTING_GEN [=y]

        [*] Fine granularity task level IRQ time accounting
        Symbol: IRQ_TIME_ACCOUNTING [=y]

        [*] Pressure stall information tracking
        Symbol: PSI [=y]

    <M> Kernel .config support
    Symbol: IKCONFIG [=m]

    [*]   Enable access to .config through /proc/config.gz
    Symbol: IKCONFIG_PROC [=y]

    -*- Control Group support  --->
    Symbol: CGROUPS [=y]

        [*]   Memory controller
        Symbol: MEMCG [=y]

        [*]   IO controller
        Symbol: BLK_CGROUP [=y]

        [*]   CPU controller  --->
        Symbol: CGROUP_SCHED [=y]

            [*]     CPU bandwidth provisioning for FAIR_GROUP_SCHED
            Symbol: CFS_BANDWIDTH [=y]

        [*]   PIDs controller
        Symbol: CGROUP_PIDS [=y]

        [*]   Freezer controller
        Symbol: CGROUP_FREEZER [=y]

        [*]   Device controller
        Symbol: CGROUP_DEVICE [=y]

        [*]   Simple CPU accounting controller
        Symbol: CGROUP_CPUACCT [=y]

        [*]   Perf controller
        Symbol: CGROUP_PERF [=y]

        [*]   Misc resource controller
        Symbol: CGROUP_MISC [=y]

    [*] Automatic process group scheduling
    Symbol: SCHED_AUTOGROUP [=y]

    [*] Kernel->user space relay support (formerly relayfs)
    Symbol: RELAY [=y]

    [*] Initial RAM filesystem and RAM disk (initramfs/initrd) support
    Symbol: BLK_DEV_INITRD [=y]

    [ ]   Support initial ramdisk/ramfs compressed using gzip
    [ ]   Support initial ramdisk/ramfs compressed using bzip2
    [ ]   Support initial ramdisk/ramfs compressed using LZMA
    [*]   Support initial ramdisk/ramfs compressed using XZ
    [ ]   Support initial ramdisk/ramfs compressed using LZO
    [ ]   Support initial ramdisk/ramfs compressed using LZ4
    [ ]   Support initial ramdisk/ramfs compressed using ZSTD

    Compiler optimization level (Optimize for performance (-O2))  --->
    Symbol: CC_OPTIMIZE_FOR_PERFORMANCE [=y]

    [*] Enable rseq() system call
    Symbol: RSEQ [=y]

    [*] Profiling support
    Symbol: PROFILING [=y]


Processor type and features  --->

    [*] Symmetric multi-processing support
    Symbol: SMP [=y]

    [*] x86 CPU resource control support
    Symbol: X86_CPU_RESCTRL [=y]

    [*] Single-depth WCHAN output
    Symbol: SCHED_OMIT_FRAME_POINTER [=y]

    [*] Supported processor vendors  --->
    Symbol: PROCESSOR_SELECT [=y]

        [ ]   Support Intel processors
        Symbol: CPU_SUP_INTEL [=n]

        [*]   Support AMD processors
        Symbol: CPU_SUP_AMD [=y]

        [ ]   Support Hygon processors
        Symbol: CPU_SUP_HYGON [=n]

        [ ]   Support Centaur processors
        Symbol: CPU_SUP_CENTAUR [=n]

        [ ]   Support Zhaoxin processors
        Symbol: CPU_SUP_ZHAOXIN [=n]

    [*] Enable DMI scanning
    Symbol: DMI [=y]

    (16) Maximum number of CPUs
    Symbol: NR_CPUS [=16]

    [*] Reroute for broken boot IRQs
    Symbol: X86_REROUTE_FOR_BROKEN_BOOT_IRQS [=y]

    [*] Machine Check / overheating reporting
    Symbol: X86_MCE [=y]

    Performance monitoring  --->

        <*> AMD Uncore performance events
        Symbol: PERF_EVENTS_AMD_UNCORE [=y]

        [*] AMD Zen3 Branch Sampling support
        Symbol: PERF_EVENTS_AMD_BRS [=y]

    [ ] Enable vsyscall emulation
    Symbol: X86_VSYSCALL_EMULATION [=n]

    [*] CPU microcode loading support
    Symbol: MICROCODE [=y]

    [*]   AMD microcode loading support
    Symbol: MICROCODE_AMD [=y]

    [ ] Enable 5-level page tables support
    Symbol: X86_5LEVEL [=n]

    [*] AMD Secure Memory Encryption (SME) support
    Symbol: AMD_MEM_ENCRYPT [=y]

    [*] NUMA Memory Allocation and Scheduler Support
    Symbol: NUMA [=y]

    [*] User Mode Instruction Prevention
    Symbol: X86_UMIP [=y]

    Timer frequency (1000 HZ)  --->
    Symbol: HZ_1000 [=y]

    vsyscall table for legacy applications (None)  --->
    Symbol: LEGACY_VSYSCALL_NONE [=y]

    [*] Built-in kernel command line
    Symbol: CMDLINE_BOOL [=y]

    (root=system/root) Built-in kernel command string
    Symbol: CMDLINE [=root=system/root]

    [*] Enable the LDT (local descriptor table)
    Symbol: MODIFY_LDT_SYSCALL [=y]


Power management and ACPI options  --->

    [*] Suspend to RAM and standby
    Symbol: SUSPEND [=y]

    [*] Hibernation (aka 'suspend to disk')
    Symbol: HIBERNATION [=y]

    (/dev/nvme0n1p2) Default resume partition
    Symbol: PM_STD_PARTITION [=/dev/nvme0n1p2]

    [*] ACPI (Advanced Configuration and Power Interface) Support  --->
    Symbol: ACPI [=y]

        [*]   ACPI Firmware Performance Data Table (FPDT) support
        Symbol: ACPI_FPDT [=y]

        <*>   ACPI Time and Alarm (TAD) Device Support
        Symbol: ACPI_TAD [=y]

        [*]   Dock
        Symbol: ACPI_DOCK [=y]

        <*>   Hardware Error Device
        Symbol: ACPI_HED [=y]

        [*]   NUMA support
        Symbol: ACPI_NUMA [=y]

        [*]     ACPI Heterogeneous Memory Attribute Table Support
        Symbol: ACPI_HMAT [=y]

        [*]   ACPI Platform Error Interface (APEI)
        Symbol: ACPI_APEI [=y]

        [*]     APEI Generic Hardware Error Source
        Symbol: ACPI_APEI_GHES [=y]

        <*>   ACPI configfs support
        Symbol: ACPI_CONFIGFS [=y]

        [*]   PMIC (Power Management Integrated Circuit) operation region support  ----
        Symbol: PMIC_OPREGION [=y]

    CPU Frequency scaling  --->

        [*] CPU Frequency scaling
        Symbol: CPU_FREQ [=y]

        Default CPUFreq governor (schedutil)  --->
        Symbol: CPU_FREQ_DEFAULT_GOV_SCHEDUTIL [=y]

        [*]   AMD Processor P-State driver
        Symbol: X86_AMD_PSTATE [=y]

        <*>   ACPI Processor P-States driver
        Symbol: X86_ACPI_CPUFREQ [=y]


[*] Virtualization  --->

    <*>   Kernel-based Virtual Machine (KVM) support
    Symbol: KVM [=y]

    <*>     KVM for AMD processors support
    Symbol: KVM_AMD [=y]


General architecture-dependent options  --->

    [*] Optimize very unlikely/likely branches
    Symbol: JUMP_LABEL [=y]

    [*] Provide system calls for 32-bit time_t
    Symbol: COMPAT_32BIT_TIME [=y]

    [ ] Use a virtually-mapped stack
    Symbol: VMAP_STACK [=n]


-*- Enable the block layer  --->
    Symbol: BLOCK [=y]

    [ ]   Legacy autoloading support
    Symbol: BLOCK_LEGACY_AUTOLOAD [=n]

    [*]   Block layer data integrity support
    Symbol: BLK_DEV_INTEGRITY [=y]

    [*]   Zoned block device support
    Symbol: BLK_DEV_ZONED [=y]

    [*]   Enable support for block device writeback throttling
    Symbol: BLK_WBT [=y]

    Partition Types  --->

        [*] Advanced partition selection
        Symbol: PARTITION_ADVANCED [=y]

        [*]   PC BIOS (MSDOS partition tables) support
        Symbol: MSDOS_PARTITION [=y]

        [*]   EFI GUID Partition support
        Symbol: EFI_PARTITION [=y]

    IO Schedulers  --->

        <*> BFQ I/O scheduler
        Symbol: IOSCHED_BFQ [=y]

        [*]   BFQ hierarchical scheduling support
        Symbol: BFQ_GROUP_IOSCHED [=y]


Executable file formats  --->

    [*] Kernel support for ELF binaries
    Symbol: BINFMT_ELF [=y]

    <*> Kernel support for scripts starting with #!
    Symbol: BINFMT_SCRIPT [=y]


Memory Management options  --->

    SLAB allocator options  --->

        Choose SLAB allocator (SLUB (Unqueued Allocator))  --->
        Symbol: SLUB [=y]

    [*] Page allocator randomization
    Symbol: SHUFFLE_PAGE_ALLOCATOR [=y]

    [*] Disable heap randomization
    Symbol: COMPAT_BRK [=y]

    [*] Allow for memory compaction
    Symbol: COMPACTION [=y]

    [*] Free page reporting
    Symbol: PAGE_REPORTING [=y]

    [*] Enable KSM for page merging
    Symbol: KSM [=y]

    (65536) Low address space to protect from user allocation
    Symbol: DEFAULT_MMAP_MIN_ADDR [=65536]

    [*] Transparent Hugepage Support  --->
    Symbol: TRANSPARENT_HUGEPAGE [=y]

        Transparent Hugepage Support sysfs defaults (madvise)  --->
        Symbol: TRANSPARENT_HUGEPAGE_MADVISE [=y]

    [*] Contiguous Memory Allocator
    Symbol: CMA [=y]

    [*] Support DMA zone
    Symbol: ZONE_DMA [=y]

    [*] Enable userfaultfd() system call
    Symbol: USERFAULTFD [=y]

    [*] Multi-Gen LRU
    Symbol: LRU_GEN [=y]

    [*]   Enable by default
    Symbol: LRU_GEN_ENABLED [=y]


[*] Networking support  --->
Symbol: NET [=y]

    Networking options  --->

        [*]   IP: advanced router
        Symbol: IP_ADVANCED_ROUTER [=y]

        <*>   IP: tunneling
        Symbol: NET_IPIP [=y]

        [*]   IP: TCP syncookie support
        Symbol: SYN_COOKIES [=y]

        <*>     UDP: socket monitoring interface
        Symbol: INET_UDP_DIAG [=y]

        <*>     RAW: socket monitoring interface
        Symbol: INET_RAW_DIAG [=y]

        [*]     INET: allow privileged process to administratively close sockets
        Symbol: INET_DIAG_DESTROY [=y]

        -*-   The IPv6 protocol  --->
        Symbol: IPV6 [=y]

            [*]   IPv6: Router Preference (RFC 4191) support
            Symbol: IPV6_ROUTER_PREF [=y]

            [*]     IPv6: Route Information (RFC 4191) support
            Symbol: IPV6_ROUTE_INFO [=y]

            [*]   IPv6: Enable RFC 4429 Optimistic DAD
            Symbol: IPV6_OPTIMISTIC_DAD [=y]

            [*]   IPv6: Multiple Routing Tables
            Symbol: IPV6_MULTIPLE_TABLES [=y]

            [*]     IPv6: source address based routing
            Symbol: IPV6_SUBTREES [=y]

            [*]   IPv6: multicast routing
            Symbol: IPV6_MROUTE [=y]

            [*]     IPv6: multicast policy routing
            Symbol: IPV6_MROUTE_MULTIPLE_TABLES [=y]

            [*]     IPv6: PIM-SM version 2 support
            Symbol: IPV6_PIMSM_V2 [=y]

        [*] Network packet filtering framework (Netfilter)  --->
        Symbol: NETFILTER [=y]

            Core Netfilter Configuration  --->

                <*> Netfilter LOG over NFNETLINK interface
                Symbol: NETFILTER_NETLINK_LOG [=y]

                <*> Netfilter connection tracking support
                Symbol: NF_CONNTRACK [=y]

                [*] Connection tracking zones
                Symbol: NF_CONNTRACK_ZONES [=y]

                [*] Connection tracking timeout
                Symbol: NF_CONNTRACK_TIMEOUT [=y]

                [*] Connection tracking timestamping
                Symbol: NF_CONNTRACK_TIMESTAMP [=y]

                <*> FTP protocol support
                Symbol: NF_CONNTRACK_FTP [=y]

                <*> H.323 protocol support
                Symbol: NF_CONNTRACK_H323 [=y]

                <*> IRC protocol support
                Symbol: NF_CONNTRACK_IRC [=y]

                <*> NetBIOS name service protocol support
                Symbol: NF_CONNTRACK_NETBIOS_NS [=y]

                <*> SNMP service protocol support
                Symbol: NF_CONNTRACK_SNMP [=y]

                <*> SANE protocol support
                Symbol: NF_CONNTRACK_SANE [=y]

                <*> SIP protocol support
                Symbol: NF_CONNTRACK_SIP [=y]

                <*> TFTP protocol support
                Symbol: NF_CONNTRACK_TFTP [=y]

                <*> Connection tracking netlink interface
                Symbol: NF_CT_NETLINK [=y]

                <*> Connection tracking timeout tuning via Netlink
                Symbol: NF_CT_NETLINK_TIMEOUT [=y]

                [*] NFQUEUE and NFLOG integration with Connection Tracking
                Symbol: NETFILTER_NETLINK_GLUE_CT [=y]

                <*> Network Address Translation support
                Symbol: NF_NAT [=y]

                <*> Netfilter nf_tables support
                Symbol: NF_TABLES [=y]

                [*]   Netfilter nf_tables mixed IPv4/IPv6 tables support
                Symbol: NF_TABLES_INET [=y]

                [*]   Netfilter nf_tables netdev tables support
                Symbol: NF_TABLES_NETDEV [=y]

                <M>   Netfilter nf_tables *

                <M> Netfilter flow table module
                Symbol: NF_FLOW_TABLE [=m]

                <M> Netfilter flow table mixed IPv4/IPv6 module
                Symbol: NF_FLOW_TABLE_INET [=m]

                [*]   Supply flow table statistics in procfs
                Symbol: NF_FLOW_TABLE_PROCFS [=y]

            IP: Netfilter Configuration  --->

                [*] ARP nf_tables support
                Symbol: NF_TABLES_ARP [=y]

            <M>   IPv4/IPV6 bridge connection tracking support
            Symbol: NF_CONNTRACK_BRIDGE [=m]

        <*> 802.1d Ethernet Bridging
        Symbol: BRIDGE [=y]

        <*> 802.1Q/802.1ad VLAN Support
        Symbol: VLAN_8021Q [=y]

        [*]   GVRP (GARP VLAN Registration Protocol) support
        Symbol: VLAN_8021Q_GVRP [=y]

        [*]   MVRP (Multiple VLAN Registration Protocol) support
        Symbol: VLAN_8021Q_MVRP [=y]

        [ ] QoS and/or fair queueing  ----
        Symbol: NET_SCHED [=n]

        <M> Virtual Socket protocol
        Symbol: VSOCKETS [=m]

        <*> NETLINK: socket monitoring interface
        Symbol: NETLINK_DIAG [=y]

    <*>   Bluetooth subsystem support  --->
    Symbol: BT [=y]

        Enable everything (preferably as module) that
        is not related to testing or debugging.

    [*]   Wireless  --->
    Symbol: WIRELESS [=y]

        <*>   cfg80211 - wireless configuration API
        Symbol: CFG80211 [=y]

        [*]     cfg80211 wireless extensions compatibility
        Symbol: CFG80211_WEXT [=y]

        <*>   Generic IEEE 802.11 Networking Stack (mac80211)
        Symbol: MAC80211 [=y]

        [*]   Enable mac80211 mesh networking support
        Symbol: MAC80211_MESH [=y]

    <*>   RF switch subsystem support  ----
    Symbol: RFKILL [=y]

    <M>   NFC subsystem support  --->
    Symbol: NFC [=m]

        Enable everything (preferably as module) that
        is not related to testing or debugging.
```

Enable device drivers.

```
Device Drivers  --->

    [*] PCI support  --->
    Symbol: PCI [=y]

        [*]   PCI Express Port Bus support
        Symbol: PCIEPORTBUS [=y]

        [*]     PCI Express Advanced Error Reporting support
        Symbol: PCIEAER [=y]

        <*>       PCI Express error injection support
        Symbol: PCIEAER_INJECT [=y]

        [*]       PCI Express ECRC settings control
        Symbol: PCIE_ECRC [=y]

        [*]   PCI Express Downstream Port Containment support
        Symbol: PCIE_DPC [=y]

        [*]   PCI Express Precision Time Measurement support
        Symbol: PCIE_PTM [=y]

        [*]   PCI Express Error Disconnect Recover support
        Symbol: PCIE_EDR [=y]

        [*]   Message Signaled Interrupts (MSI and MSI-X)
        Symbol: PCI_MSI [=y]

        <*>   PCI Stub driver
        Symbol: PCI_STUB [=y]

        [*]   PCI IOV support
        Symbol: PCI_IOV [=y]

        [*]   Enable PCI resource re-allocation detection
        Symbol: PCI_REALLOC_ENABLE_AUTO [=y]

        [*]   PCI PRI support
        Symbol: PCI_PRI [=y]

        [*]   PCI PASID support
        Symbol: PCI_PASID [=y]

        [*]   Support for PCI Hotplug  --->
        Symbol: HOTPLUG_PCI [=y]

            [*]   ACPI PCI Hotplug driver
            Symbol: HOTPLUG_PCI_ACPI [=y]

            <*>     ACPI PCI Hotplug driver IBM extensions
            Symbol: HOTPLUG_PCI_ACPI_IBM [=y]

        [*]     PCI Express Hotplug driver
        Symbol: HOTPLUG_PCI_PCIE [=y]

    Generic Driver Options  --->

        [*]   Automount devtmpfs at /dev, after the kernel mounted the rootfs
        Symbol: DEVTMPFS_MOUNT [=y]

        [*]   Use nosuid,noexec mount options on devtmpfs
        Symbol: DEVTMPFS_SAFE [=y]

        [*] Select only drivers that don't need compile-time external firmware
        Symbol: STANDALONE [=y]

        [*] Disable drivers features which enable custom firmware building
        Symbol: PREVENT_FIRMWARE_BUILD [=y]

        Firmware loader  --->

            [*]   Enable the firmware sysfs fallback mechanism
            Symbol: FW_LOADER_USER_HELPER [=y]

            [*]   Enable compressed firmware support
            Symbol: FW_LOADER_COMPRESS [=y]

            [*]     Enable XZ-compressed firmware support
            Symbol: FW_LOADER_COMPRESS_XZ [=y]

            [*]     Enable ZSTD-compressed firmware support
            Symbol: FW_LOADER_COMPRESS_ZSTD [=y]

            [*]   Enable users to initiate firmware updates using sysfs
            Symbol: FW_UPLOAD [=y]

    Bus devices  --->

        <*> Modem Host Interface (MHI) bus
        Symbol: MHI_BUS [=y]

    <*> Connector - unified userspace <-> kernelspace linker  --->
    Symbol: CONNECTOR [=y]

    Firmware Drivers  --->

        [*] Add firmware-provided memory map to sysfs
        Symbol: FIRMWARE_MEMMAP [=y]

        <*> DMI table support in sysfs
        Symbol: DMI_SYSFS [=y]

    -*- Plug and Play support  --->
    Symbol: PNP [=y]

    [*] Block devices  --->
    Symbol: BLK_DEV [=y]

        <*>   Loopback device support
        Symbol: BLK_DEV_LOOP [=y]

        (0)     Number of loop devices to pre-create at init time
        Symbol: BLK_DEV_LOOP_MIN_COUNT [=0]

    NVME Support  --->

        <*> NVM Express block device
        Symbol: BLK_DEV_NVME [=y]

        [*] NVMe multipath support
        Symbol: NVME_MULTIPATH [=y]

    SCSI device support  --->

        todo
```






```
    Device Drivers  --->

    [*] PCI support  --->
    Symbol: PCI [=y]
```

```sh
time make -j17
```
