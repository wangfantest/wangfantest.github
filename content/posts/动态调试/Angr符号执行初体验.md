---
title: "Angr符号执行初体验"
date: 2022-09-25
tags: ["Angr","符号执行"]
categories: ["动态调试"]
---

# Angr

项目地址:https://github.com/angr/angr

## 配置Angr

```powershell
pip install angr -i https://pypi.tuna.tsinghua.edu.cn/simple
```

## 使用说明

https://www.bookstack.cn/read/CTF-All-In-One/doc-5.3.1_angr.md

官方文档:https://docs.angr.io/



## CFG生成

有静态分析和动态分析两种，其中静态分析速度要快一点。

```python
import angr
p = angr.Project('/bin/true', load_options={'auto_load_libs': False})

#Generate a static CFG
cfg = p.analyses.CFGFast()

#generate a dynamic CFG
cfg = p.analyses.CFGEmulated(keep_state=True)
```

## 训练题目

https://github.com/jakespringer/angr_ctf
