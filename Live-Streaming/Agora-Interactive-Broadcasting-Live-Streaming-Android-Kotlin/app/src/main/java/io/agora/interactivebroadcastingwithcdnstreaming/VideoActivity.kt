package io.agora.interactivebroadcastingwithcdnstreaming

import android.graphics.PorterDuff
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.support.v7.widget.GridLayoutManager
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.RecyclerView
import android.view.SurfaceView
import android.view.View
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView

import java.util.ArrayList
import java.util.HashMap

import io.agora.rtc.Constants
import io.agora.rtc.IRtcEngineEventHandler
import io.agora.rtc.RtcEngine
import io.agora.rtc.live.LiveTranscoding
import io.agora.rtc.video.VideoCanvas
import io.agora.rtc.video.VideoEncoderConfiguration

// If your Agora RTC SDK version is under 2.3.0, please import `io.agora.live.LiveTranscoding;`
// If your Agora RTC SDK version is under 2.3.0, please replace 'setVideoEncoderConfiguration' with 'setVideoProfile'

class VideoActivity : AppCompatActivity() {
    private var mChannelName: String? = null
    private var mPublishUrl = ""

    private var mSmallView: RecyclerView? = null
    private var mSelfView: LinearLayout? = null
    private var mTvRoomName: TextView? = null
    private var mIvRtmp: ImageView? = null

    private var mRtcEngine: RtcEngine? = null
    private var mLiveTranscoding: LiveTranscoding? = null

    private val mUserInfo = HashMap<Int, UserInfo>()
    private var mSmallAdapter: SmallAdapter? = null

    // before join channel success, big-uid is zero, after join success big-uid will modify by onJoinChannel-uid
    private var mBigUserId = 0
    private var mBigView: SurfaceView? = null

    private var mMessageAdapter: MessageAdapter? = null
    private var mMsgList: ArrayList<String>? = null

