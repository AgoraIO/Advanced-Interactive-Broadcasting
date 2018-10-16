package io.agora.voice.only.livestreaming.ui;

import android.content.Intent;
import android.graphics.PorterDuff;
import android.media.AudioManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;

import io.agora.live.LiveTranscoding;
import io.agora.rtc.Constants;
import io.agora.rtc.RtcEngine;
import io.agora.voice.only.livestreaming.R;
import io.agora.voice.only.livestreaming.model.AGEventHandler;
import io.agora.voice.only.livestreaming.model.ConstantApp;

public class LiveRoomActivity extends BaseActivity implements AGEventHandler {

    private final static Logger log = LoggerFactory.getLogger(LiveRoomActivity.class);

    private volatile boolean mAudioMuted = false;
    private volatile boolean mPushRtmp = false;
    private String mPublishUrl = "";

    private volatile int mAudioRouting = -1; // Default
    private RtcEngine mRtcEngine;
    private LiveTranscoding mLiveTranscoding;
    private ArrayList<LiveTranscoding.TranscodingUser> mUserList = new ArrayList<>(1);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_live_room);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        return false;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        return false;
    }

    @Override
    protected void initUIandEvent() {
        event().addEventHandler(this);

        mRtcEngine = rtcEngine();

        Intent i = getIntent();

        int cRole = i.getIntExtra(ConstantApp.ACTION_KEY_CROLE, 0);

        if (cRole == 0) {
            throw new RuntimeException("Should not reach here");
        }

        String roomName = i.getStringExtra(ConstantApp.ACTION_KEY_ROOM_NAME);

        doConfigEngine(cRole);

        ImageView button1 = (ImageView) findViewById(R.id.switch_broadcasting_id);
        ImageView button2 = (ImageView) findViewById(R.id.mute_local_speaker_id);

        if (isBroadcaster(cRole)) {
            broadcasterUI(button1, button2);
        } else {
            audienceUI(button1, button2);
        }

        worker().joinChannel(roomName, config().mUid);

        TextView textRoomName = (TextView) findViewById(R.id.room_name);
        textRoomName.setText(roomName);

        optional();

        LinearLayout bottomContainer = (LinearLayout) findViewById(R.id.bottom_container);
        FrameLayout.MarginLayoutParams fmp = (FrameLayout.MarginLayoutParams) bottomContainer.getLayoutParams();
        fmp.bottomMargin = virtualKeyHeight() + 16;
    }

    private Handler mMainHandler;

    private static final int UPDATE_UI_MESSAGE = 0x1024;

    EditText mMessageList;

    StringBuffer mMessageCache = new StringBuffer();

    private void notifyMessageChanged(String msg) {
        if (mMessageCache.length() > 10000) { // drop messages
            mMessageCache = new StringBuffer(mMessageCache.substring(10000 - 40));
        }

        mMessageCache.append(System.currentTimeMillis()).append(": ").append(msg).append("\n"); // append timestamp for messages

        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (isFinishing()) {
                    return;
                }

                if (mMainHandler == null) {
                    mMainHandler = new Handler(getMainLooper()) {
                        @Override
                        public void handleMessage(Message msg) {
                            super.handleMessage(msg);

                            if (isFinishing()) {
                                return;
                            }

                            switch (msg.what) {
                                case UPDATE_UI_MESSAGE:
                                    String content = (String) (msg.obj);
                                    mMessageList.setText(content);
                                    mMessageList.setSelection(content.length());
                                    break;

                                default:
                                    break;
                            }

                        }
                    };

                    mMessageList = (EditText) findViewById(R.id.msg_list);
                }

                mMainHandler.removeMessages(UPDATE_UI_MESSAGE);
                Message envelop = new Message();
                envelop.what = UPDATE_UI_MESSAGE;
                envelop.obj = mMessageCache.toString();
                mMainHandler.sendMessageDelayed(envelop, 1000l);
            }
        });
    }

    private void optional() {
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS);

        setVolumeControlStream(AudioManager.STREAM_VOICE_CALL);
    }

    private void optionalDestroy() {
    }

    public void onSwitchSpeakerClicked(View view) {
        log.info("onSwitchSpeakerClicked " + view + " " + mAudioMuted + " " + mAudioRouting);

        mRtcEngine.setEnableSpeakerphone(mAudioRouting != 3);
    }

    private void doConfigEngine(int cRole) {
        worker().configEngine(cRole);
    }

    private boolean isBroadcaster(int cRole) {
        return cRole == Constants.CLIENT_ROLE_BROADCASTER;
    }

    private boolean isBroadcaster() {
        return isBroadcaster(config().mClientRole);
    }

    @Override
    protected void deInitUIandEvent() {
        optionalDestroy();

        doLeaveChannel();
        event().removeEventHandler(this);
    }

    private void doLeaveChannel() {
        worker().leaveChannel(config().mChannel);
    }

    public void onEndCallClicked(View view) {
        log.info("onEndCallClicked " + view);

        quitCall();
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();

        log.info("onBackPressed");

        quitCall();
    }

    private void quitCall() {
        Intent intent = new Intent(this, MainActivity.class);
        startActivity(intent);

        finish();
    }

    private void doSwitchToBroadcaster(boolean broadcaster) {
        final int uid = config().mUid;
        log.debug("doSwitchToBroadcaster " + (uid & 0XFFFFFFFFL) + " " + broadcaster);

        if (broadcaster) {
            doConfigEngine(Constants.CLIENT_ROLE_BROADCASTER);

            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {

                    ImageView button1 = (ImageView) findViewById(R.id.switch_broadcasting_id);
                    ImageView button2 = (ImageView) findViewById(R.id.mute_local_speaker_id);
                    broadcasterUI(button1, button2);
                }
            }, 1000); // wait for reconfig engine
        } else {
            stopInteraction(uid);
        }
    }

    private void stopInteraction(final int uid) {
        doConfigEngine(Constants.CLIENT_ROLE_AUDIENCE);

        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                ImageView button1 = (ImageView) findViewById(R.id.switch_broadcasting_id);
                ImageView button2 = (ImageView) findViewById(R.id.mute_local_speaker_id);
                audienceUI(button1, button2);
            }
        }, 1000); // wait for reconfig engine
    }

    private void audienceUI(ImageView button1, ImageView button2) {
        button1.setTag(null);
        button1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Object tag = v.getTag();
                if (tag != null && (boolean) tag) {
                    doSwitchToBroadcaster(false);
                } else {
                    doSwitchToBroadcaster(true);
                }
            }
        });
        button1.clearColorFilter();
        button2.setTag(null);
        button2.setVisibility(View.GONE);
        button2.clearColorFilter();
    }

    private void broadcasterUI(ImageView button1, ImageView button2) {
        button1.setTag(true);
        button1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Object tag = v.getTag();
                if (tag != null && (boolean) tag) {
                    doSwitchToBroadcaster(false);
                } else {
                    doSwitchToBroadcaster(true);
                }
            }
        });
        button1.setColorFilter(getResources().getColor(R.color.agora_blue), PorterDuff.Mode.MULTIPLY);

        button2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Object tag = v.getTag();
                boolean flag = true;
                if (tag != null && (boolean) tag) {
                    flag = false;
                }
                worker().getRtcEngine().muteLocalAudioStream(flag);
                ImageView button = (ImageView) v;
                button.setTag(flag);
                if (flag) {
                    button.setColorFilter(getResources().getColor(R.color.agora_blue), PorterDuff.Mode.MULTIPLY);
                } else {
                    button.clearColorFilter();
                }
            }
        });

        button2.setVisibility(View.VISIBLE);
    }

    public void onVoiceMuteClicked(View view) {
        log.info("onVoiceMuteClicked " + view + " audio_status: " + mAudioMuted);

        mRtcEngine.muteLocalAudioStream(mAudioMuted = !mAudioMuted);

        ImageView iv = (ImageView) view;

        if (mAudioMuted) {
            iv.setColorFilter(getResources().getColor(R.color.agora_blue), PorterDuff.Mode.MULTIPLY);
        } else {
            iv.clearColorFilter();
        }
    }

    @Override
    public void onJoinChannelSuccess(String channel, final int uid, int elapsed) {
        String msg = "onJoinChannelSuccess " + channel + " " + (uid & 0xFFFFFFFFL) + " " + elapsed;
        log.debug(msg);

        notifyMessageChanged(msg);
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                cdnLayout(uid);
            }
        });
    }

    @Override
    public void onUserJoined(final int uid, int elapsed) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                cdnLayout(uid);
                if (mPushRtmp) {
                    mLiveTranscoding.setUsers(mUserList);
                    mRtcEngine.setLiveTranscoding(mLiveTranscoding);
                }
            }
        });
    }

    @Override
    public void onUserOffline(final int uid, int reason) {
        String msg = "onUserOffline " + (uid & 0xFFFFFFFFL) + " " + reason;
        log.debug(msg);
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                removeCdnLayout(uid);
                if (mPushRtmp) {
                    mLiveTranscoding.setUsers(mUserList);
                    mRtcEngine.setLiveTranscoding(mLiveTranscoding);
                }
            }
        });

        notifyMessageChanged(msg);

    }


    @Override
    public void onExtraCallback(final int type, final Object... data) {

        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (isFinishing()) {
                    return;
                }

                doHandleExtraCallback(type, data);
            }
        });
    }

    private void doHandleExtraCallback(int type, Object... data) {
        int peerUid;
        boolean muted;

        switch (type) {
            case AGEventHandler.EVENT_TYPE_ON_USER_AUDIO_MUTED: {
                peerUid = (Integer) data[0];
                muted = (boolean) data[1];

                notifyMessageChanged("mute: " + (peerUid & 0xFFFFFFFFL) + " " + muted);
                break;
            }

            case AGEventHandler.EVENT_TYPE_ON_APP_ERROR: {
                int subType = (int) data[0];

                if (subType == ConstantApp.AppError.NO_NETWORK_CONNECTION) {
                    showLongToast(getString(R.string.msg_no_network_connection));
                }

                break;
            }

            case AGEventHandler.EVENT_TYPE_ON_AGORA_MEDIA_ERROR: {
                int error = (int) data[0];
                String description = (String) data[1];

                notifyMessageChanged(error + " " + description);

                break;
            }

            case AGEventHandler.EVENT_TYPE_ON_AUDIO_ROUTE_CHANGED: {
                notifyHeadsetPlugged((int) data[0]);

                break;
            }
        }
    }

    public void notifyHeadsetPlugged(final int routing) {
        log.info("notifyHeadsetPlugged " + routing);

        mAudioRouting = routing;

        ImageView iv = (ImageView) findViewById(R.id.switch_speaker_id);
        if (mAudioRouting == 3) { // Speakerphone
            iv.setColorFilter(getResources().getColor(R.color.agora_blue), PorterDuff.Mode.MULTIPLY);
        } else {
            iv.clearColorFilter();
        }
    }


    public void onRtmpPushClicked(View view) {

        if (isBroadcaster()) {
            mPushRtmp = !mPushRtmp;

            ImageView iv = (ImageView) view;
            if (mPushRtmp) {

                getTransCoding();
                mLiveTranscoding.setUsers(mUserList);
                mRtcEngine.setLiveTranscoding(mLiveTranscoding);
                mRtcEngine.addPublishStreamUrl(mPublishUrl, true);
                iv.setColorFilter(getResources().getColor(R.color.agora_blue), PorterDuff.Mode.MULTIPLY);
            } else {
                mRtcEngine.removePublishStreamUrl(mPublishUrl);
                iv.clearColorFilter();
            }
        }

    }

    private LiveTranscoding getTransCoding() {

        if (mLiveTranscoding == null) {
            mLiveTranscoding = new LiveTranscoding();
            mLiveTranscoding.width = 16;
            mLiveTranscoding.height = 16;
            mLiveTranscoding.videoBitrate = 1;
            mLiveTranscoding.audioChannels = 1;
        }
        return mLiveTranscoding;
    }

    public ArrayList<LiveTranscoding.TranscodingUser> cdnLayout(int uid) {

        LiveTranscoding.TranscodingUser user0 = new LiveTranscoding.TranscodingUser();
        user0.uid = uid;
        user0.alpha = 1;
        user0.zOrder = 0;
        user0.audioChannel = 0;

        user0.x = 0;
        user0.y = 0;
        user0.width = 16;
        user0.height = 16;
        mUserList.add(user0);

        return mUserList;
    }

    private void removeCdnLayout(int uid) {
        for (int i = 0; i < mUserList.size(); i++) {
            if (mUserList.get(i).uid == uid) {
                mUserList.remove(i);
            }
        }
    }

}
