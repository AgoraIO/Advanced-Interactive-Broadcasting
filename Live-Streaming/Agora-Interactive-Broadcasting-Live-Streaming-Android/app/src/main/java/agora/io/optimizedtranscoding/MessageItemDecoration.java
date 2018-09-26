package agora.io.optimizedtranscoding;

import android.graphics.Rect;
import android.support.v7.widget.RecyclerView;
import android.view.View;

/**
 * Created by wubingshuai on 28/02/2018.
 */

public class MessageItemDecoration extends RecyclerView.ItemDecoration {
    int divider = 16;
    int header = 3;
    int footer = 3;

    @Override
    public void getItemOffsets(Rect outRect, View view, RecyclerView parent, RecyclerView.State state) {
        super.getItemOffsets(outRect, view, parent, state);

        int itemCount = parent.getAdapter().getItemCount();
        int viewPosition = parent.getChildAdapterPosition(view);

        outRect.left = divider;
        outRect.right = divider;
        if (viewPosition == 0) {
            outRect.top = header;
            outRect.bottom = divider / 2;
        } else if (viewPosition == itemCount - 1) {
            outRect.top = divider / 2;
            outRect.bottom = footer;
        } else {
            outRect.top = divider / 2;
            outRect.bottom = divider / 2;
        }

    }
}
