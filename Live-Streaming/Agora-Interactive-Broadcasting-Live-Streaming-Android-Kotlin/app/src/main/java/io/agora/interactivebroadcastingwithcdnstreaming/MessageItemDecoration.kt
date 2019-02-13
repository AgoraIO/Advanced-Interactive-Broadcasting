package io.agora.interactivebroadcastingwithcdnstreaming

import android.graphics.Rect
import android.support.v7.widget.RecyclerView
import android.view.View

class MessageItemDecoration : RecyclerView.ItemDecoration() {

    companion object {
        private const val DIVIDER = 16
        private const val HEADER = 3
        private const val FOOTER = 3
    }

    override fun getItemOffsets(outRect: Rect, view: View, parent: RecyclerView, state: RecyclerView.State) {
        super.getItemOffsets(outRect, view, parent, state)

        val itemCount = parent.adapter!!.itemCount
        val viewPosition = parent.getChildAdapterPosition(view)

        outRect.left = DIVIDER
        outRect.right = DIVIDER
        when (viewPosition) {
            0 -> {
                outRect.top = HEADER
                outRect.bottom = DIVIDER / 2
            }
            itemCount - 1 -> {
                outRect.top = DIVIDER / 2
                outRect.bottom = FOOTER
            }
            else -> {
                outRect.top = DIVIDER / 2
                outRect.bottom = DIVIDER / 2
            }
        }

    }
}
