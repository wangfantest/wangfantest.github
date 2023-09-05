---
title: "paypal开通支付"
date: 2021-12-31
tags: ["paypal"]
categories: ["后端开发"]
---

# paypal开通支付

paypal是国外的一套支付服务系统，基于web来实现。

官方文档:https://developer.paypal.com/docs/

代码样例:https://demo.paypal.com/us/demo/code_samples

官方文档点进去之后，主页有三种平台文档:

1、For Business:中小型企业解决方案。

2、For Marketplaces and Platforms:大型销售平台?

3、For Enterprise:大型企业支付解决方案。

按我的猜测，应该是规模和等级依次增加吧，这样的话我就选择1，我就想搭建个小型的收费平台而已。

------

封装好的SDK:https://github.com/go-pay/gopay

新手教程:https://developer.paypal.com/docs/business/get-started/

1、paypal提供了一个沙盒平台，开发人员可以在上面进行模拟整套支付流程。

首先需要创建一个App，在[创建App](https://developer.paypal.com/developer/applications/create)页面点击创建App按钮即可。

我们会得到一个沙盒APP凭证，里面包含

```
Account:	xxx@business.example.com
Client-ID:	xxxxxx
Secret:	xxxxx
```

这个凭证可以通过官方的一个接口，转换成一个Token凭证，即 `Client-ID + Secret  => Token`，通过这个Token我们可以去访问创建订单、更新订单、捕获订单等其它API，Token存在一个有效期，如果过期了重新登录即可。

paypal默认还会给我们生成商户和用户两个虚拟账户，在https://www.sandbox.paypal.com上登录能查看到付款和收款情况。

2、创建订单

懒得写了。



## 总结大致流程如下:

1、服务器使用后台的Client-ID和Secret去登录paypal，获取访问paypal接口的权限。

2、服务器提供接口**server_CreateOrder**，用于创建订单。

3、客户端传入商品信息至服务器接口**server_CreateOrder**。

4、服务器接口**server_CreateOrder**收到订单后，调用paypal API，接口是**paypal_CreateOrder**，在这里传入商品的价格、订单的设定 (是否要显示收获地址等...)、以及用户完成订单后的重定向地址，最终得到订单的付费URL地址，再返回给客户端。

5、客户端得到付费的URL地址，通过浏览器访问并付费，付费成功后调用服务器给的重定向地址(可以算是接口)，通知服务器我已经付费完成了。

6、在此时，客户端的付费其实并未被paypal认可，只有服务端收到客户端的通知后，去调用**paypal_CaptureOrder**函数，捕获住订单，paypal才会承认客户已经付费，服务端此时检查订单的状态是否已完成，返回一些信息给客户端即可。

7、服务端在paypal后台已经设定好了webhook地址，当整个订单完成时候，paypal会发送消息通知服务端paypal的webhook接口，服务端此时确定通过付费，进行一系列操作。



## Paypal安全

https://developer.paypal.com/docs/api/info-security-guidelines/

