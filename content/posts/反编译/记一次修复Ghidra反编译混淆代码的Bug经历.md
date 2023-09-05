---
title: "记一次修复Ghidra反编译混淆代码的Bug经历"
date: 2023-09-05
tags: ["Ghidra"]
categories: ["反编译"]
---

# 记一次修复Ghidra反编译混淆代码的Bug经历

最近在尝试使用Ghidra来对混淆代码进行反编译，然而在反编译一段代码的时候出现了问题，这里记录一下修复的过程，希望对其他人有起到一点帮助。



## 复现问题

为了方便描述代码经过了简化处理，大概是下面这个样子的:

```assembly
00401009    push 0x2F9D6707
0040100E    push 0xD915B19B
00401013    push 0x1
00401015    mov ecx,dword ptr ss:[esp+0x6]
00401019    mov dword ptr ss:[esp+ecx-0x6707D915],0x2
00401024    pop eax
00401025    retn
```

通过实际运行这段代码很明显eax最终的值是0x2，然而Ghidra在这里算出来的eax是0x1。

我们调试一下Ghidra的反编译过程，在Action::perform函数里面插个日志打印代码，将执行Action后的pcode全部都打印出来，从而快速定位到最关键的Action。

最终发现是执行oppool1这个动作后，pcode发生了错误，错误之前的pcode是下面这样的;

```
0x00401009:2:	u0x10000014(0x00401009:2) = #0x2f9d6707
0x00401009:1e:	s0xfffffffc:2(0x00401009:1e) = SUB42(u0x10000014(0x00401009:2),#0x0)
0x0040100e:5:	u0x10000010(0x0040100e:5) = #0xd915b19b
0x0040100e:1d:	s0xfffffffa:2(0x0040100e:1d) = SUB42(u0x10000010(0x0040100e:5),#0x2)
0x00401013:8:	s0xfffffff4(0x00401013:8) = #0x1
0x00401015:1b:	u0x1000000c(0x00401015:1b) = CONCAT22(s0xfffffffc:2(0x00401009:1e),s0xfffffffa:2(0x0040100e:1d))
0x00401015:a:	u0x00007a00(0x00401015:a) = u0x1000000c(0x00401015:1b)
0x00401019:c:	u0x00002700(0x00401019:c) = ESP(i) + #0x98f826df
0x00401019:e:	u0x00002880(0x00401019:e) = u0x00002700(0x00401019:c) + u0x00007a00(0x00401015:a)
0x00401019:1a:	s0xfffffff4(0x00401019:1a) = s0xfffffff4(0x00401013:8) [] i0x00401019:10(free)
0x00401019:10:	*(ram,u0x00002880(0x00401019:e)) = #0x2
0x00401024:11:	EAX(0x00401024:11) = s0xfffffff4(0x00401019:1a)
0x00401025:15:	return(EAX(0x00401024:11))
```

然而执行完oppool1之后，pcode直接变成了

```
0x00401019:e:	u0x00002880(0x00401019:e) = ESP(i) + #0xfffffff4
0x00401019:10:	*(ram,u0x00002880(0x00401019:e)) = #0x2
0x00401024:11:	EAX(0x00401024:11) = #0x1
0x00401025:15:	return(EAX(0x00401024:11)) EAX(0x00401024:11)
```

## 分析Bug原因

oppool1其实是Ghidra里面的核心Action之一，里面包含了一系列优化规则，再进一步调试oppool1里面的规则，可以定位到是RulePropagateCopy这个规则，RulePropagateCopy会对CPUI_COPY类型的节点进行传播，规则将

```
0x00401013:8:	s0xfffffff4(0x00401013:8) = #0x1
0x00401024:11:	EAX(0x00401024:11) = s0xfffffff4(0x00401013:8)
```

转换成了

```
0x00401024:11:	EAX(0x00401024:11) = #0x1
```

分析到这里，Ghidra反编译失败的原因就很明显了，在将*(ram,u0x00002880(0x00401019:e))识别成堆栈变量s0xfffffff4之前就进行了传播优化。

## 解决方案

那么怎么解决这个问题呢，Ghidra的oppool1老实说我感觉就像是一个大杂烩，啥规则都往里面扔，里面的优化逻辑就是一直优化，优化到pcode没有发生变化为止，然而优化顺序似乎不怎么能保证，因此我决定自己编写规则。

模仿oppool2中的RuleStoreVarnode规则，这个规则是尝试将store节点转换为stack变量，我们也写一个RuleVmpStoreVarnode规则，在每次遇到CPUI_STORE类型的pcode的时候，就尝试去计算写入的地址是否是堆栈。规则代码如下:

