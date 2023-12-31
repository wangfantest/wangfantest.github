---
title: "C++个人感想"
date: 2021-09-20
tags: ["C++"]
categories: ["C++开发"]
---

以下谈一下自己感想

##### 使用原生数据类型

很多项目喜欢自建自己的数据类型，比如std::vector、std::list，这个项目来一个qvector、qlist，另外一个项目又是QVector、QList。又或者一个很普通的int数据类型，在这个项目中是typedef char int8，另外一个项目又是typedef long long int8。

而这样容易出现头文件不兼容，无法引用各种问题，给我们这些代码搬运工带来了很大的麻烦。这里我只能建议尽可能使用自己的数据类型，例如在Windows平台上我们使用的最多的是vector和string，如果上述方案仍然无法解决，最终的办法是建立自己的中间件，例如封装一个Wrapper类，重新封装一遍要调用的库函数。

##### 不要陷入解耦陷阱

有一次在写项目的时候，我老想着把功能给解耦，例如有一个模块G，可以解耦成三个类，于是我把模块拆分成A、B、C三个类，这三个模块分别使用数据X、Y、Z，于是我又把这三种数据类型分配到对应的类中去，但是事实上这三种数据X、Y、Z实质上可以理解为一种东西，最后我又把这三种数据合并到一起，又把类整合了回去。。。

从上面的例子来看，如果说项目由**功能** + **数据类型**组成的话，我试图对功能进行解耦，然而却忽略了数据类型无法解耦的事实，结果陷入了解耦的陷阱。

