---
title: "Vue学习"
date: 2021-12-02
tags: ["vue"]
categories: ["前端"]
---

# Vue学习

官方文档:https://cn.vuejs.org/v2/guide/index.html

Vue简介:Vue是基于javascript编写一个前端框架，也可以理解为是javascript的一个库。

## 配置Vue环境

1、安装nodejs，nodejs可以理解为javascript版本的服务端。

2、nodejs中内置npm，npm可以理解为像pip、go get之类的javascript库管理工具。

3、安装cnpm，cnpm可以理解为npm的中国版。

```bash
npm install -g cnpm --registry=https://registry.npm.taobao.org
```

4、安装vue-cli，这个网上都说是vue项目的脚手架，我个人感觉就像是一个项目控制台吧，方便构建和管理vue项目。

```bash
cnpm install vue-cli -g
```

5、npm install在下载第三方库时，偶尔会卡住，这个时候可以尝试使用以下命令(从网上搜集的)

```bash
npm cache clean
ipconfig /flushdns
git config http.postBuffer 524288000 
git config --global http.sslVerify false
npm install --registry=https://registry.npm.taobao.org
```

可能还是github被墙导致的，好像没有什么太好的办法。

6、查看使用的Vue版本

```bash
npm list vue
```

7、查看vue-cli版本

```8bash
vue --version
```

8、使用webpack初始化vue项目，webpack简单来说可以理解为一个项目打包 + 模板化工具。

```bash
vue init webpack project_test
```

项目名必须是全小写

## Vue模板详解



## 搭建VS Code环境

1、安装VS Code

https://code.visualstudio.com/

2、安装VS Code插件

插件Vetur

## 基础语法



## 可能遇到的问题

1、error:0308010C:digital envelope routines::unsupported

解决办法:输入以下命令

```bash
export NODE_OPTIONS=--openssl-legacy-provider
```

参考资料:https://github.com/webpack/webpack/issues/14532



# 参考项目

1、https://github.com/PanJiaChen/vue-element-admin

一个管理后台的项目，可以用来参考学习。
