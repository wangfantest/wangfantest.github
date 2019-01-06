---
layout: post
title: 'GetWindowLong反调试两则'
date: 2018-11-04
categories: MarkDown
tags: 反调试 ollydbg
---

今天遇到了两个比较有意思的反调试.
### 窗口样式反调试

代码是摘自V校的,核心部分如下:
```C
	LONG mStyle = GetWindowLongA(hwnd, GWL_STYLE);
	LONG ExtStyle = GetWindowLongA(hwnd, GWL_EXSTYLE);
	if (mStyle == 0x57c70000 && ExtStyle == 0x140)
	{
		printf("find od 1 %d %s\r\n", hwnd, name);
	}
	if (mStyle == 0x56CF0000 && ExtStyle == 0x140)
	{
		printf("Find od 2 %d %s\r\n", hwnd, name);
	}
```
很明显就是检测OD窗口样式,不可否认,很少有窗口会和OD有相同的窗口样式,再加上利用了SetWinEventHook这个罕见API，检测效果还行.
#### 过检测
知道了原理后，我首先尝试进行修改窗口样式.

定位到创建窗口关键代码0x41CD92处,发现似乎只有这一个窗口是拥有这个样式的,很好,那么尝试修改其样式组合。
在进行一番尝试后，发现不能减少其样式组合,只有加上WS_HSCROLL或者WS_VSCROLL能够达到修改样式过检测的目的,然而这样OD的主调试窗口
会多上难看又派不上任何用处的滚动条.我不得不陷入了沉思,最后我试了试在创建的样式里加了个1,似乎就过掉了检测.
修改代码如下:0x0041CD5B mov ebx,0x57CF0001 

--------------------- 
--------------------- 

### OD窗口数据检测

要了解反调试原理首先得知道SetWindowLong(HWND hWnd,int nIndex,LONG dwNewLong)这个函数,网上查了一些资料如下:

一般情况下SetWindowLong可以用来设置窗口属性,其中的index一般为GWL_EXSTYLE(-20),GWL_STYLE(-16),GWL_WNDPROC(-4).

然而这些常量值都是负数(在API里面少见),这是因为正数代表着另一个含义.

注册窗口类时可以指定"窗口额外内存"(cbWndExtra),而这个窗口附加的额外数据正是通过正数的index来设置与访问,参数index就是偏移字节的意思.

OD这个程序的作者也许是为了程序代码的简洁性与优雅性,就将存储着窗口句柄的地址放在了这个窗口附加数据里面...这个地址是固定不变的.

那么反调试就是GetWindowLong(0~0xFFFFFF,0),判断返回值是否与这个固定的常量值相等即可.

#### 过检测

由于这项反调试针对性太强了,暴力搜索OD中的存储地址代码,全部修改成另一处地址理论上能完美过掉此反调试,然而涉及到的代码有上百处,实际上不现实.

我就选择了比较简单的方案——修改index偏移值,在RegisterClassA的时候增加cbWndExtra的大小(默认为0x32),然后再增大SetWindowLong中的index大小即可,这样的话修改的地方相对来说就少了很多,也不易出错.

这样作者要检测OD的话必须修改反调试代码为GetWindowLong(0~0xFFFFFF,0~0xFFFF),这样的话效率太低了,枚举法就失效了!!

附上修改代码如下:

##### 扩大窗口样式内存大小:

00454172 mov dword ptr ds:[edi+0xC],0x64 

0041C16D mov dword ptr ss:[ebp-0x15C],0x60



##### 修改SetWindowLong的index:

0041CDE8 push 0x60

0041CE4D push 0x60

0041CEB2 push 0x60

004534B9 push 0x60

00495413 push 0x60

##### 修改GetwindowLong的index:

0044E637 push 0x60

StrongOD $+D377 push 0x60

只修改了这么多,反反调试成功!后续BUG待定观察.