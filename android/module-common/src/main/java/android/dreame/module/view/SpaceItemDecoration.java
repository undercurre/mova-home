package android.dreame.module.view;

import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.view.View;

import androidx.annotation.ColorInt;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

public class SpaceItemDecoration extends RecyclerView.ItemDecoration {

    private final int space; // 间隔大小
    private final int color; // 背景色
    private final Paint paint; // 画笔
    private final int orientation; // RecyclerView 方向

    public SpaceItemDecoration(int space, int orientation) {
        this(space, Color.TRANSPARENT, orientation);
    }

    public SpaceItemDecoration(int space, @ColorInt int color, int orientation) {
        this.space = space;
        this.color = color;
        this.orientation = orientation;
        this.paint = new Paint();
        this.paint.setColor(Color.TRANSPARENT);
        this.paint.setStyle(Paint.Style.FILL);
    }

    @Override
    public void getItemOffsets(@NonNull Rect outRect, @NonNull View view,
                               @NonNull RecyclerView parent, @NonNull RecyclerView.State state) {
        int position = parent.getChildAdapterPosition(view);

        // 只在 item 之间添加间隔，不在列表首项前添加
        if (position != 0) {
            if (orientation == RecyclerView.VERTICAL) {
                outRect.top = space;
            } else {
                outRect.left = space;
            }
        }
    }

    @Override
    public void onDraw(@NonNull Canvas canvas, @NonNull RecyclerView parent, @NonNull RecyclerView.State state) {
        int childCount = parent.getChildCount();

        for (int i = 0; i < childCount; i++) {
            View child = parent.getChildAt(i);

            RecyclerView.LayoutParams params = (RecyclerView.LayoutParams) child.getLayoutParams();

            if (orientation == RecyclerView.VERTICAL) {
                // 计算间隔区域
                int left = parent.getPaddingLeft();
                int right = parent.getWidth() - parent.getPaddingRight();
                int bottom = child.getTop() - params.topMargin;
                int top = bottom - space;

                // 画间隔背景
                if (i != 0) { // 跳过第一个
                    canvas.drawRect(left, top, right, bottom, paint);
                }
            } else {
                int top = parent.getPaddingTop();
                int bottom = parent.getHeight() - parent.getPaddingBottom();
                int right = child.getLeft() - params.leftMargin;
                int left = right - space;

                if (i != 0) { // 跳过第一个
                    canvas.drawRect(left, top, right, bottom, paint);
                }
            }
        }
    }
}
