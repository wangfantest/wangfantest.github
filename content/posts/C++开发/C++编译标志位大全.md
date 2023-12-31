---
title: "C++编译标志位大全"
date: 2022-12-13
tags: ["C++"]
categories: ["C++开发"]
---

有如下标志位:

## 常规

启用字符串池(是|否)，/GF	/GF-

启用最小重新生成(是|否)，/Gm	Gm-

启用C++异常(是)，/EHsc	

启用C++异常(是，但有 SEH 异常)，/EHa

启用C++异常(是，且有 Extern C 函数)，/EHs

较小类型检查(是)，/RTCc

基本运行时检查(堆栈帧)，/RTCs

基本运行时检查(未初始化的变量)，/RTCu

基本运行时检查(堆栈帧 + 未初始化的变量)，/RTC1 或者 /RTCsu

运行库(多线程)，/MT

运行库(多线程调试)，/MTd

运行库(多线程 DLL)，/MD

运行库(多线程调试 DLL)，/MDd

结构成员对齐(1|2|4|8|16字节)，/Zp1	/Zp2	/Zp4	/Zp8	/Zp16

启用安全检查(是|否)，/GS	/GS-

控制流防护(是)，/guard:cf

启用函数级链接(是|否)，/Gy	/Gy-

## 优化

优化(禁用):/Od

最大优化(优选大小):/O1

最大优化(优选速度):/O2

优化(优选速度):/Ox

内联函数扩展(禁用):/Ob0

内联函数扩展(只适用于 __inline ):/Ob1

内联函数扩展(任何适用项 ):/Ob2

启用内部函数(是):/Oi

优化大小或速度(代码大小优先):/Os

优化大小或速度(代码速度优先):/Ot

省略帧指针(是|否):/Oy	/Oy-

启动纤程安全优化(是):/GT

全程序优化(是):/GL
