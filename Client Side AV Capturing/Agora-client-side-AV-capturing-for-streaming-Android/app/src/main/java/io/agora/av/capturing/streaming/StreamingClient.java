package io.agora.av.capturing.streaming;

public abstract class StreamingClient {
    public abstract void startStreaming();

    public abstract void stopStreaming();

    public abstract void sendYUVData(final byte[] yuv, final int width, final int height);

    public abstract void sendPCMData(final byte[] pcm);
}
