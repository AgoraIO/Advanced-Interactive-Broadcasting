#Agora-Interactive-Broadcasting-Live-Streaming-Injection-Windows

*其他语言版本： [简体中文](README.zh.md)*

Injection project export external stream to the special channel. the sdk branch at least 2.9.0 upper。

The following features are included in this sample project:

- Join calls and leave calls;
- Adds an online media stream to a live broadcast.
- Removes the online media stream from a live broadcast.
 
**Note:** Call addInjectStreamUrl API must after receive onJoinChannelSuccess callback.


## Developer Environment Requirements
* VC2013 or higher
* WIN7 or higher

## Run the sample program

Register your account with [Agora.io Registration] (https://dashboard.agora.io/cn/signup/) and create your own test project to get the AppID. Fill in the AppID into source code APP_ID macro.

```
  #define APP_ID _T("Your App ID")
```

Next, download the **Agora Video SDK** from [Agora.io SDK](https://docs.agora.io/en/Agora%20Platform/downloads). Unzip the downloaded SDK package and copy the **sdk** to the "Agora-Interactive-Broadcasting-Live-Streaming-Injection-Windows" folder in project(the old one may be over written).

Finally, Open OpenLive.sln, build the solution and run.


## Contact us
- For potential issues, you may take a look at our [FAQ](https://docs.agora.io/en/faq) first
- Dive into [Agora SDK Samples](https://github.com/AgoraIO) to see more tutorials
- Would like to see how Agora SDK is used in more complicated real use case? Take a look at [Agora Use Case](https://github.com/AgoraIO-usecase)
- Repositories managed by developer communities can be found at [Agora Community](https://github.com/AgoraIO-Community)
- You can find full API document at [Document Center](https://docs.agora.io/en/)
- If you encounter problems during integration, you can ask question in [Developer Forum](https://stackoverflow.com/questions/tagged/agora.io)
- You can file bugs about this sample at [issue](https://github.com/AgoraIO/Advanced-Interactive-Broadcasting/issues)

## License

The MIT License (MIT).
