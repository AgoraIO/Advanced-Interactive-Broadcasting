package io.agora.interactivebroadcastingwithcdnstreaming;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.util.DisplayMetrics;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.SurfaceView;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewManager;
import android.view.WindowManager;
import android.widget.FrameLayout;

import java.util.ArrayList;

public class SmallAdapter extends RecyclerView.Adapter<SmallAdapter.ViewHolder> {
    private Context mContext;
    private ArrayList<UserInfo> mUsers;

    public SmallAdapter(Context context, ArrayList<UserInfo> users) {
        this.mContext = context;
        if (mUsers == null)
            mUsers = new ArrayList<>();

        mUsers.clear();
        mUsers.addAll(users);
    }

    public void update(ArrayList<UserInfo> userInfo) {
        if (mUsers == null)
            mUsers = new ArrayList<>();

        mUsers.clear();
        mUsers.addAll(userInfo);
        notifyDataSetChanged();
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        ViewGroup mvg = (ViewGroup) LayoutInflater.from(mContext).inflate(R.layout.small_view, parent, false);
        ViewHolder holder = new ViewHolder(mvg);

        int size = getScreenWidth(mContext) / 3;
        int padding = dpToPx(mContext, 8);

        mvg.getLayoutParams().width = size;
        mvg.getLayoutParams().height = size * 4 / 3;
        mvg.setPadding(padding, padding, padding, padding);
        return holder;
    }

    public static int getScreenWidth(Context context) {
        DisplayMetrics metrics = new DisplayMetrics();
        WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        wm.getDefaultDisplay().getMetrics(metrics);
        return metrics.widthPixels;
    }

    public static int dpToPx(Context context, int dp) {
        DisplayMetrics displayMetrics = context.getResources().getDisplayMetrics();
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp, displayMetrics);
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        UserInfo user = mUsers.get(position);
        SurfaceView sv = user.view;
        if (sv.getParent() != null)
            ((ViewManager) sv.getParent()).removeView(sv);

        FrameLayout.LayoutParams lp = new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT);
        sv.setLayoutParams(lp);

        holder.root.addView(sv);
    }

    @Override
    public int getItemCount() {
        return mUsers.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        FrameLayout root;

        public ViewHolder(View itemView) {
            super(itemView);
            root = (FrameLayout) itemView;
            root.setLayoutParams(new RecyclerView.LayoutParams(RecyclerView.LayoutParams.MATCH_PARENT, RecyclerView.LayoutParams.MATCH_PARENT));
        }
    }
}
