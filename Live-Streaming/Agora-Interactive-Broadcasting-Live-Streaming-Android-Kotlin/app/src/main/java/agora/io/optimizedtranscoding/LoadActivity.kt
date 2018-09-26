package agora.io.optimizedtranscoding

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.text.TextUtils
import android.view.View
import android.widget.EditText
import android.widget.Toast

class LoadActivity : AppCompatActivity() {

    private var mChannelName: String? = null
    private var mPublishUrl: String? = null

    internal var etChannleName: EditText? = null
    internal var etUrl: EditText? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_load)

        etChannleName = findViewById(R.id.et_channel_name)
        etUrl = findViewById(R.id.et_publish_url)
    }

    fun onJoinClicked(v: View) {
        mChannelName = etChannleName!!.text.toString()
        mPublishUrl = etUrl!!.text.toString()

        if (TextUtils.isEmpty(mChannelName) || TextUtils.isEmpty(mPublishUrl)) {
            Toast.makeText(this, "please input a channel name and url", Toast.LENGTH_SHORT).show()
            return
        }

        forwardToMain()
    }

    private fun forwardToMain() {
        val i = Intent(this, MainActivity::class.java)
        i.putExtra("CHANNEL", mChannelName)
        i.putExtra("URL", mPublishUrl)

        startActivity(i)
    }
}
