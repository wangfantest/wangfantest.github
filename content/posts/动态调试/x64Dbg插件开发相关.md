---
title: "x64Dbg插件开发相关"
date: 2021-10-16
tags: ["x64Dbg"]
categories: ["动态调试"]
---

## x32gui.dll

此模块是调试器界面，核心函数为processMessage，处理着所有的界面消息。

```c++
void* Bridge::processMessage(GUIMSG type, void* param1, void* param2)
```

## GUI模块

#### SelectionGet

```c++
bool SelectionGet(Window window, duint* start, duint* end);
```

获取指定窗口的光标选中区域。

#### SelectionSet

```c++
bool SelectionSet(Window window, duint start, duint end);
```

设置指定窗口的光标选中区域。

## Memory模块

#### Read

```c++
bool Read(duint addr, void* data, duint size, duint* sizeRead);
```

读取被调试进程内存中指定大小的数据。

#### Write

```c++
bool Write(duint addr, const void* data, duint size, duint* sizeWritten);
```

写入数据到被调试进程的内存中。

#### RemoteAlloc

```c++
duint RemoteAlloc(duint addr, duint size);
```

在被调试器的进程中申请指定大小内存。

#### GetBase

```c++
duint GetBase(duint addr, bool reserved = false, bool cache = true);
```

获取指定地址所在内存区域的基址。

#### GetSize

```c++
duint GetSize(duint addr, bool reserved = false, bool cache = true);
```

获取指定地址所在内存区域的大小。

#### ReadDword

```c++
unsigned int ReadDword(duint addr);
```

读取指定地址四字节大小。



## Main模块

#### GuiAddLogMessage

```c++
void GuiAddLogMessage(const char* msg);
```

在x64Dbg的日志窗口打印一条消息。

#### GuiDisasmAt

```c++
void GuiDisasmAt(duint addr, duint cip);
```

设置反汇编窗口指向的反汇编地址。

#### DbgIsDebugging

```c++
bool DbgIsDebugging();
```

判断当前调试器是否处于调试状态，未载入文件进行调试返回false，否则返回true。

#### DbgGetProcessHandle

```c++
HANDLE DbgGetProcessHandle();
```

获取当前被调试进程的句柄

#### DbgCmdExec

```c++
bool DbgCmdExec(const char* cmd);
```

将x64Dbg命令加入执行队列后立即返回。

#### DbgCmdExecDirect

```c++
bool DbgCmdExecDirect(const char* cmd);
```

执行x64Dbg命令，此函数等待命令执行完成才会后返回。

#### GuiSetFavouriteToolShortcut

```c++
void GuiSetFavouriteToolShortcut(const char* name, const char* shortcut);
```

设置收藏工具的快捷键



## Pattern模块

#### FindMem

```c++
duint FindMem(duint start, duint size, const char* pattern);
```

搜索内存中的数据，支持模板匹配

