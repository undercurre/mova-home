package android.dreame.module.view;

import android.content.Context;
import android.dreame.module.util.DisplayUtil;
import android.util.AttributeSet;
import android.util.Log;
import android.view.MotionEvent;

import androidx.annotation.Nullable;
import androidx.appcompat.widget.AppCompatTextView;


public class ReloadJsButton extends AppCompatTextView {
    private float downX;
    private float downY;
    private float lastX;
    private float lastY;
    private Context mContext;
    private OnClickListener mOnClickListener;
    private static final String TAG = ReloadJsButton.class.getSimpleName();

    public ReloadJsButton(Context context) {
        this(context, null);
    }

    public ReloadJsButton(Context context, @Nullable AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public ReloadJsButton(Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        mContext = context;
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        Log.e(TAG, "onTouch: " + event);

        switch (event.getAction()) {
            case MotionEvent.ACTION_DOWN:
                //按下位置
                downX = event.getRawX();
                downY = event.getRawY();
                lastX = event.getRawX();
                lastY = event.getRawY();
                break;
            case MotionEvent.ACTION_MOVE:

                float moveX = event.getRawX();
                float moveY = event.getRawY();

                float dx = moveX - lastX;
                float dy = moveY - lastY;

                float tX = getTranslationX() + dx;
                float tY = getTranslationY() + dy;

                Log.e(TAG, "onTouch: " + ((tX + getLeft())) + "," + (tY + getTop()));

                if ((tX + getLeft()) >= 0 && (tX + getLeft() + getWidth())
                        <= DisplayUtil.getScreenWidth(mContext)
                ) {
                    setTranslationX(tX);
                }

                if ((tY + getTop()) >= 0 && (tY + getTop() + getHeight())
                        <= DisplayUtil.getScreenHeight(mContext)
                ) {
                    setTranslationY(tY);
                }

                // 下一次按下位置
                lastX = event.getRawX();
                lastY = event.getRawY();
                break;

            case MotionEvent.ACTION_UP:

                //当手指按下的位置和手指抬起来的位置距离小于5像素时,将此次触摸归结为点击事件,
                if (Math.abs(event.getRawX() - downX) < 5 && Math.abs(event.getRawY() - downY) < 5) {
                    Log.e(TAG, "onTouch: ");
                    if (mOnClickListener != null) {
                        mOnClickListener.onClick();
                    }
                }

                break;
        }

        return true;
    }

    public OnClickListener getOnClickListener() {
        return mOnClickListener;
    }

    public void setOnClickListener(OnClickListener onClickListener) {
        mOnClickListener = onClickListener;
    }

    public interface OnClickListener {
        void onClick();
    }

}
