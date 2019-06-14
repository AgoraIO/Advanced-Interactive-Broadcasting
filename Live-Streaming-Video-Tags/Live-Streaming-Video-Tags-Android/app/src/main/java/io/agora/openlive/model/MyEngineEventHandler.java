package io.agora.openlive.model;

import android.content.Context;

import io.agora.rtc.IMetadataObserver;
import io.agora.rtc.IRtcEngineEventHandler;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.Iterator;
import java.util.concurrent.ConcurrentHashMap;

public class MyEngineEventHandler {
    public MyEngineEventHandler(Context ctx, EngineConfig config) {
        this.mContext = ctx;
        this.mConfig = config;
    }

    private final int MAX_META_LENGTH = 1024;

    private final EngineConfig mConfig;

    private final Context mContext;

    private byte[] metadata = null;

    private final ConcurrentHashMap<AGEventHandler, Integer> mEventHandlerList = new ConcurrentHashMap<>();

    public void addEventHandler(AGEventHandler handler) {
        this.mEventHandlerList.put(handler, 0);
    }

    public void removeEventHandler(AGEventHandler handler) {
        this.mEventHandlerList.remove(handler);
    }

    public void setMetadata(byte[] data) {
        metadata = data;
    }

    final IMetadataObserver mMediaMetadtaObserver = new IMetadataObserver() {
        private final Logger log = LoggerFactory.getLogger(this.getClass());
        @Override
        public int getMaxMetadataSize() {
            return MAX_META_LENGTH;
        }
        // please do pass metadata in this callback "onReadyToSendMetadata" and make sure this callback is not blocked by anything.
        @Override 
        public byte[] onReadyToSendMetadata(long ts) {
            if(metadata == null) {
                return null;
            }

            log.debug("metadata detected...");
            byte[] toSend = metadata;

            if(toSend.length > MAX_META_LENGTH) {
                // exceeding maximum length
                log.error("metadata exceeding max meta length " + MAX_META_LENGTH);
                return null;
            }
            metadata = null;
            log.debug("metadata sent success");
            return toSend;
        }

        @Override
        public void onMetadataReceived(byte[] bytes, int i, long l) {
            log.debug("onMetadataReceived: " + new String(bytes, Charset.forName("UTF-8")));
            Iterator<AGEventHandler> it = mEventHandlerList.keySet().iterator();
            while (it.hasNext()) {
                AGEventHandler handler = it.next();
                handler.onMetadataReceived(bytes, i, l);
            }
        }
    };

    final IRtcEngineEventHandler mRtcEventHandler = new IRtcEngineEventHandler() {
        private final Logger log = LoggerFactory.getLogger(this.getClass());

        @Override
        public void onFirstRemoteVideoDecoded(int uid, int width, int height, int elapsed) {
            log.debug("onFirstRemoteVideoDecoded " + (uid & 0xFFFFFFFFL) + " " + width + " " + height + " " + elapsed);

            Iterator<AGEventHandler> it = mEventHandlerList.keySet().iterator();
            while (it.hasNext()) {
                AGEventHandler handler = it.next();
                handler.onFirstRemoteVideoDecoded(uid, width, height, elapsed);
            }
        }

        @Override
        public void onFirstLocalVideoFrame(int width, int height, int elapsed) {
            log.debug("onFirstLocalVideoFrame " + width + " " + height + " " + elapsed);
        }

        @Override
        public void onUserJoined(int uid, int elapsed) {
            log.debug("onUserJoined " + (uid & 0xFFFFFFFFL) + " " + elapsed);

            Iterator<AGEventHandler> it = mEventHandlerList.keySet().iterator();
            while (it.hasNext()) {
                AGEventHandler handler = it.next();
                handler.onUserJoined(uid, elapsed);
            }
        }

        @Override
        public void onUserOffline(int uid, int reason) {
            // FIXME this callback may return times
            Iterator<AGEventHandler> it = mEventHandlerList.keySet().iterator();
            while (it.hasNext()) {
                AGEventHandler handler = it.next();
                handler.onUserOffline(uid, reason);
            }
        }

        @Override
        public void onUserMuteVideo(int uid, boolean muted) {
        }

        @Override
        public void onRtcStats(RtcStats stats) {
        }


        @Override
        public void onLeaveChannel(RtcStats stats) {

        }

        @Override
        public void onLastmileQuality(int quality) {
            log.debug("onLastmileQuality " + quality);
        }

        @Override
        public void onError(int err) {
            super.onError(err);
            log.debug("onError " + err);
        }

        @Override
        public void onJoinChannelSuccess(String channel, int uid, int elapsed) {
            log.debug("onJoinChannelSuccess " + channel + " " + uid + " " + (uid & 0xFFFFFFFFL) + " " + elapsed);

            Iterator<AGEventHandler> it = mEventHandlerList.keySet().iterator();
            while (it.hasNext()) {
                AGEventHandler handler = it.next();
                handler.onJoinChannelSuccess(channel, uid, elapsed);
            }
        }

        public void onRejoinChannelSuccess(String channel, int uid, int elapsed) {
            log.debug("onRejoinChannelSuccess " + channel + " " + uid + " " + elapsed);
        }

        public void onWarning(int warn) {
            log.debug("onWarning " + warn);
        }
    };

}
