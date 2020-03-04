# Agora-Interactive-Broadcasting-Live-Streaming-Windows
*其他语言: [中文](README.zh.md)*

This open source example is based on live demo [OpenLive](https://github.com/AgoraIO/Basic-Video-Broadcasting/tree/master/OpenLive-Windows),and demonstrate how to transcode streaming 2.0.

The following features are included in this sample project:

- Join calls and leave calls;
- Configure transcoding and streaming parameters;
- Start or stop pushing to the CDN;

## Developer Environment Requirements
* VC2013 or higher
* WIN7 or higher

## Run the sample program
1. register your account with [Agora.io Registration] (https://dashboard.agora.io/cn/signup/) and create your own test project to get the AppID. Fill in the AppID into source code APP_ID macro:

    ```
     #define APP_ID _T("Your App ID")
    ```

2. [Agora.io SDK](https://www.agora.io/cn/download/) to get window side sdk into LiveStreaming directory sdk directory contains dll, lib, include 3 parts of the file

3. Open the project with Visual Studio 2013, compile and run.
Need to copy the dll in sdk to the execution directory
Click OpenLive.exe to run.


## Contact us
- For potential issues, you may take a look at our [FAQ](https://docs.agora.io/en/faq) first
- Dive into [Agora SDK Samples](https://github.com/AgoraIO) to see more tutorials
- Would like to see how Agora SDK is used in more complicated real use case? Take a look at [Agora Use Case](https://github.com/AgoraIO-usecase)
- Repositories managed by developer communities can be found at [Agora Community](https://github.com/AgoraIO-Community)
- You can find full API document at [Document Center](https://docs.agora.io/en/)
- If you encounter problems during integration, you can ask question in [Developer Forum](https://stackoverflow.com/questions/tagged/agora.io)
- You can file bugs about this sample at [issue](https://github.com/AgoraIO/Advanced-Interactive-Broadcasting/issues)

## Code license
The MIT License (MIT).


