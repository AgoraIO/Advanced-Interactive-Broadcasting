package io.agora.interactivebroadcastingwithcdnstreaming

import android.Manifest
import android.annotation.TargetApi
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.support.v4.content.ContextCompat
import android.support.v4.content.PermissionChecker
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.text.TextUtils
import android.view.View
import android.widget.EditText
import android.widget.Toast

class MainActivity : AppCompatActivity() {

    private var mChannelName: String? = null
    private var mPublishUrl: String? = null

    private var etChannelName: EditText? = null
    private var etUrl: EditText? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        etChannelName = findViewById(R.id.et_channel_name)
        etUrl = findViewById(R.id.et_publish_url)
    }

    fun onJoinClicked(v: View) {
        mChannelName = etChannelName!!.text.toString()
        mPublishUrl = etUrl!!.text.toString()

        if (TextUtils.isEmpty(mChannelName) || TextUtils.isEmpty(mPublishUrl)) {
            Toast.makeText(this, "please input a channel name and url", Toast.LENGTH_SHORT).show()
            return
        }

        if (checkSelfPermissions()) {
            forwardToMain()
        }
    }

    @TargetApi(Build.VERSION_CODES.M)
    private fun askPermission() {
        requestPermissions(arrayOf(Manifest.permission.CAMERA, Manifest.permission.RECORD_AUDIO, Manifest.permission.WRITE_EXTERNAL_STORAGE),
                PERMISSION_REQ_ID)
    }

    private fun checkSelfPermissions(): Boolean {
        return checkSelfPermission(Manifest.permission.RECORD_AUDIO, PERMISSION_REQ_ID) &&
                checkSelfPermission(Manifest.permission.CAMERA, PERMISSION_REQ_ID) &&
                checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE, PERMISSION_REQ_ID)
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == PERMISSION_REQ_ID) {
            for (g in grantResults) {
                if (g != PermissionChecker.PERMISSION_GRANTED) {
                    return
                }
            }
        }
    }

    private fun checkSelfPermission(permission: String, requestCode: Int): Boolean {
        if (ContextCompat.checkSelfPermission(this,
                        permission) != PackageManager.PERMISSION_GRANTED) {

            askPermission()
            return false
        }
        return true
    }

    private fun forwardToMain() {
        val i = Intent(this, VideoActivity::class.java)
        i.putExtra("CHANNEL", mChannelName)
        i.putExtra("URL", mPublishUrl)

        startActivity(i)
    }

    companion object {

        private const val PERMISSION_REQ_ID = 1024
    }
}
