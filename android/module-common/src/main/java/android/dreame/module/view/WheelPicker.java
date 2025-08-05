package android.dreame.module.view;

import android.content.Context;
import android.content.res.TypedArray;
import android.dreame.module.R;
import android.graphics.Camera;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.Typeface;
import android.os.Build;
import android.os.Handler;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.util.Log;
import android.view.MotionEvent;
import android.view.VelocityTracker;
import android.view.View;
import android.view.ViewConfiguration;
import android.widget.Scroller;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.events.RCTEventEmitter;

import java.util.Arrays;
import java.util.List;

/**
 * 滚轮选择器
 * <p>
 * WheelPicker
 *
 * @author AigeStudio 2015-12-12
 * @author AigeStudio 2016-06-17
 * 更新项目结构
 * <p>
 * New project structure
 * @version 1.1.0
 */
public class WheelPicker extends View implements Runnable {
    /**
     * 滚动状态标识值
     *
     * @see OnWheelChangeListener#onWheelScrollStateChanged(int)
     */
    public static final int SCROLL_STATE_IDLE = 0, SCROLL_STATE_DRAGGING = 1,
            SCROLL_STATE_SCROLLING = 2;

    /**
     * 数据项对齐方式标识值
     *
     * @see #setItemAlign(int)
     */
    public static final int ALIGN_CENTER = 0, ALIGN_LEFT = 1, ALIGN_RIGHT = 2;

    private static final String TAG = WheelPicker.class.getSimpleName();

    private final Handler mHandler = new Handler();

    private Paint mPaint;
    private Scroller mScroller;
    private VelocityTracker mTracker;
    /**
     * Determines whether the current scrolling animation is triggered by touchEvent or setSelectedItemPosition.
     * User added eventListeners will only be fired after touchEvents.
     */
    private boolean isTouchTriggered;

    /**
     * 相关监听器
     *
     * @see OnWheelChangeListener,OnItemSelectedListener
     */
    private OnItemSelectedListener mOnItemSelectedListener;
    private OnWheelChangeListener mOnWheelChangeListener;

    private Rect mRectDrawn;
    private Rect mRectIndicatorHead, mRectIndicatorFoot;
    private Rect mRectCurrentItem;

    private Camera mCamera;
    private Matrix mMatrixRotate, mMatrixDepth;

    /**
     * 数据源
     */
    private List mData;

    /**
     * 最宽的文本
     *
     * @see #setMaximumWidthText(String)
     */
    private String mMaxWidthText;

    /**
     * 滚轮选择器中可见的数据项数量和滚轮选择器将会绘制的数据项数量
     *
     * @see #setVisibleItemCount(int)
     */
    private int mVisibleItemCount, mDrawnItemCount;

    /**
     * 滚轮选择器将会绘制的Item数量的一半
     */
    private int mHalfDrawnItemCount;

    /**
     * 单个文本最大宽高
     */
    private int mTextMaxWidth, mTextMaxHeight;

    /**
     * 数据项文本颜色以及被选中的数据项文本颜色
     *
     * @see #setItemTextColor(int)
     * @see #setSelectedItemTextColor(int)
     */
    private int mItemTextColor, mSelectedItemTextColor;

    /**
     * 被选中的数据项背景颜色
     *
     * @see #setSelectedItemBgColor(int)
     */
    private int mSelectedItemBgColor;

    /**
     * 数据项文本尺寸
     *
     * @see #setItemTextSize(int)
     * @see #setSelectedItemTextSize(int)
     */
    private int mItemTextSize, mSelectedItemTextSize;

    /**
     * 单位，默认为空，即不显示单位
     *
     * @see #setUnitText(String)
     */
    private String mUnitText;

    /**
     * 单位字体大小
     *
     * @see #setUnitTextSize(int)
     */
    private int mUnitTextSize;

    /**
     * 单位字体颜色
     *
     * @see #setUnitTextColor(int)
     */
    private int mUnitTextColor;

    /**
     * 单位与文字的间隔
     *
     * @see #setUnitTextSpace(int)
     */
    private int mUnitTextSpace;

    /**
     * 单位Y轴偏移
     *
     * @see #setUnitOffsetY(int)
     */
    private int mUnitOffsetY;

    /**
     * 指示器尺寸
     *
     * @see #setIndicatorSize(int)
     */
    private int mIndicatorSize;

    /**
     * 指示器颜色
     *
     * @see #setIndicatorColor(int)
     */
    private int mIndicatorColor;

    /**
     * 幕布颜色
     *
     * @see #setCurtainColor(int)
     */
    private int mCurtainColor;

    /**
     * 数据项之间间距
     *
     * @see #setItemSpace(int)
     */
    private int mItemSpace;

    /**
     * 数据项对齐方式
     *
     * @see #setItemAlign(int)
     */
    private int mItemAlign;

    /**
     * 滚轮选择器单个数据项高度以及单个数据项一半的高度
     */
    private int mItemHeight, mHalfItemHeight;

    /**
     * 滚轮选择器内容区域高度的一半
     */
    private int mHalfWheelHeight;

    /**
     * 当前被选中的数据项所显示的数据在数据源中的位置
     *
     * @see #setSelectedItemPosition(int)
     */
    private int mSelectedItemPosition;

    /**
     * 当前被选中的数据项所显示的数据在数据源中的位置
     *
     * @see #getCurrentItemPosition()
     */
    private int mCurrentItemPosition;

    /**
     * 滚轮滑动时可以滑动到的最小/最大的Y坐标
     */
    private int mMinFlingY, mMaxFlingY;

