package io.agora.voice.only.livestreaming.model;

public class EngineConfig {
    public int mClientRole;

    public int mUid;

    public String mChannel;

    public void reset() {
        mChannel = null;
    }

    EngineConfig() {
    }
}
