---
title: Windows
top: false
cover: false
toc: true
description: Some Configuration on Windows
categories:
  - Programming
  - Tools
  - Windows
tags:
  - Windows
abbrlink: 2c5abc07
date: 2022-06-10 18:31:06
password:
summary:
---

# Powershell

## Copy directory exclude specific type of file

```bash
robocopy C:\MyFiles D:\Backup /E /XF *.tif *.npz /V
```

C:\SourceFolder：源文件夹路径。

C:\DestinationFolder：目标文件夹路径。

/E：包括子文件夹（包括空文件夹）。

/XF _.tif _.npz：排除 .tif 和 .npz 文件。

/V 参数会显示每个文件的详细信息。

# Proxy

## In WSL

### Use the Windows proxy in WSL1

```bash
export http_proxy=socks://127.0.0.1:10808
export https_proxy=socks://127.0.0.1:10808
```

For fish user

```fish
if test $(grep Microsoft /proc/version)
  set -x http_proxy socks://127.0.0.1:10808
  set -x https_proxy socks://127.0.0.1:10808
end
```

Then verify the setting with `curl google.com`.

When `http(s)_proxy` is set you can see the log in your proxy on Windows when
you run `curl google.com`. Be careful about the `127.0.0.1` which is the loop
back address of local host, the port `10808` which is defined in your windows
proxy app, and `socks` is the protocol which also defined in your windows proxy
app.

Sometimes there is an error
`curl: (6) SOCKS4 connection to 2404:6800:4003:c0f::65 not supported`. It is the
error of `socks`. Use `socks5`,

```fish
if test $(grep Microsoft /proc/version)
  set -x http_proxy socks5://127.0.0.1:10808
  set -x https_proxy socks5://127.0.0.1:10808
end
```

### Use the Windows proxy in WSL2

`cat /etc/resolv.conf` to obtain the target ip.

```fish
if test $(grep Microsoft /proc/version)
  set -x http_proxy socks://target ip:10808
  set -x https_proxy socks://target ip:10808
end
```

For the windows side, open `allow the connection from local area network` in
your agent software.

# X server

## On the Windows side: Xming

I also tried VcXsrv. However, it failed to be launch. Thus I installed
[xming](https://sourceforge.net/projects/xming/). After installing, notice that
`No Access Control` may should be picked when start `Xlaunch`. Then a progress
`xming server` will be started (see it in your task bar).

Windows Side Done.

## On the linux side: $DISPLAY

The DISPLAY variable should be set as `:0.0`. For bash shell, write
`export DISPLAY=:0.0` in your `.bashrc`. For fish shell, write
`set -x DISPLAY :0.0` in your fish configuration file.

Then you can run a gui program on your linux and get the window on the Windows
side.

## For Remote Linux

Add the following lines in your bashrc.

```bash
export DISPLAY=local ip:0.0
export $(dbus-launch)
```

Be careful, when you start your Xming, pick `No Access Control`. When you use
local wsl, `No Access Control` makes no sense.
