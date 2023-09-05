---
title: "Go语言菜鸟系列(一)环境搭建"
date: 2021-11-08
tags: ["笔记","Go"]
categories: ["Go语言"]
---

#### Go语言库

需要进行爬围墙:https://golang.org/

国内网站:https://studygolang.com/dl

#### 学习相关网站

https://www.topgoer.com/

#### 开发环境IDE

目前使用的是GoLand，下载地址:https://www.jetbrains.com/go/

GoLand是收费软件，需要配合无限试用插件，在GoLand插件市场，搜索Eval Reset，安装插件即可。

安装插件后，在Help -> Eval Reset中，勾选Auto reset before per restart，即每次重启都会重置试用时间。

另外，GoLand这败家玩意可能和自己从官网下载的go语言库有一些不兼容，如果出了什么问题的话，建议从File -> Settings -> GOROOT中让GoLand自己去远程下载SDK。。。。。。

#### 第一个main程序

```go
package main

import "fmt"

func main()  {
	fmt.Println("hello world")
}
```

很明显，package main中的main函数就是程序的入口。

#### 下载第三方库文件

go和python一样拥有第三方库镜像平台，在命令行中使用go get命令就可以下载，但是国内经常会出现无法访问的情况，这个时候需要设置镜像源为国内。

Windows Powershell输入以下命令，切换镜像源，有下面几种:

```powershell
go env -w GOPROXY=https://goproxy.io,direct
go env -w GOPROXY=https://goproxy.cn,direct
```

Linux输入以下命令

```bash
export GOPROXY=https://goproxy.io,direct
```

输入go env查看环境变量，来检查设置是否成功。

#### 项目结构

所谓项目结构，我认为可以比作是建房子，上面的砖头依赖下面的砖头，故下面的砖头不能再去依赖上面的砖头了，其难度在于如何划分出哪些代码是最下面的砖头。

在C语言里面由于定义和实现是分开的，因此不同的文件基本上都可以互相引用，舒服得很，但到了go语言这里就不行了，分分钟交叉引用编译不通过，遇到这种情况，开发者就要考虑到如何将一个模块，拆分成更多更细的子模块，实现功能解体，说简单点就是将A依赖B，B依赖A，拆分成A依赖C，B依赖C。

#### Goland项目配置介绍

选择Goland -> Run -> Edit Configurations可以对项目进行配置。

Output directory为可执行文件的输出目录，我一般设置为 `项目根路径\bin` 目录。

Working directory为可执行文件的工作目录，我一般设置为`项目根路径\bin` 目录。

Environment为go的环境变量，有以下几种设置(设置有多个的话，使用`;`符号进行连接):

| 变量   | 说明                   | 可选项         |
| ------ | ---------------------- | -------------- |
| GOOS   | 编译指令对应的操作系统 | windows、linux |
| GOARCH | 指令集架构             | amd64、386     |

Go Tool arguments为go的编译参数，例如go语言程序想去掉控制台界面显示，可以填入以下参数:

`-ldflags -H=windowsgui`





