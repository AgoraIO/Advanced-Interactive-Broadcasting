# **Agora-Interactive-Broadcasting-Live-Streaming-Andorid**

*其他语言版本： [简体中文](README.zh.md)*

The Agora android interactive broadcasting live streaming is an open-source demo that will show you how to publish transcoding stream with broadcasting live api.

With this sample app, you can:

- Join / leave channel
- Config transcoding params
- Start / stop publish stream to CDN

## Running the App

First, create a developer account at [Agora.io](https://dashboard.agora.io/signin/), and obtain an App ID. Update  "app/src/main/res/values/strings.xml" with App ID.

```
<string name="app_id"><#your app id#></string>
```

Next, obtain an available push-url. Update "app/src/main/res/values/strings.xml" with push-url.

```
<string name="stream_url"><#your url#></string>
```

Then, download the **Agora SDK** from [Agora.io SDK](https://www.agora.io/en/download/). Unzip the downloaded SDK package and copy ***.jar** under **libs ** to **app/libs**, **arm64-v8a**/**x86**/**armeabi-v7a** under **libs** to **app/src/main/jniLibs**. Add the fllowing code in the property of the dependence of the "app/build.gradle":

```
compile fileTree(dir: 'libs', include: ['*.jar'])
```

Finally, open project with Android Studio, connect your Android device, build and run.

Or use `Gradle` to build and run.

## Tips
If you've already started to push and you want to force-kill app, please stop push first, Otherwise you will receive 19-error. If you've got 19-error, please retry after 30 seconds.

## Button description
 - Suspension window is the image of the connecter.
 - Setting-Button sets the transfer param (the App has default params).
 - RTMP-Button start or stop push-stream.
 - Red-Button close app.
## Developer Environment Requirements

- Android Studio 2.0 or above
- Real devices (Nexus 5X or other devices)
- Some simulators are function missing or have performance issue, so real device is the best choice

## Connect Us
- You can find full API document at [Document Center](https://docs.agora.io/en/)
- You can file bugs about this demo at [issue](https://github.com/AgoraIO/Agora-Android-Tutorial-1to1/issues)

## License

The MIT License (MIT).
