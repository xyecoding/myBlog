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
