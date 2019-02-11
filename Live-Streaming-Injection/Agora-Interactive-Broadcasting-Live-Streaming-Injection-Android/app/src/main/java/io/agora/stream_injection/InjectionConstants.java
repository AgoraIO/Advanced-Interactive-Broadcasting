package io.agora.stream_injection;

import io.agora.rtc.video.VideoEncoderConfiguration;

public class InjectionConstants {

    public final static VideoEncoderConfiguration VIDEO_CONFIGURATION = new VideoEncoderConfiguration(VideoEncoderConfiguration.VD_640x480,
            VideoEncoderConfiguration.FRAME_RATE.FRAME_RATE_FPS_15, VideoEncoderConfiguration.STANDARD_BITRATE,
            VideoEncoderConfiguration.ORIENTATION_MODE.ORIENTATION_MODE_FIXED_PORTRAIT);
}
