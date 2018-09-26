package agora.io.injectstream;

import android.util.Log;

import java.util.concurrent.ConcurrentHashMap;

import io.agora.rtc.IRtcEngineEventHandler;

public class MediaEngineHandler {

    private ConcurrentHashMap<Integer, IMediaEngineHandler> handlers = new ConcurrentHashMap<>();

    public void addEventHandler(IMediaEngineHandler handler) {
        handlers.put(0, handler);
    }

    public void removeEventHandler(IMediaEngineHandler handler) {
        handlers.remove(0);
    }

    final IRtcEngineEventHandler engineEventHandler = new IRtcEngineEventHandler() {
        @Override
        public void onJoinChannelSuccess(String channel, int uid, int elapsed) {
            super.onJoinChannelSuccess(channel, uid, elapsed);
            Log.e("wbsTest-->", "success");
            if (!handlers.isEmpty())
                handlers.values().iterator().next(). onJoinChannelSuccess(channel, uid, elapsed);
        }

        @Override
        public void onUserJoined(int uid, int elapsed) {
            Log.e("wbsTest-->", "joined");
            super.onUserJoined(uid, elapsed);
            if (!handlers.isEmpty())
                handlers.values().iterator().next().onUserJoined(uid, elapsed);
        }

        @Override
        public void onStreamPublished(String url, int error) {
            super.onStreamPublished(url, error);

            if (!handlers.isEmpty())
                handlers.values().iterator().next().onStreamPublished(url, error);
        }

        @Override
        public void onStreamUnpublished(String url) {
            super.onStreamUnpublished(url);
            if (!handlers.isEmpty())
                handlers.values().iterator().next().onStreamUnpublished(url);
        }

        @Override
        public void onError(int err) {
            super.onError(err);
            Log.e("wbsTest-->", "error:" + err);

            if (!handlers.isEmpty())
                handlers.values().iterator().next().onError(err);
        }

        @Override
        public void onUserOffline(int uid, int reason) {
            super.onUserOffline(uid, reason);
            if (!handlers.isEmpty())
                handlers.values().iterator().next().onUserOffline(uid, reason);
        }

        @Override
        public void onLeaveChannel(RtcStats stats) {
            super.onLeaveChannel(stats);

            if (!handlers.isEmpty())
                handlers.values().iterator().next().onLeaveChannel(stats);
        }

        @Override
        public void onStreamInjectedStatus(String url, int uid, int status) {
            super.onStreamInjectedStatus(url, uid, status);

            if (!handlers.isEmpty())
                handlers.values().iterator().next().onStreamInjectedStatus(url, uid, status);
        }
    };
}
