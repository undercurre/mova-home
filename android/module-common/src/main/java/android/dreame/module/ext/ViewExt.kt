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

fun View.setOnShakeProofClickListener(interval: Long = CLICK_INTERVAL, listener: View.OnClickListener) {
    setOnClickListener(ClickProxy(interval, listener))
}