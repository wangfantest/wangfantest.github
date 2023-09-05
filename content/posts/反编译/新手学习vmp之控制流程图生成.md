# 新手学习Vmp之控制流程图生成

控制流程图的生成对于反混淆分析来说是非常重要的一步，这里记录一下我研究的过程，以Vmp2为例子。

这里我的环境准备如下:

Visual Studio + IDA SDK + Capstone + Unicorn + Graphviz

IDA SDK插件环境，主要是有一些API可以调用，方便编写代码，X64Dbg插件环境可以替代之。

Capstone，一个很不错的反汇编引擎，IDA自带的反汇编引擎不太好用，用这个替代之。

Unicorn，指令模拟执行，用来跟踪指令。

Graphviz，一个绘图工具，可以将控制流程图可视化。



要生成流程图，首先使用unicron引擎对指令进行跟踪，大致步骤如下:

1、使用uc_mem_map和uc_mem_write函数填充内存区域和堆栈

2、uc_hook_add设置监视函数，每次执行指令前检查退出条件，例如当前指令位于text区段且上一条指令是ret的时候，基本上就是vmp结束的时候了。

3、uc_emu_start进行trace，拿到所有的指令跟踪数组。



之后是根据这些地址动态生成控制流程图，这里了解一下基本块这个概念就行了。

在遍历地址的过程中动态生成流程图，核心逻辑如下:

```C++
bool VmpTraceFlowGraph::GenerateBasicFlowData(std::vector<ea_t>& traceList)
{
	if (!traceList.size()) {
		return false;
	}
	cs_insn* curIns;
	VmpTraceFlowNode* currentNode = createNode(traceList[0]);;
	for (unsigned int n = 0; n < traceList.size(); ++n) {
		const ea_t& curAddr = traceList[n];
		if (!DisasmManager::DecodeInstruction(curAddr, curIns)) {
			return false;
		}
		//不管是什么指令,都立即追加到当前基本块
		if (!currentNode->bTraced) {
			currentNode->addrList.push_back(curAddr);
			updateInstructionToBlockMap(curAddr, currentNode);
		}
		//判断是否为终止指令
		if (isEndIns(curIns)) {
			//检查是否为最后一条指令
			if (n + 1 >= traceList.size()) {
				break;
			}
			currentNode->bTraced = true;
			//这里开始进行核心判断
			ea_t nextNodeAddr = traceList[n + 1];
			VmpTraceFlowNode* nextNode = instructionToBlockMap[nextNodeAddr];
			linkEdge(curAddr, nextNodeAddr);
			//下一个节点是新节点
			if (!nextNode) {
				currentNode = createNode(nextNodeAddr);
			}
			//已访问过该节点,且节点指向Block头部
			else if (nextNode->nodeEntry == nextNodeAddr) {
				currentNode = nextNode;
			}
			else {
				//节点指向已有区块其它地址,需要对区块进行分割
				currentNode = splitBlock(nextNode, nextNodeAddr);
			}
		}
	}
	return true;
}
```

再进行节点合并优化，核心代码是这样的:

```c++
void VmpTraceFlowGraph::MergeNodes()
{
	//已确定无法合并的节点
	std::set<ea_t> badNodeList;
	bool bUpdateNode;
	do
	{
		bUpdateNode = false;
		std::map<ea_t, VmpTraceFlowNode>::iterator it = nodeMap.begin();
		while (it != nodeMap.end()) {
			ea_t nodeAddr = it->first;
			if (badNodeList.count(nodeAddr)) {
				it++;
				continue;
			}
			//判断合并条件
			//条件1,指向子节点的边只有1条
			if (toEdges[nodeAddr].size() == 1) {
				ea_t fromAddr = *toEdges[nodeAddr].begin();
				VmpTraceFlowNode* fatherNode = instructionToBlockMap[fromAddr];
				//条件2,父节点指向的边也只有1条
				if (fromEdges[fromAddr].size() == 1) {
					//条件3,子节点不能指向父节点
					if (!fromEdges[nodeAddr].count(fatherNode->addrList[fatherNode->addrList.size() - 1])) {
						executeMerge(fatherNode, &it->second);
						bUpdateNode = true;
						it = nodeMap.erase(it);
						continue;
					}
				}
			}
			badNodeList.insert(nodeAddr);
			it++;
		}
	} while (bUpdateNode);
}
```

最后是将流程图转换成dot语言，核心代码如下:

```c++
std::string VmpTraceFlowGraph::DumpGraph()
{
	std::stringstream ss;
	ss << "strict digraph \"hello world\"{\n";
	cs_insn* tmpIns = 0x0;

	char addrBuffer[0x10];
	for (std::map<ea_t, VmpTraceFlowNode>::iterator it = nodeMap.begin(); it != nodeMap.end(); ++it) {
		VmpTraceFlowNode& node = it->second;
		sprintf_s(addrBuffer, sizeof(addrBuffer), "%08X", it->first);
		ss << "\"" << addrBuffer << "\"[label=\"";
		for (unsigned int n = 0; n < node.addrList.size(); ++n) {
			//测试代码
			if (n > 20 && (n != node.addrList.size() - 1)) {
				continue;
			}
			DisasmManager::DecodeInstruction(node.addrList[n], tmpIns);
			sprintf_s(addrBuffer, sizeof(addrBuffer), "%08X", node.addrList[n]);
			ss << addrBuffer << "\t" << tmpIns->mnemonic << " " << tmpIns->op_str << "\\n";
		}
		ss << "\"];\n";
	}

	for(std::map<ea_t, std::unordered_set<ea_t>>::iterator it = fromEdges.begin(); it != fromEdges.end(); ++it){
		std::unordered_set<ea_t>& edgeList = it->second;
		for (std::unordered_set<ea_t>::iterator edegIt = edgeList.begin(); edegIt != edgeList.end(); ++edegIt) {
			VmpTraceFlowNode* fromBlock = instructionToBlockMap[it->first];
			sprintf_s(addrBuffer, sizeof(addrBuffer), "%08X", fromBlock->nodeEntry);
			ss << "\"" << addrBuffer << "\" -> ";
			sprintf_s(addrBuffer, sizeof(addrBuffer), "%08X", *edegIt);
			ss << "\"" << addrBuffer << "\";\n";
		}
	}
	ss << "\n}";
	return ss.str();
}
```

得到文件后，调用dot命令行打印出流程图

```powershell
dot graph.txt -T png -o vmp2.png
```

