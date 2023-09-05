---
title: "Cygwin和Wine"
date: 2021-08-11
tags: ["Cygwin","Wine"]
categories: ["Linux"]
---

​	在我们遇到与跨平台有关的一些事的时候，估计就会碰上这玩意。Cygwin提供了一个在Windows下面使用Linux环境的平台。

​	这个cygwin实现的原理大概就是依赖一个能在windows平台运行的核心库，叫做cygwin1.dll，这个模块提供了底层的Linux API的所有功能，从而达到欺骗linux程序，让它以为自己在linux上面运行的目的。好家伙，这不就是中间人攻击吗？

​	而Wine可谓是和Cygwin互补，是linux系统下一个用来模拟windows环境的程序。


