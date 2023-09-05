---
title: "浅谈TCP粘包的理解"
date: 2021-10-11
tags: ["高级C++","TCP"]
categories: ["C++开发"]
---

​	在开发TCP有关的程序的时候，我们就会遇到粘包的这个单词了。

​	首先要知道TCP是"完美的"，久经考验的TCP协议能够确保数据被有序而准确地发送和接受，因此粘包问题是个伪问题，本质上其实是应用层接收和发送数据双方之间未做好约定。

​	我们都知道发送和接受的数据分别是send和recv，假设客户端发送两次数据，如下:

```c++
std::string msg1="1234";
send(ConnectSocket, msg1.c_str(), msg1.size(), 0);
std::string msg2="5678"
send(ConnectSocket, msg2.c_str(), msg2.size(), 0);
```

客户端发送数据每4个字节当作一帧，那么根据服务端设置的接受数据长度的不同，有以下几种情况:

- recv和send数据长度相等，数据正常接收。
- recv长度小于send数据长度，数据少接收，前面的数据和后面的数据都被破坏。
- recv长度大于send数据长度，数据将多接收，前面的数据和后面的数据都被破坏。

```c#
//数据正常接受
char buffer1[4]={0};
recv(ConnectSocket,buffer1,sizeof(buffer1),0);
char buffer2[4]={0};
recv(ConnectSocket,buffer2,sizeof(buffer2),0);
```

```c++
//数据遭到破坏
char buffer1[3]={0};
recv(ConnectSocket,buffer1,sizeof(buffer1),0);
char buffer2[3]={0};
recv(ConnectSocket,buffer2,sizeof(buffer2),0);
```

```c++
//数据遭到破坏
char buffer1[5]={0};
recv(ConnectSocket,buffer1,sizeof(buffer1),0);
char buffer2[5]={0};
recv(ConnectSocket,buffer2,sizeof(buffer2),0);
```

​	看到这里，我自己都觉得自己废话多，其实所谓粘包无非就是send和recv的长度不对等而已，网上说的都是屁话。

完美情况下，每次发送约定好的长度，每次接受约定好的长度，什么事都没有。但是由于实际情况比较复杂，例如客户端需要发送文件给服务端，文件的长度是会动态变化的，因此需要自己设计应用层的协议算法，一般来说有下面几种想法:

1、双方约定好数据长度

```c++
//客户端
std::string msg="1234";
int msgLen=msg.size();
send(ConnectSocket,&msgLen,4,0)
send(ConnectSocket,msg.cstr(),msgLen,0);

//服务端
int msgLen = 0;
recv(ConnectSocket, (char*)&msgLen, 4, 0);
char* pBuf = new char[msgLen];
recv(ConnectSocket, pBuf, msgLen, 0);
delete pBuf;
```

核心思想就是服务端在第一次接收到数据的时候，确认好后续的数据长度。

但是上面的代码有一个潜在的问题，比如客户端连续多次发送数据，由于网络原因存在某一个send没发送出去呢？这样服务端的解析会全乱，因此上述代码还需要进一步优化。

2、以指定字符串标记作为包的结束标志

不管三七二十一，我们自定一个值，例如0xCCDDEEFF，服务端处理每帧数据的时候，会进行判断和分包处理。

