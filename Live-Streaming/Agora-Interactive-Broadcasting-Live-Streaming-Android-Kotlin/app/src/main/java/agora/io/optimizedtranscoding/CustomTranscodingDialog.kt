package agora.io.optimizedtranscoding

import android.app.AlertDialog
import android.content.Context
import android.content.DialogInterface
import android.support.annotation.IdRes
import android.view.LayoutInflater
import android.view.View
import android.widget.CheckBox
import android.widget.RadioButton
import android.widget.RadioGroup
import android.widget.SeekBar
import android.widget.TextView

// If your Agora RTC SDK version is under 2.3.0, please import `io.agora.live.LiveTranscoding;`
import io.agora.rtc.live.LiveTranscoding

class CustomTranscodingDialog(private val mContext: Context, private val mTransCoding: LiveTranscoding) {
    private var mListener: OnUpdateTranscodingListener? = null

    fun showDialog() {
        val builder: AlertDialog.Builder
        val alertDialog: AlertDialog
        val layout = LayoutInflater.from(mContext).inflate(R.layout.transcoding_setting, null)

        val widthSeekBar = layout.findViewById<View>(R.id.text_set_width) as SeekBar
        val widthTextView = layout.findViewById<View>(R.id.show_width) as TextView
        widthSeekBar.setOnSeekBarChangeListener(object : SeekBar.OnSeekBarChangeListener {
            override fun onProgressChanged(seekBar: SeekBar, progress: Int, fromUser: Boolean) {
                var progress = progress
                if (progress == 0) {
                    progress = 1
                }

                widthTextView.text = progress.toString() + ""
                mTransCoding.width = progress
            }

            override fun onStartTrackingTouch(seekBar: SeekBar) {}

            override fun onStopTrackingTouch(seekBar: SeekBar) {}

        })
        widthSeekBar.progress = mTransCoding.width

        val heightSeekBar = layout.findViewById<View>(R.id.text_set_height) as SeekBar
        val heightTextView = layout.findViewById<View>(R.id.show_height) as TextView
        heightSeekBar.setOnSeekBarChangeListener(object : SeekBar.OnSeekBarChangeListener {
            override fun onProgressChanged(seekBar: SeekBar, progress: Int, fromUser: Boolean) {
                var progress = progress
                if (progress == 0) {
                    progress = 1
                }

                heightTextView.text = progress.toString() + ""
                mTransCoding.height = progress
            }

            override fun onStartTrackingTouch(seekBar: SeekBar) {}

            override fun onStopTrackingTouch(seekBar: SeekBar) {}

        })
        heightSeekBar.progress = mTransCoding.height

        val bitrateSeekBar = layout.findViewById<View>(R.id.text_set_bitrate) as SeekBar
        val bitRateTextView = layout.findViewById<View>(R.id.show_bitrate) as TextView
        bitrateSeekBar.setOnSeekBarChangeListener(object : SeekBar.OnSeekBarChangeListener {
            override fun onProgressChanged(seekBar: SeekBar, progress: Int, fromUser: Boolean) {
                var progress = progress
                if (progress == 0) {
                    progress = 1
                }

                bitRateTextView.text = progress.toString() + ""
                mTransCoding.videoBitrate = progress
            }

            override fun onStartTrackingTouch(seekBar: SeekBar) {}

            override fun onStopTrackingTouch(seekBar: SeekBar) {

            }

        })
        bitrateSeekBar.progress = mTransCoding.videoBitrate

        val fpsSeekBar = layout.findViewById<View>(R.id.text_set_fps) as SeekBar
        val fpsTextView = layout.findViewById<View>(R.id.show_fps) as TextView
        fpsSeekBar.setOnSeekBarChangeListener(object : SeekBar.OnSeekBarChangeListener {
            override fun onProgressChanged(seekBar: SeekBar, progress: Int, fromUser: Boolean) {
                var progress = progress
                if (progress == 0) {
                    progress = 1
                }

                fpsTextView.text = progress.toString() + ""
                mTransCoding.videoFramerate = progress
            }

            override fun onStartTrackingTouch(seekBar: SeekBar) {}

            override fun onStopTrackingTouch(seekBar: SeekBar) {}

        })
        fpsSeekBar.progress = mTransCoding.videoFramerate

        val latencyCheckBox = layout.findViewById<View>(R.id.cb_low_latency) as CheckBox
        latencyCheckBox.setOnClickListener(null)
        latencyCheckBox.isChecked = mTransCoding.lowLatency
        latencyCheckBox.setOnClickListener { mTransCoding.lowLatency = latencyCheckBox.isChecked }

        val gopSeekBar = layout.findViewById<View>(R.id.text_set_gop) as SeekBar
        val gopTextView = layout.findViewById<View>(R.id.show_gop) as TextView
        gopSeekBar.setOnSeekBarChangeListener(object : SeekBar.OnSeekBarChangeListener {
            override fun onProgressChanged(seekBar: SeekBar, progress: Int, fromUser: Boolean) {
                var progress = progress
                if (progress == 0) {
                    progress = 1
                }

                mTransCoding.videoGop = progress
                gopTextView.text = "" + progress
            }

            override fun onStartTrackingTouch(seekBar: SeekBar) {}

            override fun onStopTrackingTouch(seekBar: SeekBar) {}

        })
        gopSeekBar.progress = mTransCoding.videoGop

        val videoCodec = layout.findViewById<View>(R.id.codec) as RadioGroup
        if (mTransCoding.videoCodecProfile == LiveTranscoding.VideoCodecProfileType.BASELINE) {
            val button = layout.findViewById<View>(R.id.codec_baseline) as RadioButton
            button.isChecked = true
        } else if (mTransCoding.videoCodecProfile == LiveTranscoding.VideoCodecProfileType.HIGH) {
            val button = layout.findViewById<View>(R.id.codec_high) as RadioButton
            button.isChecked = true
        } else if (mTransCoding.videoCodecProfile == LiveTranscoding.VideoCodecProfileType.MAIN) {
            val button = layout.findViewById<View>(R.id.codec_main) as RadioButton
            button.isChecked = true
        }

        videoCodec.setOnCheckedChangeListener { group, checkedId ->
            when (checkedId) {
                R.id.codec_baseline -> mTransCoding.videoCodecProfile = LiveTranscoding.VideoCodecProfileType.BASELINE
                R.id.codec_high -> mTransCoding.videoCodecProfile = LiveTranscoding.VideoCodecProfileType.HIGH
                R.id.codec_main -> mTransCoding.videoCodecProfile = LiveTranscoding.VideoCodecProfileType.MAIN
                else -> {
                }
            }
        }

        if (mTransCoding.audioSampleRate == LiveTranscoding.AudioSampleRateType.TYPE_32000) {
            val button = layout.findViewById<View>(R.id.samplerate_32) as RadioButton
            button.isChecked = true
        } else if (mTransCoding.audioSampleRate == LiveTranscoding.AudioSampleRateType.TYPE_44100) {
            val button = layout.findViewById<View>(R.id.samplerate_44_1) as RadioButton
            button.isChecked = true
        } else if (mTransCoding.audioSampleRate == LiveTranscoding.AudioSampleRateType.TYPE_48000) {
            val button = layout.findViewById<View>(R.id.samplerate_48) as RadioButton
            button.isChecked = true
        }

        val sample = layout.findViewById<View>(R.id.samplerate) as RadioGroup
        sample.setOnCheckedChangeListener { group, checkedId ->
            when (checkedId) {
                R.id.samplerate_32 -> mTransCoding.audioSampleRate = LiveTranscoding.AudioSampleRateType.TYPE_32000
                R.id.samplerate_44_1 -> mTransCoding.audioSampleRate = LiveTranscoding.AudioSampleRateType.TYPE_44100
                R.id.samplerate_48 -> mTransCoding.audioSampleRate = LiveTranscoding.AudioSampleRateType.TYPE_48000
            }
        }

        if (mTransCoding.audioBitrate == 48) {
            val button = layout.findViewById<View>(R.id.transcoding_audio_bitrate_48) as RadioButton
            button.isChecked = true
        } else if (mTransCoding.audioBitrate == 128) {
            val button = layout.findViewById<View>(R.id.transcoding_audio_bitrate_128) as RadioButton
            button.isChecked = true
        }

        val audioBitrate = layout.findViewById<View>(R.id.transcoding_audio_bitrate) as RadioGroup
        audioBitrate.setOnCheckedChangeListener { group, checkedId ->
            when (checkedId) {
                R.id.transcoding_audio_bitrate_48 -> mTransCoding.audioBitrate = 48
                R.id.transcoding_audio_bitrate_128 -> mTransCoding.audioBitrate = 128
            }
        }

        if (mTransCoding.audioChannels == 1) {
            val button = layout.findViewById<View>(R.id.transcoding_audio_channe_mono) as RadioButton
            button.isChecked = true
        } else if (mTransCoding.audioChannels == 2) {
            val button = layout.findViewById<View>(R.id.transcoding_audio_channe_stereo) as RadioButton
            button.isChecked = true
        }

        val audioStereo = layout.findViewById<View>(R.id.transcoding_audio_channel) as RadioGroup
        audioStereo.setOnCheckedChangeListener { group, checkedId ->
            when (checkedId) {
                R.id.transcoding_audio_channe_mono -> mTransCoding.audioChannels = 1
                R.id.transcoding_audio_channe_stereo -> mTransCoding.audioChannels = 2
            }
        }

        builder = AlertDialog.Builder(mContext)
        builder.setView(layout)
        alertDialog = builder.create()
        alertDialog.setOnDismissListener {
            if (mListener != null) {
                mListener!!.onUpdateTranscoding(mTransCoding)
            }
        }
        alertDialog.show()
    }

    fun setOnUpdateTranscodingListener(listener: OnUpdateTranscodingListener) {
        mListener = listener
    }

    interface OnUpdateTranscodingListener {
        fun onUpdateTranscoding(customTranscoding: LiveTranscoding)
    }

}
