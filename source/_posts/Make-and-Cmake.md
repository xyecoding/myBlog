---
title: Make and Cmake
top: false
cover: false
toc: true
description: Make and Cmake
categories:
  - Programming
  - Utile
  - Compile
tags:
  - Compile
abbrlink: 1174cd5f
date: 2022-06-11 09:27:25
password:
summary:
---

# `cmake`

## Find CUDA

find_package(CUDAToolkit [<version>] [QUIET] [REQUIRED] [EXACT] [...])

Some default environment variable will be searched, such as `CUDAToolkit_ROOT`.
[More information](https://cmake.org/cmake/help/latest/module/FindCUDAToolkit.html)

## The difference between `LD_LIBRARY_PATH` and `LIBRARY_PATH`

`LD_LIBRARY_PATH` enables the system to locate dynamic libraries during runtime.
`LIBRARY_PATH` directs the compiler to locate dynamic libraries during
compilation.

## Libtorch

The `CmakeLists.txt` is as follow.

```
cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(custom_ops)

set(CMAKE_CUDA_COMPILER /opt/cuda/bin/nvcc)
find_package(Torch REQUIRED)

add_executable(example-app example-app.cpp)
target_link_libraries(example-app "${TORCH_LIBRARIES}")
set_property(TARGET example-app PROPERTY CXX_STANDARD 17)
```

It will use `/usr/bin/gcc` and `/usr/bin/g++` to compile the source files. When
I add

```
set(CMAKE_C_COMPILER /usr/bin/gcc-13)
set(CMAKE_CXX_COMPILER /usr/bin/g++-13)
```

into the `CmakeLists.txt`, it reports
`The C compiler identification is GNU 13.3.0`. However, it also use
`/usr/bin/gcc` and `/usr/bin/g++` to compile the source files. Only if i
`rm /usr/bin/g++`, and `ln -s /usr/bin/g++-13 /usr/bin/g++`, it will use g++13.

The path of standard include directory for g++ is embeded in the binary file of
g++, and it has nothing with `CmakeLists.txt`.

# `make`

## Some Symbols

`$@` means the target file

`$^` means all the dependences

`$<` means the first dependence

`$?` means the dependences newer than the target file
