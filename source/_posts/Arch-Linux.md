---
title: Arch Linux
top: false
cover: false
toc: true
description: "Arch Linux installation, Configuration"
categories:
  - Programming
  - Tools
  - Linux
tags:
  - Arch Linux
abbrlink: 38c4d001
date: 2022-05-15 20:40:03
password:
summary:
---

[A good Tutorial for Installing it!](https://archlinuxstudio.github.io/ArchLinuxTutorial/#/)

[A good Tutorial for Installing it!](https://arch.icekylin.online/)

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

Make partitions mount at startup. Add the following snippets to `/etc/fstab`.

```
/swapfile none swap defaults 0 0
/dev/sdb7   /home/Eric/Downloads  ext4  defaults 0 0
/dev/sdb5   /home/Eric/temp_try  ext4  defaults 0 0
/dev/sdb6   /home/Eric/expand  ext4  defaults 0 0

```

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

## `yay -S` + `tab` does not show all the package

`rm -rf ~/.cache/yay` can solve this problem.

## `Wake on Lan`

Sometimes use `wol mac_address` can not wake the server. Use
`wol -i ip_address mac_address` can wake the server.

## fish prompt

Some times `fish`get slow when going to `git` directories.

```
# ~/.local/share/omf/themes/ays/fish_prompt.fish
set -g fish_git_prompt_show_informative_status 0   # 关掉状态字符（* + …）
set -g fish_git_prompt_showdirtystate 0            # 不检查工作区
set -g fish_git_prompt_showstashstate 0
set -g fish_git_prompt_showupstream 0
```

## Baidunetdisk

`yay -S baidunetdisk-bin`

If it is failed to start when run`baidunetdisk` and reports
`gpu process isn't usable. goodbye`, run `baidunetdisk --no-sandbox`.

## Change the resolution of screen

`xrandr` can display the available screen resolution and the current
resolution(marked by star).

Add `xrandr --output VGA-1 --mode 1920x1080` to `.xinitrc` can change the
resolution of the screen permanently.

After change the resolution, the font might be unsuitable.

```cpp
static const char *fonts[] = {"Hack NF:size=16",
                              "JoyPixels:size=14:antialias=true:autohint=true"};
```

in the`config.def.h` of the `dwm` package can change the font size of the top
bar.

```cpp
static char *font = "Hack Nerd Font:lixelsize=40:antialias=true:autohint=true";
```

in the `config.default.h` of the `st` package can change the font size of `st`.

## Virtualbox conflicts with KVM

Both KVM (Kernel-based Virtual Machine) and VirtualBox are hypervisors, and they
both want to use VMX root mode. This leads to a conflict when they try to run
simultaneously.

1. Run `lsmod | grep kvm` to see if the `kvm_intel` (for Intel) or `kvm_amd`
   (for AMD) modules are loaded.
2. If they are loaded, unload them using `sudo modprobe -r kvm_intel` or
   `sudo modprobe -r kvm_amd`. This is a temporary fix, as the KVM module will
   be reloaded on reboot.
3. To disable KVM permanently, create a file named `kvm-blacklist.conf` in
   `/etc/modprobe.d/`.
4. Add the appropriate line to the file: For Intel: `blacklist kvm_intel` For
   AMD: `blacklist kvm_amd`.

## Install MS Windows fonts, Configure `matplotlib`

```
yay -S ttf-ms-win11-auto
yay -S ttf-ms-win11-auto-zh_cn
fc-list :lang=zh | grep "sim"
rm ~/.cache/matplotlib/fontlist-v390.json
```

Then `import matplotlib` will create a new version of
`~/.cache/matplotlib/fontlist-v390.json` which contains fonts like `simsun`.

The following codes will enable `plt` to use font `SimSun`.

```
plt.rcParams["axes.unicode_minus"] = False  # 解决负号显示问题
plt.rcParams["font.sans-serif"] = ["SimSun"]
# 或者直接指定字体文件路径作为全局字体
# plt.rcParams["font.sans-serif"] = [
#     FontProperties(fname="/usr/share/fonts/TTF/simsun.ttc").get_name()
# ]

```

## WPS

WPP cannot display bold text properly.

Download and install the old version of freetype.
[freetype2-2.13.0-1-x86_64.pkg.tar.zst](https://archive.archlinux.org/packages/f/freetype2/freetype2-2.13.0-1-x86_64.pkg.tar.zst)

[Here](https://zhuanlan.zhihu.com/p/657532417)

## Bluetooth

```bash
sudo pacman -S bluez bluez-utils
sudo systemctl start bluetooth
sudo systemctl enable bluetooth
bluetoothctl
```

The `br-connection-profile-unavailable` error will occur. As mentioned in
[this wiki](https://bbs.archlinux.org/viewtopic.php?id=288398), install
`pipewire-pulse` then restart `pipewire` will solve the problem.

```bash
sudo pacman -S pipewire-pulse
systemctl --user restart pipewire
```

Then you can connect your devices by bluetooth.

## Hardware time

The hardware time sometimes is not correct.

Use `sudo timedatectl set-ntp true` to solve it.

## Use Nvidia for X Server

By [this](https://wiki.archlinux.org/title/NVIDIA_Optimus)

## Block nouveau

Add
`GRUB_CMDLINE_LINUX_DEFAULT="loglevel=5 nowatchdog modprobe.blacklist=nouveau"`
to the `/etc/default/grub`. Then `grub-mkconfig -o /boot/grub/grub.cfg`.

## Default applications

To set the default applications, one needs to modify the file
`~/.config/mimeapps.list`. In the right side of `=` can be the file name in
`/usr/share/applications/`.

## Thunderbird

Thunderbird is used as the email app. However, it can not be stored on the tray.
`birdtray` can help. Install it with `yay -S birdtray` and run `birdtray` then
Configure it with thunderbird.

## Remote Desktop

To use the local camera, this command is needed.

```bash
sudo xfreerdp /f /u:Account Name /p:Password /v:IP:Port /video /usb:id,dev:1bcf:28b
0  /sound /microphone:sys:alsa
```

The usb id is obtained by command `lsusb`.

Something also need to be set on the Windows side.

1. Type `WinKey + R` and run `gpedit.msc` on the target VM (the target windows
   10 Virtual Machine) to start the `Group Policy Editor`.
2. Locate the item
   ` Computer Configuration \ Administrative Templates \ Windows Components \ Remote Desktop Services \ Remote Desktop Session Host \ Device and Resource Redirection\ Do not allow supported Plug and Play device redirection`
   and set this item to Disabled.
3. Also you can set

```bash
Remote Desktop Connection Client \ RemoteFX USB Device Redirection \ Allow RDP redirection of other supported RemoteFX USB devices from this computer (Enabled)

Remote Desktop Session Host \ Remote Session Environment \ RemoteFX for Windows Server 2008 R2 \ Configure RemoteFX (Enabled)

Remote Desktop Session Host \ Connections \ Allow users to connect remotely by using Remote Desktop Services (Enabled)

Remote Desktop Session Host \ Device and Resource Redirection\ Do not allow supported Plug and Play device redirection (Disabled)

gpupdate /force in elevated CMD Prompt and reboot
```

4. Run `gpupdate /force` from an elevated command prompt.
5. At least disconnect RDP session and connect again, if this does not work
   reboot target VM.

[For More Information](https://stackoverflow.com/questions/33719489/how-to-enable-usb-redirection-in-windows-10/46628854)

## Slstatus

`slstatus` can show the information of battery. Add the following snippets in
the `config.h` file. The name of the battery can be found by running
`sudo tlp-stat -b`.

```c
    {battery_perc, "󰁿 %s%%", "BAT0"},
    {battery_state, "%s | ", "BAT0"},
```

## Touch Pad

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

## Systemd service

### Manage user-specific systemd units

1. Create a service file in `~/.config/systemd/user/`.

Notice that not to use `~` to denote the home directory.

For `x0vncserver.service`:

```
[Unit]
Description=Remote desktop service (VNC)
After=network.target

[Service]
Type=simple
Restart=always
RestartSec=5s
ExecStartPre=/bin/sh -c 'while ! pgrep -U "$USER" Xorg; do sleep 2; done'
ExecStart=x0vncserver -rfbauth /home/Eric/.vnc/passwd  -SecurityTypes VncAuth

[Install]
WantedBy=default.target
```

For `frpc.service`:

```
[Unit]
Description=Frp Client Service
Wants = network.target
After = network.target syslog.target

[Service]
Type=simple
Restart=always
RestartSec=5s
ExecStart=/home/Eric/frp/frpc -c /home/Eric/frp/frpc.toml

[Install]
WantedBy=default.target
```

2. Reload systemd manager configuration using `systemctl --user daemon-reload`.
3. Enable and start the service using
   `systemctl --user enable ExampleService.service ` and
   `systemctl --user start ExampleService.service`.

## Auto login

The only thing needed to do is create the 'autologin.conf' file.
[Here](https://wiki.archlinux.org/title/getty#Virtual_console).

Then, change `username` to the username you want to auto login.

## Xorg

The scale of the screen can be changed by
`xrandr --output eDP-1 --scale 0.6x0.6`.

## Cursor

The cursor can be hind by `yay -S unclutter`.

## Network

Connect a network with `NetworkManager`. For example,
`nmcli connection add type wifi con-name BUPT-mobile ifname wlan0 ssid BUPT-mobile -- wifi-sec.key-mgmt wpa-eap 802-1x.eap ttls 802-1x.phase2-auth mschapv2 802-1x.identity USERNAME`
Then `BUPT-mobile` can be connected with `nmcli --ask connection up BUPT-mobile`
or `nmtui`. The `nmtui` does not support add network of `WPA2 802.1X` otherwise
one can add and connect the network by only `nmtui`.

Use `space` to enable or disable `automatically connect` in `nmtui`. `X` denotes
enable.

## startx

## libxft-bgra-git

`libxft-bgra-git` is discarded by `yay` and use ` ttf-symbola` instead.

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

## Goldendict

`Goldendict-webengine-git` is better than `Goldendict-git`.

Goldendict is a more power translator. Install `translate-shell`. `edit` >
`dictionaries` > `programs` > `add`, `type`: `Plain text`; `Command Line`:
`trans -e google -s en -t zh -show-original y -show-original-phonetics n -show-translation y -no-ansi -show-translation-phonetics n -show-prompt-message n -show-languages n -show-original-dictionary n -show-dictionary n -show-alternatives n "%GDWORD%"`

Set `popup` only press `alt`. Use `ctrl` will cause a problem that translate
when copy. Especially when copy a web link.

To enable run `goldendict` in background, pick `Enable system try icon` and
`Start to system try`. Otherwise, the gui of `goldendict` will open even if it
is executed by `goldendict &`.

## Tmux

When install `tmux`, some error maybe occur.
`/usr/share/fish/functions/fish_prompt.fish (line 6): hostname|cut -d . -f 1`
can be solved by `pacman -S inetutils`.

`shell command tmux throws can't use /dev/tty` error can be solved
by`exec </dev/tty; exec <&1; TMUX= tmux`.

## Clipboard of nvim

To enable the clipboard of nvim share by the system, run `sudo pacman -S xsel`

## Try to run `exe` files

### Wine

I successfully installed wechat with wine. However, it can not use the camera.

### Bottles

#### PyGObject

Bottles depends on `PyGObject`, it is a python package. However, it is difficult
to install it by `pip`. It can be easily installed by conda.

##### A way to install PyGObject

`pip install PyGObject` default to install its dependences like `pycairo`.
However, the latest version of `pycairo` can not be successfully ran on my
system. Thus I can install `pycairo` manually by `pip` or `conda` and run
`pip install --no-build-isolation pygobject` to install `pygobject` and in this
way `pygobject` will not install its dependences automatically and will find the
dependences locally.

##### Install successfully

`bottles` is installed successfully by using ` flatpak`, by
`sudo pacman -S flatpak`. However, it also can not use the camera.

# Locale

For detail to see the Arch Linux wiki. Notice that the KDE can set the language
too. Only set to en_US.
