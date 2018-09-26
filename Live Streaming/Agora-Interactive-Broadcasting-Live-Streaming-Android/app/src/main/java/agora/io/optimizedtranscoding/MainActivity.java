package agora.io.optimizedtranscoding;

import android.annotation.TargetApi;
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

import io.agora.live.LiveChannelConfig;
import io.agora.live.LiveEngine;
import io.agora.live.LiveEngineHandler;
import io.agora.live.LivePublisher;
import io.agora.live.LivePublisherHandler;
import io.agora.live.LiveSubscriber;
import io.agora.live.LiveSubscriberHandler;

import io.agora.rtc.Constants;
import io.agora.rtc.RtcEngine;

// If your Agora RTC SDK version is under 2.3.0, please import `io.agora.live.LiveTranscoding;`
import io.agora.rtc.live.LiveTranscoding;
// If your Agora RTC SDK version is under 2.3.0, please replace 'setVideoEncoderConfiguration' with 'setVideoProfile'
import io.agora.rtc.video.VideoEncoderConfiguration;

public class MainActivity extends AppCompatActivity {
    private final static String mChannelName = "agora-test-room";

    private final static boolean mEnableVideo = true;

    private RecyclerView mSmallView;
    private LinearLayout mSelfView;
    private TextView mTvRoomName;
    private ImageView mIvRtmp;

    private LiveEngine mLiveEngine;
    private LiveChannelConfig mLiveChannelConfig;
    private LiveSubscriber mLiveSubscriber;
    private LivePublisher mLivePublisher;
    private LiveTranscoding mLiveTranscoding;

    private Map<Integer, UserInfo> mUserInfo = new HashMap<>();
    private SmallAdapter mSmallAdapter;

    //before join channel success, big-uid is zero, after join success big-uid will modify by onJoinChannel-uid
    private int mBigUserId = 0;
    private SurfaceView mBigView;

    private MessageAdapter mMessageAdapter;
    private ArrayList<String> mMsgList;

