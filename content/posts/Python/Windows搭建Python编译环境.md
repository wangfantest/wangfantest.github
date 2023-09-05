---
title: "Windows搭建Python源码编译环境"
date: 2023-05-05
tags: ["Python"]
categories: ["Python"]
---

# Windows搭建Python源码编译环境

1、下载源码

https://www.python.org/downloads/release/python-273/

下载Source release版本就行了

2、运行PCBuild目录下的get_externals.bat，没有就不用运行了。

3、编译失败，提示找不到timezone、daylight、tzname等标识符，在变量名称前加一个下划线符号就行了。

4、编译失败，提示无法解析的外部符号 imp__pioinfo，找到PythonCore工程中的`_PyVerify_fd`函数，修改为以下代码

```C++
/* This function emulates what the windows CRT does to validate file handles */
int
_PyVerify_fd(int fd)
{
  //  const int i1 = fd >> IOINFO_L2E;
  //  const int i2 = fd & ((1 << IOINFO_L2E) - 1);

  //  static int sizeof_ioinfo = 0;

  //  /* Determine the actual size of the ioinfo structure,
  //   * as used by the CRT loaded in memory
  //   */
  //  if (sizeof_ioinfo == 0 && __pioinfo[0] != NULL) {
  //      sizeof_ioinfo = _msize(__pioinfo[0]) / IOINFO_ARRAY_ELTS;
  //  }
  //  if (sizeof_ioinfo == 0) {
  //      /* This should not happen... */
  //      goto fail;
  //  }

  //  /* See that it isn't a special CLEAR fileno */
  //  if (fd != _NO_CONSOLE_FILENO) {
  //      /* Microsoft CRT would check that 0<=fd<_nhandle but we can't do that.  Instead
  //       * we check pointer validity and other info
  //       */
  //      if (0 <= i1 && i1 < IOINFO_ARRAYS && __pioinfo[i1] != NULL) {
  //          /* finally, check that the file is open */
  //          my_ioinfo* info = (my_ioinfo*)(__pioinfo[i1] + i2 * sizeof_ioinfo);
  //          if (info->osfile & FOPEN) {
  //              return 1;
  //          }
  //      }
  //  }
  //fail:
  //  errno = EBADF;
    //a call to _get_osfhandle with invalid fd sets errno to EBADF
    if (_get_osfhandle(fd) == INVALID_HANDLE_VALUE)
        return 0;
    else
        return 1;
    return 0;
}
```