    internal var mRtcEngineEventHandler: IRtcEngineEventHandler = object : IRtcEngineEventHandler() {
        override fun onError(errorCode: Int) {
            super.onError(errorCode)
            sendMsg("-->onError<--$errorCode")
        }

        override fun onWarning(warn: Int) {
            super.onWarning(warn)
            sendMsg("-->onWarning<--$warn")
        }

        override fun onJoinChannelSuccess(channel: String, uid: Int, elapsed: Int) {
            super.onJoinChannelSuccess(channel, uid, elapsed)
            sendMsg("-->onJoinChannelSuccess<--$channel  -->uid<--$uid")
            runOnUiThread {
                mBigUserId = uid

                val mUI = UserInfo()
                mUI.view = mBigView
                mUI.uid = mBigUserId
                mUI.view!!.setZOrderOnTop(true)
                mUserInfo[mBigUserId] = mUI
            }
        }

        override fun onFirstLocalVideoFrame(width: Int, height: Int, elapsed: Int) {
            super.onFirstLocalVideoFrame(width, height, elapsed)
            sendMsg("-->onFirstLocalVideoFrame<--")
        }

        override fun onRejoinChannelSuccess(channel: String, uid: Int, elapsed: Int) {
            super.onRejoinChannelSuccess(channel, uid, elapsed)
            sendMsg("$uid -->RejoinChannel<--")
        }

        override fun onLeaveChannel(stats: RtcStats) {
            super.onLeaveChannel(stats)
            sendMsg("-->leaveChannel<--")
        }

        override fun onConnectionLost() {
            super.onConnectionLost()
            sendMsg("-->onConnectionLost<--")
        }

        override fun onRtmpStreamingStateChanged(url: String?, state: Int, errCode: Int) {
            super.onRtmpStreamingStateChanged(url, state, errCode)
            sendMsg("-->onStreamUrlPublished<--$url -->state<--$state -->error code<--$errCode")

            when(state) {
                //idle
                0 -> sendMsg("rtmp streaming stopped")
                //running
                2 -> sendMsg("rtmp streaming success")
                //failure
                4-> {
                    //you can also call addPublishStreamUrl to retry from this state
                    sendMsg("rtmp streaming failed")
                    runOnUiThread {
                        mIvRtmp!!.clearColorFilter()
                        mIvRtmp!!.tag = false
                    }
                }
            }
        }

        override fun onTranscodingUpdated() {
            super.onTranscodingUpdated()
        }

        override fun onUserJoined(uid: Int, elapsed: Int) {
            super.onUserJoined(uid, elapsed)
            sendMsg("-->onUserJoined<--$uid")
            runOnUiThread {
                val mUI = UserInfo()
                mUI.view = RtcEngine.CreateRendererView(this@VideoActivity)
                mUI.uid = uid
                mUI.view!!.setZOrderOnTop(true)
                mUserInfo[uid] = mUI
                mSmallAdapter!!.update(getSmallVideoUser(mUserInfo, mBigUserId))
                mRtcEngine!!.setupRemoteVideo(VideoCanvas(mUI.view, Constants.RENDER_MODE_HIDDEN, uid))
                setTranscoding()
            }
        }

        override fun onUserOffline(uid: Int, reason: Int) {
            super.onUserOffline(uid, reason)
            sendMsg("-->unPublishedByHost<--$uid")
            runOnUiThread {
                mUserInfo.remove(uid)
                mSmallAdapter!!.update(getSmallVideoUser(mUserInfo, mBigUserId))

                setTranscoding()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_video)

        val i = intent
        mChannelName = i.getStringExtra("CHANNEL")
        mPublishUrl = i.getStringExtra("URL")

        init()
        initEngine()
    }

    private fun init() {
        mSelfView = findViewById(R.id.self_container)

        mSmallView = findViewById(R.id.video_view_list)
        mSmallView!!.setHasFixedSize(true)
        val glm = GridLayoutManager(this, 3)
        mSmallAdapter = SmallAdapter(this, getSmallVideoUser(mUserInfo, mBigUserId))
        mSmallView!!.layoutManager = glm
        mSmallView!!.adapter = mSmallAdapter

        mTvRoomName = findViewById(R.id.tv_room_name)
        mTvRoomName!!.text = mChannelName

        mIvRtmp = findViewById(R.id.iv_push_rtmp)

        initMessage()
    }

    private fun initEngine() {
        try {
            mRtcEngine = RtcEngine.create(applicationContext, resources.getString(R.string.agora_app_id), mRtcEngineEventHandler)

            mRtcEngine!!.setChannelProfile(Constants.CHANNEL_PROFILE_LIVE_BROADCASTING)
            mRtcEngine!!.setClientRole(Constants.CLIENT_ROLE_BROADCASTER)

            mRtcEngine!!.enableVideo()

//          mRtcEngine.setVideoProfile(Constants.VIDEO_PROFILE_480P, true); // Replaced by setVideoEncoderConfiguration in Agora RTC SDK after 2.3.0+
            mRtcEngine!!.setVideoEncoderConfiguration(VideoEncoderConfiguration(VideoEncoderConfiguration.VD_640x480, VideoEncoderConfiguration.FRAME_RATE.FRAME_RATE_FPS_15, VideoEncoderConfiguration.STANDARD_BITRATE, VideoEncoderConfiguration.ORIENTATION_MODE.ORIENTATION_MODE_FIXED_PORTRAIT))

            mRtcEngine!!.joinChannel(null, mChannelName, "", mBigUserId)

            mBigView = RtcEngine.CreateRendererView(this@VideoActivity)
            if (mSelfView!!.childCount > 0)
                mSelfView!!.removeAllViews()
            mBigView!!.layoutParams = LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.MATCH_PARENT)
            mBigView!!.setZOrderMediaOverlay(false)
            mBigView!!.setZOrderOnTop(false)
            mSelfView!!.addView(mBigView)

            mRtcEngine!!.setupLocalVideo(VideoCanvas(mBigView, Constants.RENDER_MODE_HIDDEN, mBigUserId))

            initTranscoding(480, 640, 1800)
            setTranscoding()
        } catch (e: Exception) {
            e.printStackTrace()
        }

    }

    private fun initMessage() {
        mMsgList = ArrayList()
        val msgRecycle = findViewById<RecyclerView>(R.id.msg_list)

        mMessageAdapter = MessageAdapter(this, mMsgList!!)
        mMessageAdapter!!.setHasStableIds(true)

        msgRecycle.adapter = mMessageAdapter
        msgRecycle.layoutManager = LinearLayoutManager(this, RecyclerView.VERTICAL, false)
        msgRecycle.addItemDecoration(MessageItemDecoration())
    }

    private fun initTranscoding(width: Int, height: Int, bitrate: Int) {
        if (mLiveTranscoding == null) {
            mLiveTranscoding = LiveTranscoding()
            mLiveTranscoding!!.width = width
            mLiveTranscoding!!.height = height
            mLiveTranscoding!!.videoBitrate = bitrate
            // if you want high fps, modify videoFramerate
            mLiveTranscoding!!.videoFramerate = 15
        }
    }

    private fun sendMsg(msg: String) {
        runOnUiThread {
            mMsgList!!.add(msg)
            if (mMsgList!!.size > 20) {
                val remove = mMsgList!!.size - 20
                for (i in 0 until remove) {
                    mMsgList!!.removeAt(i)
                }
            }

            mMessageAdapter!!.notifyDataSetChanged()
        }
    }