    LiveEngineHandler mLiveEngineHandler = new LiveEngineHandler() {
        @Override
        public void onError(int errorCode) {
            super.onError(errorCode);
        }

        @Override
        public void onJoinChannel(String channel, final int uid, int elapsed) {
            super.onJoinChannel(channel, uid, elapsed);
            mBigUserId = uid;
            sendMsg(uid + " -->join in<--" + channel);
        }

        @Override
        public void onLeaveChannel() {
            super.onLeaveChannel();
            sendMsg("-->leaveChannel<--");
        }

        @Override
        public void onRejoinChannel(String channel, int uid, int elapsed) {
            super.onRejoinChannel(channel, uid, elapsed);
            sendMsg(uid + " -->RejoinChannel<--");
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
    };

    LivePublisherHandler mLivePublisherHandler = new LivePublisherHandler() {
        @Override
        public void onStreamUrlUnpublished(String url) {
            super.onStreamUrlUnpublished(url);
            sendMsg("-->onStreamUrlUnpublished<--" + url);
        }

        @Override
        public void onStreamUrlPublished(String url) {
            super.onStreamUrlPublished(url);
            sendMsg("-->onStreamUrlPublished<--" + url);
        }

        @Override
        public void onPublishStreamUrlFailed(String url, int errorCode) {
            super.onPublishStreamUrlFailed(url, errorCode);
            sendMsg("-->onStreamUrlFailed<--" + url + "-->" + errorCode);
            mIvRtmp.clearColorFilter();
            mIvRtmp.setTag(false);
        }

        @Override
        public void onPublisherTranscodingUpdated(LivePublisher publisher) {
            super.onPublisherTranscodingUpdated(publisher);
            sendMsg("-->onPublisherTranscodingUpdated<--");
        }
    };

    LiveSubscriberHandler mLiveSubscriberHandler = new LiveSubscriberHandler() {
        @Override
        public void publishedByHost(final int uid, final int streamType) {
            super.publishedByHost(uid, streamType);
            sendMsg("-->publishedByHost<--" + uid + "<-->" + streamType);
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    UserInfo mUI = new UserInfo();
                    mUI.view = RtcEngine.CreateRendererView(MainActivity.this);
                    mUI.uid = uid;
                    mUI.view.setZOrderOnTop(true);
                    mUserInfo.put(uid, mUI);
                    mLiveSubscriber.subscribe(uid, streamType, mUI.view, Constants.RENDER_MODE_HIDDEN, Constants.VIDEO_STREAM_HIGH);
                    mSmallAdapter.update(getSmallVideoUser(mUserInfo, mBigUserId));

                    setTranscoding();
                }
            });
        }

        @Override
        public void unpublishedByHost(final int uid) {
            super.unpublishedByHost(uid);
            sendMsg("-->unPublishedByHost<--" + uid);
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    mUserInfo.remove(uid);
                    mLiveSubscriber.unsubscribe(uid);
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

    public static ArrayList<LiveTranscoding.TranscodingUser> cdnLayout(int meId,
                                                                       ArrayList<UserInfo> publishers,
                                                                       int canvasWidth,
                                                                       int canvasHeight) {
        ArrayList<LiveTranscoding.TranscodingUser> users;
        int index = 0;
        float xIndex, yIndex;
        int viewWidth = (int) (canvasWidth * 0.25);
        int viewHEdge = viewWidth * 4 / 3;

        users = new ArrayList<>(publishers.size());

        LiveTranscoding.TranscodingUser user0 = new LiveTranscoding.TranscodingUser();
        user0.uid = meId;
        user0.alpha = 1;
        user0.zOrder = 0;
        user0.audioChannel = 0;

        user0.x = 0;
        user0.y = 0;
        user0.width = canvasWidth;
        user0.height = canvasHeight;
        users.add(user0);

        for (UserInfo entry : publishers) {
            if (entry.uid == meId)
                continue;

            xIndex = index % 3;
            yIndex = index / 3;
            LiveTranscoding.TranscodingUser tmpUser = new LiveTranscoding.TranscodingUser();
            tmpUser.uid = entry.uid;
            tmpUser.x = (int) ((xIndex) * viewWidth + 16);
            tmpUser.y = (int) (viewHEdge * (yIndex) + 9);
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
        mLiveEngine = LiveEngine.createLiveEngine(getApplicationContext(), getResources().getString(R.string.app_id), mLiveEngineHandler);

        if (mLiveEngine == null) {
            throw new RuntimeException("failed to create live engine");
        }

        mLiveSubscriber = new LiveSubscriber(mLiveEngine, mLiveSubscriberHandler);
        mLivePublisher = new LivePublisher(mLiveEngine, mLivePublisherHandler);

        mLiveChannelConfig = new LiveChannelConfig();
        mLiveChannelConfig.videoEnabled = mEnableVideo;

//      mLivePublisher.setVideoProfile(480, 640, 15, 1800); // If your Agora RTC SDK version is under 2.3.0
        mLiveEngine.getRtcEngine().setVideoEncoderConfiguration(new VideoEncoderConfiguration(VideoEncoderConfiguration.VD_640x480, VideoEncoderConfiguration.FRAME_RATE.FRAME_RATE_FPS_15, VideoEncoderConfiguration.STANDARD_BITRATE, VideoEncoderConfiguration.ORIENTATION_MODE.ORIENTATION_MODE_FIXED_PORTRAIT));

        mLivePublisher.setMediaType(Constants.MEDIA_TYPE_AUDIO_AND_VIDEO);

        mLiveEngine.joinChannel(mChannelName, null, mLiveChannelConfig, mBigUserId);

        //publish first
        mLivePublisher.publish();

        mBigView = RtcEngine.CreateRendererView(this);
        if (mSelfView.getChildCount() > 0)
            mSelfView.removeAllViews();
        mBigView.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.MATCH_PARENT));
        mBigView.setZOrderMediaOverlay(false);
        mBigView.setZOrderOnTop(false);
        mSelfView.addView(mBigView);
        mLiveEngine.startPreview(mBigView, Constants.RENDER_MODE_HIDDEN);

        initTranscoding(480, 640, 1800);
        setTranscoding();
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
        mLiveTranscoding = new LiveTranscoding();
        mLiveTranscoding.width = width;
        mLiveTranscoding.height = height;
        mLiveTranscoding.videoBitrate = bitrate;
        // if you want high fps, modify videoFramerate
        mLiveTranscoding.videoFramerate = 15;
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
        ArrayList<UserInfo> smallVideoUsers = getSmallVideoUser(mUserInfo, mBigUserId);

        transcodingUsers = cdnLayout(mBigUserId, smallVideoUsers, mLiveTranscoding.width, mLiveTranscoding.height);

        mLiveTranscoding.setUsers(transcodingUsers);
        mLiveTranscoding.userCount = transcodingUsers.size();
        mLivePublisher.setLiveTranscoding(mLiveTranscoding);
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
            mLivePublisher.addStreamUrl(getResources().getString(R.string.stream_url), true);
            ((ImageView) v).setColorFilter(getResources().getColor(R.color.agora_blue), PorterDuff.Mode.MULTIPLY);
            v.setTag(true);
        } else {
            mLivePublisher.removeStreamUrl(getResources().getString(R.string.stream_url));
            ((ImageView) v).clearColorFilter();
            v.setTag(false);
        }
    }

    @Override
    public void onBackPressed() {
        if (mLivePublisher != null) {
            mLivePublisher.unpublish();
            mLivePublisher.removeStreamUrl(getResources().getString(R.string.stream_url));
        }

        if (mLiveEngine != null)
            mLiveEngine.leaveChannel();

        mLivePublisher = null;
        mLiveEngine = null;
        finish();
    }
}
