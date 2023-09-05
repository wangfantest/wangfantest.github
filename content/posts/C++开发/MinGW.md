---
title: "MinGW编译器"
date: 2021-08-09
tags: ["MinGW"]
categories: ["C++开发"]
---

​	懒癌犯了，这里简要介绍一下吧。

​	MinGw就是一个编译器，你可以理解为和Visual Studio差不多的一个玩意儿，只不过MinGw更原始质朴，Visual Studio则进行了大量封装。

​	比较好的下载地址是:

https://www.mingw-w64.org/downloads/

https://sourceforge.net/projects/mingw-w64/files/Toolchains targetting Win64/Personal Builds/mingw-builds/

https://github.com/niXman/mingw-builds-binaries/releases

​	下载完成后，bin目录下有一个mingw32-make.exe程序，这个就是强大的make指令了，可以像linux上那样根据makefile文件进行make 编译。



mingw不同版本的区别

1、dwarf则只能用于32位程序

2、seh只能用于64位程序

3、sjlj适合32/64位程序，但是它会带来轻微的性能损失



win32，更接近windows原始api。posix，使用现代化api。

