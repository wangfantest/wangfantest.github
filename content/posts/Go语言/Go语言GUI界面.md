---
title: "Go语言编写GUI界面"
date: 2021-12-26
tags: ["Go","GUI"]
categories: ["Go语言"]
---

# 界面库介绍



## 1、fyne(16k收藏)

项目地址:https://github.com/fyne-io/fyne

自写的的界面库，语法和qt那种一样，体积较大，编译一个demo也要20MB。

优点:跨平台，代码维护性好。

缺点:体积较大、自写库需要时间学习。



刚刚接触可能会不太适应，需要一定的学习成本。这个项目可能是比较不错的小型GUI解决方案了，就是千万别拿来写复杂项目。

## 2、webview(10k收藏)

项目地址:https://github.com/webview/webview

优点:基于webkit组件，体积较小。

缺点:前端写界面哦买噶。

## 3、Walk(6k收藏)

项目地址:https://github.com/lxn/walk

优点:对Windows很友好

缺点:只支持Windows，界面布局很难设计。



在使用的过程中，我卡在了如何设计界面布局这里。。。

## 4、govcl(2k收藏)

项目地址:https://github.com/ying32/govcl/

示例文件:https://github.com/ying32/govcl/tree/master/samples

文档地址:https://gitee.com/ying32/govcl/wikis/pages?sort_id=2030600&doc_id=102420

优点:跨平台，代码可信度高，毕竟是基于前人的Delphi界面库，有背书。

缺点:需要模块，需要比较了解GTK这一块的知识。



在开发的过程中发现可用函数太少了，还得去下载专门的UI设计器，太麻烦了。

## 5、qt(9k收藏)

项目地址:https://github.com/therecipe/qt

优点:熟悉QT，入手起来有优势，项目维护好。

缺点:QT配置较为复杂。

相关资料:

https://zhuanlan.zhihu.com/p/191591015

## 6、electron(4k收藏)

项目地址:https://github.com/asticode/go-astilectron

## 7、炫彩GUI

项目地址:https://github.com/twgh/

相关文档:http://www.xcgui.com/doc-ui/page__basic_example.html



初看起来很不错，但是实际编写代码的时候发现很难使用，感觉像是一个不懂界面设计的人写出来的实验作品，如果作者能够持续不断优化的话或许有一天也能用了。

## 8、GIU

项目地址:https://github.com/AllenDang/giu

示例文件:https://github.com/AllenDang/giu/tree/master/examples

## 参考资料

https://github.com/avelino/awesome-go#gui

# 总结

需要跨平台，并且只是一个简单的UI，优先选择Fyne。

Windows平台界面，选择walk > govcl。

一个能打的都没有，缺点都很多。

......

2022年11月10日，用Go语言写GUI，我已经放弃了。

2022年11月20日，又试了试用Fyne写GUI，还不如学C#呢，我已彻底疯狂。

