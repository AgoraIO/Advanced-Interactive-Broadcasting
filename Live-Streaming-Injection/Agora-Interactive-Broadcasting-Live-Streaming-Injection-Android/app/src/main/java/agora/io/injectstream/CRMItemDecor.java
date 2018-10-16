package agora.io.injectstream;

import android.graphics.Rect;
import android.support.v7.widget.RecyclerView;
import android.view.View;

public class CRMItemDecor extends RecyclerView.ItemDecoration {
    @Override
    public void getItemOffsets(Rect outRect, View view, RecyclerView parent, RecyclerView.State state) {
        super.getItemOffsets(outRect, view, parent, state);

        int childCount = parent.getAdapter().getItemCount();
        if (parent.getChildAdapterPosition(view) == 1) {
            outRect.top = 16;
            outRect.bottom = 8;
            outRect.left = 9;
            outRect.right = 9;
        } else if (parent.getChildAdapterPosition(view) < childCount -1) {
            outRect.top = 8;
            outRect.bottom = 8;
            outRect.left = 9;
            outRect.right = 9;
        } else if (parent.getChildAdapterPosition(view) == childCount - 1) {
            outRect.top = 8;
            outRect.bottom = 16;
            outRect.left = 9;
            outRect.right = 9;
        }
    }
}
