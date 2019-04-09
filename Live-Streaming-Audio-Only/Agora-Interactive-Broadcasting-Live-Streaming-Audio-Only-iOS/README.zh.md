# **Agora-Interactive-Broadcasting-Live-Streaming-Audio-Only-iOS**

*Other languages: [English](README.md)*

这个开源示例项目演示了如何如何使用直播优化API进行纯音频转码推流。

在这个示例项目中包含了以下功能：

- 加入通话和离开通话；
- 开始或停止向CDN推流；

## 运行示例程序
首先在 [Agora.io 注册](https://dashboard.agora.io/cn/signup/) 注册账号，并创建自己的测试项目，获取到 AppID。将 AppID 填写进KeyCenter.swift

```
struct KeyCenter {
    static let AppId: String = <#Your App ID#>
}
```

然后在 [Agora.io SDK](https://www.agora.io/cn/blog/download/) 下载 **语音通话 + 直播 SDK**，解压后将其中的 **libs/AgoraAudioKit.framework** 复制到本项目的 “Agora-Interactive-Broadcasting-Live-Streaming-Audio-Only-iOS” 文件夹下。


最后用 XCode打开该项目，连上设备，编译并运行。

## 提示
如果要强杀程序，如果已经开启推流，请关闭推流后再强杀，否则会造成推流地址不可用，报19错误。
如果遇到此错误需要等待片刻后重新推流即可。

## 示例按钮简介
- RTMP按钮启动或取消推流
- 退出按钮关闭程序

## 注意
- 纯语音情况下连麦合流，需要调用setLiveTranscoding配置相应的转码推流参数，具体请参考Demo实现。

## 运行环境
- XCode打开该项目，连上设备，编译并运行。
- 真实 iOS 设备 
- 部分模拟器会存在功能缺失或者性能问题，所以推荐使用真机

## 联系我们
- 完整的 API 文档见 [文档中心](https://docs.agora.io/cn/)
- 如果在集成中遇到问题, 你可以到 [开发者社区](https://dev.agora.io/cn/) 提问
- 如果有售前咨询问题, 可以拨打 400 632 6626，或加入官方Q群 12742516 提问
- 如果需要售后技术支持, 你可以在 [Agora Dashboard](https://dashboard.agora.io) 提交工单
- 如果发现了示例代码的 bug, 欢迎提交 [issue](https://github.com/AgoraIO/Advanced-Interactive-Broadcasting/issues)

## 代码许可
The MIT License (MIT).
