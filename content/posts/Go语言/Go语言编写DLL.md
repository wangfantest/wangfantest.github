---
title: "Go语言编写DLL"
date: 2021-12-27
tags: ["Go","DLL"]
categories: ["Go语言"]
---

# Go语言编写DLL

要编写DLL，要用到CGO相关的东西，CGO是基于Mingw编译器的。

编写32位DLL需要安装Mingw，编写64位DLL则安装Mingw-64，安装后将编译器添加到环境变量中即完成了cgo配置。



测试代码如下

```go
package main

import "C"
import(
    "fmt"
)

//export Test
func Test(){
    fmt.Println("hello")
}

func main(){
    
}
```

关键点如下:

1、还是必须要有package main和main函数。

2、导出的函数前面用`//export + 函数名`声明，表示需要导出该函数

3、引出包`import "C"`

------

生成dll文件

```bash
go build -buildmode=c-shared -o test.dll main.go
```

