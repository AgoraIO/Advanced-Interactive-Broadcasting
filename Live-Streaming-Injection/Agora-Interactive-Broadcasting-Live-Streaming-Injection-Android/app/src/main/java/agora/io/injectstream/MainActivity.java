package agora.io.injectstream;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.opengl.Matrix;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity {
    private volatile boolean hasPermission = false;
    private EditText et;
    private EditText etName;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        if (checkSelfPermissions()) {
            hasPermission = true;
        }

        et = findViewById(R.id.et_inject_url);
        etName = findViewById(R.id.et_channel_name);
    }

    private boolean checkSelfPermissions() {
        return checkSelfPermission(Manifest.permission.RECORD_AUDIO, 200) &&
                checkSelfPermission(Manifest.permission.CAMERA, 201) &&
                checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE, 202);
    }

    public boolean checkSelfPermission(String permission, int requestCode) {
        if (ContextCompat.checkSelfPermission(this, permission) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this,
                    new String[]{permission},
                    requestCode);
            return false;
        }

        return true;
    }

    public void onStartClicked(View v) {
        if (!hasPermission) {
            Toast.makeText(this, "Please check permissions!", Toast.LENGTH_SHORT).show();
            return;
        }

        if (null == et || TextUtils.isEmpty(et.getText().toString())){
            Toast.makeText(this, "Please input a url!", Toast.LENGTH_SHORT).show();
            return;
        }

        if (null == etName || TextUtils.isEmpty(etName.getText().toString())){
            Toast.makeText(this, "Please input a channel name!", Toast.LENGTH_SHORT).show();
            return;
        }


        Intent i = new Intent(MainActivity.this, ShowActivity.class);
        i.putExtra("INJECT_URL", et.getText().toString());
        i.putExtra("CHANNEL_NAME", etName.getText().toString());
        startActivity(i);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        switch (requestCode) {
            case 200: {
                if (grantResults.length > 0
                        && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    checkSelfPermission(Manifest.permission.CAMERA, 201);
                } else {
                    finish();
                }
                break;
            }
            case 201: {
                if (grantResults.length > 0
                        && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE, 202);
                    hasPermission = true;
                } else {
                    finish();
                }
                break;
            }
            case 202: {
                if (grantResults.length > 0
                        && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                } else {
                    finish();
                }
                break;
            }
        }
    }
}
