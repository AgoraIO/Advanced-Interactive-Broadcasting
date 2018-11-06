# **Agora-Interactive-Broadcasting-Live-Streaming-iOS**

*阅读中文版本: [中文](README.zh.md)*


This open source sample project demonstrates how to use the Live Streaming API for transcoding.
The small demo contains following features:

- join/leave calls
- publish/unpublish streams
- add transcoding user and start live streaming


## How to run
Firstly you will need to register an account at [Agora.io](https://dashboard.agora.io/signin/). With your account logged in, you will be able to create your own test project at dev portal, there you can get your unique AppID. Take a note with your AppID as it will be used in later steps.

```
fileprivate let liveKit = AgoraLiveKit.sharedLiveKit(withAppId: <#Appid#>)

```


Get an available push address, fill in the push address.
```
func streamURL(for room: String) -> String {
   return <#streamURL#>
}
```
Next, download the **Agora Video SDK** from [Agora.io SDK](https://www.agora.io/en/blog/download/). Unzip the downloaded SDK package and copy the framework file  **AgoraRtcEngineKit.framework**   to the "AgoraPushStreaming/AgoraPushStreaming/" folder in project.

Finally, open the project with XCode, connect the device, compile and run.

## Notice
If you want to kill the program, if you have to open the stream, please close the stream and then kill, otherwise it will cause the stream address is not available, reported errorcode:19.
If you encounter this error, you need to wait for a while before re-streaming.

## Sample button introduction
- Suspended window is even Mai Mai image.
- Set button to set transcoding flow parameters (App has default parameters).
- RTMP button to start or cancel the stream.
- Exit button to close the program.

## Developer Environment Requirements
- Use Xcode open the project
- Connect iPhone
- Part of the simulator there will be missing or performance issues, it is recommended to use a real machine.

## Connect Us

- You can find full API document at [Document Center](https://docs.agora.io/en/)
- You can file bugs about this demo at [issue](https://github.com/AgoraIO/Advanced-Interactive-Broadcasting/issues)

## License

The MIT License (MIT).

