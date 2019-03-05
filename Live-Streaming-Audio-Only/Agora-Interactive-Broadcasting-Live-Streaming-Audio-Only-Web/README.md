
# Agora Interactive Broadcasting Tutorial for Web

*Read this in other languages: [中文](README.zh.md)*

This tutorial describes how to create an Agora account, download the SDK, and use the Agora sample app to integrate live streaming using the [Agora 2.0+ API](https://docs.agora.io/en/2.2/product/Voice/API%20Reference/communication_web_audio#voice-call-api).

With this sample app, you can:

- [Join calls](#create-the-join-method)
- [Leave calls](#create-the-leave-method)
- [Publish and unpublish streams](#create-the-publish-and-unpublish-methods)
- [Add user transcoding to start a live stream](#create-transcoding-methods)

## Prerequisites
- An Agora.io developer account
- A web server that supports SSL (https)

## Quick Start
This section shows you how to prepare, build, and run the sample application.

### Create an Account and Obtain an App ID
To build and run the sample application, first obtain an app ID: 

1. Create a developer account at [agora.io](https://dashboard.agora.io/signin/). Once you finish the sign-up process, you are redirected to the dashboard.
2. Navigate in the dashboard tree on the left to **Projects** > **Project List**.
3. Copy the app ID that you obtain from the dashboard into a text file. You will use this when you launch the app.

### Integrate the Agora Video SDK into the Sample Project

To use the Agora Video SDK, you must first integrate the Agora Video SDK into the sample project.

1. Download the Agora Video SDK from [Agora.io SDK](https://www.agora.io/en/download/). Under the **Video + Interactive Broadcasting SDK** heading, choose the **Web** download.
2. Unzip the downloaded SDK package.

	![download.jpg](images/download.jpg)

3. Copy the `AgoraRTCSDK` .js file into the root of your GitHub project folder. The file will have a sample name similar to `AgoraRTCSDK-2.2.0.js`.

	**Note:** `2.2.0` is a placeholder for the version number of the SDK .js file you downloaded.
	
### Update and Run the Sample Application 

1. Open the `index.html` file in a code editor.
2. At the top of the file, in the `<head>` section, make sure the JavaScript file source is now `AgoraRTCSDK-2.2.0.js`. Ensure the `2.2.0` placeholder is the version number of the SDK .js file you downloaded.

	**Before**

	``` JavaScript
  	<script src="AgoraRTCSDK-2.1.0.js"></script>
	```

	**After**

	``` JavaScript
	<script src="build/AgoraRTC-2.2.0.js"></script>
	```
	
3. Deploy the project on a web server. Make sure you access the page through an SSL (https) connection. The Agora SDK requires a secure connection to use the audio and video devices connected to the browser.
4. Use your browser to navigate to the `index.html` file. After you load the sample app, your browser looks like this:

	![appPreview.jpg](images/appPreview.jpg)

5. In your browser window, paste the `AppID` into the **Key** UI text field.

	![download.jpg](images/demoKey.jpg)

6. Add your RTMP server URL into the **Publish Url** field.

	![publishUrl.jpg](images/publishUrl.jpg)

7. Press the **Join** UI button to join the call. As soon as someone else joins the call, the call starts, and you and the other caller can see each other in the browser window.

	**Note:** If your sample app must be accessible on mobile browsers, ensure the [`createClient`](https://docs.agora.io/en/2.2/product/Voice/API%20Reference/communication_web_audio#voice-call-api) method is called with the proper `mode`. See [Create the Join Method](#create-the-join-method). For more information, see the [Agora API documentation](https://docs.agora.io/en/).

8. To add an existing user to the live stream video, press **Add Transcoding User**. Use the transcoding user configuration fields to modify the user's frame position and size.

	![transcodingUser.jpg](images/transcodingUser.jpg)

9. To start a live stream with the same transcoding settings, press **Add Streaming**.

	![addStream.jpg](images/addStream.jpg)

## Resources
* A detailed code walkthrough for this sample is available in [Steps to Create this Sample](./guide.md).
* Find complete [API documentation at the Document Center](https://docs.agora.io/en/).
* [File bugs about this sample](https://github.com/AgoraIO/Advanced-Interactive-Broadcasting/issues).

## License
This software is under the MIT License (MIT). [View the license](LICENSE.md).
