---
title: "LLVM整体架构(二)"
date: 2021-01-07
tags: ["LLVM","Clang"]
categories: ["LLVM"]
---



#### 前端代码生成LLVM IR

使用以下命令将源代码转换成LLVM IR文本。

```bash
clang -emit-llvm -S test.c -o test.ll
```



#### 前端代码生成可执行程序

基本选项是定义目标体系结构，语法为`-target <triple>`

triple的格式一般为`<arch><sub>-<vendor>-<sys>-<abi>`，其中:

- `arch` = `x86_64`、`i386`、`arm`、`thumb`、`mips`等
- `sub` = 与`arch`对应，例如在ARM上有 `v5`、`v6m`、`v7a`、`v7m`等。
- `vendor` = `none`、`linux`、`win32`、`darwin`、`cuda`等
- `abi` = `eabi`、`gnu`、`android`、`macho`、`elf`等

简单举个例子就清楚了，例如对于某个test.c文件，我们想要将它编译成不同平台下的可执行程序。

如果想要编译成Windows下的64位可执行程序，使用以下命令行即可

```bash
clang test.c -target x86_64-pc-windows-msvc
```

在上面这个例子中，`arch`就是x86_64，`sub`则没有，`vendor`是pc，`sys`是windows，`abi`是msvc。

另外如果我们想要编译成Windows下的32位可执行程序，使用以下命令行即可

```bash
clang test.c -target i386-pc-windows-msvc
```



#### LLVM IR生成可执行程序

使用clang可以直接将LLVM IR编译成可执行文件，命令如下

```bash
clang test.ll -o test.exe
```

