package com.dreame.feature.connect.views

import android.content.Context
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.Path
import android.graphics.Rect
import android.graphics.RectF
import android.text.InputFilter
import android.text.TextUtils
import android.util.AttributeSet
import android.util.TypedValue
import androidx.appcompat.widget.AppCompatEditText
import com.dreame.smartlife.connect.R

class PinCodeEditText @JvmOverloads constructor(context: Context, attrs: AttributeSet? = null, defStyleAttr: Int = R.attr.editTextStyle) :
    AppCompatEditText(context, attrs, defStyleAttr) {
    /**
     * 画笔
     */
    private var mPaint: Paint? = null

    /**
     * 画笔宽度
     */
    private var mStrokeWidth = 0f

    /**
     * 边框颜色
     */
    private var mBorderColor = -0x99999a

    /**
     * 输入的边框颜色
     */
    private var mInputBorderColor = -0xe16f01

    /**
     * 焦点的边框颜色
     */
    private var mFocusBorderColor = 0

    /**
     * 框的背景颜色
     */
    private var mBoxBackgroundColor = 0

    /**
     * 框的圆角大小
     */
    private var mBorderCornerRadius = 0f

    /**
     * 框与框之间的间距大小
     */
    private var mBorderSpacing = 0f

    /**
     * 输入框宽度
     */
    private var mBoxWidth = 0f

    /**
     * 输入框高度
     */
    private var mBoxHeight = 0f

    /**
     * 允许输入的最大长度
     */
    private var mMaxLength = 6

    /**
     * 文本长度
     */
    private var mTextLength = 0

    /**
     * 路径
     */
    private var mPath: Path? = null
    private var mRectF: RectF? = null
    private var mRadiusFirstArray: FloatArray = floatArrayOf()
    private var mRadiusLastArray: FloatArray = floatArrayOf()

    /**
     * 边框风格
     */
    @BorderStyle
    private var mBorderStyle = BorderStyle.BOX

    /**
     * 边框风格
     */
    @Retention(AnnotationRetention.SOURCE)
    annotation class BorderStyle {
        companion object {
            /**
             * 框
             */
            var BOX = 0

            /**
             * 线
             */
            var LINE = 1
        }
    }

    /**
     * 文本风格
     */
    @TextStyle
    private var mTextStyle = TextStyle.PLAIN_TEXT

    @TextStyle
    private var mTmpTextStyle = TextStyle.PLAIN_TEXT

    /**
     * 文本风格
     */
    @Retention(AnnotationRetention.SOURCE)
    annotation class TextStyle {
        companion object {
            /**
             * 明文
             */
            var PLAIN_TEXT = 0

            /**
             * 密文
             */
            var CIPHER_TEXT = 1
        }
    }

    /**
     * 密文掩码
     */
    private var mCipherMask: String? = null

    /**
     * 是否是粗体
     */
    private var isFakeBoldText = false
    private var isDraw = false
    private var mOnTextInputListener: OnTextInputListener? = null

    init {
        init(context, attrs)
    }

    private fun init(context: Context, attrs: AttributeSet?) {
        val displayMetrics = resources.displayMetrics
        mStrokeWidth = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 1f, displayMetrics)
        mBorderSpacing = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 8f, displayMetrics)
        setPadding(0, 0, 0, 0)
        val a = context.obtainStyledAttributes(attrs, R.styleable.PinCodeEditText)
        val count = a.indexCount
        for (i in 0 until count) {
            val attr = a.getIndex(i)
            if (attr == R.styleable.PinCodeEditText_setStrokeWidth) {
                mStrokeWidth = a.getDimension(attr, mStrokeWidth)
            } else if (attr == R.styleable.PinCodeEditText_setBorderColor) {
                mBorderColor = a.getColor(attr, mBorderColor)
            } else if (attr == R.styleable.PinCodeEditText_setInputBorderColor) {
                mInputBorderColor = a.getColor(attr, mInputBorderColor)
            } else if (attr == R.styleable.PinCodeEditText_setFocusBorderColor) {
                mFocusBorderColor = a.getColor(attr, mFocusBorderColor)
            } else if (attr == R.styleable.PinCodeEditText_setBoxBackgroundColor) {
                mBoxBackgroundColor = a.getColor(attr, mBoxBackgroundColor)
            } else if (attr == R.styleable.PinCodeEditText_setBorderCornerRadius) {
                mBorderCornerRadius = a.getDimension(attr, mBorderCornerRadius)
            } else if (attr == R.styleable.PinCodeEditText_setBorderSpacing) {
                mBorderSpacing = a.getDimension(attr, mBorderSpacing)
            } else if (attr == R.styleable.PinCodeEditText_setMaxLength) {
                mMaxLength = a.getInt(attr, mMaxLength)
            } else if (attr == R.styleable.PinCodeEditText_setBorderStyle) {
                mBorderStyle = a.getInt(attr, mBorderStyle)
            } else if (attr == R.styleable.PinCodeEditText_setTextStyle) {
                mTextStyle = a.getInt(attr, mTextStyle)
            } else if (attr == R.styleable.PinCodeEditText_setCipherMask) {
                mCipherMask = a.getString(attr)
            } else if (attr == R.styleable.PinCodeEditText_setFakeBoldText) {
                isFakeBoldText = a.getBoolean(attr, false)
            }
        }
        a.recycle()
        mPaint = Paint(Paint.ANTI_ALIAS_FLAG)
        mPaint!!.isAntiAlias = true
        mPaint!!.textAlign = Paint.Align.CENTER
        mPath = Path()
        mRadiusFirstArray = FloatArray(8)
        mRadiusLastArray = FloatArray(8)
        mRectF = RectF(0f, 0f, 0f, 0f)
        if (TextUtils.isEmpty(mCipherMask)) {
            mCipherMask = DEFAULT_CIPHER_MASK
        } else if (mCipherMask!!.length > 1) {
            mCipherMask = mCipherMask!!.substring(0, 1)
        }
        background = null
        isCursorVisible = false
        filters = arrayOf<InputFilter>(InputFilter.LengthFilter(mMaxLength))
    }

    override fun onSizeChanged(w: Int, h: Int, oldw: Int, oldh: Int) {
        super.onSizeChanged(w, h, oldw, oldh)
        val width = w - paddingLeft - paddingRight
        val height = h - paddingTop - paddingBottom
        updateSizeChanged(width, height)
    }

    private fun updateSizeChanged(width: Int, height: Int) {
        //如果框与框之间的间距小于0或者总间距大于控件可用宽度则将间距重置为0
        if (mBorderSpacing < 0 || (mMaxLength - 1) * mBorderSpacing > width) {
            mBorderSpacing = 0f
        }
        //计算出每个框的宽度
        mBoxWidth = (width - (mMaxLength - 1) * mBorderSpacing) / mMaxLength - mStrokeWidth
        mBoxHeight = height - mStrokeWidth
    }

    override fun onDraw(canvas: Canvas) {
        //移除super.onDraw(canvas);不绘制EditText相关的
        //绘制边框
        drawBorders(canvas)
    }

    private fun drawBorders(canvas: Canvas) {
        isDraw = true
        //遍历绘制未输入文本的框边界
        for (i in mTextLength until mMaxLength) {
            drawBorder(canvas, i, mBorderColor)
        }
        val color = if (mInputBorderColor != 0) mInputBorderColor else mBorderColor
        //遍历绘制已输入文本的框边界
        for (i in 0 until mTextLength) {
            drawBorder(canvas, i, color)
        }

        //绘制焦点框边界
        if (mTextLength < mMaxLength && mFocusBorderColor != 0 && isFocused) {
            drawBorder(canvas, mTextLength, mFocusBorderColor)
        }
    }

    private fun drawBorder(canvas: Canvas, position: Int, borderColor: Int) {
        mPaint!!.strokeWidth = mStrokeWidth
        mPaint!!.style = Paint.Style.STROKE
        mPaint!!.isFakeBoldText = false
        mPaint!!.color = borderColor

        //计算出对应的矩形
        val left = paddingLeft + mStrokeWidth / 2 + (mBoxWidth + mBorderSpacing) * position
        val top = paddingTop + mStrokeWidth / 2
        mRectF!![left, top, left + mBoxWidth] = top + mBoxHeight
        when (mBorderStyle) {
            BorderStyle.BOX -> drawBorderBox(canvas, position, borderColor)
            BorderStyle.LINE -> drawBorderLine(canvas)
        }
        if (mTextLength > position && !TextUtils.isEmpty(text)) {
            drawText(canvas, position)
        }
    }

    private fun drawText(canvas: Canvas, position: Int) {
        mPaint!!.strokeWidth = 0f
        mPaint!!.color = currentTextColor
        mPaint!!.style = Paint.Style.FILL_AND_STROKE
        mPaint!!.textSize = textSize
        mPaint!!.isFakeBoldText = isFakeBoldText
        val x = mRectF!!.centerX()
        //y轴坐标 = 中心线 + 文字高度的一半 - 基线到文字底部的距离（也就是bottom）
        val y = mRectF!!.centerY() + (mPaint!!.fontMetrics.bottom - mPaint!!.fontMetrics.top) / 2 - mPaint!!.fontMetrics.bottom
        val text = text!![position].toString()
        if (position == mTextLength - 1) {
            when (mTmpTextStyle) {
                TextStyle.PLAIN_TEXT -> canvas.drawText(text, x, y, mPaint!!)
                TextStyle.CIPHER_TEXT -> canvas.drawText(mCipherMask!!, x, y, mPaint!!)
                else -> {}
            }
        } else {
            when (mTextStyle) {
                TextStyle.PLAIN_TEXT -> canvas.drawText(text, x, y, mPaint!!)
                TextStyle.CIPHER_TEXT -> canvas.drawText(mCipherMask!!, x, y, mPaint!!)
                else -> {}
            }
        }

    }

    /**
     * 绘制框风格
     *
     * @param canvas
     * @param position
     */
    private fun drawBorderBox(canvas: Canvas, position: Int, borderColor: Int) {
        if (mBorderCornerRadius > 0) { //当边框带有圆角时
            if (mBorderSpacing == 0f) { //当边框之间的间距为0时，只需要开始一个和最后一个框有圆角
                if (position == 0 || position == mMaxLength - 1) {
                    if (mBoxBackgroundColor != 0) {
                        mPaint!!.style = Paint.Style.FILL
                        mPaint!!.color = mBoxBackgroundColor
                        canvas.drawPath(getRoundRectPath(mRectF, position == 0)!!, mPaint!!)
                    }
                    mPaint!!.style = Paint.Style.STROKE
                    mPaint!!.color = borderColor
                    canvas.drawPath(getRoundRectPath(mRectF, position == 0)!!, mPaint!!)
                } else {
                    if (mBoxBackgroundColor != 0) {
                        mPaint!!.style = Paint.Style.FILL
                        mPaint!!.color = mBoxBackgroundColor
                        canvas.drawRect(mRectF!!, mPaint!!)
                    }
                    mPaint!!.style = Paint.Style.STROKE
                    mPaint!!.color = borderColor
                    canvas.drawRect(mRectF!!, mPaint!!)
                }
            } else {
                if (mBoxBackgroundColor != 0) {
                    mPaint!!.style = Paint.Style.FILL
                    mPaint!!.color = mBoxBackgroundColor
                    canvas.drawRoundRect(mRectF!!, mBorderCornerRadius, mBorderCornerRadius, mPaint!!)
                }
                mPaint!!.style = Paint.Style.STROKE
                mPaint!!.color = borderColor
                canvas.drawRoundRect(mRectF!!, mBorderCornerRadius, mBorderCornerRadius, mPaint!!)
            }
        } else {
            if (mBoxBackgroundColor != 0) {
                mPaint!!.style = Paint.Style.FILL
                mPaint!!.color = mBoxBackgroundColor
                canvas.drawRect(mRectF!!, mPaint!!)
            }
            mPaint!!.style = Paint.Style.STROKE
            mPaint!!.color = borderColor
            canvas.drawRect(mRectF!!, mPaint!!)
        }
    }

    /**
     * 绘制线风格
     *
     * @param canvas
     */
    private fun drawBorderLine(canvas: Canvas) {
        val y = paddingTop + mBoxHeight
        canvas.drawLine(mRectF!!.left, y, mRectF!!.right, y, mPaint!!)
    }

    private fun getRoundRectPath(rectF: RectF?, isFirst: Boolean): Path? {
        mPath!!.reset()
        if (isFirst) {
            //左上角
            mRadiusFirstArray[0] = mBorderCornerRadius
            mRadiusFirstArray[1] = mBorderCornerRadius
            //左下角
            mRadiusFirstArray[6] = mBorderCornerRadius
            mRadiusFirstArray[7] = mBorderCornerRadius
            mPath!!.addRoundRect(rectF!!, mRadiusFirstArray, Path.Direction.CW)
        } else {
            //右上角
            mRadiusLastArray[2] = mBorderCornerRadius
            mRadiusLastArray[3] = mBorderCornerRadius
            //右下角
            mRadiusLastArray[4] = mBorderCornerRadius
            mRadiusLastArray[5] = mBorderCornerRadius
            mPath!!.addRoundRect(rectF!!, mRadiusLastArray, Path.Direction.CW)
        }
        return mPath
    }

    override fun onTextChanged(text: CharSequence, start: Int, lengthBefore: Int, lengthAfter: Int) {
        super.onTextChanged(text, start, lengthBefore, lengthAfter)
        mTextLength = text.length
        refreshView()
        //改变监听
        if (mOnTextInputListener != null) {
            mOnTextInputListener!!.onTextInputChanged(text.toString(), mTextLength)
            if (mTextLength == mMaxLength) {
                mOnTextInputListener!!.onTextInputCompleted(text.toString())
            }
        }
    }

    override fun onSelectionChanged(selStart: Int, selEnd: Int) {
        super.onSelectionChanged(selStart, selEnd)
        if (selStart == selEnd) {
            setSelection(if (text == null) 0 else text!!.length)
        }
    }

    override fun onFocusChanged(focused: Boolean, direction: Int, previouslyFocusedRect: Rect?) {
        super.onFocusChanged(focused, direction, previouslyFocusedRect)
        //焦点改变时刷新状态
        refreshView()
    }

    override fun onDetachedFromWindow() {
        super.onDetachedFromWindow()
        isDraw = false
    }

    var borderColor: Int
        get() = mBorderColor
        set(borderColor) {
            mBorderColor = borderColor
            refreshView()
        }
    var inputBorderColor: Int
        get() = mInputBorderColor
        set(inputBorderColor) {
            mInputBorderColor = inputBorderColor
            refreshView()
        }
    var focusBorderColor: Int
        get() = mFocusBorderColor
        set(focusBorderColor) {
            mFocusBorderColor = focusBorderColor
            refreshView()
        }
    var boxBackgroundColor: Int
        get() = mBoxBackgroundColor
        set(boxBackgroundColor) {
            mBoxBackgroundColor = boxBackgroundColor
            refreshView()
        }
    var borderCornerRadius: Float
        get() = mBorderCornerRadius
        set(borderCornerRadius) {
            mBorderCornerRadius = borderCornerRadius
            refreshView()
        }
    var borderSpacing: Float
        get() = mBorderSpacing
        set(borderSpacing) {
            mBorderSpacing = borderSpacing
            refreshView()
        }

    @get:BorderStyle
    var borderStyle: Int
        get() = mBorderStyle
        set(borderStyle) {
            mBorderStyle = borderStyle
            refreshView()
        }

    @get:TextStyle
    var textStyle: Int
        get() = mTextStyle
        set(textStyle) {
            mTextStyle = textStyle
            refreshView()
        }
    var cipherMask: String?
        get() = mCipherMask
        /**
         * 设置密文掩码 不设置时，默认为[.DEFAULT_CIPHER_MASK]
         *
         * @param cipherMask
         */
        set(cipherMask) {
            mCipherMask = cipherMask
            refreshView()
        }

    /**
     * 是否粗体
     *
     * @param fakeBoldText
     */
    fun setFakeBoldText(fakeBoldText: Boolean) {
        isFakeBoldText = fakeBoldText
        refreshView()
    }

    /**
     * 刷新视图
     */
    private fun refreshView() {
        if (isDraw) {
            invalidate()
        }
        if (mTextStyle == TextStyle.CIPHER_TEXT) {
            mTmpTextStyle = TextStyle.PLAIN_TEXT
            removeCallbacks(runnable)
            postDelayed(runnable, 500)
        } else {
            mTmpTextStyle = TextStyle.PLAIN_TEXT
        }
    }

    val runnable = {
        refreshView2()
    }

    private fun refreshView2() {
        if (isDraw) {
            invalidate()
        }
        if (mTextStyle == TextStyle.CIPHER_TEXT) {
            mTmpTextStyle = TextStyle.CIPHER_TEXT
        }
    }

    /**
     * 设置文本输入监听
     *
     * @param onTextInputListener
     */
    fun setOnTextInputListener(onTextInputListener: OnTextInputListener) {
        mOnTextInputListener = onTextInputListener
    }

    abstract class OnSimpleTextInputListener : OnTextInputListener {
        override fun onTextInputChanged(text: String?, length: Int) {}
    }

    /**
     * 文本输入监听
     */
    interface OnTextInputListener {
        /**
         * Text改变监听
         *
         * @param text
         * @param length
         */
        fun onTextInputChanged(text: String?, length: Int)

        /**
         * Text输入完成
         *
         * @param text
         */
        fun onTextInputCompleted(text: String?)
    }

    companion object {
        private const val DEFAULT_CIPHER_MASK = "●"
    }
}