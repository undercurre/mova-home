package android.dreame.module.rn.load

import android.app.Activity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.dreame.module.R
import android.dreame.module.util.LogUtil
import android.dreame.module.util.toast.ToastUtils.show
import android.os.Build

/**
 * 桌面快捷方式添加成功回调
 */
class ShortcutPinnedReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        LogUtil.i("---------添加快捷方式 end-------")
        show(context.getString(R.string.operate_success))

    }
}

/**
 * 注册桌面快捷方式添加成功回调
 *
 */
fun registerShortcutPinnedReceiver(activity: Activity): ShortcutPinnedReceiver? {
    val intentFilter = IntentFilter()
    intentFilter.addAction("com.example.shortcutstest.PINNED_BROADCAST")
    val receiver = ShortcutPinnedReceiver()
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            activity.registerReceiver(receiver, intentFilter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            activity.registerReceiver(receiver, intentFilter)
        }
        return receiver
    }
    return null
}

/**
 * 取消注册桌面快捷方式添加成功回调
 *
 */
fun unregisterShortcutPinnedReceiver(activity: Activity?, receiver: ShortcutPinnedReceiver?) {
    if (activity == null || receiver == null) {
        return
    }
    try {
        activity.unregisterReceiver(receiver)
    } catch (e: Exception) {
        e.printStackTrace()
    }
}
