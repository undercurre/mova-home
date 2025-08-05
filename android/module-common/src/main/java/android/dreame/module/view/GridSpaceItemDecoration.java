package android.dreame.module.view;

import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Rect;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

public class GridSpaceItemDecoration extends RecyclerView.ItemDecoration {

    private final int spanCount;
    private final int horizontalSpace;
    private final int verticalSpace;
    private final boolean includeEdge;
    private final int color;
    private final Paint paint;

    public GridSpaceItemDecoration(int spanCount, int horizontalSpace, int verticalSpace, boolean includeEdge, int color) {
        this.spanCount = spanCount;
        this.horizontalSpace = horizontalSpace;
        this.verticalSpace = verticalSpace;
        this.includeEdge = includeEdge;
        this.color = color;
        this.paint = new Paint();
        this.paint.setColor(color);
        this.paint.setStyle(Paint.Style.FILL);
    }

    private boolean isLayoutRTL(View view) {
        return view.getLayoutDirection() == View.LAYOUT_DIRECTION_RTL;
    }

    @Override
    public void getItemOffsets(@NonNull Rect outRect, @NonNull View view,
                               @NonNull RecyclerView parent, @NonNull RecyclerView.State state) {

        int position = parent.getChildAdapterPosition(view);
        int column = position % spanCount;
        boolean isRTL = isLayoutRTL(parent);

        if (includeEdge) {
            int leftSpace = horizontalSpace - column * horizontalSpace / spanCount;
            int rightSpace = (column + 1) * horizontalSpace / spanCount;

            if (isRTL) {
                outRect.right = leftSpace;
                outRect.left = rightSpace;
            } else {
                outRect.left = leftSpace;
                outRect.right = rightSpace;
            }

            if (position < spanCount) { // 第一行
                outRect.top = verticalSpace;
            }
            outRect.bottom = verticalSpace;

        } else {
            int leftSpace = column * horizontalSpace / spanCount;
            int rightSpace = horizontalSpace - (column + 1) * horizontalSpace / spanCount;

            if (isRTL) {
                outRect.right = leftSpace;
                outRect.left = rightSpace;
            } else {
                outRect.left = leftSpace;
                outRect.right = rightSpace;
            }

            if (position >= spanCount) {
                outRect.top = verticalSpace;
            }
        }
    }

    @Override
    public void onDraw(@NonNull Canvas canvas, @NonNull RecyclerView parent, @NonNull RecyclerView.State state) {

        int childCount = parent.getChildCount();

        for (int i = 0; i < childCount; i++) {
            View child = parent.getChildAt(i);
            RecyclerView.LayoutParams params = (RecyclerView.LayoutParams) child.getLayoutParams();
            boolean isRTL = isLayoutRTL(child);

            int left = child.getLeft() - params.leftMargin;
            int right = child.getRight() + params.rightMargin;
            int top = child.getTop() - params.topMargin;
            int bottom = child.getBottom() + params.bottomMargin;

            if (includeEdge) {
                // 顶部间距
                if (top - verticalSpace >= 0) {
                    canvas.drawRect(left, top - verticalSpace, right, top, paint);
                }

                if (isRTL) {
                    // 右侧间距 (在视觉上是 start)
                    if (right + horizontalSpace <= parent.getWidth()) {
                        canvas.drawRect(right, top - verticalSpace, right + horizontalSpace, bottom + verticalSpace, paint);
                    }
                    // 左侧间距 (在视觉上是 end)
                    if (left - horizontalSpace >= 0) {
                        canvas.drawRect(left - horizontalSpace, top - verticalSpace, left, bottom + verticalSpace, paint);
                    }
                } else {
                    // 左侧间距
                    if (left - horizontalSpace >= 0) {
                        canvas.drawRect(left - horizontalSpace, top - verticalSpace, left, bottom + verticalSpace, paint);
                    }
                    // 右侧间距
                    if (right + horizontalSpace <= parent.getWidth()) {
                        canvas.drawRect(right, top - verticalSpace, right + horizontalSpace, bottom + verticalSpace, paint);
                    }
                }

                // 底部间距
                canvas.drawRect(left, bottom, right, bottom + verticalSpace, paint);

            } else {
                // 顶部间距
                if (top - verticalSpace >= 0) {
                    canvas.drawRect(left, top - verticalSpace, right, top, paint);
                }

                if (isRTL) {
                    // 右侧间距 (视觉上 start)
                    canvas.drawRect(right, top, right + horizontalSpace, bottom, paint);
                } else {
                    // 右侧间距
                    canvas.drawRect(right, top, right + horizontalSpace, bottom, paint);
                }
            }
        }
    }
}



