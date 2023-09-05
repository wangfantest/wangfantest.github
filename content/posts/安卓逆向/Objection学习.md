---
title: "Objection学习"
date: 2022-11-22
tags: ["Objection"]
categories: ["安卓逆向"]
---

# Objection学习

## 安装

```bash
pip3 install -U objection
```

## 注入

常规注入

```bash
objection -g zs.miaohui.xin explore
```

启动注入

```bash
objection -g zs.miaohui.xin explore --startup-command "android hooking watch class xxx"
```

## 探索

打印内存中的所有类

```bash
android hooking list classes
```

搜索类名

```bash
android hooking search classes <name>
```

搜索方法

```bash
android hooking search methods <name>
```

查看指定类的方法列表

```bash
android hooking list class_methods <name>
```

列出所有的活动

```bash
android hooking list activities
```

监控某一个类

```
android hooking watch class <name> --dump-args --dump-return --dump-backtrace
```



## 主动调用

```bash
android heap search instances <classname>
```

