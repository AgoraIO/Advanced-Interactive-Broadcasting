package io.agora.stream_injection;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;

import io.agora.rtc.RtcEngine;
import io.agora.rtc.live.LiveInjectStreamConfig;

public abstract class BaseActivity extends AppCompatActivity {
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ((MyApplication) getApplication()).initWorkerThread();
    }

    @Override
    protected void onPostCreate(@Nullable Bundle savedInstanceState) {
        super.onPostCreate(savedInstanceState);
        initUIandEvent();
    }

    protected abstract void initUIandEvent();

    protected abstract void deInitUIandEvent();

    protected final WorkerThread worker() {
        return ((MyApplication) getApplication()).getWorkerThread();
    }

    protected RtcEngine rtcEngine() {
        return ((MyApplication) getApplication()).getWorkerThread().rtcEngine();
    }

    protected final MyEngineEventHandler event() {
        return ((MyApplication) getApplication()).getWorkerThread().eventHandler();
    }

    // set LiveInjectStreamConfig property for this channel
    protected LiveInjectStreamConfig newLiveInjectStreamConfig() {

        LiveInjectStreamConfig config = new LiveInjectStreamConfig();
        config.width = 0;
        config.height = 0;
        config.videoGop = 30;
        config.videoFramerate = 15;
        config.videoBitrate = 400;
        config.audioSampleRate = LiveInjectStreamConfig.AudioSampleRateType.TYPE_44100;
        config.audioBitrate = 48;
        config.audioChannels = 1;

        return config;
    }
}
