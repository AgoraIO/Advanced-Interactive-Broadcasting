package io.agora.stream_injection;

import android.content.Context;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.SurfaceView;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.List;

import io.agora.rtc.Constants;
import io.agora.rtc.IRtcEngineEventHandler;
import io.agora.rtc.RtcEngine;

public class ShowActivity extends BaseActivity implements AGEventHandler {
    private SurfaceView localView;
    private SurfaceView injectView;

    private FrameLayout mLocal;
    private FrameLayout mInject;
    private String url;

    private RecyclerView msgView;
    private List<String> mMessageDataSet = new ArrayList<>();
    private CRMRecycleAdapter mCrmAdapter;

    private boolean hasInjectedJoined = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_show);

        ((MyApplication) getApplication()).initWorkerThread();

        msgView = findViewById(R.id.rv_chat_room_main_message);
        msgView.setHasFixedSize(true);
        mCrmAdapter = new CRMRecycleAdapter(new WeakReference<Context>(this), mMessageDataSet);
        msgView.setAdapter(mCrmAdapter);
        msgView.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false));
        msgView.addItemDecoration(new CRMItemDecor());

        event().addEventHandler(this);
        worker().configEngine(Constants.CLIENT_ROLE_BROADCASTER);

        localView = RtcEngine.CreateRendererView(this);
        injectView = RtcEngine.CreateRendererView(this);

        mLocal = findViewById(R.id.fl_local_view);
        mInject = findViewById(R.id.fl_inject_view);

        worker().preview(true, localView, 0);

        worker().joinChannel(getIntent().getStringExtra("CHANNEL_NAME"), 0);

        url = getIntent().getStringExtra("INJECT_URL");
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();

        event().removeEventHandler(this);
    }

    @Override
    protected void initUIandEvent() {

    }

    @Override
    protected void deInitUIandEvent() {

    }

    public void onExitClicked(View v) {
        stop();
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        stop();
    }

    @Override
    public void onJoinChannelSuccess(String channel, int uid, int elapsed) {
        sendChatMessage("joinSuccess: " + channel);
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                localView.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
                localView.setZOrderOnTop(true);

                if (mLocal.getChildCount() > 0)
                    mLocal.removeAllViews();

                if (localView.getParent() != null)
                    ((ViewGroup) (localView.getParent())).removeAllViews();

                mLocal.addView(localView);

                rtcEngine().addInjectStreamUrl(url, newLiveInjectStreamConfig());
            }
        });
    }

    @Override
    public void onUserJoined(final int uid, int elapsed) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                // FIXME 666 using a friendly uid
                if (uid == 666 && !hasInjectedJoined) {
                    sendChatMessage("inject user joined: " + uid);

                    if (injectView.getParent() != null) {
                        ((ViewGroup) (injectView.getParent())).removeAllViews();
                    }

                    if (mInject.getChildCount() > 0)
                        mInject.removeAllViews();

                    injectView.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
                    injectView.setZOrderOnTop(false);
                    mInject.addView(injectView);

                    worker().setupRemoteView(injectView, uid);

                    hasInjectedJoined = true;
                }
            }
        });

    }

    @Override
    public void onStreamPublished(String url, int error) {

    }

    @Override
    public void onStreamUnpublished(String url) {

    }

    @Override
    public void onError(int err) {
        sendChatMessage("error: " + err);
    }

    @Override
    public void onUserOffline(int uid, int reason) {

    }

    @Override
    public void onLeaveChannel(IRtcEngineEventHandler.RtcStats stats) {

    }

    @Override
    public void onStreamInjectedStatus(String url, int uid, int status) {

        String reason;
        if (status == Constants.INJECT_STREAM_STATUS_START_TIMEDOUT) {
            reason = "timeout";
        } else if (status == Constants.INJECT_STREAM_STATUS_START_SUCCESS) {
            reason = "success";
        } else if (status == Constants.INJECT_STREAM_STATUS_START_ALREADY_EXISTS) {
            reason = "exists";
        } else if (status == Constants.INJECT_STREAM_STATUS_START_UNAUTHORIZED) {
            reason = "unauthorized";
        } else if (status == Constants.INJECT_STREAM_STATUS_START_FAILED) {
            reason = "failed";
        } else {
            reason = "see Constants.INJECT_STREAM_STATUS*";
        }

        sendChatMessage("injected status: " + (uid & 0xFFFFFFFFL) + " " + reason + "(" + status + ") " + url);
    }

    public void stop() {
        rtcEngine().removeInjectStreamUrl(url);

        worker().preview(false, null, 0);

        worker().leaveChannel();
        finish();
    }

    public void sendChatMessage(final String message) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                mMessageDataSet.add(message);

                if (mMessageDataSet.size() > 14) { // max value is 15
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
}
