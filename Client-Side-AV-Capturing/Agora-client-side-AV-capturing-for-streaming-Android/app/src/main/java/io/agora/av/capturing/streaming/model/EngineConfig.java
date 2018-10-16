package io.agora.av.capturing.streaming.model;

import io.agora.rtc.video.VideoEncoderConfiguration;

public class EngineConfig {
    public int mClientRole;

    public VideoEncoderConfiguration.VideoDimensions mVideoProfile;

    public int mUid;

    public String mChannel;

    public void reset() {
        mChannel = null;
    }

    EngineConfig() {
    }
}
