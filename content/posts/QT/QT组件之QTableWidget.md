---
title: "QT组件之QTableWidget"
date: 2021-04-05
tags: ["TableWidget","新手教程","QT"]
categories: ["QT"]
---

在QT的开发中，免不了要用到表格(QTableWidget)这个控件。

### 一、初始化表格

#### 设置基本属性

```c++
ui.FileTableWidget->setColumnCount(2);        //设置列数
ui.FileTableWidget->setColumnWidth(0, 100);   //设置第一列宽度
ui.FileTableWidget->setColumnWidth(1, 300);   //设置第二列宽度

//使行列头自适应宽度，最后一列将会填充空白部分  
ui.FileTableWidget->horizontalHeader()->setStretchLastSection(true);            
  
//使行列头自适应宽度，所有列平均分来填充空白部分              
ui.FileTableWidget->horizontalHeader()->setResizeMode(QHeaderView::Strtch);          

//设置表头标题
ui.FileTableWidget->setHorizontalHeaderLabels(QStringList()<<"property"<<"value"");

//设置选中的模式,有禁止选择、单选、多选等5种模式
ui.tableView->setSelectionMode(QAbstractItemView::ExtendedSelection);

//设置整个表格不可被编辑
ui.tableView->setEditTriggers(QAbstractItemView::NoEditTriggers);

//设置某一列不可编辑
QTableWidgetItem *item1 = new QTableWidgetItem(“xxx”);
item1->setFlags(item1->flags() & (~Qt::ItemIsEditable));
ui->tableView->setItem(i, 0, item1);
```

#### 添加代理

如果我们想让表格中的单元不仅仅是显示文本，而是其他的控件，例如编辑框、复选框等，这个时候我们就得使用代理了，可以给所有的单元添加代理控件:

```c++
//给所有的单元添加代理控件
ui.tableView->setItemDelegate(new ReadOnlyDelegate());
```

或者只给某一列或某一行添加代理控件:

```c++
//给特定的单元添加代理控件
ui.tableView->setItemDelegateForColumn(0, new ReadOnlyDelegate());
ui.tableView->setItemDelegateForRow(0, new ReadOnlyDelegate());
```

假设我们想要通过代理控件达到的需求是，控件列表中的内容不可编辑、但是可以选中且被复制，那么我们需要实现以下代码:

```c++
#include <QLineEdit>
#include <QStyledItemDelegate>
class ReadOnlyDelegate : public QStyledItemDelegate
{
	Q_OBJECT

public:
        ReadOnlyDelegate(QObject* parent = 0) :QStyledItemDelegate(){}
	QWidget* createEditor(QWidget* parent, const QStyleOptionViewItem& option,
		const QModelIndex& index) const override
	{
		QLineEdit* editor = new QLineEdit(parent);
		editor->setFrame(false);
		editor->setReadOnly(true);
		return editor;
	}

	void setEditorData(QWidget* editor, const QModelIndex& index) const
	{
		QString value = index.model()->data(index, Qt::EditRole).toString();
		QLineEdit* spinBox = static_cast<QLineEdit*>(editor);
		spinBox->setText(value);
	}
	void setModelData(QWidget* editor, QAbstractItemModel* model,
		const QModelIndex& index) const
	{
		QLineEdit* spinBox = static_cast<QLineEdit*>(editor);
		QString value = spinBox->text();
		model->setData(index, value, Qt::EditRole);
	}

	void updateEditorGeometry(QWidget* editor,
		const QStyleOptionViewItem& option, const QModelIndex& index) const
	{
		editor->setGeometry(option.rect);
	}
};
```



#### 二、获取选中的行

```c++
QModelIndexList selectedsList = ui.tableView->selectionModel()->selectedRows();
for (unsigned int n = 0; n < selectedsList.size(); ++n) {
	int row = selectedsList.at(n).row();
}
```

#### 三、动态插入数据

```c++
ui.tableView->setSortingEnabled(false);   //关闭排序功能
int insertRow = ui.tableView->rowCount();
ui.tableView->insertRow(insertRow);
ui.tableView.setItem(insertRow,0,new QTableWidgetItem("name"));
ui.tableView->setSortingEnabled(true);    //开启排序功能
```

这里需要注意的是，在插入数据的时候，必须关闭表头的排序(对应上述代码中的setSortingEnabled函数)，否则表格数据会错乱。

#### 四、清空所有数据

```c++
ui.tableView->setRowCount(0);
ui.tableView->clearContents();
```

