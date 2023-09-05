---
title: "QQ群文件协议"
date: 2021-05-09
tags: ["协议逆向"]
categories: ["QQ"]
---

因为工作需要，需要对QQ群文件协议进行逆向分析。

### 1.分析准备流程

首先我们要知道QQ群文件的静态页面网址是https://pan.qun.qq.com/clt_filetab/groupShareClientNew.html?gid=633783602，

其中gid这个值就是QQ群号。

我们正常情况下访问这个页面是一片空白，因为缺少QQ登录的Cookie，这个时候我们需要到[QQ群官网](https://qun.qq.com/)登录一下我们的QQ，然后再访问静态页面，就会发现能看到QQ群内的群文件，可以开始进行协议分析了。

### 2.BKN算法

在分析的过程中，会遇到一个重要的参数BKN，我们其实不必理解这个参数有什么含义，只需要找到值的来源就行了。算法很简单，由Cookie中的skey转换得到，算法如下:

```javascript
function getBKN(skey) {  
    var hash = 5381;  
    for (var n = 0, len = skey.length; n < len; ++n)  
        hash += (hash << 5) + skey.charCodeAt(n);  
    return hash & 2147483647  
};  
```

### 3.获取群文件列表

请求协议如下:

```ini
Request URL:https://pan.qun.qq.com/cgi-bin/group_file/get_file_list?gc=633783602&bkn=xxxx&start_index=0&cnt=50&filter_code=0&folder_id=%2F&show_onlinedoc_folder=1
referer:https://pan.qun.qq.com/clt_filetab/groupShareClientNew.html?gid=633783602
cookie:skey=xxxx
```

gc就是QQ群号，bkn是根据cookie中的skey转换得到的值，cnt是显示的群文件个数。

返回的数据如下:

```json
{
    "ec": 0,
    "file_list": [
        {
            "create_time": 1620539743,
            "id": "\/5637b4d6-1216-4d84-bbbe-579d4c65f6e2",
            "modify_name": "💀",
            "modify_time": 1620539743,
            "modify_uin": 425063169,
            "name": "新建文件夹",
            "owner_name": "💀",
            "owner_uin": 425063169,
            "parent_id": "\/",
            "size": 0,
            "type": 2
        },
        {
            "bus_id": 104,
            "create_time": 1620539142,
            "dead_time": 1621403742,
            "download_times": 2,
            "id": "\/5fc46b55-5ff8-47dc-bf2a-7171752843e9",
            "local_path": "",
            "md5": "3f26d3be679d81b5d9bd4fdf046d3eed",
            "modify_time": 1620539144,
            "name": "VMware.exe",
            "owner_name": "﻿﻿﻿💀",
            "owner_uin": 425063169,
            "parent_id": "\/",
            "safe_type": 0,
            "sha": "d52d301385647f4dab3fee94734534a0385c22147c",
            "sha3": "",
            "size": 241597204,
            "type": 1,
            "upload_size": 241597204
        },
        {
            "bus_id": 102,
            "create_time": 1618906774,
            "dead_time": 0,
            "download_times": 3,
            "id": "\/9366e551-cb4e-49c5-922a-17bc25f6cc3e",
            "local_path": "",
            "md5": "d9a985b55c724f4912fe5f80e21463aef3",
            "modify_time": 1618906775,
            "name": "VMOS.APK",
            "owner_name": "💀",
            "owner_uin": 425063169,
            "parent_id": "\/",
            "safe_type": 0,
            "sha": "b4de8c3c29f4911bae322ea2c2fc5c306ca8c9ec43",
            "sha3": "",
            "size": 15365031,
            "type": 1,
            "upload_size": 15365031
        },
    ],
    "next_index": 50,
    "open_flag": 0,
    "total_cnt": 63,
    "user_role": 2
}
```

bus_id推测表示文件的类型，102表示是永久文件，104表示是缓存文件。

id表示文件的唯一ID，比较重要的一个值。

total_cnt表示群内文件的总数。

### 4.获取文件下载地址

请求协议如下:

```ini
Request URL:https://pan.qun.qq.com/cgi-bin/group_share_get_downurl?uin=425063169&groupid=633783602&pa=%2F102%2F9366e551-cb4e-49c5-951a-17bc25f6cc3e&charset=utf-8&g_tk=xxxx
referer:https://pan.qun.qq.com/clt_filetab/groupShareClientNew.html?gid=633783602
cookie:skey=xxxx
```

uin是我们的QQ号。

groupid是QQ群号。

pa其实是文件的bus_id和id的组合路径。

g_tk的值等于bkn。

结果如下:

```json
{
    "code": 0,
    "data": {
        "cookie": "6138633965635533",
        "dns": "tj-ctfs.ftn.qq.com",
        "ismember": 1,
        "md5": "d9a985b50d4f4912fe5f80e21463aef3",
        "ret": 0,
        "sha": "b4de8c3c29f4911bae322ea2c2fc006ca8c9ec43",
        "sha3": "",
        "sip": "133.150.76.225",
        "url": "http:\/\/tj-ctfs.ftn.qq.com\/ftn_handler\/daab4b510d965064e12d4586ad5e2967167c95610b0188f29f5655fa607f83aa6f29326e8cf806300b4d2a8f11c0756601abc5698bf8df4ff4896f0865c08ccb"
    },
    "default": 0,
    "message": "",
    "subcode": 0
});
```

url是文件的下载地址直链。

