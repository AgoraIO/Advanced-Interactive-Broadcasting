# Agora client side AV capturing for streaming iOS

*Other languages: [简体中文](README.zh.md)*

The Agora client side AV capturing for streaming iOS Sample App is an open-source demo that shows how to build a broadcasting application via Agora Video SDK, and get raw data of audio and video streaming for other purpose.

With this sample app, you can:

- Join / leave channel
- Get raw data of audio and video streaming from Agora Video SDK
- Return callbacks for audio frame(mixed) and video frame in Objective-C language

A tutorial demo for Agora Video SDK can be found here: [Agora-iOS-Tutorial-Swift-1to1](https://github.com/AgoraIO/Basic-Video-Call/tree/master/One-to-One-Video/Agora-Android-Tutorial-1to1)

You can find demo for Android here:

- [Agora-client-side-AV-capturing-for-streaming-Android](https://github.com/AgoraIO/Advanced-Interactive-Broadcasting/tree/master/Client-Side-AV-Capturing/Agora-client-side-AV-capturing-for-streaming-Android)

## Running the App
First, create a developer account at [Agora.io](https://dashboard.agora.io/signin/), and obtain an App ID. Update "KeyCenter.swift" with your App ID.

```
static let AppId: String = "Your App ID"
```

Next, download the **Agora Video SDK** from [Agora.io SDK](https://www.agora.io/en/blog/download/). Unzip the downloaded SDK package and copy the **libs/AgoraRtcEngineKit.framework** to the "Agora-client-side-AV-capturing-for-streaming-iOS" folder in project.

Finally, Open Agora-client-side-AV-capturing-for-streaming-iOS.xcodeproj, connect your iPhone／iPad device, setup your development signing and run.

## Developer Environment Requirements
* XCode 10.0+
* Real devices (iPhone or iPad)
* iOS simulator is NOT supported

## Connect Us

- You can find full API document at [Document Center](https://docs.agora.io/en/)
- You can file bugs about this demo at [issue](https://github.com/AgoraIO/Advanced-Interactive-Broadcasting/issues)

## License

The MIT License (MIT).
