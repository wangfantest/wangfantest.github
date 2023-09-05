---
title: "QT入门之Windows开发环境搭建"
date: 2021-03-12
tags: ["入门","新手教程"]
categories: ["QT"]
---

QT是一个跨平台的C++开发库，主要用来开发图形用户界面程序，不过QT还自带很多其它的开发库，比如多线程、访问数据库、图像处理、音频视频处理、网络通信、文件操作等。

#### 参考教程

http://c.biancheng.net/qt/

#### 安装QT

由于QT版本较多，初学者建议选择稳定的老版本，而不是追求那些最新版本，否则可能踩各种坑，从而失去对QT的兴趣。

1. QT最后一个比较稳定且支持离线安装包版本是5.12，下载地址如下，自行选择一个版本即可，例如QT 5.12.10。

   https://download.qt.io/official_releases/qt/5.12/

   进入到安装界面后，在安装的组件中，`QT 5.12.10`部分选择以下项:

   - MSVC 2017 32-bit
   - MSVC 2017 64-bit
   - MinGW 7.3.0 32-bit

   而`Developer and Designer Tools`部分选择以下项:

   - Qt Creator 4.13.1 CDB Debugger Support
   - MinGW 7.3.0 32-bit
   
2. 因为我个人习惯了使用Visual Studio  2019，为了配合还需要下载一个VS插件，下载地址如下，选最新版的即可:

   https://download.qt.io/official_releases/vsaddin/

3. 在安装完成了上述两个程序，打开Visual Studio还需要配置一下QT的关键路径:

   Visual Studio菜单 -> 扩展 -> QT VS Tools -> Qt Versions，在此添加对应的QT版本，路径选择QT目录下的`qmake`程序，例如`C:\Qt\Qt5.12.10\5.12.10\msvc2017\qmake.exe`

