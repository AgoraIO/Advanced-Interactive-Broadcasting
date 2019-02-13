package io.agora.interactivebroadcastingwithcdnstreaming;

import android.graphics.Rect;
import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.View;

public class MessageItemDecoration extends RecyclerView.ItemDecoration {
    private static final int DIVIDER = 16;
    private static final int HEADER = 3;
    private static final int FOOTER = 3;

    @Override
    public void getItemOffsets(@NonNull Rect outRect, @NonNull View view, @NonNull RecyclerView parent, @NonNull RecyclerView.State state) {
        super.getItemOffsets(outRect, view, parent, state);

        int itemCount = parent.getAdapter().getItemCount();
        int viewPosition = parent.getChildAdapterPosition(view);

        outRect.left = DIVIDER;
        outRect.right = DIVIDER;
        if (viewPosition == 0) {
            outRect.top = HEADER;
            outRect.bottom = DIVIDER / 2;
        } else if (viewPosition == itemCount - 1) {
            outRect.top = DIVIDER / 2;
            outRect.bottom = FOOTER;
        } else {
            outRect.top = DIVIDER / 2;
            outRect.bottom = DIVIDER / 2;
        }

    }
}
