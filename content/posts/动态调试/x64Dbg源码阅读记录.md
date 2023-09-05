---
title: "x64Dbg源码阅读记录"
date: 2021-10-30
tags: ["x64Dbg"]
categories: ["x64Dbg"]
---

##### x64Dbg是如何绘制程序代码流程图的

首先在C++代码src\dbg\analysis\advancedanalysis.cpp有与代码流程算法与结构生成相关的代码，最后应该是转换成了dot格式吧。

之后在Qt代码src\gui\Src\Gui\DisassemblerGraphView.cpp有与流程图的显示、缩放之类相关的代码。

