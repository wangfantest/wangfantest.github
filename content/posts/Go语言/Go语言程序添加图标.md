---
title: "Go语言程序添加图标"
date: 2022-06-28
tags: ["Go","ICO"]
categories: ["Go语言"]
---

## Go语言程序添加图标

1、下载rsrc工具

```bash
go get github.com/akavel/rsrc
```

2、生成程序描述文件ico.manifest

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0">
<assemblyIdentity
    version="1.0.0.0"
    processorArchitecture="x86"
    name="controls"
    type="win32"
></assemblyIdentity>
<dependency>
    <dependentAssembly>
        <assemblyIdentity
            type="win32"
            name="Microsoft.Windows.Common-Controls"
            version="6.0.0.0"
            processorArchitecture="*"
            publicKeyToken="6595b64144ccf1df"
            language="*"
        ></assemblyIdentity>
    </dependentAssembly>
</dependency>
</assembly>
```

3、制作syso文件

```bash
rsrc.exe -manifest ico.manifest -o rsrc.syso -ico myapp.ico
```

生成的rsrc.syso放到main.go目录下面就行了，会自动被编译器引用，这样生成出来的程序就有图标了。