---
title: "Go语言使用QT界面库"
date: 2022-04-05
tags: ["Go","GUI","QT"]
categories: ["Go语言"]
---

## Go语言使用QT界面库

Go语言要使用QT库的话，装起来也是比较麻烦

项目地址:https://github.com/therecipe/qt

文档地址:https://github.com/therecipe/examples

1、首先需要安装QT库，根据文档介绍来看，目前项目使用的版本是5.13.0，推荐保持一致，不然可能会出问题。

https://download.qt.io/archive/qt/5.13/5.13.0

安装的时候需要参考issue:https://github.com/therecipe/qt/issues/939，也就是在安装选项中需要选择`Qt Script (Deprecated)`这一选项，不然后面会出错。

2、下载完成后，安装Mingw64位版本，对应编译出来的64位Go语言程序。

3、将Go语言bin目录添加到path环境变量，在cmd中敲一下go version，看看能不能用就是了。

4、安装Go语言版本的QT库，命令如下，可能会执行比较久的时间。

```powershell
go get -u -v github.com/therecipe/qt/cmd/qtsetup
go get -u -v github.com/therecipe/qt/cmd/...
```

5、配置好环境变量

```powershell
SET PATH=%PATH%;%GOPATH%\bin;

REM 配置Qt目录和Qt版本
SET QT_DIR=D:\Qt\Qt5.13.0
SET QT_API=5.13.0
SET QT_VERSION_MAJOR=5.13.0

REM 编译32位程序用386
SET GOARCH=amd64

REM 默认使用Mingw编译，使用MSVC编译的话开启下面的选项，qtsetup可以运行，但是后面qtdeploy会报cgo相关错误
REM SET QT_MSVC=true
REM SET PATH=%PATH%;C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build;
REM call vcvarsall.bat amd64_x86

qtsetup
```

6、编译工程的时候，使用以下命令行

```bash
qtdeploy build
```



## 有的时候编译工程不通过

使用qtdeploy命令编译工程，有的时候会失败。

这个时候可以试试先运行qmoc，再运行qtdeploy，玄学。

