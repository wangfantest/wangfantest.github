ghidra中函数在创建的时候会使用架构中对应的默认Model，例如x86下面就是stdcall

```C++
void FuncProto::setScope(Scope *s,const Address &startpoint)
{
  store = new ProtoStoreSymbol(s,startpoint);
  if (model == (ProtoModel *)0)
    setModel(s->getArch()->defaultfp);
}
```

但是很明显在vmp架构中函数块不是stdcall，我们