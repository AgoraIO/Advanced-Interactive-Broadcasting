package agora.io.optimizedtranscoding;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

public class LoadActivity extends AppCompatActivity {

    private String mChannelName;
    private String mPublishUrl;

    EditText etChannleName;
    EditText etUrl;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_load);

        etChannleName = findViewById(R.id.et_channel_name);
        etUrl = findViewById(R.id.et_publish_url);
    }

    public void onJoinClicked(View v){
        mChannelName = etChannleName.getText().toString();
        mPublishUrl = etUrl.getText().toString();

        if (TextUtils.isEmpty(mChannelName) || TextUtils.isEmpty(mPublishUrl)) {
            Toast.makeText(this, "please input a channel name and url", Toast.LENGTH_SHORT).show();
            return;
        }

        forwardToMain();
    }

    private void forwardToMain(){
       Intent i = new Intent(this, MainActivity.class);
       i.putExtra("CHANNEL", mChannelName);
       i.putExtra("URL", mPublishUrl);

       startActivity(i);
    }
}
