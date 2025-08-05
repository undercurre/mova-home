package com.dreame.module.res.ext

import android.view.View

internal fun View.setOnShakeProofClickListener(interval: Long = CLICK_INTERVAL, listener: View.OnClickListener) {
    setOnClickListener(ClickProxy(interval, listener))
}


/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/12/01
 *     desc   :
 *     version: 1.0
 * </pre>
 */
internal const val CLICK_INTERVAL = 800L

internal open class ClickProxy(
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