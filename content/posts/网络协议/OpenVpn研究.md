---
title: "OpenVPN研究"
date: 2022-06-09
tags: ["OpenVPN"]
categories: ["网络协议"]
---

# 前言

本来想研究OpenVPN如何抓取流量的，可惜没研究出啥成果，备份一下资料而已。

# OpenVpn

1、下载对应版本的代码

```bash
wget https://swupdate.openvpn.org/community/releases/openvpn-2.4.9.tar.gz
```

2、安装lzo压缩库，不同的操作系统选择不同的安装命令

```bash
sudo apt-get install liblzo2-dev
sudo yum install lzo-devel
```

或者也可以直接通过源码来安装

```bash
wget http://www.oberhumer.com/opensource/lzo/download/lzo-2.10.tar.gz
tar xf lzo-2.10.tar.gz
cd lzo-2.10
./configure
make
sudo make install
```

3、安装libpam

```bash
yum install pam-devel
```



## 生成证书

1、cmd进入OpenVPN/eazy-rsa目录，执行初始化命令，vars里面的内容得修改修改，设置设置目录之类的。

```bash
init-config
vars
clean-all
```

2、创建CA根证书

```bash
build-ca
```

得到ca.key和ca.crt

3、创建dh证书

```bash
build-dh
```

得到dh2048.pem

4、创建服务端证书

```bash
build-key-server server
```

首先是直接生成一组证书server.key和server.csr，之后利用ca证书给server.csr签名得到server.crt。

5、创建客户端证书，这里注意的是Common Name不能和服务端一样。

```bash
build-key client
```

还是直接生成一组证书client.key和client.csr，之后利用ca证书给client.csr签名得到client.crt

# Windows开启路由转发

windows默认是没有启用IP转发的，因此需要开启，编辑注册表

HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters

将IPEnableRouter值修改为1后，重启操作系统。

## Config配置

服务器的配置如下:

```
#监听的端口
port 1195

#TCP还是UDP服务
;proto tcp
proto udp

#tap和tun两种模式
;dev tap
dev tun

#服务器证书
ca ca.crt
cert server.crt
key server.key  # This file should be kept secret

#dh证书
dh dh2048.pem

#网段设置
server 192.168.233.0 255.255.255.0

#ip缓存池,不用管
ifconfig-pool-persist ipp.txt


# If enabled, this directive will configure
# all clients to redirect their default
# network gateway through the VPN, causing
# all IP traffic such as web browsing and
# and DNS lookups to go through the VPN
# (The OpenVPN server machine may need to NAT
# or bridge the TUN/TAP interface to the internet
# in order for this to work properly).
push "redirect-gateway def1 bypass-dhcp"

#DNS服务器
push "dhcp-option DNS 114.114.114.114"
push "dhcp-option DNS 8.8.8.8"


#支持多客户端
duplicate-cn

#心跳设置
keepalive 10 120

#加密算法
cipher none

persist-key
persist-tun

#忽略错误日志
verb 0

#表示客户端无需证书,根据不同的版本有两种配置语句
client-cert-not-required
#verify-client-cert none

username-as-common-name
script-security 3
#开启用户名密码校验,bat脚本返回0则校验通过
auth-user-pass-verify radiuscheck.bat via-env
```

## 运行OpenVPN服务

实际命令行如下，可用于源码调试。

```bash
openvpn --config "server.ovpn"
```



## 安装服务端

## 端口转发

```bash
查看端口转发
netsh interface portproxy show v4tov4

netsh interface portproxy add v4tov4 listenaddress=10.8.8.1 listenport=139 connectaddress=0.0.0.0 connectport=80

删除端口转发
netsh interface portproxy delete v4tov4 listenaddress=127.0.0.1 listenport=80
```

## OpenVPN解析

socket.h link_socket_write_udp函数，写入









## 参考资料

OpenVpn下载地址:https://github.com/portapps/openvpn-portable/releases

OpenVpn官方手册:https://openvpn.net/community-resources/how-to/

Open命令行手册:https://community.openvpn.net/openvpn/wiki/Openvpn23ManPage

维基百科介绍:https://wiki.wireshark.org/OpenVPN

https://www.wumingx.com/others/openvpn-win.html

https://www.junmajinlong.com/virtual/network/data_flow_about_openvpn/

https://discourse.mitmproxy.org/t/configuration-for-openvpn/1354

https://www.codeproject.com/Articles/5323785/OpenVPN-for-Windows-XP#topic08

https://paper.seebug.org/1648/
