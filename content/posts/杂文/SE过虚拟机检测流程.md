---
title: "SE过虚拟机检测流程"
date: 2021-07-04
tags: ["SafeEngine"]
categories: ["杂文"]
---

#### 1.注册表检测

[HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\BIOS]
"SystemManufacturer"="VMware, Inc."

根据SystemManufacturer中的内容计算出一个hash值，判断是否为0x6A7BDBF4。

可以通过修改注册表来绕过此检测。

#### 2.特权指令检测

通过以下代码来检测是否在虚拟机内

```c++
bool IsInsideVMWare()
{
	bool rc = true;
	__try
	{
		__asm
		{
			push edx
			push ecx
			push ebx
			mov eax, ‘VMXh’
			mov ebx, 0 // 将ebx设置为非幻数’VMXH’的其它值
			mov ecx, 10 // 指定功能号，用于获取VMWare版本，当它为0x14时用于获取VMware内存大小
			mov edx, ‘VX’ // 端口号
			in eax, dx // 从端口dx读取VMware版本到eax
			//若上面指定功能号为0x14时，可通过判断eax中的值是否大于0，若是则说明处于虚拟机中
			cmp ebx, ‘VMXh’ // 判断ebx中是否包含VMware版本’VMXh’，若是则在虚拟机中
			setz [rc] // 设置返回值
			pop ebx
			pop ecx
			pop edx
		}
	}
	__except(EXCEPTION_EXECUTE_HANDLER) //如果未处于VMware中，则触发此异常
	{
		rc = false;
	}
	return rc;
}
```

目前没有找到什么好办法，可以在虚拟机vmx文件中加入以下配置绕过检测:

```
monitor_control.restrict_backdoor = TRUE
```

但这样有一个缺点就是会使Vmware Tools工具失效。

#### 3.vpcext指令检测

```c++
DWORD __forceinline IsInsideVPC_exceptionFilter(LPEXCEPTION_POINTERS ep) 
{    
  PCONTEXT ctx = ep->ContextRecord;    
    
  ctx->Ebx = -1; // Not running VPC    
  ctx->Eip += 4; // skip past the "call VPC" opcodes    
  return EXCEPTION_CONTINUE_EXECUTION; // we can safely resume execution since we skipped faulty instruction 
}

// high level language friendly version of IsInsideVPC()    
bool IsInsideVPC()    
{    
  bool rc = false;    
    
  __try    
  {    
    _asm push ebx    
    _asm mov  ebx, 0 // Flag    
    _asm mov  eax, 1 // VPC function number    
    
    // call VPC     
    _asm __emit 0Fh
    _asm __emit 3Fh
    _asm __emit 07h
    _asm __emit 0Bh
    
    _asm test ebx, ebx    
    _asm setz [rc]
    _asm pop ebx    
  }
  // The except block shouldn't get triggered if VPC is running!!    
  __except(IsInsideVPC_exceptionFilter(GetExceptionInformation()))    
  {    
      
  }    
    
  return rc;    
}  
```

这套代码是用来检测VPC虚拟机的，Vmware不用管。

#### 4.cpuid指令检测

据说是检测cpuid一号功能 ecx的最高位。

.vmx文件中添加下面配置可绕过检测。

```
cpuid.1.ecx = "0111:1111:1101:1010:1111:1011:1011:1111"
```

有一些AMD处理器的电脑似乎不支持上面的配置，修改后会无法正常启动虚拟机。这个时候添加下面的代码:

```
hypervisor.cpuid.v0 = "FALSE"
```

#### 参考资料

[sanbarrow.com](http://sanbarrow.com/index.html)

[绕过SE的虚拟机检测](https://www.52pojie.cn/thread-598022-1-1.html)