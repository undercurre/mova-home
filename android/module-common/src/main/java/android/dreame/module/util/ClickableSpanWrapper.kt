package android.dreame.module.util

import android.text.TextPaint
import android.text.style.ClickableSpan
import android.view.View

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/09/17
 *     desc   :
 *     version: 1.0
 * </pre>
 */
class ClickableSpanWrapper(private var clickableSpan:ClickableSpan?): ClickableSpan() {

    override fun onClick(widget: View) {
        clickableSpan?.onClick(widget)
    }

    override fun updateDrawState(ds: TextPaint) {
       clickableSpan?.updateDrawState(ds)
    }

    fun removeReference(){
        clickableSpan = null
    }
}
