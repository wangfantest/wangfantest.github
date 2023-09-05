---
title: "x64Dbg常用快捷键和命令"
date: 2022-02-19
tags: ["x64Dbg"]
categories: ["动态调试"]
---

## dump某一块内存

我们在使用调试器的时候，经常想要dump出某一块内存数据，这时候可以使用savedata命令，示例如下

```
savedata "D:\1.bin",0x401000,0x2A0
```

有三个参数，分别表示dump文件的保存地址，内存块起始地址，内存块大小。

