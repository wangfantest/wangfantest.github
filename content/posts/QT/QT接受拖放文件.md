---
title: "QT接受拖放文件"
date: 2021-03-14
tags: ["入门","新手教程"]
categories: ["QT"]
---

例如我们想让主窗口能接受到拖放来的文件，要点如下:

#### 1.设置属性

在Qt Designer中点击主窗口，右侧会出现属性编辑器，我们在属性`acceptDrops`上打√。

或者在初始化ui代码中添加

```c++
this->setAcceptDrops(true);
```

事实上这二者是等价的。

#### 2.实现虚函数dragEnterEvent()

当窗口触发拖放事件的时候，就会进入到这个函数，这个时候我们可以检查一下拖进来的是什么东西(文件或者文本之类的)。

```c++
void MainWindow::dragEnterEvent(QDragEnterEvent* event)
{
    //判断是否是文件
    if (event->mimeData()->hasFormat("text/uri-list")) {
        event->acceptProposedAction();
    }
}
```

#### 3.实现虚函数dropEvent()

这里可以填写触发的动作代码

```c++
void MainWindow::dropEvent(QDropEvent* event)
{
    QList<QUrl> urls = event->mimeData()->urls();
    if (urls.isEmpty()) {
        return;
    }
    //To do...
    //拿到文件路径后，就可以执行想做的事了
}
```

