---
title: "Go语言常用时间转换"
date: 2022-01-17
tags: ["Go","时间"]
categories: ["Go语言"]
---

## 时间戳转换为时间

秒级别转换

```go
timeStamp := 1642429952
timeStr := time.Unix(int64(timeStamp),0).Format(time.RFC3339)
fmt.Println(timeStr)
```

毫秒级别转换

```go
timeStamp := 1642430127727
timeStr := time.UnixMilli(int64(timeStamp)).Format(time.RFC3339)
fmt.Println(timeStr)
```

## 时间转换为时间戳

秒级别转换

```go
timeStamp := 1642429952
timeStr := time.Unix(int64(timeStamp),0)
fmt.Println(timeStr.Unix())
```

毫秒级别转换

```go
timeStamp := 1642430127727
timeStr := time.UnixMilli(int64(timeStamp))
fmt.Println(timeStr.UnixMilli())
```

## Go语言加载时间错误

当Go语言调用了时区相关的代码时，生产环境没啥问题，但在缺乏Go环境的Windows机器上可能就会出错，例如下面这句代码

```go
var err error
time.Local, err = time.LoadLocation("Asia/Shanghai")
if err != nil{
	log.Panicln(err)
}
```

解决方案如下:

1、下载zoneinfo.zip文件，https://github.com/golang/go/blob/master/lib/time/zoneinfo.zip

2、配置环境变量`ZONEINFO`，变量值为zoneinfo.zip的绝对路径。

## 参考资料

https://github.com/ArtalkJS/ArtalkGo/issues/35
