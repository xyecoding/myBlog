---
title: Python
top: false
cover: false
toc: true
description: Tips for Python
categories:
  - Programming
  - Tools
tags:
  - Python
abbrlink: a378bd8e
date: 2025-10-19 20:20:33
password:
summary:
---

# The Isolation property of `pip`

When installing `detectron2` via
`git+https://github.com/facebookresearch/detectron2.git`, you may encounter a
`ModuleNotFoundError: No module named 'torch'` error. This occurs even if
`torch` is already installed. The problem stems from recent versions of `pip`
using isolated builds, which prevent the installation process from accessing
installed packages like `torch`. Using
`pip install --no-build-isolation 'git+https://github.com/facebookresearch/detectron2.git'`
can resolve this error.
