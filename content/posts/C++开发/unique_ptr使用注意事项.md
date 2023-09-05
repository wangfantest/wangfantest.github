---
title: "unique_ptr使用注意事项"
date: 2021-09-25
tags: ["高级C++"]
categories: ["C++开发"]
---

​	unique_ptr指针的出现是为了解决指针释放的问题，在将指针升级为unique_ptr指针的时候，需要注意这二者之间的区别。

在C++项目中我们一般这样定义头文件:

```c++
class A;
class B
{
	A* a;
}
```

没毛病，非常完美，但是升级到unique_ptr之后:

```c++
class A;
class B
{
    std::unique_ptr<A> a;
}
```

这样实际上是存在隐患的，因为std::unique_ptr需要静态检测类型的大小，我们需要额外声明B的析构函数，像下面这样:

```c++
class A;
class B
{
    std::unique_ptr<A> a;
public:
   ~B() = default;
}
```

总的来说，unique_ptr相较之前的裸指针传递，还是好用的，就是得多撸很多代码...

