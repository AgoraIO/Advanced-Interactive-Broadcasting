package agora.io.optimizedtranscoding

import android.content.Context
import android.support.v7.widget.RecyclerView
import android.util.DisplayMetrics
import android.util.TypedValue
import android.view.*
import android.widget.FrameLayout

class SmallAdapter(private val mContext: Context, users: ArrayList<UserInfo>) : RecyclerView.Adapter<SmallAdapter.ViewHolder>() {
    private var mUsers: ArrayList<UserInfo>? = null

    init {
        if (mUsers == null)
            mUsers = ArrayList()

        mUsers!!.clear()
        mUsers!!.addAll(users)
    }

    fun update(userInfo: ArrayList<UserInfo>) {
        if (mUsers == null)
            mUsers = ArrayList()

        mUsers!!.clear()
        mUsers!!.addAll(userInfo)
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val mvg = LayoutInflater.from(mContext).inflate(R.layout.small_view, parent, false) as ViewGroup
        val holder = ViewHolder(mvg)

        val size = getScreenWidth(mContext) / 3
        val padding = dpToPx(mContext, 8)

        mvg.layoutParams.width = size
        mvg.layoutParams.height = size * 4 / 3
        mvg.setPadding(padding, padding, padding, padding)
        return holder
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val user = mUsers!![position]
        val sv = user.view
        if (sv!!.parent != null)
            (sv!!.parent as ViewManager).removeView(sv)

        val lp = FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT)
        sv.layoutParams = lp

        holder.root.addView(sv)
    }

    override fun getItemCount(): Int {
        return mUsers!!.size
    }

    inner class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        internal var root: FrameLayout

        init {
            root = itemView as FrameLayout
            root.layoutParams = RecyclerView.LayoutParams(RecyclerView.LayoutParams.MATCH_PARENT, RecyclerView.LayoutParams.MATCH_PARENT)
        }
    }

    companion object {

        fun getScreenWidth(context: Context): Int {
            val metrics = DisplayMetrics()
            val wm = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
            wm.defaultDisplay.getMetrics(metrics)
            return metrics.widthPixels
        }

        fun dpToPx(context: Context, dp: Int): Int {
            val displayMetrics = context.resources.displayMetrics
            return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp.toFloat(), displayMetrics).toInt()
        }
    }
}
