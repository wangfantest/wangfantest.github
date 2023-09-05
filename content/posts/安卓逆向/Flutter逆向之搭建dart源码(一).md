---
title: "Flutter逆向之搭建dart源码(一)"
date: 2022-11-06
tags: ["Flutter","Dart"]
categories: ["安卓逆向"]
---

​	Flutter难就难在Dart部分的逆向，这又是一套字节码执行引擎，目前没有好用的反编译工具。

1、先了解了解Dart语言吧

https://dart.dev/overview

博客

https://blog.tst.sh/reverse-engineering-flutter-apps-part-1/



2、来到项目地址https://github.com/dart-lang/sdk，发现搭建项目需要准备以下条件:

- Visual Studio 2022 社区版。

- Windows调试SDK，安装方法https://stackoverflow.com/questions/46237620/how-to-install-debugging-tools-with-visual-studio-2017-installer

- gclient，看起来像是Google自家的项目管理工具，下载地址是:https://www.chromium.org/developers/how-tos/depottools/，添加环境变量。

- 安装Python3，添加环境变量。

- 添加环境变量DEPOT_TOOLS_WIN_TOOLCHAIN为0

  

![调试SDK](/images/Dart/修改示意图.png "调试SDK")



3、创建目录sdk，执行下载源码指令

使用cmd

```bash
fetch dart
```

如果出现HTTP/2 stream 1 was not closed cleanly before end of the underlying stream错误，试试以下命令：

```bash
git config --global http.version HTTP/1.1
git config --global http.postBuffer 524288000
```

如果网络环境不太好，可以去vultr租一个服务器，把下载好的包上传到Google云盘，再拉回来。。。。。。



4、生成项目

使用powsershell

```powershell
cd sdk
python3 ./tools/build.py --no-goma --mode debug --arch x64 create_sdk
#只生成runtime
python3 ./tools/build.py --mode debug --arch x64 runtime
```

如果出现`You must install Windows 10 SDK version 10.0.20348.0 including the "Debugging Tools for Windows" feature`错误，安装对应版本的Windows调试SDK。

如果出现xxx.gn文件缺失，且执行`gclient sync`命令之后错误依然出现，可以直接删掉整个目录从第三步开始。



5、编译不同的版本

事实上，后面我们会知道每个dart版本都有一个不同的hash值，我们需要根据该值来编译不同的版本源码。

关于如何切换到指定的分支，首先找到dart版本对应的commit，执行以下命令

```bash
git checkout 5aa5cd76f00e7774f71367f34d9998cfa0034d04
git clean -ffd
gclient sync -D --force --reset
gclient sync -D --force --reset --with_branch_heads
git -c core.deltaBaseCacheLimit=2g clone checkout 73c34f2ad73f3d5e89680206a3beabb510be818c --progress https://dart.googlesource.com/sdk.git
```



## 参考资料

https://www.pnfsoftware.com/blog/dart-aot-snapshot-helper-plugin-to-better-analyze-flutter-based-apps/

[Reverse engineering Flutter apps (Part 1) (tst.sh)](https://blog.tst.sh/reverse-engineering-flutter-apps-part-1/)
