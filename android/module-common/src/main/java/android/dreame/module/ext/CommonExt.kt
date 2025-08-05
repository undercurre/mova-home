@file:JvmName("CommonExt")

package android.dreame.module.ext

import android.dreame.module.LocalApplication
import android.dreame.module.util.ActivityUtil


fun Float.dp(): Int {
    val context = LocalApplication.getInstance().applicationContext
    return context?.let {
        (this * it.resources.displayMetrics.density + 0.5f).toInt()
    } ?: 0
}

fun Float.px(): Float {
    val context = LocalApplication.getInstance().applicationContext
    return context?.let {
        this / context.resources.displayMetrics.density
    } ?: 0f
}

fun Int.dp(): Int {
    val context = LocalApplication.getInstance().applicationContext
    return context?.let {
        (this * it.resources.displayMetrics.density + 0.5f).toInt()
    } ?: 0
}

fun Int.px(): Float {
    val context = LocalApplication.getInstance().applicationContext
    return context?.let {
        this / context.resources.displayMetrics.density
    } ?: 0f
}

fun getStringExt(resId: Int): String {
    return ActivityUtil.getInstance().currentActivity?.getString(resId) ?: ""
}