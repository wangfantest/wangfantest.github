---
title: "QQ群查询信息协议"
date: 2021-07-23
tags: ["协议逆向"]
categories: ["QQ"]
---

利用QQ群的查询接口来获取QQ群的一些信息。接口:

https://qun.qq.com/cgi-bin/group_search/pc_group_search

post数据:

| 传递值  | 说明                        | 选项 |
| ------- | --------------------------- | ---- |
| keyword | 关键字，可为QQ群号,QQ群名称 | 必填 |
| wantnum | 想要查询的个数              | 必填 |
| from    | 来源，填1                   | 必填 |

在发送请求时，需要携带好QQ的Cookie。

请求返回值示例如下:

```json
{"ec":0,"errcode":0,"em":"","keywordSuicide":0,"exactSearch":1,"gTotal":1,"endflag":1,"penetrate":"eyJwb3MiOjEsInAiOiJ7XCJyZWNvbW1lbmRcIjp0cnVlfSJ9","usr_cityid":null,"exact":1,"group_list":[{"code":633783602,"owner_uin":425063169,"name":"E-debug兴趣小组","class":27,"class_text":"","dist":null,"face":0,"flag":150995985,"flag_ext":2163040,"geo":null,"gid":633783602,"latitude":"0","level":0,"longitude":"0","max_member_num":500,"member_num":175,"group_label":[{"item":"文件多","type":3,"text_color":"ffffff","edging_color":"00cafc"},{"item":"管理员活跃","type":3,"text_color":"ffffff","edging_color":"c573ff"},{"item":"男生多","type":3,"text_color":"ffffff","edging_color":"ff80ca"}],"memo":"E-debug Plus插件交流与反馈群.https:github.comfjqisbaE-debug-plus","richfingermemo":"","option":2,"app_privilege_flag":67731665,"url":"http:\/\/p.qlogo.cn\/gh\/633783602\/633783602\/140","calc":null,"join_auth":"iGo2gTpSQ3GUGtZJkOrvSQCfjWanN9xTC0wCfnVGo0RRyc+kZC0llDIFthXkv0j1","certificate_type":0,"certificate_name":"","bitmap":1024,"labels":[{"label":"王者荣耀","tagid":"1955f30159a44e2800005e21","time":1503940136},{"label":"小学生","tagid":"1955f30159a44e2d0000ab6a","time":1503940141},{"label":"PUBG","tagid":"1955f3015a3a53fb0000dc32","time":1513772027}],"uin_privilege":1,"activity":9,"cityid":10282,"qaddr":["江西省","上饶市"],"gcate":["人物"]}]}
```

其中group_list.option这个值表示QQ群的加群方式，有以下几种:

option1:允许任何人加群
option2:需要验证消息

option4:需要正确回答问题
option5:需要回答问题并由管理员审核

