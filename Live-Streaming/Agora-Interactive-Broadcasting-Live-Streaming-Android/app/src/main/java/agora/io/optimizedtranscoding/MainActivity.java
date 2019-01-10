package agora.io.optimizedtranscoding;

import android.annotation.TargetApi;
import android.content.Intent;
import android.graphics.PorterDuff;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.content.PermissionChecker;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.SurfaceView;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import io.agora.rtc.Constants;
import io.agora.rtc.IRtcEngineEventHandler;
import io.agora.rtc.RtcEngine;

// If your Agora RTC SDK version is under 2.3.0, please import `io.agora.live.LiveTranscoding;`
import io.agora.rtc.live.LiveTranscoding;

// If your Agora RTC SDK version is under 2.3.0, please replace 'setVideoEncoderConfiguration' with 'setVideoProfile'
import io.agora.rtc.video.VideoEncoderConfiguration;

import io.agora.rtc.video.VideoCanvas;

public class MainActivity extends AppCompatActivity {
    private String mChannelName;
    private String mPublishUrl = "";

    private RecyclerView mSmallView;
    private LinearLayout mSelfView;
    private TextView mTvRoomName;
    private ImageView mIvRtmp;

    private RtcEngine mRtcEngine;
    private LiveTranscoding mLiveTranscoding;

    private Map<Integer, UserInfo> mUserInfo = new HashMap<>();
    private SmallAdapter mSmallAdapter;

    //before join channel success, big-uid is zero, after join success big-uid will modify by onJoinChannel-uid
    private int mBigUserId = 0;
    private SurfaceView mBigView;

    private MessageAdapter mMessageAdapter;
    private ArrayList<String> mMsgList;

