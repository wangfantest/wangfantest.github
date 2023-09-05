---
title: "linux安装nload命令"
date: 2021-11-10
tags: ["nload"]
categories: ["Linux"]
---

## 安装nload工具

nload可以用来查看linux网络流量，用来实时监测网络流量和带宽使用情况。

```bash
yum install gcc
yum install gcc gcc-c++ gcc-g77
sudo yum -y install ncurses
sudo yum -y install ncurses-devel
yum install wget
#下载源码编译安装
wget http://www.roland-riegel.de/nload/nload-0.7.2.tar.gz 
tar zxvf nload-0.7.2.tar.gz
cd nload-0.7.2
./configure
make
make install
```

