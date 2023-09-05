---
title: "Flutter逆向之分析dart源码(二)"
date: 2022-11-06
tags: ["Flutter","Dart"]
categories: ["安卓逆向"]
---

1、dart是一门强类型语言。

2、编译打包的apk里面有两个so文件，libflutter.so是flutter的运行环境，libapp.so是dart编译生成的二进制代码。



### 项目

gen_snapshot，生成二进制文件的核心。

dart_precompiled_runtime，可以模拟出一个runtime执行aot。



关于编译:https://dart.dev/tools/dart-compile

dart编译模式，有以下几种:

| 编译模式     | 说明                                        |
| ------------ | ------------------------------------------- |
| aot-snapshot | Compile Dart to an AOT snapshot             |
| exe          | Compile Dart to a self-contained executable |
| jit-snapshot | Compile Dart to a JIT snapshot              |
| js           | Compile Dart to JavaScript                  |
| kernel       | Compile Dart to a kernel snapshot           |

kernel生成dill文件，其实和源码差不太多，可以理解为对象序列化后的源码文件。



### dart编译aot的实现

```bash
dart.exe compile aot-snapshot C:\Work\main.dart
```

通过这条命令，我们可以将源码文件编译成二进制aot文件，通过procmon进行监视，可以发现，这条命令会调用以下命令:

```bash
> dart.exe C:\dart-sdk\bin\snapshots\gen_kernel.dart.snapshot --platform C:\dart-sdk\lib\_internal\vm_platform_strong_product.dill --aot -Ddart.vm.product=true -o C:\Users\ADMINI~1\AppData\Local\Temp\7c46dc67\kernel.dill --invocation-modes=compile --verbosity=all --sound-null-safety c:\Work\main.dart
> gen_snapshot.exe --snapshot-kind=app-aot-elf --elf=c:\work\main.aot C:\Users\ADMINI~1\AppData\Local\Temp\7c46dc67\kernel.dill
```

分析上面的命令，可以大概了解到dart先是生成dill代码，再将dill代码通过gen_snapshot.exe转换成aot文件。



事实上，通过procmon监视flutter app的生成，能发现libapp.so文件也是这么生成的:

```bash
gen_snapshot.exe --deterministic --snapshot_kind=app-aot-elf --elf=app.so --strip app.dill
```

那么我们要的核心文件生成代码在gen_snapshot这个项目里面，需要看看它是怎么把dill文件转成二进制so文件的。

### gen_snapshot源码阅读

在调试gen_snapshot源码的过程中发现断点下不下来，分析了一下生成的exe，发现代码是被优化的，很明显不是debug模式。

分析项目的配置文件，就是BUILD.gn那些玩意儿，找到runtime目录下的runtime_args.gni配置文件，修改成如下结果:

```
- dart_debug = false
+ dart_debug = true

- dart_debug_optimization_level = "2"
+ dart_debug_optimization_level = "0"
```



CreateAndWritePrecompiledSnapshot -> CreateAndWritePrecompiledSnapshot

生成的区段解释:

- Dart VM 快照 (kDartVmSnapshotData): 代表 isolate 之间共享的 Dart 堆 (heap) 的初始状态。有助于更快地启动 Dart isolate，但不包含任何 isolate 专属的信息。
- Dart VM 指令 (kDartVmSnapshotInstructions): 包含 VM 中所有 Dart isolate 之间共享的通用例程的 AOT 指令。这种快照的体积通常非常小，并且大多会包含程序桩 (stub)。
- Isolate 快照 (kDartIsolateSnapshotData): 代表 Dart 堆的初始状态，并包含 isolate 专属的信息。
- Isolate 指令 (kDartIsolateSnapshotInstructions): 包含由 Dart isolate 执行的 AOT 代码。



核心文件

app_snapshot.h





FullSnapshotWriter::WriteVMSnapshot，生成头部



### 参考资料

[Flutter机器码生成gen_snapshot - Gityuan博客 | 袁辉辉的技术博客](http://gityuan.com/2019/09/21/flutter_gen_snapshot/)
