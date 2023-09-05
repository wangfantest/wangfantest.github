---
title: "Go语言使用Fyne界面库"
date: 2022-05-05
tags: ["Go","GUI","Fyne"]
categories: ["Go语言"]
---

项目地址:https://github.com/fyne-io/fyne

示例代码:https://github.com/fyne-io/fyne/blob/master/cmd/fyne_demo/main.go

## Fyne不支持中文字符

一上来就遇到坑，带有中文的控件无法正常显示，得人工设置字体，参考这篇文章解决:

https://github.com/fyne-io/fyne/issues/2660

## Fyne控件大全

单选框列表，widget.NewRadioGroup

选择框列表，widget.NewCheckGroup

列表框，widget.NewList和widget.NewListWithData

组合框，widget.NewSelect

## 关于主菜单的Quit选项

fyne为了兼容mac os，设定主菜单默认有quit这一选项，但是这对多语言程序就很不友好，菜单选项语言不一致看起来非常别扭。

有人提出了解决方案:

https://github.com/fyne-io/fyne/pull/1982

大概意思就是给菜单加个IsQuit标记吧，代码如下：

```go
func (this *FyneApp)makeMainMenu()*fyne.MainMenu  {
	quitAction := fyne.NewMenuItem("退出", func() {
		this.app.Quit()
	})
	quitAction.IsQuit = true
	menu_About := fyne.NewMenu("程序", quitAction)
	mainMenu := fyne.NewMainMenu(menu_About)
	return mainMenu
}
```

## Fyne致命缺陷

1、Fyne组合框项目过多的时候，界面会卡死。

Fyne中的Select这一控件，当其中的选项较多的时候(上千个)，界面就卡死了，这是难以接受的。

2、Fyne为了适配各个平台，做出了很多功能上的牺牲，例如你无法在相对布局中定义控件的最小长度，这样的布局很难满足界面的设计需求。

3、Fyne程序无法在Windows Server上跑起来，因为服务器显卡驱动永远是OpenGL 1.1且无法升级，而Fyne使用的是OpenGL 2.0以上。

