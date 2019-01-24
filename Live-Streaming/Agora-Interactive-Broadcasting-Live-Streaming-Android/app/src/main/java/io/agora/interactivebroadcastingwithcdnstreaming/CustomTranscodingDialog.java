package io.agora.interactivebroadcastingwithcdnstreaming;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.support.annotation.IdRes;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.CheckBox;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.SeekBar;
import android.widget.TextView;

// If your Agora RTC SDK version is under 2.3.0, please import `io.agora.live.LiveTranscoding;`
import io.agora.rtc.live.LiveTranscoding;

public class CustomTranscodingDialog {

    private LiveTranscoding mTransCoding;
    private Context mContext;
    private OnUpdateTranscodingListener mListener;

    public CustomTranscodingDialog(Context context, LiveTranscoding transcoding) {
        mContext = context;
        mTransCoding = transcoding;
    }

    public void showDialog() {
        AlertDialog.Builder builder;
        AlertDialog alertDialog;
        View layout = LayoutInflater.from(mContext).inflate(R.layout.transcoding_setting, null);

        SeekBar widthSeekBar = (SeekBar) layout.findViewById(R.id.text_set_width);
        final TextView widthTextView = (TextView) layout.findViewById(R.id.show_width);
        widthSeekBar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                if (progress == 0) {
                    progress = 1;
                }

                widthTextView.setText(progress + "");
                mTransCoding.width = progress;
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {
            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
            }

        });
        widthSeekBar.setProgress(mTransCoding.width);

        SeekBar heightSeekBar = (SeekBar) layout.findViewById(R.id.text_set_height);
        final TextView heightTextView = (TextView) layout.findViewById(R.id.show_height);
        heightSeekBar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                if (progress == 0) {
                    progress = 1;
                }

                heightTextView.setText(progress + "");
                mTransCoding.height = progress;
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {
            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
            }

        });
        heightSeekBar.setProgress(mTransCoding.height);

        final SeekBar bitrateSeekBar = (SeekBar) layout.findViewById(R.id.text_set_bitrate);
        final TextView bitRateTextView = (TextView) layout.findViewById(R.id.show_bitrate);
        bitrateSeekBar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                if (progress == 0) {
                    progress = 1;
                }

                bitRateTextView.setText(progress + "");
                mTransCoding.videoBitrate = progress;
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {
            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

            }

        });
        bitrateSeekBar.setProgress(mTransCoding.videoBitrate);

        SeekBar fpsSeekBar = (SeekBar) layout.findViewById(R.id.text_set_fps);
        final TextView fpsTextView = (TextView) layout.findViewById(R.id.show_fps);
        fpsSeekBar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                if (progress == 0) {
                    progress = 1;
                }

                fpsTextView.setText(progress + "");
                mTransCoding.videoFramerate = progress;
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {
            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
            }

        });
        fpsSeekBar.setProgress(mTransCoding.videoFramerate);

        final CheckBox latencyCheckBox = (CheckBox) layout.findViewById(R.id.cb_low_latency);
        latencyCheckBox.setOnClickListener(null);
        latencyCheckBox.setChecked(mTransCoding.lowLatency);
        latencyCheckBox.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mTransCoding.lowLatency = latencyCheckBox.isChecked();
            }
        });

        SeekBar gopSeekBar = (SeekBar) layout.findViewById(R.id.text_set_gop);
        final TextView gopTextView = (TextView) layout.findViewById(R.id.show_gop);
        gopSeekBar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                if (progress == 0) {
                    progress = 1;
                }

                mTransCoding.videoGop = progress;
                gopTextView.setText("" + progress);
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {
            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
            }

        });
        gopSeekBar.setProgress(mTransCoding.videoGop);

        RadioGroup videoCodec = (RadioGroup) layout.findViewById(R.id.codec);
        if (mTransCoding.videoCodecProfile == LiveTranscoding.VideoCodecProfileType.BASELINE) {
            RadioButton button = (RadioButton) layout.findViewById(R.id.codec_baseline);
            button.setChecked(true);
        } else if (mTransCoding.videoCodecProfile == LiveTranscoding.VideoCodecProfileType.HIGH) {
            RadioButton button = (RadioButton) layout.findViewById(R.id.codec_high);
            button.setChecked(true);
        } else if (mTransCoding.videoCodecProfile == LiveTranscoding.VideoCodecProfileType.MAIN) {
            RadioButton button = (RadioButton) layout.findViewById(R.id.codec_main);
            button.setChecked(true);
        }

        videoCodec.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, @IdRes int checkedId) {
                switch (checkedId) {
                    case R.id.codec_baseline:
                        mTransCoding.videoCodecProfile = LiveTranscoding.VideoCodecProfileType.BASELINE;
                        break;
                    case R.id.codec_high:
                        mTransCoding.videoCodecProfile = LiveTranscoding.VideoCodecProfileType.HIGH;
                        break;
                    case R.id.codec_main:
                        mTransCoding.videoCodecProfile = LiveTranscoding.VideoCodecProfileType.MAIN;

                        break;
                    default:
                        break;
                }
            }
        });

        if (mTransCoding.audioSampleRate == LiveTranscoding.AudioSampleRateType.TYPE_32000) {
            RadioButton button = (RadioButton) layout.findViewById(R.id.samplerate_32);
            button.setChecked(true);
        } else if (mTransCoding.audioSampleRate == LiveTranscoding.AudioSampleRateType.TYPE_44100) {
            RadioButton button = (RadioButton) layout.findViewById(R.id.samplerate_44_1);
            button.setChecked(true);
        } else if (mTransCoding.audioSampleRate == LiveTranscoding.AudioSampleRateType.TYPE_48000) {
            RadioButton button = (RadioButton) layout.findViewById(R.id.samplerate_48);
            button.setChecked(true);
        }

        RadioGroup sample = (RadioGroup) layout.findViewById(R.id.samplerate);
        sample.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, @IdRes int checkedId) {
                switch (checkedId) {
                    case R.id.samplerate_32:
                        mTransCoding.audioSampleRate = LiveTranscoding.AudioSampleRateType.TYPE_32000;
                        break;
                    case R.id.samplerate_44_1:
                        mTransCoding.audioSampleRate = LiveTranscoding.AudioSampleRateType.TYPE_44100;
                        break;
                    case R.id.samplerate_48:
                        mTransCoding.audioSampleRate = LiveTranscoding.AudioSampleRateType.TYPE_48000;
                        break;
                }
            }
        });

        if (mTransCoding.audioBitrate == 48) {
            RadioButton button = (RadioButton) layout.findViewById(R.id.transcoding_audio_bitrate_48);
            button.setChecked(true);
        } else if (mTransCoding.audioBitrate == 128) {
            RadioButton button = (RadioButton) layout.findViewById(R.id.transcoding_audio_bitrate_128);
            button.setChecked(true);
        }

        RadioGroup audioBitrate = (RadioGroup) layout.findViewById(R.id.transcoding_audio_bitrate);
        audioBitrate.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, @IdRes int checkedId) {
                switch (checkedId) {
                    case R.id.transcoding_audio_bitrate_48:
                        mTransCoding.audioBitrate = 48;
                        break;
                    case R.id.transcoding_audio_bitrate_128:
                        mTransCoding.audioBitrate = 128;
                        break;
                }
            }
        });

        if (mTransCoding.audioChannels == 1) {
            RadioButton button = (RadioButton) layout.findViewById(R.id.transcoding_audio_channe_mono);
            button.setChecked(true);
        } else if (mTransCoding.audioChannels == 2) {
            RadioButton button = (RadioButton) layout.findViewById(R.id.transcoding_audio_channe_stereo);
            button.setChecked(true);
        }

        RadioGroup audioStereo = (RadioGroup) layout.findViewById(R.id.transcoding_audio_channel);
        audioStereo.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, @IdRes int checkedId) {
                switch (checkedId) {
                    case R.id.transcoding_audio_channe_mono:
                        mTransCoding.audioChannels = 1;
                        break;
                    case R.id.transcoding_audio_channe_stereo:
                        mTransCoding.audioChannels = 2;
                        break;
                }
            }
        });

        builder = new AlertDialog.Builder(mContext);
        builder.setView(layout);
        alertDialog = builder.create();
        alertDialog.setOnDismissListener(new DialogInterface.OnDismissListener() {
            @Override
            public void onDismiss(DialogInterface dialog) {
                if (mListener != null) {
                    mListener.onUpdateTranscoding(mTransCoding);
                }
            }
        });
        alertDialog.show();
    }

    public void setOnUpdateTranscodingListener(OnUpdateTranscodingListener listener) {
        mListener = listener;
    }

    interface OnUpdateTranscodingListener {
        public void onUpdateTranscoding(LiveTranscoding customTranscoding);
    }

}
