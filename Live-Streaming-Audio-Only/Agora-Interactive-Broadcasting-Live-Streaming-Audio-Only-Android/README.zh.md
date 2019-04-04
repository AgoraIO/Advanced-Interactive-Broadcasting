# **Agora-Interactive-Broadcasting-Live-Streaming-Audio-Only-Andorid**
*Read this in other languages: [English](README.md)*

这个开源示例项目演示了如何在纯音频场景下使用直播优化API转码推流。

在这个示例项目中包含了以下功能：

- 加入通话和离开通话；
- 开始或停止向 CDN 推流(RTMP 协议)；

## 运行示例程序
**首先**在 [Agora.io 注册](https://dashboard.agora.io/cn/signup/) 注册账号，并创建自己的测试项目，获取到 AppID。将 AppID 填写进 "app/src/main/res/values/strings_config.xml"

```
<string name="agora_app_id"><#YOUR APP ID#></string>
```

**其次**获取一个可用的推流地址，将推流地址填写进"app/src/main/java/io/agora/voice/only/livestreaming/ui/LiveRoomActivity"

```
private String mPublishUrl = "";
```
**然后**是集成 Agora 视频 SDK ，集成方式有以下两种：

- 首选集成方式：

在项目对应的模块的 "app/build.gradle" 文件的依赖属性中加入通过 JCenter 自动集成 Agora 视频 SDK 的地址：

```xml
implementation 'io.agora.rtc:full-sdk:2.3.3'
```

- 次选集成方式：

第一步: 在 [Agora.io SDK](https://www.agora.io/cn/download/) 下载 **视频通话 + 直播 SDK**，解压后将其中的 **libs** 文件夹下的 ***.jar** 复制到本项目的 **app/libs** 下，其中的 **libs** 文件夹下的 **arm64-v8a**，**x86**，**armeabi-v7a** 复制到本项目的 **app/src/main/jniLibs** 下。

第二步: 在本项目的 "app/build.gradle" 文件依赖属性中添加如下依赖关系：

```xml
implementation fileTree(dir: 'libs', include: ['*.jar'])
```

**最后**用 Android Studio 打开该项目，连上设备，编译并运行。

也可以使用 `Gradle` 直接编译运行。

## 提示
如果要强杀程序，如果已经开启推流，请关闭推流后再强杀，否则会造成推流地址不可用，报19错误。
如果遇到此错误需要等待片刻后重新推流即可。

## 运行环境
- Android Studio 3.3 +
- 真实 Android 设备 (Nexus 5X 或者其它设备)
- 部分模拟器会存在功能缺失或者性能问题，所以推荐使用真机

## 联系我们
- 完整的 API 文档见 [文档中心](https://docs.agora.io/cn/)
- 如果在集成中遇到问题, 你可以到 [开发者社区](https://dev.agora.io/cn/) 提问
- 如果有售前咨询问题, 可以拨打 400 632 6626，或加入官方Q群 12742516 提问
- 如果需要售后技术支持, 你可以在 [Agora Dashboard](https://dashboard.agora.io) 提交工单
- 如果发现了示例代码的 bug, 欢迎提交 [issue](https://github.com/AgoraIO/Advanced-Interactive-Broadcasting/issues)

## 代码许可
The MIT License (MIT).
