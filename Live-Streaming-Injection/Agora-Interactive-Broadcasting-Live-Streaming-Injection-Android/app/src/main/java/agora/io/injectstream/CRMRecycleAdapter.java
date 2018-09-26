package agora.io.injectstream;

import android.content.Context;
import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import java.lang.ref.WeakReference;
import java.util.List;

public class CRMRecycleAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder>{
    private List<String> mDataSet;
    private Context mCtx;

    public CRMRecycleAdapter(WeakReference<Context> ctx, List<String> data) {
        mCtx = ctx.get();
        mDataSet = data;

    }

    public void upDateDataSet(List<String> da) {
        if (da == null || da.isEmpty())
            return;

        mDataSet = da;
        notifyDataSetChanged();
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new MyHolder(LayoutInflater.from(mCtx).inflate(R.layout.chat_room_msg_item, parent, false));
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {
        ((MyHolder)holder).tv.setText(mDataSet.get(position));
    }

    @Override
    public int getItemCount() {
        return mDataSet.size();
    }

    public class MyHolder extends RecyclerView.ViewHolder{
        private TextView tv;
        public MyHolder(View itemView) {
            super(itemView);

            tv = itemView.findViewById(R.id.tv_chat_room_message_bubble);
        }
    }
}
