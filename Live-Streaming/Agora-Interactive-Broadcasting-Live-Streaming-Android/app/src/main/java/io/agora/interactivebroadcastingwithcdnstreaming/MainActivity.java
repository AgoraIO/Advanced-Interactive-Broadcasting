package io.agora.interactivebroadcastingwithcdnstreaming;

import android.Manifest;
import android.annotation.TargetApi;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.support.annotation.NonNull;
import android.support.v4.content.ContextCompat;
import android.support.v4.content.PermissionChecker;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity {

    private String mChannelName;
    private String mPublishUrl;

    EditText etChannelName;
    EditText etUrl;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        etChannelName = findViewById(R.id.et_channel_name);
        etUrl = findViewById(R.id.et_publish_url);
    }

    public void onJoinClicked(View v) {
        mChannelName = etChannelName.getText().toString();
        mPublishUrl = etUrl.getText().toString();

        if (TextUtils.isEmpty(mChannelName) || TextUtils.isEmpty(mPublishUrl)) {
            Toast.makeText(this, "please input a channel name and url", Toast.LENGTH_SHORT).show();
            return;
        }

        if (checkSelfPermissions()) {
            forwardToMain();
        }
    }

    private static final int PERMISSION_REQ_ID = 1024;

    @TargetApi(Build.VERSION_CODES.M)
    private void askPermission() {
        requestPermissions(new String[]{
                        Manifest.permission.CAMERA,
                        Manifest.permission.RECORD_AUDIO,
                        Manifest.permission.WRITE_EXTERNAL_STORAGE},
                PERMISSION_REQ_ID);
    }

    private boolean checkSelfPermissions() {
        return checkSelfPermission(Manifest.permission.RECORD_AUDIO, PERMISSION_REQ_ID) &&
                checkSelfPermission(Manifest.permission.CAMERA, PERMISSION_REQ_ID) &&
                checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE, PERMISSION_REQ_ID);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == PERMISSION_REQ_ID) {
            for (int g : grantResults) {
                if (g != PermissionChecker.PERMISSION_GRANTED) {
                    return;
                }
            }
        }
    }

    public boolean checkSelfPermission(String permission, int requestCode) {
        if (ContextCompat.checkSelfPermission(this,
                permission)
                != PackageManager.PERMISSION_GRANTED) {

            askPermission();
            return false;
        }
        return true;
    }

    private void forwardToMain() {
        Intent i = new Intent(this, VideoActivity.class);
        i.putExtra("CHANNEL", mChannelName);
        i.putExtra("URL", mPublishUrl);

        startActivity(i);
    }
}
