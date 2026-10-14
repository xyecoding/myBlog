---
title: Detection Systems
top: false
cover: false
toc: true
description: Detection Systems
categories:
  - Detection Systems
tags:
  - Detection Systems
abbrlink: e14c40f7
date: 2026-10-14 17:30:04
password:
summary:
---

# RF 侦测（射频侦测）

> 与光学探测的关系：**RF 侦测不属于光学探测**。光学探测工作在紫外、可见光、红外波段，靠光学系统/光电探测器接收光波；RF 侦测工作在射频/微波波段（如广播、5G、Wi-Fi、雷达频段），靠天线接收电磁波。两者同属"电磁波探测"，只是频段和器件不同——红外属于光学探测，射频则不是。

```text
RF 侦测（射频侦测）
                         │
          ┌──────────────┴──────────────┐
          │                             │
    目标自己发射信号               目标只反射信号
    （信号侦测/频谱侦测）          （反射式侦测）
          │                             │
    防窃听排查                  ┌───────┴───────┐
    反无人机侦测                │               │
                          用环境信号照明      自己发射信号照明
                          = 无源雷达         = 有源雷达（雷达）
                          （借广播/5G/Wi-Fi） （自己打光）
```

# 合成孔径雷达（SAR）介绍

![合成孔径雷达介绍](sar_intro.png)

# 相扫天线和转塔

<iframe src="phase_gradient_physics_demo.html" width="100%" height="800" frameborder="0" style="border-radius:12px;box-shadow:0 4px 20px rgba(0,0,0,0.1);"></iframe>
