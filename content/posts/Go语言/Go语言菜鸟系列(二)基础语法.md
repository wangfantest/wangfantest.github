---
title: "Go语言菜鸟系列(二)基础语法"
date: 2021-11-09
tags: ["笔记","Go"]
categories: ["Go语言"]
---

#### 基础类型

整数型:int、uint、int8、int16、int32、int64、uint、uint8、uint16、uint32、uint64

浮点类型:float32、float64

布尔类型:bool

字符串类型:string

字符类型:byte、rune

1、Go语言编译器不会对数据类型进行任何隐式转换，int和int32是两种不同的类型。

2、整数型默认值是0，布尔类型默认值是false，字符串默认是空字符串

3、这些基础类型在进行函数参数传递的时候，都是值传递，即会拷贝一份副本传递至函数体内，函数内对参数的修改不会影响到变量本身。

#### 变量声明

有两种声明方式

```go
//第一种是正常的声明
var a int
a = 1
var b int = 2

//第二种是类型自动推导
c := 3
d := "4"
```



### Go语言函数参数传递

| 参数类型                             | 参数传递 |
| ------------------------------------ | -------- |
| int、string                          | 值传递   |
| []int、[]string、[]\*int、[]\*string | 指针传递 |
| map[string]string                    | 指针传递 |

总结来说，go语言仅有的两个容器——切片和哈希表，它们的拷贝都是浅拷贝，测试用例如下:

```go
func NoCopyMap(testMap map[string]string)  {
	testMap["111"] = "222"
}

func main()  {
	testMap := make(map[string]string)
	newMap := testMap
	NoCopyMap(newMap)
	print(testMap,"=",newMap)
}
```

