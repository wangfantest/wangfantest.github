---
title: "RetDec反编译器学习"
date: 2022-04-25
tags: ["RetDec"]
categories: ["反编译"]
---

## 项目地址

https://github.com/avast/retdec

## 编译前置条件

该项目引用了不少github远程库，你得有比较好的网络环境，不然国内网络你懂的。我自己也是用SSR + SSTap才在visual studio中成功编译出了该项目。

## 编译时遇到的坑

我在编译最新版的retdec-decompiler的时候，发现编译authenticode这个项目会出错，而且错误莫名奇妙，如下所示:

```
在 <未知>“null”后添加了“14455024”字节填充
```

后来发现是项目附加包含目录中没有OpenSSL。

## capstone2llvmir

是retdec反编译器的核心库，负责将二进制指令转换为llvmir。

核心函数是Capstone2LlvmIrTranslator::translate，调试了一下发现原理没那么复杂，稍微懂点反汇编和LLVM基础应该都能理解。

首先基于Capstone反汇编器将指令解析出来，之后基于LLVM库将这些PUSH,CALL指令转换成等价的LLVM基本指令。

## bin2llvmir

从名字可以猜到，在capstone2llvmir的基础上，将二进制文件转换llvmir。

## retdec-decompiler

反编译器exe示例程序。

1、核心函数就一个retdec::decompile，首先是调用initializeLlvmPasses初始化Pass，这里要注意的是，项目中的PASS是以静态模板类的方式注册的，例如下面这种:

```c++
static RegisterPass<SyscallFixer> X(
		"retdec-syscalls",
		"Syscalls optimization",
		false, // Only looks at CFG
		false // Analysis Pass
);
static RegisterPass<LlvmIrWriter> X(
		"retdec-write-ll",
		"Generate the current LLVM IR",
		 false, // Only looks at CFG
		 false // Analysis Pass
);
//........
```

retdec注册的pass按照decompiler-config.json配置文件中的顺序进行添加，一共有以下:

| 类                      | pass                         | 作用                         |
| ----------------------- | ---------------------------- | ---------------------------- |
| ProviderInitialization  | retdec-provider-init         | 初始化信息                   |
| Decoder                 | retdec-decoder               | 将二进制解码成LLVM IR        |
| X86AddressSpacesPass    | retdec-x86-addr-spaces       | 针对x86进行地址优化          |
| X87FpuAnalysis          | retdec-x87-fpu               | Fpu寄存器优化                |
| MainDetection           | retdec-main-detection        | main函数检测                 |
| IdiomsLibgcc            | retdec-idioms-libgcc         |                              |
| Idioms                  | retdec-idioms                |                              |
| InstructionOptimizer    | retdec-inst-opt              | 指令优化，这个pass会多次调用 |
| CondBranchOpt           | retdec-cond-branch-opt       | 条件跳转优化                 |
| SyscallFixer            | retdec-syscalls              | 优化syscall                  |
| StackAnalysis           | retdec-stack                 | 堆栈分析                     |
| ConstantsAnalysis       | retdec-constants             | 常量分析                     |
| ParamReturn             | retdec-param-return          |                              |
| InstructionRdaOptimizer | retdec-inst-opt-rda          |                              |
| SimpleTypesAnalysis     | retdec-simple-types          | 简单的数据类型分析           |
| DsmWriter               | retdec-write-dsm             |                              |
| AsmInstructionRemover   | retdec-remove-asm-instrs     |                              |
| ClassHierarchyAnalysis  | retdec-class-hierarchy       |                              |
| SelectFunctions         | retdec-select-fncs           |                              |
| UnreachableFuncs        | retdec-unreachable-funcs     |                              |
| RegisterLocalization    | retdec-register-localization |                              |
| ValueProtect            | retdec-value-protect         | 变量保护，防止过度优化       |
|                         |                              |                              |
| StackPointerOpsRemove   | retdec-stack-ptr-op-remove   | 堆栈操作优化                 |
| PhiRemover              | retdec-remove-phi            |                              |
| LlvmIrWriter            | retdec-write-ll              | 生成LLVM IR                  |
| BitcodeWriter           | retdec-write-bc              | 生成bitcode信息              |
| LlvmIr2Hll              | retdec-llvmir2hll            |                              |
| ConfigWriter            | retdec-write-config          | 生成配置信息                 |
| DumpModule              | retdec-dump-module           |                              |

# LLVMPASS分析

## retdec-provider-init

程序首先执行这个pass，主要用来初始化变量，没啥好说的。

## retdec-decoder

这个是比较关键的的pass，将二进制中的每条指令全部解码转成LLVM IR。

Decoder::decode函数，一边翻译地址一边确定函数范围。

Decoder::initEnvironmentAsm2LlvmMapping函数，这个初始化函数是为了在转换出的LLVMIR里添加和原始ASM有关的元数据，方便后面解析LLVMIR。

例如指令**mov ebx,0x6;call 0x00401004**转换成了下面的LLVMIR:

```
; 0x40100f
  store volatile i64 4198415, i64* @_asm_program_counter
  store i32 6, i32* @ebx
; 0x401014
  store volatile i64 4198420, i64* @_asm_program_counter
  %5 = load i32, i32* @esp
  %6 = sub i32 %5, 4
  %7 = inttoptr i32 %6 to i32*
  store i32 4198425, i32* %7
  store i32 %6, i32* @esp
  call void @__pseudo_call(i32 4198404)
  %8 = call i32 @sub_401004()
  store i32 %8, i32* @eax
```

Decoder::finalizePseudoCalls，处理pseudo_call

pass是通过Config参数中的isSelectedDecodeOnly()函数来决定是反编译函数还是反编译整个bin的，通过遍历所有的跳转来得到可行路径，将decoder_debug.h中的变量debug_enabled设置为true，则会打印出日志。

## ParamReturn

ParamReturn::collectExtraData函数尝试从config中采集函数的声明信息。

## LlvmIr2Hll

将LLVMIR转换为源码。

basic、simple、c、strict、dot、optim、pessim、readable
