package io.agora.interactivebroadcastingwithcdnstreaming;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import java.util.ArrayList;

public class MessageAdapter extends RecyclerView.Adapter<MessageAdapter.ViewHolder> {
    private Context mContext;
    private ArrayList<String> mMsg;

    public MessageAdapter(Context context, ArrayList<String> msgs) {
        this.mContext = context;
        this.mMsg = msgs;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(mContext).inflate(R.layout.msg_content, parent, false);
        return new ViewHolder(v);
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        String msg = mMsg.get(position);

        holder.tv.setBackgroundResource(R.drawable.msg_bubble_blue);
        holder.tv.setText(msg);
    }

    @Override
    public int getItemCount() {
        return mMsg.size();
    }

    @Override
    public long getItemId(int position) {
        return mMsg.get(position).hashCode();
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        TextView tv;

        public ViewHolder(View itemView) {
            super(itemView);
            tv = itemView.findViewById(R.id.tv_msg_content);
        }
    }
}
