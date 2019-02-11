package io.agora.stream_injection;

import android.util.Log;

import java.util.Iterator;
import java.util.concurrent.ConcurrentHashMap;

import io.agora.rtc.Constants;
import io.agora.rtc.IRtcEngineEventHandler;

public class MyEngineEventHandler {

    private static final String LOG_TAG = "AG_EVT";

    private final ConcurrentHashMap<AGEventHandler, Integer> mEventHandlerList = new ConcurrentHashMap<>();

    public void addEventHandler(AGEventHandler handler) {
        this.mEventHandlerList.put(handler, 0);
    }

    public void removeEventHandler(AGEventHandler handler) {
        this.mEventHandlerList.remove(handler);
    }

    final IRtcEngineEventHandler mRtcEventHandler = new IRtcEngineEventHandler() {
        @Override
        public void onJoinChannelSuccess(String channel, int uid, int elapsed) {
            Log.d(LOG_TAG, "onJoinChannelSuccess: " + channel + " " + (uid & 0xFFFFFFFFL) + " " + elapsed);
            super.onJoinChannelSuccess(channel, uid, elapsed);

            if (mEventHandlerList.isEmpty()) {
                return;
            }

            Iterator<AGEventHandler> it = mEventHandlerList.keySet().iterator();
            while (it.hasNext()) {
                it.next().onJoinChannelSuccess(channel, uid, elapsed);
            }
        }

        @Override
        public void onUserJoined(int uid, int elapsed) {
            Log.d(LOG_TAG, "onUserJoined: " + (uid & 0xFFFFFFFFL) + " " + elapsed);
            super.onUserJoined(uid, elapsed);

            if (mEventHandlerList.isEmpty()) {
                return;
            }

            Iterator<AGEventHandler> it = mEventHandlerList.keySet().iterator();
            while (it.hasNext()) {
                it.next().onUserJoined(uid, elapsed);
            }
        }

        @Override
        public void onStreamPublished(String url, int error) {
            Log.d(LOG_TAG, "onStreamPublished: " + url + " " + error);
            super.onStreamPublished(url, error);

            if (mEventHandlerList.isEmpty()) {
                return;
            }

            Iterator<AGEventHandler> it = mEventHandlerList.keySet().iterator();
            while (it.hasNext()) {
                it.next().onStreamPublished(url, error);
            }
        }

        @Override
        public void onStreamUnpublished(String url) {
            Log.d(LOG_TAG, "onStreamUnpublished: " + url);
            super.onStreamUnpublished(url);

            if (mEventHandlerList.isEmpty()) {
                return;
            }

            Iterator<AGEventHandler> it = mEventHandlerList.keySet().iterator();
            while (it.hasNext()) {
                it.next().onStreamUnpublished(url);
            }
        }

        @Override
        public void onError(int err) {
            Log.e(LOG_TAG, "error: " + err);
            super.onError(err);

            if (mEventHandlerList.isEmpty()) {
                return;
            }

            Iterator<AGEventHandler> it = mEventHandlerList.keySet().iterator();
            while (it.hasNext()) {
                it.next().onError(err);
            }
        }

        @Override
        public void onUserOffline(int uid, int reason) {
            Log.d(LOG_TAG, "onUserOffline: " + (uid & 0xFFFFFFFFL) + " " + reason);
            super.onUserOffline(uid, reason);

            if (mEventHandlerList.isEmpty()) {
                return;
            }

            Iterator<AGEventHandler> it = mEventHandlerList.keySet().iterator();
            while (it.hasNext()) {
                it.next().onUserOffline(uid, reason);
            }
        }

        @Override
        public void onLeaveChannel(RtcStats stats) {
            super.onLeaveChannel(stats);

            if (mEventHandlerList.isEmpty()) {
                return;
            }

            Iterator<AGEventHandler> it = mEventHandlerList.keySet().iterator();
            while (it.hasNext()) {
                it.next().onLeaveChannel(stats);
            }
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

            Log.d(LOG_TAG, "onStreamInjectedStatus: " + url + " " + (uid & 0xFFFFFFFFL) + " " + reason + "(" + status + ")");
            super.onStreamInjectedStatus(url, uid, status);

            if (mEventHandlerList.isEmpty()) {
                return;
            }

            Iterator<AGEventHandler> it = mEventHandlerList.keySet().iterator();
            while (it.hasNext()) {
                it.next().onStreamInjectedStatus(url, uid, status);
            }
        }
    };
}
