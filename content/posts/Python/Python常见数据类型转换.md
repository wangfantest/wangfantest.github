---
title: "Python常见数据类型转换"
date: 2021-01-08
tags: ["Crypto","pip"]
categories: ["Python"]
---

## str和bytes

python3中str默认是Unicode，bytes则是utf-8。

例如字符串"我日你哥"，在str状态下打印出十六进制

```bash
b = [hex(ord(x)) for x in '我日你哥']
print(b)
11 62 E5 65 60 4F E5 54
```

## str转bytes

```python
a = "我日你哥"
b = a.encode("utf-8")
```

实际数据则变成了

```
E6 88 91 E6 97 A5 E4 BD A0 E5 93 A5
```



## bytes转str

bytes转换回str，使用以下方法:

```bash
a = "我日你哥"
b = a.encode("utf-8")
a = b.decode("utf-8")
```



## bytes转换为十六进制字符串

Python3直接用hex函数即可。

```python
a = "我日你哥"
b = a.encode("utf-8")
print(b.hex())
```

得到结果e68891e697a5e4bda0e593a5



