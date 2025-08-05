package android.dreame.module.view;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.res.TypedArray;
import android.dreame.module.R;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.RectF;
import android.os.Handler;
import android.os.Message;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Timer;
import java.util.TimerTask;

public class CircleProgressButton extends View implements View.OnTouchListener {

    private int processSec = 5;
    private float processStep;

    private OnProgressCallback callback;
    private Paint innerPaint, outerPaint, progressPaint;
    private int innerBgColor, outerBgColor, progressBgColor;
    private boolean enableTake;
    private RectF rectF;
    private Timer tr;
    private final long REFLASH_TIEM = 50L;

    private float cWidth = 0f;
    private float cHeight = 0f;
    private float arc = 0f;
    private boolean starting = false;
    private boolean showBigButton = false;
    private float bigFactor = 0.8f;

    private float maxPro = 10000f;
    private float curPro = 0f;

    private boolean isPress = false;
    private boolean isTake = false;
    private long TAKE_INTERVAL = 200;


    @SuppressLint("HandlerLeak")
    private Handler mHandler = new Handler() {
        @Override
        public void handleMessage(@NonNull Message msg) {
            super.handleMessage(msg);
            postInvalidate();
        }
    };

    private Runnable launchRunnable =  new Runnable() {
        @Override
        public void run() {
            if (isPress) {
                //拍摄开始启动
                isTake = false;
                start();
            }
        }
    };


    public CircleProgressButton(Context context) {
        this(context, null);
    }

    public CircleProgressButton(Context context, @Nullable AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public CircleProgressButton(Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        TypedArray ta = context.obtainStyledAttributes(attrs, R.styleable.CircleProgressButton);
        innerBgColor = ta.getColor(R.styleable.CircleProgressButton_inner_background_color, Color.parseColor("#FFFFFF"));
        outerBgColor = ta.getColor(R.styleable.CircleProgressButton_outer_background_color, Color.parseColor("#DDDDDD"));
        progressBgColor = ta.getColor(R.styleable.CircleProgressButton_progress_color, Color.parseColor("#3ec88e"));
        enableTake = ta.getBoolean(R.styleable.CircleProgressButton_enable_take, false);
        ta.recycle();
        init();
        processStep = maxPro / (processSec * 1000 / REFLASH_TIEM);
    }

    private void init() {
        innerPaint = new Paint();
        innerPaint.setAntiAlias(true);
        innerPaint.setColor(innerBgColor);

        outerPaint = new Paint();
        outerPaint.setAntiAlias(true);
        outerPaint.setColor(outerBgColor);

        progressPaint = new Paint();
        progressPaint.setAntiAlias(true);
        progressPaint.setStyle(Paint.Style.STROKE);
        progressPaint.setColor(progressBgColor);

        rectF = new RectF();
        setOnTouchListener(this);
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        cWidth = getWidth();
        cHeight = getHeight();
        if (cWidth != cHeight) {
            cWidth = Math.min(cWidth, cHeight);
            cHeight = Math.min(cWidth, cHeight);
        }
        arc = cWidth / 14f;
        progressPaint.setStrokeWidth(arc);
        if (starting) {
            if (!showBigButton) {
                //缓慢放大
                bigFactor += 0.025f;
                if (bigFactor >= 0.99f) {
                    bigFactor = 1f;
                }
                canvas.drawCircle((cWidth / 2), (cHeight / 2), (cWidth / 2) * bigFactor, outerPaint);
                canvas.drawCircle((cWidth / 2), (cHeight / 2), (float) ((cWidth / 2) * (1.40 - bigFactor)), innerPaint);
                if (bigFactor >= 0.99f) {
                    //放大完毕
                    showBigButton = true;
                    postInvalidate();
                    //通知调用者 开始
                    if (callback != null) {
                        callback.onStartRecord();
                    }
                } else {
                    mHandler.sendEmptyMessageDelayed(0, 10);
                }
            } else {
                //开始绘制进度
                canvas.drawCircle((cWidth / 2), (cHeight / 2), (cWidth / 2) * bigFactor, outerPaint);
                canvas.drawCircle((cWidth / 2), (cHeight / 2), (float) ((cWidth / 2) * (1.40 - bigFactor)), innerPaint);
                if (curPro < maxPro) {
                    rectF.left = 0f + arc / 2;
                    rectF.top = 0f + arc / 2;
                    rectF.right = cWidth - arc / 2;
                    rectF.bottom = cWidth - arc / 2;
                    canvas.drawArc(rectF, -90f, curPro / maxPro * 360, false, progressPaint);
                    curPro += processStep;
                } else {
                    //通知调用者 结束
                    if (callback != null) {
                        callback.progressFinish();
                    }
                    stop();
                    return;
                }
                if (tr == null) {
                    //定时绘制
                    tr = new Timer();
                    tr.schedule(new TimerTask() {
                        @Override
                        public void run() {
                            postInvalidate();
                        }
                    }, 0L, REFLASH_TIEM);
                }
            }

        } else {
            if (showBigButton) {
                bigFactor -= 0.025f;
                if (bigFactor <= 0.81f) {
                    bigFactor = 0.8f;
                }
                canvas.drawCircle((cWidth / 2), (cHeight / 2), (cWidth / 2) * bigFactor, outerPaint);
                canvas.drawCircle((cWidth / 2), (cHeight / 2), ((cWidth / 2) * 0.75f * (1.55f - bigFactor)), innerPaint);
                if (bigFactor <= 0.81f) {
                    //还原完毕
                    showBigButton = false;
                } else {
                    mHandler.sendEmptyMessageDelayed(0, 10);
                }
            } else {
                canvas.drawCircle((cWidth / 2), (cHeight / 2), (cWidth / 2) * bigFactor, outerPaint);
                canvas.drawCircle((cWidth / 2), (cHeight / 2), (cWidth / 2) * 0.75f * bigFactor, innerPaint);
                showBigButton = false;
            }
        }

    }

    public void start() {
        starting = true;
        postInvalidate();
    }

    public void stop() {
        starting = false;
        curPro = 0f;
        tr.cancel();
        tr = null;
        mHandler.removeMessages(0);
        mHandler.removeCallbacks(launchRunnable);
        postInvalidate();
        if(callback != null){
            callback.onStopRecord();
        }
    }

    public void setCallback(OnProgressCallback callback) {
        this.callback = callback;
    }

    @Override
    public boolean onTouch(View v, MotionEvent event) {
        switch (event.getAction()) {
            case MotionEvent.ACTION_DOWN:
                isPress = true;
                isTake = true;
                mHandler.postDelayed(launchRunnable, TAKE_INTERVAL);
                break;

            case MotionEvent.ACTION_MOVE:
                break;
            case MotionEvent.ACTION_CANCEL:
            case MotionEvent.ACTION_UP:
                if(isPress){
                    isPress = false;
                    mHandler.removeCallbacks(launchRunnable);
                    if(!starting){
                        if(isTake  && enableTake){
                            if(callback != null){
                                callback.onTake();
                            }
                        }
                    }else{
                        stop();
                    }
                }
        }
        return true;
    }

    public interface OnProgressCallback {
        void onStopRecord();

        void onTake();

        void onStartRecord();

        void progressFinish();
    }

    public void setProcessSec(int processSec) {
        this.processSec = processSec;
        processStep = maxPro / (processSec * 1000 / REFLASH_TIEM);
    }

    public void enableTake(boolean enable){
        this.enableTake = enable;
    }
}
