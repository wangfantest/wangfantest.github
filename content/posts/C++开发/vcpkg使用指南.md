---
title: "vcpkg使用指南"
date: 2022-10-18
tags: ["高级C++","Windows"]
categories: ["C++开发"]
---

# vcpkg

微软开源的项目，地址为:https://github.com/microsoft/vcpkg

经常写C++的老铁们就知道使用一个三方库有麻烦，下载源码 -> 配置cmake -> 编译lib。。。

而使用vcpkg就可以做到一键编译lib。

入门教程:https://github.com/microsoft/vcpkg/blob/master/README_zh_CN.md

## 使用方式

```powershell
vcpkg install [package name]:x64-windows
```

例如，安装某个三方库

```
vcpkg install libevent:x64-windows-static
vcpkg install libevent:x64-windows-dynamic
vcpkg install libevent:x86-windows-static
vcpkg install libevent:x86-windows-dynamic
```

忘了填啥，使用vcpkg help triplets打印一下。



搜索项目库

```
vcpkg search xxx
```

