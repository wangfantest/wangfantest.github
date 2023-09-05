---
title: "ClickHouse学习"
date: 2021-12-16
tags: ["ClickHouse"]
categories: ["数据库"]
---

# ClickHouse

ClickHouse是俄罗斯Yandex于2016年开源的一个高性能的SQL数据库。我对这个数据库的看法是，如果你的数据只涉及到读和写，不存在对数据的修改和删除，那么你永远可以信任ClickHouse。

### 简介

1、对linux比较友好，如果要在windows运行，就必须使用容器了。

相关文档:https://clickhouse.com/docs/zh/

### 安装过程

```bash
sudo yum install yum-utils
sudo rpm --import https://repo.clickhouse.com/CLICKHOUSE-KEY.GPG
sudo yum-config-manager --add-repo https://repo.clickhouse.com/rpm/stable/x86_64
```





# ClickHouse语句

查询数据库中所有的表名，以及对应的建表语句

```mysql
select database,name,create_table_query from `system`.tables where database = 'Test'
```

