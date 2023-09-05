---
title: "ubuntu替换apt源"
date: 2022-01-23
tags: ["vnc"]
categories: ["Linux"]
---

## ubuntu替换apt源

有一些主机使用apt get命令会出现各种问题，那么很有可能是apt源有问题。

可以试试替换阿里云的软件源。

1、修改/etc/apt/sources.list，修改为以下内容

```
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
```

2、执行

```bash
apt-get update -y
apt-get upgrade -y
```

3、如果更新出现下面这种问题

```
The following signatures couldn't be verified because the public key is not available: NO_PUBKEY 3B4FE6ACC0B21F32
```

那么执行以下命令，命令中的 **公钥编码**就是上述问题后面的PUBKEY了。

```
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys '公钥编码'
```

完成后，重新执行步骤2。

