package android.dreame.module.util

import android.graphics.Paint
import android.text.TextPaint
import android.text.TextUtils
import android.util.Log
import android.util.TypedValue
import android.widget.TextView

/**
 * 低端手机计算耗时太明显，不建议使用
 */
object ViewShowHelper {

    /**
     * 动态根据View 宽度，缩小字号
     * 前置条件： 单行  不做省略折叠  需保证调用时机，view计算完毕
     *
     */
    @JvmStatic
    fun measureTextWidth(textView: TextView) {
        // 单行
        if (textView.maxLines != 1) {
            return
        }
        // 未设置 ellipsize
        if (textView.ellipsize != null) {
            return
        }
        measureTextWidthInternal(textView);
    }

    /**
     * 强制做单行 缩小字号
     */
    @JvmStatic
    fun measureTextWidthForce(textView: TextView) {
        textView.post {
            measureTextWidthInternal(textView)
        }
    }

    /**
     * 强制做单行 缩小字号
     */

    private fun measureTextWidthInternal(textView: TextView) {
        Log.d("sunzhibin", "measureTextWidth: start  ====== ${textView.textSize}  $textView")
        var textSize = textView.textSize
        val textHint = textView.hint
        var text = textView.text

        if (TextUtils.isEmpty(textHint) && TextUtils.isEmpty(text)) {
            // 无需操作
            return
        }
        text = if (!TextUtils.isEmpty(textHint)) {
            if (!TextUtils.isEmpty(text) && text.length > textHint.length) {
                text
            } else {
                textHint
            }
        } else text
        Log.d("sunzhibin", "measureTextWidth:  measureText -----------  $textView")

        // 需保证调用时机，view计算完毕
        val contentWidth = textView.width - textView.paddingStart - textView.paddingEnd
        if (contentWidth <= 0) {
            return
        }
        Log.d("sunzhibin", "measureTextWidth:  measureText -----------  $textView")

        val sp1 = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, 1f, textView.resources.displayMetrics)
        val sp8 = sp1 * 8

        Log.d("sunzhibin", "measureTextWidth:  measureText -----------  $textView")
        // 计算设置的字的宽度
        val mPaint = Paint()
        mPaint.textSize = textSize
        var textWidth = mPaint.measureText(text, 0, text.length)
        Log.d("sunzhibin", "measureTextWidth:  measureText ----------- ${mPaint.textSize} $textView")

        if (contentWidth > textWidth) {
            return
        }
        val lastTextWidth = textWidth
        // 尝试size - 1
        textSize -= sp1
        mPaint.textSize = textSize
        textWidth = mPaint.measureText(text, 0, text.length)
        Log.d("sunzhibin", "measureTextWidth:  measureText ---2--------${mPaint.textSize}  $textView")
        val perWidth = kotlin.math.abs(lastTextWidth - textWidth)
        if (contentWidth < textWidth) {
            val overFlowWidth = textWidth - contentWidth
            val index: Int = overFlowWidth.toInt() / perWidth.toInt() + if (overFlowWidth % perWidth == 0.toFloat()) 0 else 1;
            if (textSize <= sp1 * index) {
                textSize = sp1
            } else {
                textSize -= sp1 * index
            }
        }
        if (textSize < sp8) {
            textSize = sp8
        }
        textView.setTextSize(TypedValue.COMPLEX_UNIT_PX, textSize)
        Log.d("sunzhibin", "measureTextWidth: end  ---- $textSize  ====== $textView")
    }

    fun adjustTvTextSize(tv: TextView, maxWidth: Int, text: String) {
        val avaiWidth = maxWidth - tv.paddingStart - tv.paddingEnd
        if (avaiWidth <= 0) {
            return
        }
        val textPaintClone = TextPaint(tv.paint)
        var trySize: Float = textPaintClone.textSize
        while (textPaintClone.measureText(text) > avaiWidth) {
            trySize--
            textPaintClone.textSize = trySize
        }
        tv.setTextSize(TypedValue.COMPLEX_UNIT_PX, trySize)
    }
}