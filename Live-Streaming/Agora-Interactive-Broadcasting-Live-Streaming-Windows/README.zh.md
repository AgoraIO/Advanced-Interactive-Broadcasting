# Agora-Interactive-Broadcasting-Live-Streaming-Windows
*Other languages: [English](README.md)*

基于声网直播项目[OpenLive](https://github.com/AgoraIO/OpenLive-Windows/tree/dev/2.2.0)修改，主要展示旁路推流2.0版本。

在这个示例项目中包含了以下功能：

- 加入通话和离开通话；
- 配置转码推流参数；
- 开始或停止向CDN推流；

## 运行示例程序
首先在 [Agora.io 注册](https://dashboard.agora.io/cn/signup/) 注册账号，并创建自己的测试项目，获取到 AppID。将appid放入代码中APP_ID宏定义中


然后在 [Agora.io SDK](https://www.agora.io/cn/download/) 获取2.2.1 window端sdk 放到 LiveStreaming目录下 sdk目录下包含 dll,lib,include 3各部分文件

最后用 Visual Studio 2013 打开该项目，编译并运行。
需要将sdk 中的dll 拷贝到 执行目录下
点击 OpenLive.exe 即可运行。


## 联系我们
- 完整的 API 文档见 [文档中心](https://docs.agora.io/cn/)
- 如果在集成中遇到问题, 你可以到 [开发者社区](https://dev.agora.io/cn/) 提问
- 如果有售前咨询问题, 可以拨打 400 632 6626，或加入官方Q群 12742516 提问
- 如果需要售后技术支持, 你可以在 [Agora Dashboard](https://dashboard.agora.io) 提交工单
- 如果发现了示例代码的 bug, 欢迎提交 [issue](https://github.com/AgoraIO/Advanced-Interactive-Broadcasting/issues)

## 代码许可
The MIT License (MIT).