    IRtcEngineEventHandler mRtcEngineEventHandler = new IRtcEngineEventHandler() {
        @Override
        public void onError(int errorCode) {
            super.onError(errorCode);
            sendMsg("-->onError<--" + errorCode);
        }

        @Override
        public void onWarning(int warn) {
            super.onWarning(warn);
            sendMsg("-->onWarning<--" + warn);
        }

        @Override
        public void onJoinChannelSuccess(String channel, final int uid, int elapsed) {
            super.onJoinChannelSuccess(channel, uid, elapsed);
            sendMsg("-->onJoinChannelSuccess<--" + channel + "  -->uid<--" + uid);
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    mBigUserId = uid;

                    UserInfo mUI = new UserInfo();
                    mUI.view = mBigView;
                    mUI.uid = mBigUserId;
                    mUI.view.setZOrderOnTop(true);
                    mUserInfo.put(mBigUserId, mUI);
                }
            });
        }

        @Override
        public void onFirstLocalVideoFrame(int width, int height, int elapsed) {
            super.onFirstLocalVideoFrame(width, height, elapsed);
            sendMsg("-->onFirstLocalVideoFrame<--");
        }

        @Override
        public void onRejoinChannelSuccess(String channel, int uid, int elapsed) {
            super.onRejoinChannelSuccess(channel, uid, elapsed);
            sendMsg(uid + " -->RejoinChannel<--");
        }

        @Override
        public void onLeaveChannel(RtcStats stats) {
            super.onLeaveChannel(stats);
            sendMsg("-->leaveChannel<--");
        }

        @Override
        public void onConnectionInterrupted() {
            super.onConnectionInterrupted();
            sendMsg("-->onConnectionInterrupted<--");
        }

        @Override
        public void onConnectionLost() {
            super.onConnectionLost();
            sendMsg("-->onConnectionLost<--");
        }

        @Override
        public void onStreamPublished(String url, final int error) {
            super.onStreamPublished(url, error);
            sendMsg("-->onStreamUrlPublished<--" + url + " -->error code<--" + error);
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    // error code
                    // 19 republish
                    // 0 publish success
                    if (error != 0) {
                        mIvRtmp.clearColorFilter();
                        mIvRtmp.setTag(false);
                    }
                }
            });

        }

        @Override
        public void onStreamUnpublished(String url, final int error) {
            super.onStreamUnpublished(url, error);
            sendMsg("-->onStreamUrlUnpublished<--" + url + " -->error code<--" + error);
        }

        @Override
        public void onTranscodingUpdated() {
            super.onTranscodingUpdated();
        }

        @Override
        public void onUserJoined(final int uid, int elapsed) {
            super.onUserJoined(uid, elapsed);
            sendMsg("-->onUserJoined<--" + uid);
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    UserInfo mUI = new UserInfo();
                    mUI.view = RtcEngine.CreateRendererView(MainActivity.this);
                    mUI.uid = uid;
                    mUI.view.setZOrderOnTop(true);
                    mUserInfo.put(uid, mUI);
                    mSmallAdapter.update(getSmallVideoUser(mUserInfo, mBigUserId));
                    mRtcEngine.setupRemoteVideo(new VideoCanvas(mUI.view, Constants.RENDER_MODE_HIDDEN, uid));
                    setTranscoding();
                }
            });
        }

        @Override
        public void onUserOffline(final int uid, int reason) {
            super.onUserOffline(uid, reason);
            sendMsg("-->unPublishedByHost<--" + uid);
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    mUserInfo.remove(uid);
                    mSmallAdapter.update(getSmallVideoUser(mUserInfo, mBigUserId));

                    setTranscoding();
                }
            });
        }
    };

    public static ArrayList<UserInfo> getSmallVideoUser(Map<Integer, UserInfo> userInfo, int bigUserId) {
        ArrayList<UserInfo> users = new ArrayList<>();
        Iterator<Map.Entry<Integer, UserInfo>> iterator = userInfo.entrySet().iterator();
        while (iterator.hasNext()) {
            Map.Entry<Integer, UserInfo> entry = iterator.next();
            UserInfo user = entry.getValue();
            if (user.uid == bigUserId) {
                continue;
            }
            users.add(user);
        }
        return users;
    }

    public static ArrayList<UserInfo> getAllVideoUser(Map<Integer, UserInfo> userInfo) {
        ArrayList<UserInfo> users = new ArrayList<>();
        Iterator<Map.Entry<Integer, UserInfo>> iterator = userInfo.entrySet().iterator();
        while (iterator.hasNext()) {
            Map.Entry<Integer, UserInfo> entry = iterator.next();
            UserInfo user = entry.getValue();
            users.add(user);
        }
        return users;
    }

    public static ArrayList<LiveTranscoding.TranscodingUser> cdnLayout(int bigUserId, ArrayList<UserInfo> publishers,
                                                                       int canvasWidth,
                                                                       int canvasHeight) {

        ArrayList<LiveTranscoding.TranscodingUser> users;
        int index = 0;
        float xIndex, yIndex;
        int viewWidth;
        int viewHEdge;

        if (publishers.size() <= 1)
            viewWidth = canvasWidth;
        else
            viewWidth = canvasWidth / 2;

        if (publishers.size() <= 2)
            viewHEdge = canvasHeight;
        else
            viewHEdge = canvasHeight / ((publishers.size() - 1) / 2 + 1);

        users = new ArrayList<>(publishers.size());

        LiveTranscoding.TranscodingUser user0 = new LiveTranscoding.TranscodingUser();
        user0.uid = bigUserId;
        user0.alpha = 1;
        user0.zOrder = 0;
        user0.audioChannel = 0;

        user0.x = 0;
        user0.y = 0;
        user0.width = viewWidth;
        user0.height = viewHEdge;
        users.add(user0);

        index++;
        for (UserInfo entry : publishers) {
            if (entry.uid == bigUserId)
                continue;

            xIndex = index % 2;
            yIndex = index / 2;
            LiveTranscoding.TranscodingUser tmpUser = new LiveTranscoding.TranscodingUser();
            tmpUser.uid = entry.uid;
            tmpUser.x = (int) ((xIndex) * viewWidth);
            tmpUser.y = (int) (viewHEdge * (yIndex));
            tmpUser.width = viewWidth;
            tmpUser.height = viewHEdge;
            tmpUser.zOrder = index + 1;
            tmpUser.audioChannel = 0;
            tmpUser.alpha = 1f;

            users.add(tmpUser);
            index++;
        }

        return users;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Intent i = getIntent();
        mChannelName = i.getStringExtra("CHANNEL");
        mPublishUrl = i.getStringExtra("URL");

        if (shouldRequestPermission()) {
            askPermission();
        } else {
            init();
            initEngine();
        }
    }

    private void init() {
        mSelfView = findViewById(R.id.self_container);

        mSmallView = findViewById(R.id.video_view_list);
        mSmallView.setHasFixedSize(true);
        GridLayoutManager glm = new GridLayoutManager(this, 3);
        mSmallAdapter = new SmallAdapter(this, getSmallVideoUser(mUserInfo, mBigUserId));
        mSmallView.setLayoutManager(glm);
        mSmallView.setAdapter(mSmallAdapter);

        mTvRoomName = findViewById(R.id.tv_room_name);
        mTvRoomName.setText(mChannelName);

        mIvRtmp = findViewById(R.id.iv_push_rtmp);

        initMessage();
    }

    private void initEngine() {
        try {
            mRtcEngine = RtcEngine.create(getApplicationContext(), getResources().getString(R.string.app_id), mRtcEngineEventHandler);

            mRtcEngine.setChannelProfile(Constants.CHANNEL_PROFILE_LIVE_BROADCASTING);
            mRtcEngine.setClientRole(Constants.CLIENT_ROLE_BROADCASTER);

            mRtcEngine.enableVideo();

//          mRtcEngine.setVideoProfile(Constants.VIDEO_PROFILE_480P, true); // Replaced by setVideoEncoderConfiguration in Agora RTC SDK after 2.3.0+
            mRtcEngine.setVideoEncoderConfiguration(new VideoEncoderConfiguration(VideoEncoderConfiguration.VD_640x480, VideoEncoderConfiguration.FRAME_RATE.FRAME_RATE_FPS_15, VideoEncoderConfiguration.STANDARD_BITRATE, VideoEncoderConfiguration.ORIENTATION_MODE.ORIENTATION_MODE_FIXED_PORTRAIT));

            mRtcEngine.joinChannel(null, mChannelName, "", mBigUserId);

            mBigView = RtcEngine.CreateRendererView(MainActivity.this);
            if (mSelfView.getChildCount() > 0)
                mSelfView.removeAllViews();
            mBigView.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.MATCH_PARENT));
            mBigView.setZOrderMediaOverlay(false);
            mBigView.setZOrderOnTop(false);
            mSelfView.addView(mBigView);

            mRtcEngine.setupLocalVideo(new VideoCanvas(mBigView, Constants.RENDER_MODE_HIDDEN, mBigUserId));

            initTranscoding(480, 640, 1800);
            setTranscoding();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void initMessage() {
        mMsgList = new ArrayList<>();
        RecyclerView msgRecycle = findViewById(R.id.msg_list);

        mMessageAdapter = new MessageAdapter(this, mMsgList);
        mMessageAdapter.setHasStableIds(true);

        msgRecycle.setAdapter(mMessageAdapter);
        msgRecycle.setLayoutManager(new LinearLayoutManager(this, RecyclerView.VERTICAL, false));
        msgRecycle.addItemDecoration(new MessageItemDecoration());
    }

    private void initTranscoding(int width, int height, int bitrate) {
        if (mLiveTranscoding == null) {
            mLiveTranscoding = new LiveTranscoding();
            mLiveTranscoding.width = width;
            mLiveTranscoding.height = height;
            mLiveTranscoding.videoBitrate = bitrate;
            // if you want high fps, modify videoFramerate
            mLiveTranscoding.videoFramerate = 15;
        }
    }

    private void sendMsg(final String msg) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                mMsgList.add(msg);
                if (mMsgList.size() > 20) {
                    int remove = mMsgList.size() - 20;
                    for (int i = 0; i < remove; i++) {
                        mMsgList.remove(i);
                    }
                }

                mMessageAdapter.notifyDataSetChanged();
            }
        });
    }

    public void onSettingsClicked(View v) {
        showTransCodingSettingDialog();
    }

    private void showTransCodingSettingDialog() {
        CustomTranscodingDialog dialog = new CustomTranscodingDialog(this, mLiveTranscoding);
        dialog.setOnUpdateTranscodingListener(new CustomTranscodingDialog.OnUpdateTranscodingListener() {
            @Override
            public void onUpdateTranscoding(LiveTranscoding customTranscoding) {
                mLiveTranscoding = customTranscoding;
                setTranscoding();
            }
        });
        dialog.showDialog();
    }

    private void setTranscoding() {
        ArrayList<LiveTranscoding.TranscodingUser> transcodingUsers;
        ArrayList<UserInfo> videoUsers = getAllVideoUser(mUserInfo);

        transcodingUsers = cdnLayout(mBigUserId, videoUsers, mLiveTranscoding.width, mLiveTranscoding.height);

        mLiveTranscoding.setUsers(transcodingUsers);
        mLiveTranscoding.userCount = transcodingUsers.size();
        mRtcEngine.setLiveTranscoding(mLiveTranscoding);
    }

    private boolean shouldRequestPermission() {
        return Build.VERSION.SDK_INT > Build.VERSION_CODES.LOLLIPOP_MR1;
    }

    @TargetApi(23)
    private void askPermission() {
        requestPermissions(new String[]{
                        "android.permission.CAMERA",
                        "android.permission.RECORD_AUDIO",
                        "android.permission.RECORD_AUDIO",
                        "android.permission.WRITE_EXTERNAL_STORAGE"},
                200);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == 200) {
            for (int g : grantResults) {
                if (g != PermissionChecker.PERMISSION_GRANTED) {
                    finish();
                    return;
                }
            }

            init();
            initEngine();
        }
    }

    public void onEndCallClicked(View v) {
        onBackPressed();
    }

    public void onRtmpClicked(View v) {
        if (v.getTag() == null) {
            v.setTag(false);
        }

        if (!(boolean) v.getTag()) {
            setTranscoding();
            mRtcEngine.addPublishStreamUrl(mPublishUrl, true);
            ((ImageView) v).setColorFilter(getResources().getColor(R.color.agora_blue), PorterDuff.Mode.MULTIPLY);
            v.setTag(true);
        } else {
            mRtcEngine.removePublishStreamUrl(mPublishUrl);
            ((ImageView) v).clearColorFilter();
            v.setTag(false);
        }
    }

    @Override
    public void onBackPressed() {
        if (mRtcEngine != null) {
            mRtcEngine.removePublishStreamUrl(mPublishUrl);
            mRtcEngine.leaveChannel();
        }
        RtcEngine.destroy();
        mRtcEngine = null;
        finish();
    }
}
