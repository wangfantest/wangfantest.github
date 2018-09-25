---
layout: post
title: 'OD命令行BUG导致的GetCommandLine反调试'
date: 2018-09-19
categories: ollydbg
tags: ollydbg bug修复 反调试
---

原来OD一直有一个bug,就是在CreateProcessA创建EXE进程的时候,传入的命令行参数和不在OD里调试的命令行参数不一致！！！
这就导致可以利用这个BUG,使用GetCommandLine进行检测OD调试器.

例如
某个程序默认打开的命令行如下:
"D:\\test.exe" 

用十六进制形式表示则为
22 44 3A 5C 5C 74 65 73 74 2E 65 78 65 22 20
	
---
那么在调试器内打开，命令行则为:
"D:\\test.exe"

看起来和程序不在调试器内打开的一样是吗?

然而实际上十六进制形式表示则为
22 44 3A 5C 5C 74 65 73 74 2E 65 78 65 22

其实说白了就是利用了命令行后是否有一个空格符来检测是否为反调试....
知道了这个bug就很好处理了,可以定位到OD关键代码处0x00477925,对此处进行patch即可修正此BUG

此外我还对其它调试器进行了测试,发现YZDBG和X32DBG都有这个BUG,看样子这个反调试还是挺厉害的啊.....
![坑爹](/assets/img/坑爹.gif)