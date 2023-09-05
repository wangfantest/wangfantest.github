---
title: "IDA7.5支持中文的办法"
date: 2021-04-10
tags: ["IDA"]
categories: ["静态分析"]
---

### 解除函数名称的限制

默认配置情况下我们是不能将函数名称修改为中文的，会提示bad character，意思就是包含非法字符，那么怎样让中文成为合法的字符呢？

通过在网上查找资料，这个合法字符的定义在ida.cfg文件中，我们定位到文件，搜索Block_CJK_Unified_Ideographs，如下图所示:

```ida.cfg
// the following characters are allowed in user-defined names:

NameChars =
        "$?@"           // asm specific character
        "_0123456789"
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        "abcdefghijklmnopqrstuvwxyz",
        // This would enable common Chinese characters in identifiers:
        // Block_CJK_Unified_Ideographs,
        CURRENT_CULTURE;
```

我们去掉`Block_CJK_Unified_Ideographs`这一行前面的注释，就可以给函数名字起中文了。

### 解除IDA反汇编代码限制

虽然通过上述操作函数可以起名为中文，但是实际上使用F5功能的时候，得到的伪代码，中文函数名称却会变成下划线，如下图所示:

![中文变成下划线](/images/IDA支持中文的办法/中文下划线.png "中文变成下划线")

通过对IDA进行逆向得知，原来hexray在生成伪代码的时候会调用一个`calc_c_cpp_name`函数，该函数会试图针对C/C++的函数名称进行优化，结果却误伤中文字符，我们将此处代码给NOP掉，就可以了。
![合法化名称](/images/IDA支持中文的办法/合法化名称.png "合法化名称")

### 最终效果

我已制作[Patch好的DLL](https://github.com/fjxisba/GithubDropBox/files/6289179/IDA.7.5.SP3.zip)，替换后效果如下:

![中文函数](/images/IDA支持中文的办法/中文函数.png "中文函数")

