package io.agora.stream_injection;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.util.Log;
import android.view.SurfaceView;

import java.lang.ref.WeakReference;

import io.agora.rtc.Constants;
import io.agora.rtc.RtcEngine;
import io.agora.rtc.video.VideoCanvas;

public class WorkerThread extends Thread {
    private final static String LOG_TAG = WorkerThread.class.getName();

    private Context mContext;

    private static final int ACTION_WORKER_THREAD_QUIT = 0X1010; // quit this thread

    private static final int ACTION_WORKER_JOIN_CHANNEL = 0X2010;

    private static final int ACTION_WORKER_LEAVE_CHANNEL = 0X2011;

    private static final int ACTION_WORKER_CONFIG_ENGINE = 0X2012;

    private static final int ACTION_WORKER_SETUP_REMOTE_VIEW = 0X2013;

    private static final int ACTION_WORKER_PREVIEW = 0X2014;

    private RtcEngine mRtcEngine;
    private WorkerThreadHandler mWorkerHandler;
    private MyEngineEventHandler mMyEngineEventHandler;

    private boolean mReady = false;

    private static class WorkerThreadHandler extends Handler {
        private WorkerThread mWorkerThread;

        public WorkerThreadHandler(WorkerThread thread) {
            this.mWorkerThread = thread;
        }

        public void release() {
            mWorkerThread = null;
        }

        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);

            switch (msg.what) {
                case ACTION_WORKER_JOIN_CHANNEL:
                    mWorkerThread.joinChannel((String) msg.obj, msg.arg1);
                    break;
                case ACTION_WORKER_PREVIEW:
                    Object[] previewData = (Object[]) msg.obj;
                    mWorkerThread.preview((boolean) previewData[0], (SurfaceView) previewData[1], (int) previewData[2]);
                    break;
                case ACTION_WORKER_THREAD_QUIT:
                    mWorkerThread.exit();
                    break;
                case ACTION_WORKER_LEAVE_CHANNEL:
                    mWorkerThread.leaveChannel();
                    break;
                case ACTION_WORKER_CONFIG_ENGINE:
                    mWorkerThread.configEngine((Integer) msg.obj);
                    break;
                case ACTION_WORKER_SETUP_REMOTE_VIEW:
                    Object[] remoteData = (Object[]) msg.obj;
                    mWorkerThread.setupRemoteView((SurfaceView) remoteData[0], (int) remoteData[1]);
                    break;
                default:
                    throw new RuntimeException("unknown handler event");
            }
        }
    }

    public WorkerThread(WeakReference<Context> ctx) {
        this.mContext = ctx.get();
        this.mMyEngineEventHandler = new MyEngineEventHandler();
    }

    @Override
    public void run() {
        super.run();
        Looper.prepare();

        mWorkerHandler = new WorkerThreadHandler(this);

        ensureRtcEngineReadyLock();

        mReady = true;

        Looper.loop();
    }

    public void waitForReady() {
        while (!mReady) {
            try {
                Thread.sleep(20);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    private void ensureRtcEngineReadyLock() {
        if (mRtcEngine != null)
            return;

        try {
            mRtcEngine = RtcEngine.create(mContext, mContext.getResources().getString(R.string.agora_app_id), mMyEngineEventHandler.mRtcEventHandler);
        } catch (Exception e) {
            e.printStackTrace();
        }

        mRtcEngine.setChannelProfile(Constants.CHANNEL_PROFILE_LIVE_BROADCASTING);
        mRtcEngine.setParameters("{\"rtc.log_filter\":32781}");
    }

    public RtcEngine rtcEngine() {
        return mRtcEngine;
    }

    public MyEngineEventHandler eventHandler() {
        return mMyEngineEventHandler;
    }

    /**
     * call this method to exit
     * should ONLY call this method when this thread is running
     */
    public final void exit() {
        if (Thread.currentThread() != this) {
            Log.w(LOG_TAG, "exit() - exit app thread asynchronously");
            mWorkerHandler.sendEmptyMessage(ACTION_WORKER_THREAD_QUIT);
            return;
        }

        mReady = false;

        // TODO should remove all pending(read) messages

        Log.d(LOG_TAG, "exit() > start");

        // exit thread looper
        Looper.myLooper().quit();

        mWorkerHandler.release();

        Log.d(LOG_TAG, "exit() > end");
    }

    public final void joinChannel(final String channel, int uid) {
        if (Thread.currentThread() != this) {
            Message envelop = new Message();
            envelop.what = ACTION_WORKER_JOIN_CHANNEL;
            envelop.obj = channel;
            envelop.arg1 = uid;
            mWorkerHandler.sendMessage(envelop);
            return;
        }

        ensureRtcEngineReadyLock();
        int ret = mRtcEngine.joinChannel(null, channel, "", uid);
        Log.d(LOG_TAG, "joinChannel: " + ret);
    }

    public final void configEngine(int channelProfile) {
        if (Thread.currentThread() != this) {
            Message msg = Message.obtain();
            msg.what = ACTION_WORKER_CONFIG_ENGINE;
            msg.obj = channelProfile;
            mWorkerHandler.sendMessage(msg);

            return;
        }

        ensureRtcEngineReadyLock();
        mRtcEngine.setClientRole(channelProfile);

        mRtcEngine.setVideoEncoderConfiguration(InjectionConstants.VIDEO_CONFIGURATION);

        mRtcEngine.enableVideo();
        mRtcEngine.enableDualStreamMode(true);
    }

    public final void preview(boolean start, SurfaceView view, int uid) {
        if (Thread.currentThread() != this) {
            Message envelop = new Message();
            envelop.what = ACTION_WORKER_PREVIEW;
            envelop.obj = new Object[]{start, view, uid};
            mWorkerHandler.sendMessage(envelop);
            return;
        }

        ensureRtcEngineReadyLock();
        if (start) {
            mRtcEngine.setupLocalVideo(new VideoCanvas(view, VideoCanvas.RENDER_MODE_HIDDEN, uid));
            mRtcEngine.startPreview();
        } else {
            mRtcEngine.stopPreview();
        }
    }

    public final void setupRemoteView(SurfaceView view, int uid) {
        if (Thread.currentThread() != this) {
            Message envelop = new Message();
            envelop.what = ACTION_WORKER_SETUP_REMOTE_VIEW;
            envelop.obj = new Object[]{view, uid};
            mWorkerHandler.sendMessage(envelop);
            return;
        }

        ensureRtcEngineReadyLock();
        int ret = mRtcEngine.setupRemoteVideo(new VideoCanvas(view, VideoCanvas.RENDER_MODE_HIDDEN, uid));

        Log.e(LOG_TAG, "setupRemoteVideo: " + view + " " + (uid & 0xFFFFFFFFL) + " " + ret);
    }

    public final void leaveChannel() {
        if (Thread.currentThread() != this) {
            Message envelop = new Message();
            envelop.what = ACTION_WORKER_LEAVE_CHANNEL;
            mWorkerHandler.sendMessage(envelop);
            return;
        }

        if (mRtcEngine != null) {
            mRtcEngine.leaveChannel();
        }
    }
}
