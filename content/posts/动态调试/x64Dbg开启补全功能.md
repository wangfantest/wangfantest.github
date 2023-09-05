---
title: "x64Dbg开启补全功能"
date: 2021-07-04
tags: ["x64Dbg"]
categories: ["杂文"]
---

​	x64Dbg的Ctrl+G功能，有的时候能够自动补全Api名称，有的时候不行，我一开始没太注意这个功能，后来观察x64Dbg的源码才发现，作者设置了x32Dbg.ini两个配置项，CaseSensitiveAutoComplete和DisableAutoComplete。

- CaseSensitiveAutoComplete：用来设置补全功能是否大小写敏感。

- DisableAutoComplete：是否禁用自动补全功能。

  将这两个配置项都设置为0就好了。

​	