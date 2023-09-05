---
title: "html查询语法"
date: 2022-05-25
tags: ["html"]
categories: ["爬虫"]
---

#### 解析Html

1、获取第一个<p>元素

```javascript
document.querySelector("p");
document.querySelector("body");
```

2、获取第一个类为example的元素

```javascript
document.querySelector(".example");
```

3、选中 data-foo-bar 属性等于 someval 的元素

```js
document.querySelectorAll('[data-foo-bar="someval"]');
```

