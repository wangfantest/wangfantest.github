---
title: "QT组件之QListWidget"
date: 2021-07-15
tags: ["ListWidget","新手教程","QT"]
categories: ["QT"]
---

在QT的开发中，免不了要用到列表(QListWidget)这个控件。

### 一、初始化表格



### 信号大全

QListWidget控件的信号

```c++
void itemPressed(QListWidgetItem *item);
void itemClicked(QListWidgetItem *item);
void itemDoubleClicked(QListWidgetItem *item);
void itemActivated(QListWidgetItem *item);
void itemEntered(QListWidgetItem *item);
void itemChanged(QListWidgetItem *item);

void currentItemChanged(QListWidgetItem *current, QListWidgetItem *previous);
void currentTextChanged(const QString &currentText);
void currentRowChanged(int currentRow);

void itemSelectionChanged();
```

itemPressed，当在项目上按下鼠标按钮时，此信号随指定项目一起发出 。

itemClicked，当在项目上单击鼠标按钮时，此信号随指定项目一起发出。 

itemDoubleClicked，当在项目上双击鼠标按钮时，此信号随指定项目一起发出。 

itemActivated，当项目被激活时发出这个信号。 当用户单击或双击它时，该项目将被激活，具体取决于系统配置。 当用户按下激活键时它也会被激活（在 Windows 和 X11 上这是返回键，在 Mac OS X 上是 Command+O）。

itemEntered，当鼠标光标进入一个项目时发出这个信号，item指针指向进入的项目。 此信号仅在mouseTracking选项开启，或者在鼠标光标移动进入项目的过程中按下鼠标按钮时发出。

itemChanged，每当 item 的数据发生变化时，就会发出此信号。 

currentItemChanged，每当当前选中项发生改变时就会发出此信号。 previous 是先前具有焦点的项目； current 是新的当前项目。 

currentTextChanged，每当当前选中项发生改变时就会发出此信号。 currentText 是当前选中项中的文本数据。 如果当前项为空，则 currentText 无效。 

currentRowChanged，每当当前选中项发生改变时就会发出此信号。currentRow是当前项的行，如果没有当前项，则为-1。

itemSelectionChanged，每当当前选中项发生改变时就会发出此信号。

