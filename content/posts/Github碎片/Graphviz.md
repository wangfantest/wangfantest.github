---
title: "Graphviz"
date: 2021-01-30
tags: ["开源项目","Graphviz"]
categories: ["Github碎片"]
---

Github项目地址:[graphviz ](https://gitlab.com/graphviz/graphviz)

Graphviz 是一款由 AT&T Research 和 Lucent Bell 实验室开源的可视化图形工具，用于绘制DOT语言脚本描述的图形。它可以很方便的用来绘制结构化的图形网络，并且支持GIF,PNG,SVG,PDF等多种格式输出。

官方文档地址:[Documentation](https://graphviz.org/documentation/)

要想使用Graphviz就得先熟悉DOT语言，这是一种用来描述图形的脚本语言。

#### [DOT语言](https://zh.wikipedia.org/wiki/DOT语言)

DOT语言是一种文本图形描述语言。它提供了一种简单的描述图形的方法，并且可以为人类和计算机程序所理解。DOT语言文件通常是具有.gv或是.dot的文件扩展名。

`graph`表示无向图，例如下面的dot脚本

```D
graph graphname {
 a -- b -- c;
 b -- d;
}
```

`digraph`为有向图，例如下面的dot脚本

```D
digraph graphname {
 a -> b -> c;
 b -> d;
}
```

#### 在线画图工具

项目地址:https://github.com/dreampuf/GraphvizOnline

工具地址:https://dreampuf.github.io/GraphvizOnline/

