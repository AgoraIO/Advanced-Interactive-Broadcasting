# Injection Streaming for Android

This tutorial describes how to add Agora injection streaming for CDN live to your Android applications using the Agora Video SDK.

With this sample app you can:

- [Join / leave a channel](#define-interaction-methods)
- [Add an injection stream URL](#define-join-leave-event-listeners)
- [Remove an injection stream URL](#define-interaction-methods)

## Prerequisites

- Android Studio 2.0 or above
- Android SDK Platform 25+
- Android SDK Build-Tools 25.0.2+
- Android NDK
- Android device (for example, Nexus 5X)
	
	**Note:** Use a physical device to run the sample. Some simulators lack the functionality or the performance needed to run the sample.

## Quick Start

This section shows you how to prepare, build, and run the sample application.

- [Create an Account and Obtain an App ID](#create-an-account-and-obtain-an-app-id)
- [Integrate the Agora Video SDK](#integrate-the-agora-video-sdk) 


### Create an Account and Obtain an App ID

To build and run the sample application, first obtain an App ID: 

1. Create a developer account at [agora.io](https://dashboard.agora.io/signin/). Once you finish the signup process, you are redirected to the dashboard.
2. In the dashboard tree on the left, navigate to **Projects** > **Project List**.
3. Locate the file **app/src/main/res/values/strings.xml** and replace `<#YOUR APP ID#>` with the App ID from the Agora dashboard.

``` XML
<string name="app_id"><#YOUR APP ID#></string>
```


### Integrate the Agora Video SDK

To open and build the sample app, first integrate the SDK into the sample project. There are two methods: The first method uses JCenter to automatically integrate the SDK files, and the second method requires you to manually copy the SDK files to the project.

#### Method 1: Integrate the SDK Automatically Using JCenter (Recommended)

1. Clone this repository.
2. Open **app/build.gradle** and add the following line to the `dependencies` list:

	```
	...
	dependencies {
		...
		compile 'io.agora.rtc:full-sdk:2.2.0'
	}
	```

3. Download the Agora Video SDK from [Agora.io SDK](https://www.agora.io/en/download/).
4. Unzip the downloaded SDK package.
5. Copy the .h files from the **/libs/include** folder of the downloaded SDK package to the **/app/src/main/cpp/agora** folder of the sample application.


#### Method 2: Manually Copy the SDK Files

1. Clone this repository.
2. Download the Agora Video SDK from [Agora.io SDK](https://www.agora.io/en/download/).
3. Unzip the downloaded SDK package.
4. Copy the .jar file from the **libs** folder of the downloaded SDK package to the **/apps/libs** folder of the sample application.
5. Copy the .so files from the **arm64-v8a** folder of the downloaded SDK package to the **/app/src/main/jniLibs/arm64-v8a** folder of the sample application.
6. Copy the .so files from the **armeabi-v7a** folder of the downloaded SDK package to the **/app/src/main/jniLibs/armeabi-v7a** folder of the sample application.
7. Copy the .so files from the **x86** folder of the downloaded SDK package to the **/app/src/main/jniLibs/x86a** folder of the sample application.
8. Copy the .h files from the **include** folder of the downloaded SDK package to the **/app/src/main/cpp/agora** folder of the sample application.
8. Open the **app/build.gradle** file and add the following line to the `dependencies` list:

	```
	...
	dependencies {
		...
		compile fileTree(dir: 'libs', include: ['*.jar'])
	}
	```


### Download and Build the Sample Application 

Ensure USB debugging is enabled on your device under **Settings > Developer options** and connect the device to your computer.

#### Method 1: Using Android Studio (Recommended)

1. Open the sample application in Android Studio.
2. Build and run the sample project. This should display the application on your device.

**Note:** If your application does not compile in Android Studio, you might need to install additional Android SDK support files. Check the **Build Error** window to troubleshoot.

#### Method 2: Using the Command Line

1. In Android Studio, select **View > Tool Windows > Terminal** to open the command line app.

2. Build and run the sample project with the following command, replacing `path/to/your_app` with the app directory path and app name. The application displays on your device.

	``` 
	adb -d install path/to/your_app.apk	
	```

## Steps to Create the Sample 

- [Set Permissions](#set-permissions)
- [Add Activities to Manifest](#add-activities-to-manifest)
- [Create Visual Assets](#create-visual-assets)
- [Design the User Interface](#design-the-user-interface)
- [Create the MainActivity Class](#create-the-mainactivity-class)
- [Create the ShowActivity Class](#create-the-showactivity-class)

### Set Permissions
The `AndroidManifest.xml` file applies a set of `uses-permissions` settings:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="agora.io.injectstream">

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.RECORD_AUDIO" />
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.BLUETOOTH" />

...

</manifest>
```

These settings allow the app to access the following Android features:

Permission name|Permission description
----|----
`android.permission.INTERNET`|The internet 
`android.permission.RECORD_AUDIO`|Audio recording
`android.permission.CAMERA `|Camera
`android.permission.MODIFY_AUDIO_SETTINGS`|Modification of audio settings
`android.permission.ACCESS_NETWORK_STATE `|Network state
`android.permission.WRITE_EXTERNAL_STORAGE `|External storage
`android.permission.BLUETOOTH `|Bluetooth

### Add Activities to Manifest

The sample app has two activities `MainActivity` and `ShowActivity`. Add the two activity settings to the `AndroidManifest.xml` file under the `application` node:

``` XML
<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="io.agora.openvcall">

	...

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:name=".MApplication"
        android:theme="@style/AppTheme">
        <activity
            android:name=".MainActivity"
            android:theme="@style/Theme.AppCompat.Light.NoActionBar">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />

                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
        <activity
            android:name=".ShowActivity"
            android:label="@string/title_activity_show"
            android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>
    </application>
</manifest>
```

### Create Visual Assets

Add the icon assets for the user interface to the `/res/drawable` folder:

|Asset|Description|Image|
|----|----|----|
|`exit.png `|An image of a gray circle for the *exit* button.|![exit.png](app/src/main/res/drawable/exit.png)|
|`main_log_text_agora.png`|Agora logo.|![main_log_text_agora.png](app/src/main/res/drawable/main_log_text_agora.png)|
|`main_log_agora.png`|App logo.|![main_log_agora.png](app/src/main/res/drawable/main_log_agora.png)

The remaining files in the `/res/drawable` folder are XML files to support in-app visual asset creation:

|Asset|Description|
|----|----|
|`chat_room_et_style_2.xml`|A black rounded rectangle for chat bubbles.|
|`chat_room_main_pk_bg.xml`|A background image for the chat room.|
|`main_btn_style.xml`|A blue rounded rectangle for button backgrounds.|
|`ic_launcher_background.xml`|An image for the app launcher.|


### Design the User Interface

- [Create the MainActivity UI](#create-the-mainactivity-ui)
- [Create the ShowActivity UI](#create-the-showactivity-ui)

#### Create the MainActivity UI

`MainActivity` and its layout are defined in */layout/activity_main.xml*. 

The main aspects of this layout are shown here:

Component|Description
-----|-----
`iv_main_log`|App logo.
`iv_main_log_text`|Agora logo.
`et_channel_name`|A text box for the channel name.
`et_inject_url`|A text box for the injection URL.
`btn_main_login`|A button for login.

#### Create the ShowActivity UI

`ShowActivity` and its layout are defined in */layout/activity_show.xml*. 

The main aspects of this layout are shown here:

Component|Description
-----|-----
`fl_inject_view`|Layout container for the chat room.
`fl_local_view`|Layout container for the local view.
`ImageView` element|Exit button.
`rv_chat_room_main_message`|Layout container for the chat room messages.

### Create the MainActivity Class

*MainActivity.java* defines and connects application functionality with the [MainActivity UI](#create-the-mainactivity-ui).

#### Create Private Variables and Initializer Method

The `MainActivity` class contains three private global variables:

Variable|Description
--- | ---
`hasPermission`|Indicates if the app as permissions.
`et`|Text field for the injection URL.
`etName`|Text field for the channel name.

``` Java
public class MainActivity extends AppCompatActivity {
    private volatile boolean hasPermission = false;
    private EditText et;
    private EditText etName;
    
    ...
}
```

The `onCreate()` method is trigged when the application starts.

1. Initialize the main activity layout using `setContentView()`.
2. Check the permissions using `checkSelfPermissions()` and set `hasPermission` to `true` if permissions have been granted.
3. Map the injection URL and channel name variables to the text input boxes using `findViewById()`.

``` Java
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        if (checkSelfPermissions()) {
            hasPermission = true;
        }

        et = findViewById(R.id.et_inject_url);
        etName = findViewById(R.id.et_channel_name);
    }
```

#### Create Permission Methods

The `checkSelfPermissions()` methods check and ask for device permissions.

The `checkSelfPermissions()` method without parameters returns if the user has granted audio, camera, and and external storage write permissions.

``` Java
    private boolean checkSelfPermissions() {
        return checkSelfPermission(Manifest.permission.RECORD_AUDIO, 200) &&
                checkSelfPermission(Manifest.permission.CAMERA, 201) &&
                checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE, 202);
    }
```

The `checkSelfPermissions()` method with parameters asks the user for the specified type of permission, and returns `true` if the permission is granted, and `false` if the permission is denied.

``` Java
    public boolean checkSelfPermission(String permission, int requestCode) {
        if (ContextCompat.checkSelfPermission(this, permission) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this,
                    new String[]{permission},
                    requestCode);
            return false;
        }

        return true;
    }
```

The `onRequestPermissionsResult()` event listener is triggered when the user grants or denies permission to device capabilities.

If the permission has been granted, and `request` code is:

Code|Description
---|---
`200`|Audio permissions have been granted, so check for camera permissions.
`201`|Audio and camera permissions have been granted, so check for external storage write permissions and set `hasPermission` to `true`.
`202`|Audio, camera, and external storage write have been granted.

``` Java
    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        switch (requestCode) {
            case 200: {
                if (grantResults.length > 0
                        && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    checkSelfPermission(Manifest.permission.CAMERA, 201);
                } else {
                    finish();
                }
                break;
            }
            case 201: {
                if (grantResults.length > 0
                        && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE, 202);
                    hasPermission = true;
                } else {
                    finish();
                }
                break;
            }
            case 202: {
                if (grantResults.length > 0
                        && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                } else {
                    finish();
                }
                break;
            }
        }
    }
```

#### Create Start Method

The `onStartClicked()` is triggered by the login / start button in the MainActivity UI.

Before executing the remaining method statements:

1. Ensure device permissions for audio and video have been enabled. If the permissions are not set, display an alert to the user to check permissions.
2. Ensure the injection URL `et` is not empty. If the text input box is empty, display an alert to the user to input a URL.
3. Ensure the channel n ame `etName` is not empty. If the text input box is empty, display an alert to the user to enter a channel name.

Initialize the activity:

1. Create a new `Intent` with `MainActivity` and `ShowActivity`.
2. Add the injection URL and channel name to the intent using `i.putExtra()`.
3. Start the activity with the intent, using `startActivity()`.

``` Java
    public void onStartClicked(View v) {
        if (!hasPermission) {
            Toast.makeText(this, "Please check permissions!", Toast.LENGTH_SHORT).show();
            return;
        }

        if (null == et || TextUtils.isEmpty(et.getText().toString())){
            Toast.makeText(this, "Please input a url!", Toast.LENGTH_SHORT).show();
            return;
        }

        if (null == etName || TextUtils.isEmpty(etName.getText().toString())){
            Toast.makeText(this, "Please input a channel name!", Toast.LENGTH_SHORT).show();
            return;
        }


        Intent i = new Intent(MainActivity.this, ShowActivity.class);
        i.putExtra("INJECT_URL", et.getText().toString());
        i.putExtra("CHANNEL_NAME", etName.getText().toString());
        startActivity(i);
    }
```

### Create the ShowActivity Class

*ShowActivity.java* defines and connects application functionality with the [ShowActivity UI](#create-the-showactivity-ui).

- [Define Private Variables](#define-private-variables)
- [Define Initialization Method](#define-initialization-method)
- [Define Interaction Methods](#define-interaction-methods)
- [Define Join / Leave Event Listeners](#define-join-leave-event-listeners)
- [Define User Event Listeners](#define-user-event-listeners)
- [Define Stream Event Listeners](#define-stream-event-listeners)
- [Define Error Event Listener](#define-error-event-listener)
- [Define Configuration and Chat Methods](#define-configuration-and-chat-methods)

#### Define Private Variables

Variable|Description
---|---
`mWorkThread`|Worker thread object, which manages communication with the Agora SDK.
`localView`|Container for the local video view.
`injectView`|Container for the injection video view.
`mLocal`|Reference to the local view in the UI layout.
`mInject`|Reference to the injection view in the UI layout.
`url`|The URL for the injection view.
`msgView`|Container for the chat messages.
`mMessageDataSet`|List of chat messages.
`mCrmAdapter`|`CRMRecycleAdapter` object which helps in the display of chat messages.
`hasInjectedJoined`|Indicates if the injection user has joined.

``` Java
public class ShowActivity extends AppCompatActivity implements IMediaEngineHandler {
    private WorkThread mWorkThread;
    private SurfaceView localView;
    private SurfaceView injectView;

    private FrameLayout mLocal;
    private FrameLayout mInject;
    private String url;

    private RecyclerView msgView;
    private List<String> mMessageDataSet = new ArrayList<>();
    private CRMRecycleAdapter mCrmAdapter;

    private boolean hasInjectedJoined = false;
    
    ...
}
```

#### Define Initialization Method

The `onCreate()` method is triggered when the view is loaded.
``` Java
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        ...
    }
```

Load the show activity UI layout using `setContentView()` and initialize the application's worker thread using `initWorkThread()`.

``` Java
        setContentView(R.layout.activity_show);

        ((MApplication)getApplication()).initWorkThread();
```

Configure the message view:

1. Initialize the message view with the `R.id.rv_chat_room_main_message` UI layout object using `findViewById()`.
2. Set the message view to a fixed size using `msgView.setHasFixedSize()`.
3. Initialize `mCrmAdapter()` with the message data set object.
4. Set the message view's adapter using `msgView.setAdapter()`.
5. Set the layout to a vertical linear layout, using `msgView.setLayoutManager()`.
6. Add the item decoration to the message view using `msgView.addItemDecoration()`.

``` Java
        msgView = findViewById(R.id.rv_chat_room_main_message);
        msgView.setHasFixedSize(true);
        mCrmAdapter = new CRMRecycleAdapter(new WeakReference<Context>(this), mMessageDataSet);
        msgView.setAdapter(mCrmAdapter);
        msgView.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false));
        msgView.addItemDecoration(new CRMItemDecor());
```

Initialize and configure the worker thread:

1. Initialize `mWorkThread` using `getWorkThread()`
2. Add an event listener to this activity using `mWorkThread.handler().addEventHandler()`.
3. Configure the Agora engine with a broadcaster role and video profile of 480P using `mWorkThread.configEngine()`.
4. Join the channel using `mWorkThread.joinChannel()`.

``` Java
        mWorkThread = ((MApplication)getApplication()).getWorkThread();
        mWorkThread.handler().addEventHandler(this);
        mWorkThread.configEngine(Constants.CLIENT_ROLE_BROADCASTER, Constants.VIDEO_PROFILE_480P);
        mWorkThread.joinChannel(getIntent().getStringExtra("CHANNEL_NAME"), 0);
```

Setup the local and injection views:

1. Initialize the local and injection views with the Agora engine using `RtcEngine.CreateRendererView()`.
2. Initialize the local and injection UI references using `findViewById()`.

``` Java
        localView = RtcEngine.CreateRendererView(this);
        injectView = RtcEngine.CreateRendererView(this);

        mLocal = findViewById(R.id.fl_local_view);
        mInject = findViewById(R.id.fl_inject_view);
```

Start the local view's preview using `mWorkThread.preview()` and set the injection url using `getStringExtra()`.

``` Java
        mWorkThread.preview(true, localView, 0);

        url = getIntent().getStringExtra("INJECT_URL");
```

#### Define Interaction Methods

The `onExitClicked()` method triggers when the **Exit** UI button is pressed. Invoke the `stop()` method.

``` Java
    public void onExitClicked(View v) {
        stop();
    }
```

The `onExitClicked()` method triggers when the back button is pressed. Invoke the `stop()` method.

``` Java
    @Override
    public void onBackPressed() {
        super.onBackPressed();
        stop();
    }
```

The `stop()` method ends the video connection.

1. Leave the channel using `mWorkThread.leaveChannel()`.
2. Remove the injection stream URL using `mWorkThread.rtcEngine().removeInjectStreamUrl()`.

``` Java
    public void stop(){
        mWorkThread.leaveChannel();
        mWorkThread.rtcEngine().removeInjectStreamUrl(url);
        finish();
    }
```

#### Define Join / Leave Event Listeners

The `onJoinChannelSuccess()` method triggers when joining the channel is successful.

1. Add a message to the chat window using `sendChatMessage()`, to let the user know they have successfully joined the channel.
2. On the main thread, execute the `run()` method.

	1. Set the layout parameters for the local view using `localView.setLayoutParams()`.
	2. Set the local view to the top layer using `localView.setZOrderOnTop()`.
	3. If the number of views in the local view container is greater than `0`, remove all the views using `mLocal.removeAllViews()`.
	4. If the local view has a parent, remove all the views from the parent using `(localView.getParent())).removeAllViews()`.
	5. Add the local view to the local view container using `mLocal.addView()`.
	6. Add the injection stream URL to the Agora engine using `mWorkThread.rtcEngine().addInjectStreamUrl()`.

``` Java
    @Override
    public void onJoinChannelSuccess(String channel, int uid, int elapsed) {
        sendChatMessage("joinSuccess:" + channel);
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                localView.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
                localView.setZOrderOnTop(true);

                if (mLocal.getChildCount() > 0)
                    mLocal.removeAllViews();

                if (localView.getParent() != null)
                    ((ViewGroup)(localView.getParent())).removeAllViews();

                mLocal.addView(localView);

                mWorkThread.rtcEngine().addInjectStreamUrl(url, getConfig());
            }
        });
    }
```

The `onLeaveChannel()` triggers when the channel is successfully exited. Add code to this method to customize the user's exiting experience.

``` Java
    @Override
    public void onLeaveChannel(IRtcEngineEventHandler.RtcStats stats) {

    }
```

#### Define User Event Listeners

The `onUserJoined()` method triggers when a user joins the channel.

On the main thread, execute the `run()` method. If the user ID is `666` and the injection joined flag is `false`:

1. Add a message to the chat using `sendChatMessage()`, informing the user that the injection user has joined.
2. If the injection view has a parent view, remove all views from the parent using `(injectView.getParent())).removeAllViews()`.
3. If the injection view container has children, remove all the subviews using `mInject.removeAllViews()`.
4. Set the layout parameters for the injection view using `injectView.setLayoutParams()`.
5. Set the injection view to not maintain the top layer using `injectView.setZOrderOnTop()`.
6. Set the injection view to the remote view on the Agora engine using `mWorkThread.setmRemoteView()`.
7. Add the injection view to the injection view container using `mInject.addView()`.
8. Set the injection joined flag to `true`.

``` Java
    @Override
    public void onUserJoined(final int uid, int elapsed) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (uid == 666 && !hasInjectedJoined) {
                    sendChatMessage("inject user joined: " + uid);

                    if (injectView.getParent() != null) {
                        ((ViewGroup)(injectView.getParent())).removeAllViews();
                    }

                    if (mInject.getChildCount() > 0)
                        mInject.removeAllViews();

                    injectView.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
                    injectView.setZOrderOnTop(false);

                    mWorkThread.setmRemoteView(injectView, uid);
                    mInject.addView(injectView);
                    hasInjectedJoined = true;
                }
            }
        });

    }

