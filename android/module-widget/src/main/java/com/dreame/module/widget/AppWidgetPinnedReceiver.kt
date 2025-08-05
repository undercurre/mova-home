package com.dreame.module.widget

import android.appwidget.AppWidgetManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.dreame.module.util.ActivityUtil
import android.dreame.module.util.LogUtil
import com.dreame.module.widget.constant.ACTION_APPWIDGET_PIN
import com.dreame.module.widget.constant.ACTION_APPWIDGET_PIN_ID
import com.dreame.module.widget.select.widget.AppWidgetSelectActivity

private var time: Long = 0

class AppWidgetPinnedReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        LogUtil.i("AppWidgetDeviceProvider", "AppWidgetPinnedReceiver onReceive: ${intent.action}")
        when (intent.action) {
            ACTION_APPWIDGET_PIN -> {
                // 添加成功
                widgetPinnedSuccess(context, intent)
            }

            ACTION_APPWIDGET_PIN_ID -> {
                // 补偿
                widgetPinnedSuccess(context, intent)
            }
        }
    }

    private fun widgetPinnedSuccess(context: Context?, intent: Intent?) {
        val appwidget_id = intent?.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, -1) ?: -1
        LogUtil.i(
            "AppWidgetDeviceProvider",
            "AppWidgetPinnedReceiver widgetPinnedSuccess: $appwidget_id   $time  ${android.os.Process.myPid()}"
        )
        if (appwidget_id != -1) {
            val currentTimeMillis = System.currentTimeMillis()
            val tempTime = currentTimeMillis - time
            if (tempTime < 100) {
                return
            }
            time = currentTimeMillis
            LogUtil.i(
                "AppWidgetDeviceProvider",
                "AppWidgetPinnedReceiver startActivity: $appwidget_id  $tempTime  $time  ${Thread.currentThread().name}"
            )
            val topActivity = ActivityUtil.getInstance().topActivity
            topActivity?.let {
                if (it is AppWidgetSelectActivity) {
                    if (it.isActivityVisiable) {
                        context?.startActivity(
                            Intent(context, AppWidgetSelectActivity::class.java).apply {
                                `package` = context.packageName
                                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appwidget_id)
                                setFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
                            }
                        )
                    }
                }
            }
        }
    }
}