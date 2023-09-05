---
title: "Ghidra反编译(一)"
date: 2021-08-09
tags: ["Ghidra"]
categories: ["反编译"]
---

​	Ghidra项目地址:https://github.com/NationalSecurityAgency/ghidra

​	在项目/Ghidra/Features/Decompiler/src/decompile/cpp目录下有一个C++写的开源反编译器。下载下来后一共有consolemain.cc、sleighexample.cc、slgh_compile.cc、test.cc、ghidra_process.cc这五个测试例子。

​	ghidra_process.cc对应生成的文件decompile.exe。

​	slgh_compile.cc对应生成的文件sleigh.exe。

​	test.cc是一些测试代码，不用管。

​	

​	项目代码适用于linux上的编译器，因为其使用了linux下的bfd库，如果要移植到windows平台上，就得重写项目中loadimage_bfd.hh和loadimage_bfd.cc这两个文件。



#### consolemain项目

```bash
load file 123.exe
load addr 0x4C0
decompile
print C
```



#### 项目文件介绍

项目中有doccore.hh和docmain.hh这两个帮助文档。

代码中还有几个比较有有用的例子，例如consolemain.cc、sleighexample.cc、slgh_compile.cc，可以让我们快速理解代码的运行。

| 类               | 说明                                               |
| ---------------- | -------------------------------------------------- |
| UserPcodeOp      | 用户自定义的Pcode操作指令，指令类型都属于CALLOTHER |
| Pattern          | 指令匹配模板                                       |
| StringManager    | 字符串管理类                                       |
| ParamList        | 函数参数列表                                       |
| Symbol           | 符号相关                                           |
| Scope            | 命名空间或者函数范围，用来区分Symbol符号           |
| Datatype         | 变量、函数的数据类型                               |
| **Action**       | 用来表示代码具体执行的行为动作。                   |
| **LoadImage**    | 二进制文件加载至映像内存中                         |
| **Architecture** | 针对LoadImage实例化的处理器类                      |
| **Translate**    | 根据处理器将指令数据转换为汇编代码或者pcode。      |
| PrintLanguage    | 生成高级语言                                       |
| PcodeEmit        | Pcode生成器                                        |
| TransformManager | 根据数据流对代码逻辑进行转换                       |
| MemoryBank       | 用来表示二进制文件中的虚拟内存                     |
| JumpModel        | 跳转表模型                                         |
| TypeModifier     | 类型修饰符                                         |
| Emulate          | 基于Pcode的代码模拟执行                            |
| Widener          | 值扩展类，将值的字节大小自动进行扩充。             |
| CapabilityPoint  | 反编译器的扩展能力。                               |
| Rule             | 用来表示反编译规则。                               |
| FlowBlock        | 控制流基本块。                                     |
| TypeOp           | Op指令的类型大全                                   |

#### Address

用来表示地址，主要是用来存储offset这一个字段。

#### P-Code

p-code 可以理解为一种新的指令集，能够适用于任何处理器的语言。

### VarNode

varnode可以理解为pcode的组成参数。

```
例如一条PUSH 0x0指令 可以理解为
var tmp = 0x0
esp = esp - 0x4
[esp] = tmp

[40101e]:(unique,0x2f200,4) = COPY (const,0x0,4)
[40101e]:(register,0x10,4) = INT_SUB (register,0x10,4) (const,0x4,4)
[40101e]:STORE (const,0x1def5c9fdd0,8) (register,0x10,4) (unique,0x2f200,4)
```



#### 结构体解读

1、Varnode

变量节点，可以理解为pCode指令对应的变量，一个变量节点可以用来表示任何数据，包括寄存器、堆栈、内存、常量。

不同变量节点通过Address来进行标记。

2、FuncData

函数可以理解为Ghidra重要的反编译基本单位，此结构体包含与函数反编译有关的一切。

包含控制流、数据流、数据类型信息、跳转表、参数，其中比较重要的几个函数有:

startProcessing()，开始对函数进行基本的分析。

followFlow()，跟踪代码流程，并根据遇到的每句汇编指令生成原始的PCode。

printBlockTree()，打印出控制流结构体。

numCalls()，getCallSpecs()，可用来遍历函数内的call指令信息。



#### 源码解读

1、initializeProcess函数(DecompInterface.java) ->

2、decompProcess.registerProgram函数

| 文件                 | 类              | 说明                                                   |
| -------------------- | --------------- | ------------------------------------------------------ |
| DecompInterface.java | DecompInterface | 与反编译进程通讯的接口类                               |
| Program.java         | Program         | 用来表示一个完整的程序，包括内存、函数、标签、符号等。 |
|                      |                 |                                                        |



#### 代码分析

将汇编指令转换为OP指令

```c++
int4 Sleigh::oneInstruction(PcodeEmit& emit, const Address& baseaddr) const
{
	SleighBuilder builder;
	try {
		builder.build(walker.getConstructor()->getTempl(), -1);
		pcode_cache.resolveRelatives();
		pcode_cache.emit(baseaddr, &emit);
	}
	catch (UnimplError& err) {
		...
	}
}
```



```


FlowInfo::generateOps
生成所有的op列表

FlowInfo::setupCallSpecs
根据类型为CPUI_CALL的opcode生成FuncCallSpecs。

```

