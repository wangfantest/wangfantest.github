---
title: "QT控件中的菜单"
date: 2021-07-15
tags: ["入门","新手教程"]
categories: ["QT"]

---

​	Qt中控件中的弹出菜单(ContextMenu)，依据ContextMenuPolicy的值的不同，有五种形式：

一、无菜单

此时,ContextMenuPolicy的值为Qt::NoContextMenu

二、默认菜单

此时，ContextMenuPolicy的值为Qt::DefaultContextMenu，这是默认值，其将显示控件定义的默认菜单

三、由Action定义菜单

此时，ContextMenuPolicy的值为Qt::ActionsContextMenu,要为此部件定义这种菜单，很简单，只要把已经定义好的Action部件插入到要显示此菜单的部件中，部件将自动按顺序显示菜单。

QWidget::addAction(QAction *action);

四、自定义菜单

此时，ContextMenuPolicy的值为Qt::CustomContextMenu，这回，有两种方式来定义菜单，一种是响应
customContextMenuRequested(const QPoint&)这个signal，在响应的槽中显示菜单(QMenu的exec()方法)。第二种是需要从这个部件的类中派生一个类，重写contextMenuEvent()这个函数显示菜单(QMenu的exec()方法显示)。

