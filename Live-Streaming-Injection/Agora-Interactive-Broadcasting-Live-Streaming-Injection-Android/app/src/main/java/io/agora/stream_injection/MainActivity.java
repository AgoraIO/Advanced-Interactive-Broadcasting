package io.agora.stream_injection;

import android.Manifest;
import android.annotation.TargetApi;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.content.ContextCompat;
import android.support.v4.content.PermissionChecker;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity {
    private EditText et;
    private EditText etName;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        et = findViewById(R.id.et_inject_url);
        etName = findViewById(R.id.et_channel_name);

        etName.setSelection(etName.getText().length()); // move cursor to the last
    }

    public void onStartClicked(View v) {
        if (null == et || TextUtils.isEmpty(et.getText().toString())) {
            Toast.makeText(this, "Please input a url!", Toast.LENGTH_SHORT).show();
            return;
        }

        if (null == etName || TextUtils.isEmpty(etName.getText().toString())) {
            Toast.makeText(this, "Please input a channel name!", Toast.LENGTH_SHORT).show();
            return;
        }

        if (checkSelfPermissions()) {
            Intent i = new Intent(MainActivity.this, ShowActivity.class);
            i.putExtra("INJECT_URL", et.getText().toString());
            i.putExtra("CHANNEL_NAME", etName.getText().toString());
            startActivity(i);
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
}
