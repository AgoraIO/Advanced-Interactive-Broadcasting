# Agora Inject Streaming for iOS 

*其他语言版本： [简体中文](README.zh.md)*

This readme describes the steps and considerations for demonstrating the Agora Inject Streaming iOS sample app.

## Introduction

Built upon the Agora Video SDK, the Agora Live Streaming for iOS is an open-source demo that publishes stream for CDN live.

This sample app allows you to:

- Join / leave channel
- Add Inject Stream Url
- Remove Inject Stream Url
- Switch camera
- Mute / unmute audio

## Preparing the Developer Environment

* Xcode 9.0 or later
* An iPhone or iPad

NOTE: The iOS emulator is NOT supported.

## Running the App
1. Create a developer account at [Agora.io](https://dashboard.agora.io/signin/), obtain an App ID.
2. Fill in the AppID in the *KeyCenter.swift*.
```
struct KeyCenter {
    static let AppId: String = <#Your App ID#>
}
```
3. Download the **Agora Video SDK** from [Agora.io](https://www.agora.io/en/download/).
4. Unzip the downloaded **Agora Video SDK** and copy **libs/AgoraRtcEngineKit.framework** to the "AgoraInjectStreaming" folder of your project.
5. Open AgoraLiveStreaming.xcodeproj, connect your iPhone／iPad device, set up your code signature, and run the sample app.

## Contact Us

- You can find the API documentation at the [Developer Center](https://docs.agora.io/en/).
- You can report issues about this demo at [issue](https://github.com/AgoraIO/Advanced-Interactive-Broadcasting/issues).

## License

The MIT License (MIT). 
