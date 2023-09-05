---
title: "ubuntu开启远程桌面可视化"
date: 2022-01-22
tags: ["vncs"]
categories: ["Linux"]
---

## ubuntu开启远程桌面可视化

首先要让系统具备可视化桌面的能力。

## 安装X-Window

X-Windows是一款桌面可视化系统。

执行以下命令

```bash
sudo apt-get install xserver-xorg
sudo apt-get install x-window-system-core
sudo apt-get install ubuntu-desktop
sudo dpkg-reconfigure xserver-xorg
sudo apt-get install gnome-core
sudo apt-get install gdm3 xscreensaver
sudo apt-get install ttf-arphic*
```



## 安装VNC SERVER

关闭VNC SERVER

```bash
vncserver -kill :1
```

