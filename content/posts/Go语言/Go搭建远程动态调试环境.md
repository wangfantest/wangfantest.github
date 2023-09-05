---
title: "Go语言搭建远程动态调试环境"
date: 2021-11-01
tags: ["Go"]
categories: ["Go语言"]
---

## Go搭建远程动态调试环境

### 1、安装go语言

yum install epel-release

yum install golang

### 2、安装调试工具Delve

```bash
#安装dlv
go get -u github.com/go-delve/delve/cmd/dlv
#寻找dlv的路径
sudo find / -name dlv
#软链接到go的路径
ln -s /root/go/bin/dlv $GOROOT/bin
#输入dlv测试是否配置成功
dlv
```

### 3、配置GoLand

1、选择Tools -> deployment -> Configuration，新建sftp。

2、填写SSH configuration，配置Root path，这里的root path指的是项目的根目录。

3、选中项目，选择Tools -> deployment  -> upload to server，将项目上传到服务器上。

4、选择Run -> Edit Configurations -> 新增Go Remote，填写需要连接的host和端口。

### 4、开始调试

1、远程服务器，在项目目录中，运行

```sh
dlv debug --headless --listen=:2345 --api-version=2
```

2、Goland点击远程调试即可。

