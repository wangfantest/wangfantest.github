# Flutter



https://github.com/iampawan/FlutterExampleApps，这个项目收录了一些基础的flutter项目。

https://github.com/mitesh77/Best-Flutter-UI-Templates，这个是某位大哥写的app/ios项目，MIT协议可供参考。

https://flutter.github.io/samples/#?platform=web，官方的例子。



## 编译代码出错

1、Connect to 127.0.0.1:1080 [/127.0.0.1] failed: Connection refused: connect，这是因为Android Studio存在使用代理的Bug，解决方式是修改`C:\Users\Administrator\.gradle\gradle.properties`文件，填写正确的代理端口，例如

```
systemProp.http.proxyHost=127.0.0.1
systemProp.https.proxyHost=127.0.0.1
systemProp.https.proxyPort=10809
systemProp.http.proxyPort=10809
```

