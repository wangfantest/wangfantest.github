---
title: "Mysql学习"
date: 2021-12-23
tags: ["Mysql"]
categories: ["数据库"]
---

## Mysql学习

## Mysql的安装

### Windows平台下:

需要安装Mysql Community Server，下载地址:[https://dev.mysql.com/downloads/mysql/](https://dev.mysql.com/downloads/mysql/)

### linux平台下:

```bash
wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
rpm -ivh mysql-community-release-el7-5.noarch.rpm
yum update
yum install mysql-server
```

### 安装步骤

1、下载完成后首次启动需要初始化数据库，会得到一个临时密码

另外，mysql5.6版本则没有初始化这一步。

```bash
mysqld --initialize --console
```

2、将mysql安装为系统服务

```bash
//安装服务
mysqld -install
//移除服务
mysqld -remove
```

3、使用临时密码登录mysql服务

```bash
mysql -u root -p
```

4、修改root用户密码，并提交

```bash
mysql> alter user 'root'@'localhost' identified by '想要设置的密码';
mysql> commit;
```

5、创建数据库

```bash
mysql> create database <数据库名>;
```

6、Mysql8.0设置远程连接密码

```bash
mysql> ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'mypass@123';
```

7、Mysql关闭密码策略，分别是Mysq旧版本和新版本两种命令。

```
mysql> set global validate_password_policy = 0;
```

```
mysql> set global validate_password.policy = 0;
set global validate_password.mixed_case_count = 0;
set global validate_password.number_count = 0;
set global validate_password.special_char_count = 0;
```

8、刷新权限

```bash
mysql> flush privileges;
```



## MySQL语句

1、查询有哪些数据库

```mysql
mysql> show databases;
```

2、使用数据库

```mysql
mysql> use <数据库名>;
```



## SQL语句

1、查询数据库中有哪些表

```mysql
select table_name from information_schema.tables where table_schema='数据库名';
```

2、



## 关于UNIQUE

Mysql数据库中可以使用UNIQUE关键字给字段添加唯一索引。需要注意的是，创建唯一的索引的目的不是为了提高访问速度，而是为了避免数据出现重复。唯一索引可以有多个但索引列的值必须唯一，索引列的值运行有空值。创建唯一索引的示例如下:

```mysql
CREATE TABLE URLTABLE(
    url TEXT COMMENT 'url接口',
    ip	TEXT COMMENT 'IP地址',
    md5	CHAR(32) UNIQUE COMMENT 'hash值'
);
```



## Mysql获取字段去重后的总数

如果一张表中某个字段存在重复的值，我们想去重后获取这个字段值的总数。例如有下列数据库

```mysql
select count(distinct(去重的字段)) as count from 表名;
```

