package io.agora.av.capturing.streaming.model;

public class CurrentUserSettings {
    public String mChannelName;

    public int mSampleRate;

    public int mSamplesPerCall;

    public CurrentUserSettings() {
        reset();
    }

    public void reset() {
        mSampleRate = 32000;
        mSamplesPerCall = 1024;
    }
}
