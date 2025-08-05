package android.dreame.module.ext

import android.view.View

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/12/01
 *     desc   :
 *     version: 1.0
 * </pre>
 */
const val CLICK_INTERVAL = 400L
open class ClickProxy(
    private val interval: Long = CLICK_INTERVAL,
    private val origin: View.OnClickListener
) :
    View.OnClickListener {
    // 最后一次点击时间
    private var lastclick: Long = 0

    override fun onClick(v: View) {
        if (System.currentTimeMillis() - lastclick >= interval) {
            origin.onClick(v)
            lastclick = System.currentTimeMillis()
        }
    }
}