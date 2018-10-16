# **Agora-Interactive-Broadcasting-Live-Streaming-Android**

*其他语言版本： [简体中文](README.zh.md)*

The Agora Android interactive broadcasting live streaming is an open-source demo that will show you how to publish streams to CDN(with RTMP, you can also enable transcoding with customized parameters) with lite broadcasting live api.

With this sample app, you can:

- Join / leave channel
- Config transcoding parameters
- Start / stop RTMP streaming to CDN from Agora cloud

## Running the App

First, create a developer account at [Agora.io](https://dashboard.agora.io/signin/), and obtain an App ID. Update  "app/src/main/res/values/strings.xml" with App ID.

```
<string name="app_id"><#your app id#></string>
```

Next, obtain an available push-url. Update "app/src/main/res/values/strings.xml" with push-url.

```
<string name="stream_url"><#your url#></string>
```

Then, download the **Agora SDK** from [Agora.io SDK](https://www.agora.io/en/download/). Unzip the downloaded SDK package and copy ***.jar** under **libs ** to **app/libs**, **arm64-v8a**/**x86**/**armeabi-v7a** under **libs** to **app/src/main/jniLibs**. Add the following code in the property of the dependence of the "app/build.gradle":

```
compile fileTree(dir: 'libs', include: ['*.jar'])
```

Finally, open project with Android Studio, connect your Android device, build and run.

Or use `Gradle` to build and run.

## Tips
If you've already started RTMP streaming and you want to force-kill app, please stop RTMP streaming first, Or you will receive error code 19(RTMP streaming already ongoing). If you've got error 19, please retry after 30 seconds.

## Button description

 - Suspension window is the video of the other host.
 - Settings Button: set the transcoding parameters (the App has default parameters).
 - RTMP Button: start or stop RTMP streaming from Agora cloud.
 - Hang-up Button: close app.

## Developer Environment Requirements

- Android Studio 3.1 or above
- Real devices (Nexus 5X or other devices)
- Some simulators are function missing or have performance issue, so real device is the best choice

## Connect Us
- You can find full API document at [Document Center](https://docs.agora.io/en/)
- You can file bugs about this demo at [issue](https://github.com/AgoraIO/Agora-Interactive-Broadcasting-Live-Streaming-Android/issues)

## License

The MIT License (MIT).
