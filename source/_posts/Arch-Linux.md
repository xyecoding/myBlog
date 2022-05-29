---
title: Arch Linux
top: false
cover: false
toc: true
date: 2022-05-15 20:40:03
password:
summary:
description: Arch Linux installation, Configuration
categories:
  - Programming
  - Linux
tags:
  - Arch Linux
---

[A good Tutorial for Installing it!](https://archlinuxstudio.github.io/ArchLinuxTutorial/#/)

# What is Verify Signature

Signature is used for protecting data from undetected changes by including a
proof of identify value called a digital signature.

# What is Kernel Module

Kernel module are pieces of code that can be loaded and unloaded into the kernel
upon demand. They extend the functionality of the kernel without the need of
reboot the system.

Modules are stored in `/usr/lib/modules/kernel_release` or `/lib/modules`. You
can use the command `uname -r` to get your current kernel release version.

[How to block a kernel module](https://wiki.archlinux.org/title/Kernel_modules#Blacklisting).

## Nouveau

Nouveau is an open-source Nouveau driver for NVIDIA graphics cards.

# initramfs

The root file system at `/` starts out as an empty rootfs, which is a special
instance of ramfs or tmpfs. The purpose of the initramfs is to bootstrap the
system to the point where it can access the root file system. It does not need
to contain every module one would ever want to use; it should only have modules
required for the root device like IDE, SCCI, SATA or USB/FW. The majority of
modules will be loaded later on by `udev`, during the init process.

# What is fstab

`fstab` is the Linux system's file system table. It is a configuration table
designed to ease the burden of mounting and unmounting file systems to a
machine. It is a set of rules used to control how different file systems are
treated each time they are introduced to a system.

# What is grub

`grub` is a boot loader. It is the software that loads the Linux kernel (It has
other uses as well). It is the first software that starts at a system boot.

The BIOS checks the Master Boot Record (MBR) which is a 512 byte section located
first on the Hard Drive. It looks for a bootloader (like GRUB).

Then you will be prompted by the GRUB menu which can contain a list of the
operating systems installed (in the case of dual boot), or perhaps different
kernels installed in a Linux distro.

When you choose which distro or kernel you want to use, GRUB loads the selected
kernel. The kernel starts `init` or `systemd`, which is the first process to
start in Linux. `init` then starts other processes like network services and
other that you might have configured at boot time.

# Firmware Types

The firmware is the very first program that is executed once the system is
switched on. The words BIOS or (U)EFI are often used instead of firmware.

# What is UEFI

## BIOS

1. BIOS (basic input/output system) is a program.
2. It is in the ROM (read only) disk. It is hard encoded on the computer
   motherboard.
3. It is used by a computer's microprocessor to start the computer system after
   it is powered on. It performs hardware initialization during the booting
   process (power-on startup).
4. It also manages data flow between the computer's operating system (OS) and
   attached devices, such as the hard disk, video adapter, keyboard, mouse and
   printer.

## UEFI

BIOS's popularity has waned in favor of a newer technology: UEFI (Unified
Extensible Firmware Interface). Intel announced a plan in 2017 to retire support
for legacy BIOS systems by 2020, replacing them with UEFI.

UEFI does not launch any boot code from the Master Boot Record (MBR) whether it
exists or not, instead booting relies on boot entries in NVRAM.

### The Usage of UEFI

UEFI launches EFI (Extensible Firmware Interface) applications, e.g., boot
loaders, boot managers, UEFI shell, etc. These applications are usually stored
as files in the EFI system partition. Each vendor can stores its files in the
EFI system partition under the `/EFI/vendor_name` directory. The applications
can be launched by adding a boot entry to the NVRAM (non-volatile random access
memory, an RAM can keep the data with power off) or from the UEFI shell.

# System Initialization

## Under BIOS

![The Initialization process](init.png)

1. System switched on, the POST (power-on self-test) is executed.
2. After POST, BIOS initializes the hardware required for booting (disk,
   keyboard controller etc.).
3. BIOS launches the first 440 bytes (the Master Boot Record bootstrap code
   area) of the first disk in the BIOS disk order.
4. The boot loader's first stage in the MBR (Master Boot Record) boot code then
   launches its second stage code (if any) from either:
   - next disk sectors after the MBR, i.e., the so called post-MBR gap (only on
     a MBR partition table).
   - A partition's or a partitionless disk's volume boot record (VBR)
   - The BIOS boot partition (GRUB on BIOS/GPT only).
5. The actual boot loader is launched.
6. The boot loader then loads an operating system by either chain-loading or
   directly loading the operating system kernel

> POST: A power-on self-test is a set of routines performed by firmware or
> software immediately after a computer is powered on, to determine if the
> hardware is working as expected. The process would proceed further only if the
> required hardware is working correctly, else the BIOS would issue an error
> message. POST sequence is executed irrespective of the Operating System and is
> handled by the system BIOS. Once the tests are passed the POST would generally
> notify the OS with beeps while the number of beeps can vary from system to
> system. When POST is successfully finalized bootstrapping is enable.
> Bootstrapping starts the initialization of the OS.

## Under UEFI

1. System switched on, the power-on self-test (POST) is executed.
2. After POST, UEFI initializes the hardware required for booting (disk,
   keyboard controllers etc.).
3. Firmware reads the boot entries in the NVRAM to determine which EFI
   application to launch and from where (e.g. from which disk and partition).
   - A boot entry could simply be a disk. In this case the firmware looks fro an
     EFI system partition on that disk and tries to find an EFI application in
     the fallback boot path `\EFI\BOOT\BOOTx64.EFI` (`bootia32.EFI` on systems
     with a IA32 (32-bit) UEFI). This is how UEFI bootable removable media work.
4. Firmware launches the EFI application.
   - This could be a boot loader or the Arch kernel itself using EFISTUB.
   - It could be some other EFI application such as UEFI shell or a boot manages
     like systemd-boot or rEFInd.

If Secure Boot is enabled, the boot process will verify authenticity of the EFI
binary by signature.

# Dual Boot with Windows

## Windows Before Linux

The main difference between installing individual Linux and dual system is the
boot loader, which load the operating system.

### BIOS Systems

#### Using a Linux Boot Loader

You may use any multi-boot supporting BIOS boot loader, such as 'grub'.

#### Using Windows Boot Loader

1. Install a Linux bootloader on a partition instead of the MBR, e.g., the
   `/boot` partition
2. Copy this bootloader to a partition readable by the windows bootloader
3. Use Windows bootloader to start said copy of the Linux bootloader

# Configuration

## Touch pad

When `dwm` is started, tapping the touchpad does not work. To let it work create
`/etc/X11/xorg.conf.d/30-touchpad.conf`, which contains

```
Section "InputClass"
Identifier "touchpad catchall"
Driver "libinput"
Option "Tapping" "on"
EndSection
```

Notice that there is no indents in the file, otherwise it will not work.

## Network

Connect a network with `NetworkManager`. For example,
`nmcli connection add type wifi con-name BUPT-mobile ifname wlan0 ssid BUPT-mobile -- wifi-sec.key-mgmt wpa-eap 802-1x.eap ttls 802-1x.phase2-auth mschapv2 802-1x.identity USERNAME`
Then `BUPT-mobile` can be connected with `nmcli --ask connection up BUPT-mobile`
or `nmtui`. The `nmtui` does not support add network of `WPA2 802.1X` otherwise
one can add and connect the network by only `nmtui`.

Use `space` to enable or disable `automatically connect` in `nmtui`. `X` denotes
enable.

## startx

### NVIDIA

`startx` provides a command line startup of Linux. However, it will cause a
black screen problem with NVIDIA. To avoid it, add

```bash
xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto
```

to the `.xinitrc`.

### Auto Start

Add the following snippets to `~/.bash_profile`.

```bash
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx
fi
```

## Screen Translator

### youdao

`youdao` can be installed by `yay -S youdao-dict`. However, it is very slow to
show the result when words are picked. This is because of the vpn. I use
`51game`. However, when I set the `system client` into `mainland white list`, it
translate fast for picking words.

## Tmux

When install `tmux`, some error maybe occur.
`/usr/share/fish/functions/fish_prompt.fish (line 6): hostname|cut -d . -f 1`
can be solved by `pacman -S inetutils`.

`shell command \`tmux\`throws\`can't use /dev/tty\` error`can be solved by`exec
</dev/tty; exec <&1; TMUX= tmux`.

## Clipboard of nvim

To enable the clipboard of nvim share by the system, run `sudo pacman -S xsel`

## Try to run `exe` files

## Wine

I successfully installed wechat with wine. However, it can not use the camera.

## Bottles

### PyGObject

Bottles depends on `PyGObject`, it is a python package. However, it is difficult
to install it by `pip`. It can be easily installed by conda.

# A way to install PyGObject

`pip install PyGObject` default to install its dependences like `pycairo`.
However, the latest version of `pycairo` can not be successfully ran on my
system. Thus I can install `pycairo` manually by `pip` or `conda` and run
`pip install --no-build-isolation pygobject` to install `pygobject` and in this
way `pygobject` will not install its dependences automatically and will find the
dependences locally.

## Install successfully

`bottles` is installed successfully by using ` flatpak`, by
`sudo pacman -S flatpak`. However, it also can not use the camera.

# Locale

For detail to see the Arch Linux wiki. Notice that the KDE can set the language
too. Only set to en_US.