    /**
     * 滚轮滑动时的最小/最大速度
     */
    private int mMinimumVelocity = 50, mMaximumVelocity = 8000;

    /**
     * 滚轮选择器中心坐标
     */
    private int mWheelCenterX, mWheelCenterY;

    /**
     * 滚轮选择器绘制中心坐标
     */
    private int mDrawnCenterX, mDrawnCenterY, mSelectedItemDrawnCenterY, mUnitDrawnCenterY;

    /**
     * 滚轮选择器视图区域在Y轴方向上的偏移值
     */
    private int mScrollOffsetY;

    /**
     * 滚轮选择器中最宽或最高的文本在数据源中的位置
     */
    private int mTextMaxWidthPosition;

    /**
     * 用户手指上一次触摸事件发生时事件Y坐标
     */
    private int mLastPointY;

    /**
     * 手指触摸屏幕时事件点的Y坐标
     */
    private int mDownPointY;

    /**
     * 点击与触摸的切换阀值
     */
    private int mTouchSlop = 8;

    /**
     * 滚轮选择器的每一个数据项文本是否拥有相同的宽度
     *
     * @see #setSameWidth(boolean)
     */
    private boolean hasSameWidth;

    /**
     * 是否显示指示器
     *
     * @see #setIndicator(boolean)
     */
    private boolean hasIndicator;

    /**
     * 行高
     *
     * @see #setRowHeight(int)
     */
    private int mRowHeight;

    /**
     * 是否显示幕布
     *
     * @see #setCurtain(boolean)
     */
    private boolean hasCurtain;

    /**
     * 是否显示空气感效果
     *
     * @see #setAtmospheric(boolean)
     */
    private boolean hasAtmospheric;

    /**
     * 数据是否循环展示
     *
     * @see #setCyclic(boolean)
     */
    private boolean isCyclic;

    /**
     * 滚轮是否为卷曲效果
     *
     * @see #setCurved(boolean)
     */
    private boolean isCurved;

    /**
     * 是否为点击模式
     */
    private boolean isClick;

    /**
     * 是否为强制结束滑动
     */
    private boolean isForceFinishScroll;

    /**
     * Font typeface path from assets
     */
    private String fontPath;

    private boolean isDebug;

    private boolean isInScrolling = false;

    public WheelPicker(Context context) {
        this(context, null);
    }

    public WheelPicker(Context context, AttributeSet attrs) {
        super(context, attrs);

        TypedArray a = context.obtainStyledAttributes(attrs, R.styleable.WheelPicker);
        int idData = a.getResourceId(R.styleable.WheelPicker_wheel_data, 0);
        mData = Arrays.asList(getResources()
                .getStringArray(idData == 0 ? R.array.WheelArrayDefault : idData));
        mItemTextSize = a.getDimensionPixelSize(R.styleable.WheelPicker_wheel_item_text_size,
                getResources().getDimensionPixelSize(R.dimen.WheelItemTextSize));
        mSelectedItemTextSize = a.getDimensionPixelSize(R.styleable.WheelPicker_wheel_selected_item_text_size,
                getResources().getDimensionPixelSize(R.dimen.WheelSelectedItemTextSize));
        mVisibleItemCount = a.getInt(R.styleable.WheelPicker_wheel_visible_item_count, 7);
        mSelectedItemPosition = a.getInt(R.styleable.WheelPicker_wheel_selected_item_position, 0);
        hasSameWidth = a.getBoolean(R.styleable.WheelPicker_wheel_same_width, false);
        mTextMaxWidthPosition =
                a.getInt(R.styleable.WheelPicker_wheel_maximum_width_text_position, -1);
        mMaxWidthText = a.getString(R.styleable.WheelPicker_wheel_maximum_width_text);
        mUnitText = a.getString(R.styleable.WheelPicker_wheel_unit_text);
        mUnitTextSize = a.getDimensionPixelSize(R.styleable.WheelPicker_wheel_unit_text_size,
                getResources().getDimensionPixelSize(R.dimen.WheelUnitTextSize));
        mUnitTextSpace = a.getDimensionPixelSize(R.styleable.WheelPicker_wheel_unit_text_space,
                getResources().getDimensionPixelSize(R.dimen.WheelUnitTextSpace));
        mUnitOffsetY = a.getDimensionPixelSize(R.styleable.WheelPicker_wheel_unit_offset_Y,
                getResources().getDimensionPixelSize(R.dimen.WheelUnitOffsetY));
        mUnitTextColor = a.getColor(R.styleable.WheelPicker_wheel_unit_text_color, 0xFF121212);
        mSelectedItemTextColor = a.getColor
                (R.styleable.WheelPicker_wheel_selected_item_text_color, -1);
        mItemTextColor = a.getColor(R.styleable.WheelPicker_wheel_item_text_color, 0xFF888888);
        mSelectedItemBgColor = a.getColor(R.styleable.WheelPicker_wheel_selected_item_bg_color, -1);
        mItemSpace = a.getDimensionPixelSize(R.styleable.WheelPicker_wheel_item_space,
                getResources().getDimensionPixelSize(R.dimen.WheelItemSpace));
        isCyclic = a.getBoolean(R.styleable.WheelPicker_wheel_cyclic, false);
        hasIndicator = a.getBoolean(R.styleable.WheelPicker_wheel_indicator, false);
        mIndicatorColor = a.getColor(R.styleable.WheelPicker_wheel_indicator_color, 0xFFEE3333);
        mIndicatorSize = a.getDimensionPixelSize(R.styleable.WheelPicker_wheel_indicator_size,
                getResources().getDimensionPixelSize(R.dimen.WheelIndicatorSize));
        hasCurtain = a.getBoolean(R.styleable.WheelPicker_wheel_curtain, false);
        mCurtainColor = a.getColor(R.styleable.WheelPicker_wheel_curtain_color, 0x88FFFFFF);
        hasAtmospheric = a.getBoolean(R.styleable.WheelPicker_wheel_atmospheric, false);
        isCurved = a.getBoolean(R.styleable.WheelPicker_wheel_curved, true);
        mItemAlign = a.getInt(R.styleable.WheelPicker_wheel_item_align, ALIGN_CENTER);
        fontPath = a.getString(R.styleable.WheelPicker_wheel_font_path);
        a.recycle();

        // 可见数据项改变后更新与之相关的参数
        // Update relevant parameters when the count of visible item changed
        updateVisibleItemCount();

        mPaint = new Paint(Paint.ANTI_ALIAS_FLAG | Paint.DITHER_FLAG | Paint.LINEAR_TEXT_FLAG);
        mPaint.setTextSize(mItemTextSize);

        if (fontPath != null) {
            Typeface typeface = Typeface.createFromAsset(context.getAssets(), fontPath);
            setTypeface(typeface);
        }

        // 更新文本对齐方式
        // Update alignment of text
        updateItemTextAlign();

        // 计算文本尺寸
        // Correct sizes of text
        computeTextSize();

        mScroller = new Scroller(getContext());

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.DONUT) {
            ViewConfiguration conf = ViewConfiguration.get(getContext());
            mMinimumVelocity = conf.getScaledMinimumFlingVelocity();
            mMaximumVelocity = conf.getScaledMaximumFlingVelocity();
            mTouchSlop = conf.getScaledTouchSlop();
        }
        mRectDrawn = new Rect();