    fun onSettingsClicked(v: View) {
        showTransCodingSettingDialog()
    }

    private fun showTransCodingSettingDialog() {
        val dialog = CustomTranscodingDialog(this, mLiveTranscoding!!)
        dialog.setOnUpdateTranscodingListener(object : CustomTranscodingDialog.OnUpdateTranscodingListener {
            override fun onUpdateTranscoding(customTranscoding: LiveTranscoding) {
                mLiveTranscoding = customTranscoding
                setTranscoding()
            }
        })
        dialog.showDialog()
    }

    private fun setTranscoding() {
        val transcodingUsers: ArrayList<LiveTranscoding.TranscodingUser>
        val videoUsers = getAllVideoUser(mUserInfo)

        transcodingUsers = cdnLayout(mBigUserId, videoUsers, mLiveTranscoding!!.width, mLiveTranscoding!!.height)

        mLiveTranscoding!!.users = transcodingUsers
        mRtcEngine!!.setLiveTranscoding(mLiveTranscoding)
    }

    fun onEndCallClicked(v: View) {
        onBackPressed()
    }

    fun onRtmpClicked(v: View) {
        if (v.tag == null) {
            v.tag = false
        }

        if (!(v.tag as Boolean)) {
            setTranscoding()
            mRtcEngine!!.addPublishStreamUrl(mPublishUrl, true)
            (v as ImageView).setColorFilter(resources.getColor(R.color.agora_blue), PorterDuff.Mode.MULTIPLY)
            v.setTag(true)
        } else {
            mRtcEngine!!.removePublishStreamUrl(mPublishUrl)
            (v as ImageView).clearColorFilter()
            v.setTag(false)
        }
    }

    override fun onBackPressed() {
        if (mRtcEngine != null) {
            mRtcEngine!!.removePublishStreamUrl(mPublishUrl)
            mRtcEngine!!.leaveChannel()
        }
        RtcEngine.destroy()
        mRtcEngine = null
        finish()
    }

    companion object {

        fun getSmallVideoUser(userInfo: Map<Int, UserInfo>, bigUserId: Int): ArrayList<UserInfo> {
            val users = ArrayList<UserInfo>()
            val iterator = userInfo.entries.iterator()
            while (iterator.hasNext()) {
                val entry = iterator.next()
                val user = entry.value
                if (user.uid == bigUserId) {
                    continue
                }
                users.add(user)
            }
            return users
        }

        fun getAllVideoUser(userInfo: Map<Int, UserInfo>): ArrayList<UserInfo> {
            val users = ArrayList<UserInfo>()
            val iterator = userInfo.entries.iterator()
            while (iterator.hasNext()) {
                val entry = iterator.next()
                val user = entry.value
                users.add(user)
            }
            return users
        }

        fun cdnLayout(bigUserId: Int, publishers: ArrayList<UserInfo>,
                      canvasWidth: Int,
                      canvasHeight: Int): ArrayList<LiveTranscoding.TranscodingUser> {

            val users: ArrayList<LiveTranscoding.TranscodingUser> = ArrayList(publishers.size)
            var index = 0
            var xIndex: Float
            var yIndex: Float
            val viewWidth: Int
            val viewHEdge: Int

            if (publishers.size <= 1)
                viewWidth = canvasWidth
            else
                viewWidth = canvasWidth / 2

            if (publishers.size <= 2)
                viewHEdge = canvasHeight
            else
                viewHEdge = canvasHeight / ((publishers.size - 1) / 2 + 1)

            val user0 = LiveTranscoding.TranscodingUser()
            user0.uid = bigUserId
            user0.alpha = 1f
            user0.zOrder = 0
            user0.audioChannel = 0

            user0.x = 0
            user0.y = 0
            user0.width = viewWidth
            user0.height = viewHEdge
            users.add(user0)

            index++
            for (entry in publishers) {
                if (entry.uid == bigUserId)
                    continue

                xIndex = (index % 2).toFloat()
                yIndex = (index / 2).toFloat()
                val tmpUser = LiveTranscoding.TranscodingUser()
                tmpUser.uid = entry.uid
                tmpUser.x = (xIndex * viewWidth).toInt()
                tmpUser.y = (viewHEdge * yIndex).toInt()
                tmpUser.width = viewWidth
                tmpUser.height = viewHEdge
                tmpUser.zOrder = index + 1
                tmpUser.audioChannel = 0
                tmpUser.alpha = 1f

                users.add(tmpUser)
                index++
            }

            return users
        }
    }
}
