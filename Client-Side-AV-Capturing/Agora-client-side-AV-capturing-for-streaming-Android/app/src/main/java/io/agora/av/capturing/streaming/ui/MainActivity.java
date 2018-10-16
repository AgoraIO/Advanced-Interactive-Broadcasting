package io.agora.av.capturing.streaming.ui;

import android.content.DialogInterface;
import android.content.Intent;
import android.support.v7.app.AlertDialog;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.Spinner;

import io.agora.av.capturing.streaming.R;
import io.agora.av.capturing.streaming.model.ConstantApp;
import io.agora.rtc.Constants;

public class MainActivity extends BaseActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    @Override
    protected void initUIandEvent() {
        EditText v_room = (EditText) findViewById(R.id.room_name);
        v_room.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                boolean isEmpty = TextUtils.isEmpty(s.toString());
                findViewById(R.id.button_join).setEnabled(!isEmpty);
            }
        });

        String lastChannelName = vSettings().mChannelName;
        if (!TextUtils.isEmpty(lastChannelName)) {
            v_room.setText(lastChannelName);
            v_room.setSelection(lastChannelName.length());
        }

        initAudioConfigUi();
    }

    @Override
    protected void deInitUIandEvent() {
    }

    private void initAudioConfigUi() {
        // sample rate
        Spinner audioSampleRate = (Spinner) findViewById(R.id.audio_sample_rate);
        String[] audioSampleRateValues = getResources().getStringArray(R.array.audio_sample_rate_values);
        ArrayAdapter<String> adapter = new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, audioSampleRateValues);
        audioSampleRate.setAdapter(adapter);
        audioSampleRate.setSelection(1); // 32000
        audioSampleRate.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                setAudioConfigUi();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        // samples per call
        Spinner audioSamplesPerCall = (Spinner) findViewById(R.id.audio_samples_per_call);
        String[] audioSamplesPerTimeValues = getResources().getStringArray(R.array.audio_samples_per_call_values);
        ArrayAdapter<String> aAdapter = new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, audioSamplesPerTimeValues);
        audioSamplesPerCall.setAdapter(aAdapter);
        audioSamplesPerCall.setSelection(1); // 1024
        audioSamplesPerCall.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                setAudioConfigUi();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });
    }

    private void setAudioConfigUi() {
        Spinner audioSampleRate = (Spinner) findViewById(R.id.audio_sample_rate);
        String[] sampleRateValues = getResources().getStringArray(R.array.audio_sample_rate_values);
        vSettings().mSampleRate = Integer.valueOf(sampleRateValues[audioSampleRate.getSelectedItemPosition()]);

        Spinner audioSamplesCall = (Spinner) findViewById(R.id.audio_samples_per_call);
        String[] samplesPerTimeValues = getResources().getStringArray(R.array.audio_samples_per_call_values);

        vSettings().mSamplesPerCall = Integer.valueOf(samplesPerTimeValues[audioSamplesCall.getSelectedItemPosition()]);
    }

    @Override
    public boolean onCreateOptionsMenu(final Menu menu) {
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        return super.onOptionsItemSelected(item);
    }

    public void onClickJoin(View view) {
        // show dialog to choose role
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setMessage(R.string.msg_choose_role);
        builder.setNegativeButton(R.string.label_audience, new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                MainActivity.this.forwardToLiveRoom(Constants.CLIENT_ROLE_AUDIENCE);
            }
        });
        builder.setPositiveButton(R.string.label_broadcaster, new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                MainActivity.this.forwardToLiveRoom(Constants.CLIENT_ROLE_BROADCASTER);
            }
        });
        AlertDialog dialog = builder.create();

        dialog.show();
    }

    public void forwardToLiveRoom(int cRole) {
        final EditText v_room = (EditText) findViewById(R.id.room_name);
        String room = v_room.getText().toString();

        Intent i = new Intent(MainActivity.this, LiveRoomActivity.class);
        i.putExtra(ConstantApp.ACTION_KEY_CROLE, cRole);
        i.putExtra(ConstantApp.ACTION_KEY_ROOM_NAME, room);

        startActivity(i);
    }
}
