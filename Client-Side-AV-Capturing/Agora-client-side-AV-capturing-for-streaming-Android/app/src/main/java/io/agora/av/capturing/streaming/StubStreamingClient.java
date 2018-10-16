package io.agora.av.capturing.streaming;

/**
 * Implement your own streaming client
 */
public class StubStreamingClient extends StreamingClient {
    @Override
    public void startStreaming() {
        // do nothing
    }

    @Override
    public void stopStreaming() {
        // do nothing
    }

    @Override
    public void sendYUVData(final byte[] yuv, final int width, final int height) {
        // do nothing
    }

    @Override
    public void sendPCMData(final byte[] pcm) {
        // do nothing
    }
}