        mRectIndicatorHead = new Rect();
        mRectIndicatorFoot = new Rect();

        mRectCurrentItem = new Rect();

        mCamera = new Camera();

        mMatrixRotate = new Matrix();
        mMatrixDepth = new Matrix();
    }

    private void updateVisibleItemCount() {
        if (mVisibleItemCount < 2)
            throw new ArithmeticException("Wheel's visible item count can not be less than 2!");

        // 确保滚轮选择器可见数据项数量为奇数
        // Be sure count of visible item is odd number
        if (mVisibleItemCount % 2 == 0)
            mVisibleItemCount += 1;
        mDrawnItemCount = mVisibleItemCount + 2;
        mHalfDrawnItemCount = mDrawnItemCount / 2;
    }

    private void computeTextSize() {
        mTextMaxWidth = mTextMaxHeight = 0;
        mPaint.setTextSize(Math.max(mItemTextSize, mSelectedItemTextSize));
        if (hasSameWidth) {
            mTextMaxWidth = (int) mPaint.measureText(String.valueOf(mData.get(0)));
        } else if (isPosInRang(mTextMaxWidthPosition)) {
            mTextMaxWidth = (int) mPaint.measureText
                    (String.valueOf(mData.get(mTextMaxWidthPosition)));
        } else if (!TextUtils.isEmpty(mMaxWidthText)) {
            mTextMaxWidth = (int) mPaint.measureText(mMaxWidthText);
        } else {
            for (Object obj : mData) {
                String text = String.valueOf(obj);
                int width = (int) mPaint.measureText(text);
                mTextMaxWidth = Math.max(mTextMaxWidth, width);
            }
        }
        Paint.FontMetrics metrics = mPaint.getFontMetrics();
        mTextMaxHeight = (int) (metrics.bottom - metrics.top);
    }

    private void updateItemTextAlign() {
        switch (mItemAlign) {
            case ALIGN_LEFT:
                mPaint.setTextAlign(Paint.Align.LEFT);
                break;
            case ALIGN_RIGHT:
                mPaint.setTextAlign(Paint.Align.RIGHT);
                break;
            default:
                mPaint.setTextAlign(Paint.Align.CENTER);
                break;
        }
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        int modeWidth = MeasureSpec.getMode(widthMeasureSpec);
        int modeHeight = MeasureSpec.getMode(heightMeasureSpec);

        int sizeWidth = MeasureSpec.getSize(widthMeasureSpec);
        int sizeHeight = MeasureSpec.getSize(heightMeasureSpec);

        // 计算原始内容尺寸
        // Correct sizes of original content
        int resultWidth = mTextMaxWidth;
        int resultHeight = mTextMaxHeight * mVisibleItemCount + mItemSpace * (mVisibleItemCount - 1);

        // 如果开启弯曲效果则需要重新计算弯曲后的尺寸
        // Correct view sizes again if curved is enable
        if (isCurved) {
            resultHeight = (int) (2 * resultHeight / Math.PI);
        }
        if (isDebug)
            Log.i(TAG, "Wheel's content size is (" + resultWidth + ":" + resultHeight + ")");

        // 考虑内边距对尺寸的影响
        // Consideration padding influence the view sizes
        resultWidth += getPaddingStart() + getPaddingEnd();
        resultHeight += getPaddingTop() + getPaddingBottom();
        if (isDebug)
            Log.i(TAG, "Wheel's size is (" + resultWidth + ":" + resultHeight + ")");

        // 考虑父容器对尺寸的影响
        // Consideration sizes of parent can influence the view sizes
        resultWidth = measureSize(modeWidth, sizeWidth, resultWidth);
        resultHeight = measureSize(modeHeight, sizeHeight, resultHeight);

        setMeasuredDimension(resultWidth, resultHeight);
    }

    private int measureSize(int mode, int sizeExpect, int sizeActual) {
        int realSize;
        if (mode == MeasureSpec.EXACTLY) {
            realSize = sizeExpect;
        } else {
            realSize = sizeActual;
            if (mode == MeasureSpec.AT_MOST)
                realSize = Math.min(realSize, sizeExpect);
        }
        return realSize;
    }

    @Override
    protected void onSizeChanged(int w, int h, int oldW, int oldH) {
        // 设置内容区域
        // Set content region
        mRectDrawn.set(getPaddingStart(), getPaddingTop(), getWidth() - getPaddingEnd(),
                getHeight() - getPaddingBottom());
        if (isDebug)
            Log.i(TAG, "Wheel's drawn rect size is (" + mRectDrawn.width() + ":" +
                    mRectDrawn.height() + ") and location is (" + mRectDrawn.left + ":" +
                    mRectDrawn.top + ")");

        // 获取内容区域中心坐标
        // Get the center coordinates of content region
        mWheelCenterX = mRectDrawn.centerX();
        mWheelCenterY = mRectDrawn.centerY();

        // 计算数据项绘制中心
        // Correct item drawn center
        computeDrawnCenter();

        mHalfWheelHeight = mRectDrawn.height() / 2;

        mItemHeight = mRowHeight > 0 ? mRowHeight : mRectDrawn.height() / mVisibleItemCount;
        mHalfItemHeight = mItemHeight / 2;

        // 初始化滑动最大坐标
        // Initialize fling max Y-coordinates
        computeFlingLimitY();

        // 计算指示器绘制区域
        // Correct region of indicator
        computeIndicatorRect();

        // 计算当前选中的数据项区域
        // Correct region of current select item
        computeCurrentItemRect();
    }

    private void computeDrawnCenter() {
        switch (mItemAlign) {
            case ALIGN_LEFT:
                mDrawnCenterX = mRectDrawn.left;
                break;
            case ALIGN_RIGHT:
                mDrawnCenterX = mRectDrawn.right;
                break;
            default:
                mDrawnCenterX = mWheelCenterX;
                break;
        }

        mSelectedItemDrawnCenterY = computeDrawnCenterYByTextSize(mSelectedItemTextSize);
        mUnitDrawnCenterY = computeDrawnCenterYByTextSize(mUnitTextSize);
        mDrawnCenterY = computeDrawnCenterYByTextSize(mItemTextSize);
    }

    private int computeDrawnCenterYByTextSize(int textSize) {
        mPaint.setTextSize(textSize);
        return (int) (mWheelCenterY - ((mPaint.ascent() + mPaint.descent()) / 2));
    }

    private void computeFlingLimitY() {
        int currentItemOffset = mSelectedItemPosition * mItemHeight;
        mMinFlingY = isCyclic ? Integer.MIN_VALUE :
                -mItemHeight * (mData.size() - 1) + currentItemOffset;
        mMaxFlingY = isCyclic ? Integer.MAX_VALUE : currentItemOffset;
    }

    private void computeIndicatorRect() {
        if (!hasIndicator) return;
        int halfIndicatorSize = mIndicatorSize / 2;
        int indicatorHeadCenterY = mWheelCenterY + mHalfItemHeight;
        int indicatorFootCenterY = mWheelCenterY - mHalfItemHeight;
        mRectIndicatorHead.set(mRectDrawn.left, indicatorHeadCenterY - halfIndicatorSize,
                mRectDrawn.right, indicatorHeadCenterY + halfIndicatorSize);
        mRectIndicatorFoot.set(mRectDrawn.left, indicatorFootCenterY - halfIndicatorSize,
                mRectDrawn.right, indicatorFootCenterY + halfIndicatorSize);
    }

    private void computeCurrentItemRect() {
        if (!hasCurtain && mSelectedItemTextColor == -1) return;
        mRectCurrentItem.set(mRectDrawn.left, mWheelCenterY - mHalfItemHeight, mRectDrawn.right,
                mWheelCenterY + mHalfItemHeight);
    }

    @Override
    protected void onDraw(Canvas canvas) {
        if (null != mOnWheelChangeListener)
            mOnWheelChangeListener.onWheelScrolled(mScrollOffsetY);
        if (mData.isEmpty() || mItemHeight== 0)
            return;
        int drawnDataStartPos = -mScrollOffsetY / mItemHeight - mHalfDrawnItemCount;
        for (int drawnDataPos = drawnDataStartPos + mSelectedItemPosition,
             drawnOffsetPos = -mHalfDrawnItemCount;
             drawnDataPos < drawnDataStartPos + mSelectedItemPosition + mDrawnItemCount;
             drawnDataPos++, drawnOffsetPos++) {
            String data = "";
            boolean isSelected = (!isInScrolling && drawnDataPos == mCurrentItemPosition);
            int realDrawnCenterY = isSelected ? mSelectedItemDrawnCenterY : mDrawnCenterY;

            if (isCyclic) {
                int actualPos = drawnDataPos % mData.size();
                actualPos = actualPos < 0 ? (actualPos + mData.size()) : actualPos;
                data = String.valueOf(mData.get(actualPos));
            } else {
                if (isPosInRang(drawnDataPos))
                    data = String.valueOf(mData.get(drawnDataPos));
            }
            mPaint.setColor(mItemTextColor);
            mPaint.setStyle(Paint.Style.FILL);
            int mDrawnItemCenterY = realDrawnCenterY + (drawnOffsetPos * mItemHeight) +
                    mScrollOffsetY % mItemHeight;

            int distanceToCenter = 0;
            if (isCurved) {
                // 计算数据项绘制中心距离滚轮中心的距离比率
                // Correct ratio of item's drawn center to wheel center
                float ratio = (realDrawnCenterY - Math.abs(realDrawnCenterY - mDrawnItemCenterY) -
                        mRectDrawn.top) * 1.0F / (realDrawnCenterY - mRectDrawn.top);

                // 计算单位
                // Correct unit
                int unit = 0;
                if (mDrawnItemCenterY > realDrawnCenterY)
                    unit = 1;
                else if (mDrawnItemCenterY < realDrawnCenterY)
                    unit = -1;

                float degree = (-(1 - ratio) * 90 * unit);
                if (degree < -90) degree = -90;
                if (degree > 90) degree = 90;
                distanceToCenter = computeSpace((int) degree);

                int transX = mWheelCenterX;
                switch (mItemAlign) {
                    case ALIGN_LEFT:
                        transX = mRectDrawn.left;
                        break;
                    case ALIGN_RIGHT:
                        transX = mRectDrawn.right;
                        break;
                }
                int transY = mWheelCenterY - distanceToCenter;

                mCamera.save();
                mCamera.rotateX(degree);
                mCamera.getMatrix(mMatrixRotate);
                mCamera.restore();
                mMatrixRotate.preTranslate(-transX, -transY);
                mMatrixRotate.postTranslate(transX, transY);

                mCamera.save();
                mCamera.translate(0, 0, computeDepth((int) degree));
                mCamera.getMatrix(mMatrixDepth);
                mCamera.restore();
                mMatrixDepth.preTranslate(-transX, -transY);
                mMatrixDepth.postTranslate(transX, transY);

                mMatrixRotate.postConcat(mMatrixDepth);
            }
            if (hasAtmospheric) {
                int alpha = (int) ((realDrawnCenterY - Math.abs(realDrawnCenterY - mDrawnItemCenterY)) *
                        1.0F / realDrawnCenterY * 255);
                alpha = Math.max(alpha, 0);
                mPaint.setAlpha(alpha);
            }
            // 根据卷曲与否计算数据项绘制Y方向中心坐标
            // Correct item's drawn centerY base on curved state
            int drawnCenterY = isCurved ? realDrawnCenterY - distanceToCenter : mDrawnItemCenterY;

            // 绘制背景
            if (isSelected && mSelectedItemBgColor != -1) {
                mPaint.setColor(mSelectedItemBgColor);
                canvas.drawRect(mRectCurrentItem, mPaint);
            }

            // 绘制文字
            mPaint.setTextSize(isSelected ? mSelectedItemTextSize : mItemTextSize);
            mPaint.setColor(isSelected ? mSelectedItemTextColor : mItemTextColor);
            mPaint.setStyle(Paint.Style.FILL);

            canvas.save();
            canvas.clipRect(mRectDrawn);
            if (isCurved) canvas.concat(mMatrixRotate);
            canvas.drawText(data, mDrawnCenterX, drawnCenterY, mPaint);
            canvas.restore();

            if (isDebug) {
                canvas.save();
                canvas.clipRect(mRectDrawn);
                mPaint.setColor(0xFFEE3333);
                int lineCenterY = mWheelCenterY + (drawnOffsetPos * mItemHeight);
                canvas.drawLine(mRectDrawn.left, lineCenterY, mRectDrawn.right, lineCenterY,
                        mPaint);
                mPaint.setColor(0xFF3333EE);
                mPaint.setStyle(Paint.Style.STROKE);
                int top = lineCenterY - mHalfItemHeight;
                canvas.drawRect(mRectDrawn.left, top, mRectDrawn.right, top + mItemHeight, mPaint);
                canvas.restore();
            }
        }
        // 是否需要绘制幕布
        // Need to draw curtain or not
        if (hasCurtain) {
            mPaint.setColor(mCurtainColor);
            mPaint.setStyle(Paint.Style.FILL);
            canvas.drawRect(mRectCurrentItem, mPaint);
        }
        // 是否需要绘制指示器
        // Need to draw indicator or not
        if (hasIndicator) {
            mPaint.setColor(mIndicatorColor);
            mPaint.setStyle(Paint.Style.FILL);
            canvas.drawRect(mRectIndicatorHead, mPaint);
            canvas.drawRect(mRectIndicatorFoot, mPaint);
        }

        // 绘制单位
        if (!TextUtils.isEmpty(mUnitText)) {
            mPaint.setColor(mUnitTextColor);
            mPaint.setTextSize(mUnitTextSize);
            mPaint.setStyle(Paint.Style.FILL);
            float unitWidth = mPaint.measureText(mUnitText);

            // 文字是从中心开始画的，所以宽度要除以2
            float unitX = mDrawnCenterX + mTextMaxWidth / 2f + unitWidth / 2f + mUnitTextSpace;
            float unitY = mUnitDrawnCenterY + mUnitOffsetY;

            canvas.drawText(mUnitText, unitX, unitY, mPaint);
        }
        if (isDebug) {
            mPaint.setColor(0x4433EE33);
            mPaint.setStyle(Paint.Style.FILL);
            canvas.drawRect(0, 0, getPaddingStart(), getHeight(), mPaint);
            canvas.drawRect(0, 0, getWidth(), getPaddingTop(), mPaint);
            canvas.drawRect(getWidth() - getPaddingEnd(), 0, getWidth(), getHeight(), mPaint);
            canvas.drawRect(0, getHeight() - getPaddingBottom(), getWidth(), getHeight(), mPaint);
        }
    }

    private boolean isPosInRang(int position) {
        return position >= 0 && position < mData.size();
    }

    private int computeSpace(int degree) {
        return (int) (Math.sin(Math.toRadians(degree)) * mHalfWheelHeight);
    }

    private int computeDepth(int degree) {
        return (int) (mHalfWheelHeight - Math.cos(Math.toRadians(degree)) * mHalfWheelHeight);
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        switch (event.getAction()) {
            case MotionEvent.ACTION_DOWN:
                isTouchTriggered = true;
                isInScrolling = true;
                if (null != getParent())
                    getParent().requestDisallowInterceptTouchEvent(true);
                if (null == mTracker)
                    mTracker = VelocityTracker.obtain();
                else
                    mTracker.clear();
                mTracker.addMovement(event);
                if (!mScroller.isFinished()) {
                    mScroller.abortAnimation();
                    isForceFinishScroll = true;
                }
                mDownPointY = mLastPointY = (int) event.getY();
                break;
            case MotionEvent.ACTION_MOVE:
                if (Math.abs(mDownPointY - event.getY()) < mTouchSlop) {
                    isClick = true;
                    break;
                }
                isClick = false;
                mTracker.addMovement(event);
                if (null != mOnWheelChangeListener)
                    mOnWheelChangeListener.onWheelScrollStateChanged(SCROLL_STATE_DRAGGING);

                // 滚动内容
                // Scroll WheelPicker's content
                float move = event.getY() - mLastPointY;
                if (Math.abs(move) < 1) break;
                mScrollOffsetY += move;
                mLastPointY = (int) event.getY();
                invalidate();
                break;
            case MotionEvent.ACTION_UP:
                if (null != getParent())
                    getParent().requestDisallowInterceptTouchEvent(false);
                if (isClick && !isForceFinishScroll) break;
                mTracker.addMovement(event);

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.DONUT)
                    mTracker.computeCurrentVelocity(1000, mMaximumVelocity);
                else
                    mTracker.computeCurrentVelocity(1000);

                // 根据速度判断是该滚动还是滑动
                // Judges the WheelPicker is scroll or fling base on current velocity
                isForceFinishScroll = false;
                int velocity = (int) mTracker.getYVelocity();
                if (Math.abs(velocity) > mMinimumVelocity) {
                    mScroller.fling(0, mScrollOffsetY, 0, velocity, 0, 0, mMinFlingY, mMaxFlingY);
                    mScroller.setFinalY(mScroller.getFinalY() +
                            computeDistanceToEndPoint(mScroller.getFinalY() % mItemHeight));
                } else {
                    mScroller.startScroll(0, mScrollOffsetY, 0,
                            computeDistanceToEndPoint(mScrollOffsetY % mItemHeight));
                }
                // 校正坐标
                // Correct coordinates
                if (!isCyclic)
                    if (mScroller.getFinalY() > mMaxFlingY)
                        mScroller.setFinalY(mMaxFlingY);
                    else if (mScroller.getFinalY() < mMinFlingY)
                        mScroller.setFinalY(mMinFlingY);
                mHandler.post(this);
                if (null != mTracker) {
                    mTracker.recycle();
                    mTracker = null;
                }
                break;
            case MotionEvent.ACTION_CANCEL:
                if (null != getParent())
                    getParent().requestDisallowInterceptTouchEvent(false);
                if (null != mTracker) {
                    mTracker.recycle();
                    mTracker = null;
                }
                break;
        }
        return true;
    }

    private int computeDistanceToEndPoint(int remainder) {
        if (Math.abs(remainder) > mHalfItemHeight)
            if (mScrollOffsetY < 0)
                return -mItemHeight - remainder;
            else
                return mItemHeight - remainder;
        else
            return -remainder;
    }

    @Override
    public void run() {
        if (null == mData || mData.size() == 0) return;
        if (mScroller.isFinished() && !isForceFinishScroll) {
            isInScrolling = false;
            if (mItemHeight == 0) return;
            int position = (-mScrollOffsetY / mItemHeight + mSelectedItemPosition) % mData.size();
            position = position < 0 ? position + mData.size() : position;
            if (isDebug)
                Log.i(TAG, position + ":" + mData.get(position) + ":" + mScrollOffsetY);
            mCurrentItemPosition = position;
            postInvalidate();
            onReceiveNativeEvent(String.valueOf(mData.get(position)));
            if (null != mOnItemSelectedListener && isTouchTriggered)
                mOnItemSelectedListener.onItemSelected(this, mData.get(position), position);
            if (null != mOnWheelChangeListener && isTouchTriggered) {
                mOnWheelChangeListener.onWheelSelected(position);
                mOnWheelChangeListener.onWheelScrollStateChanged(SCROLL_STATE_IDLE);
            }
        }
        if (mScroller.computeScrollOffset()) {
            isInScrolling = true;
            if (null != mOnWheelChangeListener)
                mOnWheelChangeListener.onWheelScrollStateChanged(SCROLL_STATE_SCROLLING);
            mScrollOffsetY = mScroller.getCurrY();
            postInvalidate();
            mHandler.postDelayed(this, 16);
        }
    }

    public void setDebug(boolean isDebug) {
        this.isDebug = isDebug;
    }

    public int getVisibleItemCount() {
        return mVisibleItemCount;
    }

    public void setVisibleItemCount(int count) {
        mVisibleItemCount = count;
        updateVisibleItemCount();
        requestLayout();
    }

    public boolean isCyclic() {
        return isCyclic;
    }

    public void setCyclic(boolean isCyclic) {
        this.isCyclic = isCyclic;
        computeFlingLimitY();
        invalidate();
    }

    public void setOnItemSelectedListener(OnItemSelectedListener listener) {
        mOnItemSelectedListener = listener;
    }

    public int getSelectedItemPosition() {
        return mSelectedItemPosition;
    }

    public void setSelectedItemPosition(int position) {
        setSelectedItemPosition(position, true);
    }

    public void setSelectedItemPosition(int position, final boolean animated) {
        isTouchTriggered = false;
        if (animated && mScroller.isFinished()) { // We go non-animated regardless of "animated" parameter if scroller is in motion
            int length = getData().size();
            int itemDifference = position - mCurrentItemPosition;
            if (itemDifference == 0)
                return;
            if (isCyclic && Math.abs(itemDifference) > (length / 2)) { // Find the shortest path if it's cyclic
                itemDifference += (itemDifference > 0) ? -length : length;
            }
            mScroller.startScroll(0, mScroller.getCurrY(), 0, (-itemDifference) * mItemHeight);
            mHandler.post(this);
        } else {
            if (!mScroller.isFinished())
                mScroller.abortAnimation();
            position = Math.min(position, mData.size() - 1);
            position = Math.max(position, 0);
            mSelectedItemPosition = position;
            mCurrentItemPosition = position;
            mScrollOffsetY = 0;
            computeFlingLimitY();
            requestLayout();
            invalidate();
        }
    }

    public int getCurrentItemPosition() {
        return mCurrentItemPosition;
    }

    public List getData() {
        return mData;
    }

    public void setData(List data) {
        if (null == data)
            throw new NullPointerException("WheelPicker's data can not be null!");
        mData = data;

        // 重置位置
        if (mSelectedItemPosition > data.size() - 1 || mCurrentItemPosition > data.size() - 1) {
            mSelectedItemPosition = mCurrentItemPosition = data.size() - 1;
        } else {
            mSelectedItemPosition = mCurrentItemPosition;
        }
        mScrollOffsetY = 0;
        computeTextSize();
        computeFlingLimitY();
        requestLayout();
        invalidate();
    }

    public void setSameWidth(boolean hasSameWidth) {
        this.hasSameWidth = hasSameWidth;
        computeTextSize();
        requestLayout();
        invalidate();
    }

    public void setDefaultValue(String defaultValue) {
        if (!mData.isEmpty()) {
            for (int i = 0; i < mData.size(); i++) {
                if (mData.get(i).equals(defaultValue)) {
                    setSelectedItemPosition(i, false);
                    break;
                }
            }
        }
    }

    public boolean hasSameWidth() {
        return hasSameWidth;
    }

    public void setOnWheelChangeListener(OnWheelChangeListener listener) {
        mOnWheelChangeListener = listener;
    }

    public String getMaximumWidthText() {
        return mMaxWidthText;
    }

    public void setMaximumWidthText(String text) {
        if (null == text)
            throw new NullPointerException("Maximum width text can not be null!");
        mMaxWidthText = text;
        computeTextSize();
        requestLayout();
        invalidate();
    }

    public int getMaximumWidthTextPosition() {
        return mTextMaxWidthPosition;
    }

    public void setMaximumWidthTextPosition(int position) {
        if (!isPosInRang(position))
            throw new ArrayIndexOutOfBoundsException("Maximum width text Position must in [0, " +
                    mData.size() + "), but current is " + position);
        mTextMaxWidthPosition = position;
        computeTextSize();
        requestLayout();
        invalidate();
    }

    public int getSelectedItemTextColor() {
        return mSelectedItemTextColor;
    }

    public void setSelectedItemTextColor(int color) {
        mSelectedItemTextColor = color;
        computeCurrentItemRect();
        invalidate();
    }

    public int getSelectedItemBgColor() {
        return mSelectedItemBgColor;
    }

    public void setSelectedItemBgColor(int color) {
        mSelectedItemBgColor = color;
        invalidate();
    }

    public int getItemTextColor() {
        return mItemTextColor;
    }

    public void setItemTextColor(int color) {
        mItemTextColor = color;
        invalidate();
    }

    public int getItemTextSize() {
        return mItemTextSize;
    }

    public void setItemTextSize(int size) {
        mItemTextSize = size;
        computeTextSize();
        computeDrawnCenter();
        requestLayout();
        invalidate();
    }

    public int getSelectedItemTextSize() {
        return mSelectedItemTextSize;
    }

    public void setSelectedItemTextSize(int size) {
        mSelectedItemTextSize = size;
        computeTextSize();
        computeDrawnCenter();
        requestLayout();
        invalidate();
    }

    public String getUnitText() {
        return mUnitText;
    }

    public void setUnitText(String mUnitText) {
        this.mUnitText = mUnitText;
        computeDrawnCenter();
        requestLayout();
        invalidate();
    }

    public int getUnitTextSize() {
        return mUnitTextSize;
    }

    public void setUnitTextSize(int mUnitTextSize) {
        this.mUnitTextSize = mUnitTextSize;
    }

    public int getUnitTextColor() {
        return mUnitTextColor;
    }

    public void setUnitTextColor(int mUnitTextColor) {
        this.mUnitTextColor = mUnitTextColor;
    }

    public int getUnitTextSpace() {
        return mUnitTextSpace;
    }

    public void setUnitTextSpace(int mUnitTextSpace) {
        this.mUnitTextSpace = mUnitTextSpace;
    }

    public int getUnitOffsetY() {
        return mUnitOffsetY;
    }

    public void setUnitOffsetY(int mUnitOffsetY) {
        this.mUnitOffsetY = mUnitOffsetY;
    }

    public int getItemSpace() {
        return mItemSpace;
    }

    public void setItemSpace(int space) {
        mItemSpace = space;
        requestLayout();
        invalidate();
    }

    public void setIndicator(boolean hasIndicator) {
        this.hasIndicator = hasIndicator;
        computeIndicatorRect();
        invalidate();
    }

    public boolean hasIndicator() {
        return hasIndicator;
    }

    public int getIndicatorSize() {
        return mIndicatorSize;
    }

    public void setIndicatorSize(int size) {
        mIndicatorSize = size;
        computeIndicatorRect();
        invalidate();
    }

    public int getIndicatorColor() {
        return mIndicatorColor;
    }

    public void setIndicatorColor(int color) {
        mIndicatorColor = color;
        invalidate();
    }

    public int getRowHeight() {
        return mRowHeight;
    }

    public void setRowHeight(int rowHeight) {
        this.mRowHeight = rowHeight;
    }

    public void setCurtain(boolean hasCurtain) {
        this.hasCurtain = hasCurtain;
        computeCurrentItemRect();
        invalidate();
    }

    public boolean hasCurtain() {
        return hasCurtain;
    }

    public int getCurtainColor() {
        return mCurtainColor;
    }

    public void setCurtainColor(int color) {
        mCurtainColor = color;
        invalidate();
    }

    public void setAtmospheric(boolean hasAtmospheric) {
        this.hasAtmospheric = hasAtmospheric;
        invalidate();
    }

    public boolean hasAtmospheric() {
        return hasAtmospheric;
    }

    public boolean isCurved() {
        return isCurved;
    }

    public void setCurved(boolean isCurved) {
        this.isCurved = isCurved;
        requestLayout();
        invalidate();
    }

    public int getItemAlign() {
        return mItemAlign;
    }

    public void setItemAlign(int align) {
        mItemAlign = align;
        updateItemTextAlign();
        computeDrawnCenter();
        invalidate();
    }

    public Typeface getTypeface() {
        if (null != mPaint)
            return mPaint.getTypeface();
        return null;
    }

    public void setTypeface(Typeface tf) {
        if (null != mPaint)
            mPaint.setTypeface(tf);
        computeTextSize();
        requestLayout();
        invalidate();
    }

    /**
     * 滚轮选择器Item项被选中时监听接口
     *
     * @author AigeStudio 2016-06-17
     * 新项目结构
     * @version 1.1.0
     */
    public interface OnItemSelectedListener {
        /**
         * 当滚轮选择器数据项被选中时回调该方法
         * 滚动选择器滚动停止后会回调该方法并将当前选中的数据和数据在数据列表中对应的位置返回
         *
         * @param picker   滚轮选择器
         * @param data     当前选中的数据
         * @param position 当前选中的数据在数据列表中的位置
         */
        void onItemSelected(WheelPicker picker, Object data, int position);
    }

    /**
     * 滚轮选择器滚动时监听接口
     *
     * @author AigeStudio 2016-06-17
     * 新项目结构
     * <p>
     * New project structure
     * @since 2016-06-17
     */
    public interface OnWheelChangeListener {
        /**
         * 当滚轮选择器滚动时回调该方法
         * 滚轮选择器滚动时会将当前滚动位置与滚轮初始位置之间的偏移距离返回，该偏移距离有正负之分，正值表示
         * 滚轮正在往上滚动，负值则表示滚轮正在往下滚动
         * <p>
         * Invoke when WheelPicker scroll stopped
         * WheelPicker will return a distance offset which between current scroll position and
         * initial position, this offset is a positive or a negative, positive means WheelPicker is
         * scrolling from bottom to top, negative means WheelPicker is scrolling from top to bottom
         *
         * @param offset 当前滚轮滚动距离上一次滚轮滚动停止后偏移的距离
         *               <p>
         *               Distance offset which between current scroll position and initial position
         */
        void onWheelScrolled(int offset);

        /**
         * 当滚轮选择器停止后回调该方法
         * 滚轮选择器停止后会回调该方法并将当前选中的数据项在数据列表中的位置返回
         * <p>
         * Invoke when WheelPicker scroll stopped
         * This method will be called when WheelPicker stop and return current selected item data's
         * position in list
         *
         * @param position 当前选中的数据项在数据列表中的位置
         *                 <p>
         *                 Current selected item data's position in list
         */
        void onWheelSelected(int position);

        /**
         * 当滚轮选择器滚动状态改变时回调该方法
         * 滚动选择器的状态总是会在静止、拖动和滑动三者之间切换，当状态改变时回调该方法
         * <p>
         * Invoke when WheelPicker's scroll state changed
         * The state of WheelPicker always between idle, dragging, and scrolling, this method will
         * be called when they switch
         *
         * @param state 滚轮选择器滚动状态，其值仅可能为下列之一
         *              {@link WheelPicker#SCROLL_STATE_IDLE}
         *              表示滚动选择器处于静止状态
         *              {@link WheelPicker#SCROLL_STATE_DRAGGING}
         *              表示滚动选择器处于拖动状态
         *              {@link WheelPicker#SCROLL_STATE_SCROLLING}
         *              表示滚动选择器处于滑动状态
         *              <p>
         *              State of WheelPicker, only one of the following
         *              {@link WheelPicker#SCROLL_STATE_IDLE}
         *              Express WheelPicker in state of idle
         *              {@link WheelPicker#SCROLL_STATE_DRAGGING}
         *              Express WheelPicker in state of dragging
         *              {@link WheelPicker#SCROLL_STATE_SCROLLING}
         *              Express WheelPicker in state of scrolling
         */
        void onWheelScrollStateChanged(int state);
    }

    public void onReceiveNativeEvent(String value) {
        WritableMap event = Arguments.createMap();
//        event.putString("index", value);
        event.putString("newValue", value);
        ReactContext reactContext = (ReactContext) getContext();
        reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(
                getId(),
                "onWheelSelected",
                event);
    }
}
