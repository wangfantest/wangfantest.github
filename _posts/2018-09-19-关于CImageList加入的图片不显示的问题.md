---
layout: post
title: '关于CImageList加入的图片不显示的问题'
date: 2018-09-19
categories: C语言学习
cover: '/assets/img/timg.jpg'
tags: C语言 CTreeCtrl CImageList 易失误
---

今天在为CTreeCtrl中的项目添加图标的时候
用到了如下代码
```C
CImageList m_ICO;
m_ICO.Create(16,16,ILC_COLOR24,2,0);
m_ICO.Add(AfxGetApp()->LoadIcon(IDI_ICON1));
m_ICO.Add(AfxGetApp()->LoadIcon(IDI_ICON2));
m_Tree.SetImageList(&m_ICO,TVSIL_NORMAL);
m_Tree.SetItemImage(ControlID, 0, 1);
```
调试了很久,查看函数的返回值也完全正确！！！然而就是不显示图片...
最后才发现原来CImageList这个局部变量应该设置为对象内部变量或者全局变量.
设置成局部变量的话图片就被释放掉了,我终于知道C语言为什么这么难用了......
![坑爹](/assets/img/坑爹.gif)