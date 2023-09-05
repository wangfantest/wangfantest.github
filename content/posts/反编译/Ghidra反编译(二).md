---
title: "Ghidra反编译器(二)"
date: 2023-06-02
tags: ["Ghidra"]
categories: ["反编译"]
---

#### 关于Sleigh指令转换器

Sleigh::oneInstruction负责将二进制转换为反汇编或者PCode指令。

这是一个转换器，通过递归查表来实现快速转换。



#### 关于反编译核心Perform函数

反编译的核心动作类是在Architecture::buildAction进行构建的。

Action类就是执行一个反编译动作。

ActionGroup是按照固定的顺序执行一组反编译动作。

有各种各样的ActionGroup，根动作是ActionRestartGroup



每个动作都有一个名称，所有的规则保存在actionmap中，规则还有不同的种类:

有只执行一次的动作，还有每次函数发生改变都执行一次的动作。

动作是非常多的

```c++
ActionRestartGroup
{
	ActionStart,非常关键，基本块和流程图生成
	ActionConstbase,搜寻常量输入节点
	ActionDefaultParams,初步确定每个子函数的原型,基本都是置为空
	ActionExtraPopSetup
	ActionPrototypeTypes,
	ActionFuncLink
    actfullloop
    {
        actmainloop
        {
            ActionUnreachable,移除掉无法达到的Block块
            ActionVarnodeProps,
            ActionHeritage,非常关键，执行SSA转换
            ActionParamDouble,处理参数可能为浮点数的子函数
            ActionSegmentize,处理区段相关的东西,貌似没什么用
            ActionForceGoto,处理强制跳转
            ActionDirectWrite,优化直接写入pcode
            ActionActiveParam,分析子函数的参数
            ActionReturnRecovery,分析return的结果
            ActionRestrictLocal,分析局部变量
            ActionDeadCode,非常关键，移除未被使用的代码
            ActionDynamicMapping,
            ActionRestructureVarnode,
            ActionSpacebase,
            ActionNonzeroMask,
            ActionInferTypes,
            //不断继续优化,循环执行多遍
            actstackstall
            {
                oppool1
                {
                    //针对OP规则进行优化
                }
                ActionLaneDivide,
                ActionMultiCse,
                ActionShadowVar,
                ActionDeindirect,
                ActionStackPtrFlow,
            }
            ActionRedundBranch,
            ActionBlockStructure,
            ActionConstantPtr,
            oppool2
            {
                //针对OP规则进行优化
            }
            ActionDeterminedBranch,
            ActionUnreachable,
            ActionNodeJoin,
            ActionConditionalExe,
            ActionConditionalConst,
        }
        ActionLikelyTrash
        ActionDirectWrite
        ActionDirectWrite
        ActionDeadCode
        ActionDoNothing
        ActionSwitchNorm
        ActionReturnSplit
        ActionUnjustifiedParams
        ActionStartTypes
        ActionActiveReturn
    }
    ActionStartCleanUp
    {
        opcleanup
        {
            //针对OP规则进行优化
        }
    },
    ActionPreferComplement,
    ActionStructureTransform,
    ActionNormalizeBranches,
    ActionAssignHigh,
    ActionMergeRequired,
    ActionMarkExplicit,
    ActionMarkImplied,
    ActionMergeMultiEntry,
    ActionMergeCopy,
    ActionDominantCopy,
    ActionDynamicSymbols,
    ActionMarkIndirectOnly,
    ActionMergeAdjacent,
    ActionMergeType,
    ActionHideShadow,
    ActionCopyMarker,
    ActionOutputPrototype,
    ActionInputPrototype,
    ActionRestructureHigh,
    ActionMapGlobals,
    ActionDynamicSymbols,
    ActionNameVars,
    ActionSetCasts,
    ActionFinalStructure,
    ActionPrototypeWarnings,
    ActionStop,
}
```

