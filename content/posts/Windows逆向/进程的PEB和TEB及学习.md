# 进程的PEB和TEB学习

mov eax,fs:[0x18] 存储的是TEB结构

mov eax,fs:[0x30] 存储的是PEB结构



TEB也称作是

32位进程下TEB的结构如下:

```C++
struct _TEB32
{
    //占用大小是0x1C
    struct _NT_TIB32 NtTib{
        ULONG ExceptionList;
        ULONG StackBase;
        ULONG StackLimit;
        ULONG SubSystemTib;
        union
        {
            ULONG FiberData;
            ULONG Version;
        }
        ULONG ArbitraryUserPointer;
    	ULONG Self;	//指向自己的指针,也是fs:[0x18]的来源
    }
    ULONG EnvironmentPointer;
    struct CLIENT_ID{
        HANDLE UniqueProcess;
        HANDLE UniqueThread;
    }
    PVOID ActiveRpcHandle;
    PVOID ThreadLocalStoragePointer;
    PEB* ProcessEnvironmentBlock;	//指向PEB,也是fs:[0x30]的来源
    //...
}
```

