---
title: Deep Learning Tools
top: false
cover: false
toc: true
description: Deep Learning Tools
categories:
  - Programming
  - Tools
tags:
  - Deep Learning Tools
abbrlink: 9eb3b355
date: 2025-10-28 15:59:52
password:
summary:
---

# CUDNN

## C++ API

[cudnn_frontend](https://github.com/NVIDIA/cudnn-frontend.git)
provides a c++ wrapper for
the cudnn backend API and samples on how to use it.

## Python API

### Use CUDNN in pytorch

#### torch.backends.cudnn.benchmark

A bool that, if True, causes cuDNN to benchmark multiple
convolution algorithms and select the fastest.

This flag allows you to enable the inbuilt
cudnn auto-tuner to find the best algorithm to use for your hardware.
Benchmark mode is good whenever your input sizes
for your network do not vary.
This way, cudnn will look for the optimal set of algorithms
for that particular configuration (which takes some time).
This usually leads to faster runtime.
But if your input sizes changes at each iteration,
then cudnn will benchmark every time a new size appears,
possibly leading to worse runtime performances.

#### torch.backends.cudnn.enabled

A bool that controls whether cuDNN is enabled.

#### torch.backends.cudnn.is_available()

Return a bool indicating if CUDNN is currently available.

# CUDA
