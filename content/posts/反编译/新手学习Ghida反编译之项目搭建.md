# 新手学习Ghida反编译之项目搭建

反编译是逆向的核心，然而这方面的研究似乎并不多，ida反编译固然强大，然而对外只提供了残缺的sdk，retdec更倾向于是实验品，且已停止维护。Ghidra是目前能在网上找到的最强开源反编译器了。

因此写一篇记录方便更多人入门学习该项目。



项目地址:

https://github.com/NationalSecurityAgency/ghidra

其中界面和逻辑处理部分的代码是用java写的，然而核心的反编译部分是用C++写的，完全可以剥离出来一个独立项目。

反编译部分的代码位于https://github.com/NationalSecurityAgency/ghidra/tree/master/Ghidra/Features/Decompiler/src/decompile/cpp



使用Visual Studio新建一个空项目，直接拖入全部的代码，然后编译之。。。

这样肯定是不能通过的，需要进行一些项目修复:

1、在C/C++ -> 预处理器上添加预处理器定义

```
_CRT_SECURE_NO_WARNINGS
_WINDOWS
```

C/C++ -> 常规 -> SDL检查，改为否

高级 -> 字符集，使用多字节字符集

2、处理loadimage_bfd文件

由于loadimage_bfd类中引用了bfd这个库，这个类主要是用来解析PE、符号，读取二进制数据相关的功能，而msvc编译器是不支持的，因此可以直接移除loadimage_bfd.hh、loadimage_bfd.cc、bfd_arch.hh、bfd_arch.cc这几个文件，或者自己写个类来代替。



ghidra_process.cc、sleighexample.cc、slgh_compile.cc、test.cc、consolemain.cc这几个文件中有main函数，想编译哪个项目，就移除其它的cc文件即可。

test.cc看起来像是做单元测试用的，直接移除。

ghidra_process看起来像是编译一个反编译后台进程给Ghidra前端用的，也直接移除。

slgh_compile.cc看起来像是和Sleigh编译器有关，这里抄一下gpt的解释

> 在Ghidra项目中，`slgh_compile.cc`文件是用于编译Sleigh语言的编译器的源代码文件。Sleigh语言是一种特定于Ghidra的领域特定语言（DSL），用于描述处理器指令集的语义和模式。
>
> Sleigh编译器负责将Sleigh语言描述的处理器指令集编译成中间表示形式，以便Ghidra可以使用它来进行二进制代码的逆向工程和分析。`slgh_compile.cc`文件实现了Sleigh编译器的主要逻辑和算法。

这里暂时用不上，如果要移除，需要将与之有关的slghparse、slghscan文件也一并移除，或者直接去掉main函数。

sleighexample.cc比较有用，作用是输入一段二进制，可以用来反汇编、打印pcode或者是模拟执行。

consolemain.cc算是一个完整的控制台，输入一个文件，可以执行反编译打印源码等一系列操作。





这里只说明一下consolemain这个项目，首先里面有一个startDecompilerLibrary函数，这个函数作用是用扫描sleigh一些预定义数据文件的，这个文件一般在Ghidra/Processors/*/data/languages目录里面，函数参数的话传入Ghidra反编译程序的根目录就行了。之前说的loadimage类，需要自己进行补充，这里可以参考一下这个项目https://github.com/airbus-cert/Yagi/blob/main/yagi/src/idaloader.cc

跑起来后是一个控制台，输入类似下面的命令:

```powershell
load file C:\123.exe
load addr 0x401000
decompile
print C
```

就能够完成反编译流程，输出源码文件了。







