package agora.io.optimizedtranscoding

import android.content.Context
import android.support.v7.widget.RecyclerView
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView

import java.util.ArrayList

/**
 * Created by wangdaoxin on 26/09/2018.
 */

class MessageAdapter(private val mContext: Context, private val mMsg: ArrayList<String>) : RecyclerView.Adapter<MessageAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val v = LayoutInflater.from(mContext).inflate(R.layout.msg_content, parent, false)
        return ViewHolder(v)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val msg = mMsg[position]

        holder.tv.setBackgroundResource(R.drawable.msg_bubble_blue)
        holder.tv.text = msg
    }

    override fun getItemCount(): Int {
        return mMsg.size
    }

    override fun getItemId(position: Int): Long {
        return mMsg[position].hashCode().toLong()
    }

    inner class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        internal var tv: TextView

        init {
            tv = itemView.findViewById(R.id.tv_msg_content)
        }
    }
}
