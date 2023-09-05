---
title: "Go语言调用Windows Api"
date: 2022-06-14
tags: ["Go","API"]
categories: ["Go语言"]
---

#### 关于DLL的加载

调用消息框示例

```go
func callMsgBox()  {
	hUser32,_ := syscall.LoadDLL("user32.dll")
	callMessageBox, _ := hUser32.FindProc("MessageBoxW")
	text := uintptr(unsafe.Pointer(syscall.StringToUTF16Ptr("我是内容")))
	title := uintptr(unsafe.Pointer(syscall.StringToUTF16Ptr("我是标题")))
	callMessageBox.Call(0,text,title,0)
}
```

