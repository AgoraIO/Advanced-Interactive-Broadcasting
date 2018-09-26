package agora.io.injectstream;

import android.app.Application;

import java.lang.ref.WeakReference;

public class MApplication extends Application {
    private WorkThread workThread;

    public synchronized void initWorkThread(){
        if (workThread == null) {
            workThread = new WorkThread(new WeakReference<>(getApplicationContext()));
            workThread.start();
            workThread.waitForReady();
        }
    }

    public synchronized WorkThread getWorkThread() {
        return workThread;
    }
}
