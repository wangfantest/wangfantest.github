---
title: "在Windows下搭建LLVM环境(一)"
date: 2021-01-06
tags: ["LLVM"]
categories: ["LLVM"]
---

LLVM是一个非常有名的开源编译器框架，由C++编写。

介绍:[LLVM - 维基百科，自由的百科全书 (wikipedia.org)](https://zh.wikipedia.org/wiki/LLVM)

Github项目地址:[llvm-project](https://github.com/llvm/llvm-project)



编译LLVM前需要准备的环境

- Git，工具地址为https://git-scm.com/download
- CMake，工具地址为https://cmake.org/download/
- Visual Studio 2017或者以上
- Python



#### 1.克隆代码仓库

执行以下命令即可

```bash
git clone --config core.autocrlf=false https://github.com/llvm/llvm-project.git
```

#### 2.配置VS工程

执行以下命令即可

```bash
cd llvm-project
mkdir build
cd build
cmake -DLLVM_ENABLE_PROJECTS=clang -G "Visual Studio 16 2019" -A x64 -Thost=x64 ..\llvm
```

这样就得到了生成好的LLVM.sln工程

#### 3.编译程序

在Visual Studio中打开LLVM.sln工程，里面项目有很多，还包含一些测试用例，如果全部编译的话，占用空间估计得上百G。



LLVM工程中的项目介绍:

##### Clang:

LLVM中的前端，可用来输出源代码对应的抽象语法树(Abstract Syntax Tree, AST)，并将代码编译成LLVM Bitcode，最后在后端编译出平台相关的机器语言。Clang命令行参数文档:[Clang command line argument reference](https://clang.llvm.org/docs/ClangCommandLineReference.html)

##### llvm-as

LLVM的汇编器，它可以将LLVM IR转换为bitcode(就像把普通的汇编代码转换为可执行文件)。

##### llvm-dis

LLVM的反汇编器，它可以将bitcode转回为LLVM IR。

##### llvm-link

LLVM bitcode的链接器，可以将多个bitcode链接成一个bitcode。

##### opt

LLVM模块化的优化器和分析器。可以通过使用PASS对LLVM IR或者LLVM bitcode进行优化处理。