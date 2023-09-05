---
title: "C++中的volatile关键字"
date: 2021-08-17
tags: ["高级C++"]
categories: ["C++开发"]
---

​	volatile单词意思为易变的，这里作为关键字是用来提示编译器它后面所定义的变量随时有可能改变。具体看下面这个源码例子:

```c++
void test()
{
    int a=2;
    while(1){
        if(a==1){
           break; 
        }
    }
}
```

​	按照C++的编译优化逻辑，汇编伪代码可能会变成下面这个样子:

```c++
void test()
{
    //申请四个字节堆栈空间
    var a=alloc(0x4);
    //初始化变量a
    mov a,0x2;
    //将变量a存储到寄存器上
    mov eax,a;
    while(1){
        if(eax==1){
            break;
        }
    }
}
```

​	如果像这个样子，即使a的值在其他的地方发生了改变，循环也无法跳出去了。因此我们需要指定volatile关键字，提示编译器不要随便使用寄存器来缓存变量，汇编代码就是这个样子:

```c++
void test()
{
    //申请四个字节堆栈空间
    var a=alloc(0x4);
    mov a,0x2;
    while(1){
        if(a==1){
            break;
        }
    }
}
```

