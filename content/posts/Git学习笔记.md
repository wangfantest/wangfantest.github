---
title: "Git学习笔记"
date: 2020-08-23
tags: ["笔记","Git"]
categories: ["杂文"]
---

# 项目管理

### 克隆含有子模块的项目

当一个git项目含有子模块(submodule)时，直接克隆下来的子模块目录里面是空的。

这时可以在执行git clone时加上--recursive参数，它会自动初始化并更新每一个子模块，例如

```bash
git clone --recursive https://github.com/x64dbg/x64dbg.git
```



如果项目已经克隆到了本地，执行下面的步骤：

1.初始化本地子模块配置文件

```bash
git submodule init
```

2.更新项目，抓取子模块内容。

```bash
git submodule update
```

### 配置Git信息

第一次使用git的时候需要配置一下用户名和邮箱

```bash
git config --global user.name fjqisba
git config --global user.email fjqisba@sohu.com
```

#### 清空所有的commit

想要删掉仓库中所有的commit，得到一个新的仓库且当前代码不变，可以使用下面的命令

```bash
git checkout --orphan newBranch
git add -A
git commit -am "commit message"
git branch -D master
git branch -m master
git push -f origin master
```

#### 关闭Github的换行符自动转化功能

```bash
git config --global core.autocrlf false
```

# 搜索功能

1、搜索star数目超过1w的项目，stars:>10000

