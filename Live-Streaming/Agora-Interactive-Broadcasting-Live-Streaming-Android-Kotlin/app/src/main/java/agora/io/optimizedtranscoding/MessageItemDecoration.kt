package agora.io.optimizedtranscoding

import android.graphics.Rect
import android.support.v7.widget.RecyclerView
import android.view.View

/**
 * Created by wangdaoxin on 26/09/2018.
 */

class MessageItemDecoration : RecyclerView.ItemDecoration() {
    internal var divider = 16
    internal var header = 3
    internal var footer = 3

    override fun getItemOffsets(outRect: Rect, view: View, parent: RecyclerView, state: RecyclerView.State?) {
        super.getItemOffsets(outRect, view, parent, state)

        val itemCount = parent.adapter.itemCount
        val viewPosition = parent.getChildAdapterPosition(view)

        outRect.left = divider
        outRect.right = divider
        if (viewPosition == 0) {
            outRect.top = header
            outRect.bottom = divider / 2
        } else if (viewPosition == itemCount - 1) {
            outRect.top = divider / 2
            outRect.bottom = footer
        } else {
            outRect.top = divider / 2
            outRect.bottom = divider / 2
        }

    }
}