```

The `onUserOffline()` method triggers when a user goes offline. Use this method to customize the user's experience when previously connected users leave the channel.

``` Java
    @Override
    public void onUserOffline(int uid, int reason) {

    }
```


#### Define Stream Event Listeners

The `onStreamPublished()` method triggers when a stream is published. Use this method to customize the user's experience when a new stream is added to the Agora engine.

``` Java
    @Override
    public void onStreamPublished(String url, int error) {

    }
```

The `onStreamPublished()` method triggers when a stream is unpublished. Use this method to customize the user's experience when an existing stream is removed from the Agora engine.

``` Java
    @Override
    public void onStreamUnpublished(String url) {

    }
```

The `onStreamInjectedStatus()` method triggers when an injection stream's status changes. Use this method to customize the user's experience when changes to the injection stream occur.

``` Java
    @Override
    public void onStreamInjectedStatus(String url, int uid, int status) {
        sendChatMessage("injected status:" + status);
    }
```

#### Define Error Event Listener

The `onError()` method triggers when an error occurs. Use this method to customize the user's experience when errors occur on the Agora engine.

``` Java
    @Override
    public void onError(int err) {

    }
```

#### Define Configuration and Chat Methods

The `getConfig()` method returns default configuration settings for the app:

1. Initialize a configuration object using `new LiveInjectStreamConfig()`.
2. Set the width and height for the configuration.
3. Set the video GOP, frame rate, and bit rate for the configuration.
4. Set the audio sample rate, bit rate, and channels for the configuration.
5. Return the configuration object.

``` Java
    public LiveInjectStreamConfig getConfig() {
        LiveInjectStreamConfig config = new LiveInjectStreamConfig();
        config.width = 0;
        config.height = 0;
        config.videoGop = 30;
        config.videoFramerate = 15;
        config.videoBitrate = 400;
        config.audioSampleRate = LiveInjectStreamConfig.AudioSampleRateType.TYPE_44100;
        config.audioBitrate = 48;
        config.audioChannels = 1;

        return config;
    }