```C++
class RuleVmpStoreVarnode : public Rule {
public:
    RuleVmpStoreVarnode(const string& g) : Rule(g, 0, "vmpstorevarnode") {} ///< Constructor
    virtual Rule* clone(const ActionGroupList& grouplist) const {
        if (!grouplist.contains(getGroup())) return (Rule*)0;
        return new RuleVmpStoreVarnode(getGroup());
    }
    virtual void getOpList(vector<uint4>& oplist) const;
    virtual int4 applyOp(PcodeOp* op, Funcdata& data);
};
void RuleVmpStoreVarnode::getOpList(vector<uint4>& oplist) const
{
    oplist.push_back(CPUI_STORE);
}
int4 RuleVmpStoreVarnode::applyOp(PcodeOp* op, Funcdata& data)
{
    VmpStackEvaluator evalCall;
    Varnode* offvn = op->getIn(1);
    int stackOffset = 0x0;
    if (!evalCall.EvaluateStackOffset(data, offvn, stackOffset)) {
        return 0;
    }
    int4 size = op->getIn(2)->getSize();
    Address addr(data.getArch()->getStackSpace(), uint32_t(stackOffset));
    data.newVarnodeOut(size, addr, op);
    op->getOut()->setStackStore();    // Mark as originally coming from CPUI_STORE
    data.opRemoveInput(op, 1);
    data.opRemoveInput(op, 0);
    data.opSetOpcode(op, CPUI_COPY);
    return 1;
}
```

为了计算堆栈的偏移，写了一个类VmpStackEvaluator，核心思路就是不断遍历def节点，判断最终是否为esp + xxx这种偏移。

```C++
class VmpStackEvaluator
 {
 public:
     bool EvaluateStackOffset(Funcdata& data,Varnode* vn,int& outOffset);
 private:
     uintb traceVarnodeStack(Varnode* vn);
     uintb tracePcodeStack(PcodeOp* op);
     uintb eval(PcodeOp* op);
 private:
     bool bContainEsp = false;
     bool bError = false;
     VarnodeData espLoc;
 };
 
uintb VmpStackEvaluator::eval(PcodeOp* op)
{
   if (bError) {
        return 0x0;
    }
    uintb val1 = traceVarnodeStack(op->getIn(0));
    uintb val2 = traceVarnodeStack(op->getIn(1));
    uintb calVal = op->getOpcode()->evaluateBinary(op->getOut()->getSize(), op->getIn(0)->getSize(), val1, val2);
    return calVal;
}
 
 
uintb VmpStackEvaluator::tracePcodeStack(PcodeOp* op)
{
    if (bError) {
        return 0x0;
    }
    OpCode code = op->code();
    switch (code) {
    case CPUI_INT_ADD:
    case CPUI_INT_SUB:
    case CPUI_PIECE:
    case CPUI_SUBPIECE:
        return eval(op);
    case CPUI_COPY:
        return traceVarnodeStack(op->getIn(0));
    default:
        bError = true;
        break;
    }
    return 0x0;
}
 
uintb VmpStackEvaluator::traceVarnodeStack(Varnode* vn)
{
    if (bError) {
        return 0x0;
    }
    if (vn->isConstant()) {
        return vn->getOffset();
    }
    if (vn->isInput()) {
        if (vn->getSpace() == espLoc.space && vn->getOffset() == espLoc.offset) {
            bContainEsp = true;
        }
        else {
            bError = true;
        }
        return 0x0;
    }
    PcodeOp* defOp = vn->getDef();
    if (!defOp) {
        bError = true;
        return 0x0;
    }
    return tracePcodeStack(defOp);
}
 
bool VmpStackEvaluator::EvaluateStackOffset(Funcdata& data, Varnode* vn,int& outOffset)
{
    espLoc = data.getArch()->translate->getRegister("ESP");
    if (!vn->isWritten()) {
        return false;
    }
    PcodeOp* defOp = vn->getDef();
    if (defOp->code() != CPUI_INT_ADD && defOp->code() != CPUI_INT_SUB) {
        return false;
    }
    outOffset = tracePcodeStack(defOp);
    if (bError) {
        return false;
    }
    return bContainEsp;
}
```

不管效率怎么样，往oppool1里面扔进去这个规则，执行后最终的代码变成了:

```
0x00401024:11:	EAX(0x00401024:11) = #0x2
0x00401025:15:	return(EAX(0x00401024:11))
```

也算是勉强完成了修复吧