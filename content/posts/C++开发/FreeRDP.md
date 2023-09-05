---
title: "FreeRDP开源远程控制"
date: 2021-10-09
tags: ["远程控制"]
categories: ["C开发"]
---

# FreeRDP

FreeRDP是由C语言编写的一个远程桌面连接软件，使用标准的RDP协议。

#### 搭建编译环境

1、下载openssl和libusb三方库。

```bash
vcpkg.exe install openssl:x86-windows
vcpkg.exe install openssl:x64-windows
vcpkg.exe install libusb:x86-windows
vcpkg.exe install libusb:x64-windows
```

libusb:[https://github.com/libusb/libusb/releases](https://github.com/libusb/libusb/releases)

OpenSSL:http://slproweb.com/products/Win32OpenSSL.html

