---
title: "Unicorn笔记"
date: 2022-09-21
tags: ["Unicorn"]
categories: ["动态调试"]
---

​	Unicorn这个引擎接口比较简单，比较容易上手，但是在实际使用的过程中还是会遇到不少问题的。

1、执行异常指令

例如执行下面的这种指令

```assembly
FF15 64C24700	call dword ptr ds:[0x47C264]	kernel32.GetCurrentThreadId
```

很明显这是个系统API调用CALL，unicorn无法找到调用的地址，会抛出一个UC_MEM_FETCH_UNMAPPED异常。问题就在于抛出这个异常之后，Esp寄存器发生了偏移，相较于之前偏移了-4。

我们可以尝试猜测一下:由于call指令可以近似分解为push nextInsAddr + jmp callAddr两步，unicorn在执行这条指令的时候很有可能是第一段push执行成功，后面的jmp则执行失败了，因此导致Esp寄存器偏移了-4，同时Eip地址发生错乱，变成了-1。

那么我们在使用unicorn模拟器的时候就要想办法去解决这种问题。