```

The `sendChatMessage()` method adds a message to the user's chat session.

Execute the `run()` method on the main thread:

1. Add the message to the message list using `mMessageDataSet.add()`.
2. If there are more than 14 messages in the message list, iterate through the message list and remove the excess messages. 

	**Note:** The message list is set to a maximum of 15 items.

3. Update the messages in the chat view using `mCrmAdapter.upDateDataSet()`.
4. Scroll to the last message in the chat view using `msgView.smoothScrollToPosition()`.

``` Java
    public void sendChatMessage(final String message) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                mMessageDataSet.add(message);

                if (mMessageDataSet.size() > 14) {// max value is 15
                    int len = mMessageDataSet.size() - 15;
                    for (int i = 0; i < len; i++) {
                        mMessageDataSet.remove(i);
                    }
                }

                mCrmAdapter.upDateDataSet(mMessageDataSet);
                msgView.smoothScrollToPosition(mCrmAdapter.getItemCount() - 1);
            }
        });
    }
```

## Resources
- Find full API documentation in the [Document Center](https://docs.agora.io/en/)
- [File bugs about this sample](https://github.com/AgoraIO/Advanced-Interactive-Broadcasting/issues)

## License

This software is licensed under the MIT License (MIT). [View the license](../../LICENSE.md).
