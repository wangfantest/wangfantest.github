---
title: "Docker容器学习"
date: 2021-10-08
tags: ["Docker"]
categories: ["Linux"]
---

# Docker容器学习

#### docker查询容器

docker ps

#### docker进入容器

docker exec -it `容器id` ash

docker exec -u root -it `容器id` ash

#### docker列举本地已有镜像

docker images

#### docker 保存镜像

docker save `镜像仓库名` -o `文件路径`

#### docker 杀掉一个运行中的容器

docker kill `容器id`

#### docker查看容器内的标准输出

docker logs `容器id`

#### docker拷贝文件

从容器内拷贝至主机

docker cp 容器id:文件路径 文件路径

#### 远程调试Docker内的进程

1、根据容器的id获取容器的pid

docker inspect --format {{.State.Pid}} 834e73bf3caa

2、使用nsenter进程gbd调试

nsenter -t `容器PID` -m -p gdb -p `容器内进程PID`

#### 容器端口映射

端口也可以映射多个

docker run -it -d -p 0.0.0.0:3000:3000 -p 9988:9988 容器镜像名称

设定网络模式

--network host

