# Agora client side AV capturing for streaming Android

*Other languages: [简体中文](README.zh.md)*

The Agora client side AV capturing for streaming Android is an open-source demo that shows how to build a video chat application via Agora Video SDK, and get raw data of audio and video streaming to push to RTMP server.

With this sample app, you can:

- Join / leave channel
- Get raw data of audio and video streaming from Agora Video SDK
- Merge raw data to push to RTMP server

A tutorial demo for Agora Video SDK can be found here: [Agora-Android-Tutorial-1to1](https://github.com/AgoraIO/Basic-Video-Call/tree/master/One-to-One-Video/Agora-Android-Tutorial-1to1)

You can find demo for iOS here: [Agora-client-side-AV-capturing-for-streaming-iOS](https://github.com/AgoraIO/Advanced-Interactive-Broadcasting/tree/master/Client-Side-AV-Capturing/Agora-client-side-AV-capturing-for-streaming-iOS)

## Running the App
**First**, create a developer account at [Agora.io](https://dashboard.agora.io/signin/), and obtain an App ID. Update "app/src/main/res/values/strings_config.xml" with your App ID.

```
<string name="agora_app_id"><#YOUR APP ID#></string>
```

**Next**, integrate the Agora Video SDK.

There are two ways:

- The recommended way:

First, add the address which can integrate the Agora Video SDK automatically through JCenter in the property of the dependence of the "app/build.gradle":
```
implementation 'io.agora.rtc:full-sdk:2.3.0'
```
(Adding the link address is the most important step)

Then, download the **Agora Video SDK** from [Agora.io SDK](https://www.agora.io/en/download/). Unzip the downloaded SDK package and copy ***.h** under **libs/include** to **app/src/main/cpp/agora**.

- Alternative way:

Download the **Agora Video SDK** from [Agora.io SDK](https://www.agora.io/en/download/). Unzip the downloaded SDK package and copy ***.jar** under **libs** to **app/libs**, **arm64-v8a**/**x86**/**armeabi-v7a** under **libs** to **app/src/main/jniLibs**, ***.h** under **libs/include** to **app/src/main/cpp/agora**.

**Finally**, open project with Android Studio, connect your Android device, build and run.

Or use `Gradle` to build and run.

## Developer Environment Requirements
- Android Studio 3.1 or above
- Real devices (Nexus 5X or other devices)
- Some simulators are function missing or have performance issue, so real device is the best choice

## Connect Us

- You can find full API document at [Document Center](https://docs.agora.io/en/)
- You can file bugs about this demo at [issue](https://github.com/AgoraIO/Advanced-Interactive-Broadcasting/issues)

## License

The MIT License (MIT).
