package android.dreame.module.view;

import android.graphics.Rect;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.chad.library.adapter.base.BaseQuickAdapter;

/**
 * @author edy
 */
public class SpaceDecoration extends RecyclerView.ItemDecoration {
    private int spaceSize;

    public SpaceDecoration(int spaceSize) {
        this.spaceSize = spaceSize;
    }

    @Override
    public void getItemOffsets(@NonNull Rect outRect, @NonNull View view, @NonNull RecyclerView parent, @NonNull RecyclerView.State state) {
        super.getItemOffsets(outRect, view, parent, state);
        RecyclerView.LayoutManager layoutManager = parent.getLayoutManager();
        RecyclerView.Adapter adapter = parent.getAdapter();
        if (adapter instanceof BaseQuickAdapter) {
            if (layoutManager instanceof GridLayoutManager) {
                GridLayoutManager.LayoutParams params = (GridLayoutManager.LayoutParams) view.getLayoutParams();
                if (params.getViewLayoutPosition() < ((BaseQuickAdapter<?, ?>) adapter).getFooterViewPosition()) {
                    if (view.getContext().getResources().getConfiguration().getLayoutDirection() == View.LAYOUT_DIRECTION_LTR) {
                        if (params.getSpanIndex() % 2 == 0) {
                            outRect.right = spaceSize / 2;
                        } else {
                            outRect.left = spaceSize / 2;
                        }
                    } else {
                        if (params.getSpanIndex() % 2 == 0) {
                            outRect.left = spaceSize / 2;
                        } else {
                            outRect.right = spaceSize / 2;
                        }
                    }
                }
            }
        }
    }
}