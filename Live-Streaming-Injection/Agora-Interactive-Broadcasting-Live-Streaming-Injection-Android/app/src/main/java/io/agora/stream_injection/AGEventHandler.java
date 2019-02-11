package io.agora.stream_injection;

import io.agora.rtc.IRtcEngineEventHandler;

public interface AGEventHandler {
    void onJoinChannelSuccess(String channel, int uid, int elapsed);

    void onUserJoined(int uid, int elapsed);

    void onStreamPublished(String url, int error);

    void onStreamUnpublished(String url);

    void onError(int err);

    void onUserOffline(int uid, int reason);

    void onLeaveChannel(IRtcEngineEventHandler.RtcStats stats);

    void onStreamInjectedStatus(String url, int uid, int status);
}
