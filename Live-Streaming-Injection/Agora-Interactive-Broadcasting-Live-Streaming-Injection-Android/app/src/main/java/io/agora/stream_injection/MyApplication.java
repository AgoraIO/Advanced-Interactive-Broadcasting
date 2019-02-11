package io.agora.stream_injection;

import android.app.Application;

import java.lang.ref.WeakReference;

public class MyApplication extends Application {
    private WorkerThread mWorkerThread;

    public synchronized void initWorkerThread() {
        if (mWorkerThread == null) {
            mWorkerThread = new WorkerThread(new WeakReference<>(getApplicationContext()));
            mWorkerThread.start();
            mWorkerThread.waitForReady();
        }
    }

    public synchronized WorkerThread getWorkerThread() {
        return mWorkerThread;
    }
}
