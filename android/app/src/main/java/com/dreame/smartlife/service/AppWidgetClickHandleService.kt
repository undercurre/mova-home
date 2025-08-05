package com.dreame.smartlife.service

import android.content.Context
import android.content.Intent
import android.dreame.module.RoutPath
import android.dreame.module.RouteServiceProvider
import android.dreame.module.util.LogUtil
import android.os.Bundle
import com.dreame.module.service.app.IAppWidgetClickHandleService
import com.dreame.module.service.app.flutter.IFlutterBridgeService
import com.dreame.movahome.ui.activity.SplashActivity
import com.therouter.TheRouter
import com.therouter.router.Route

@Route(path = RoutPath.APP_WIDGET_CLICK_HANDLE_SERVICE)
class AppWidgetClickHandleService : IAppWidgetClickHandleService {
    override fun handleAppWidgetClickEvent(context: Context, intent: Intent) {
        /// 判断如果当前未打开App，则先打开App
        if (RouteServiceProvider.getService<IFlutterBridgeService>()?.isMainEngineRunning() != true) {
            // 要先启动主引擎
            val intent1 = Intent(context, SplashActivity::class.java).apply {
                val bundle = intent.extras ?: Bundle()
                bundle.putString("event", "handleAppWidgetClickEvent")
                putExtras(bundle)
            }
            context.startActivity(intent1)
        } else {
            val content = intent.extras?.keySet()?.joinToString { key ->
                val value = intent.extras?.get(key)
                "$key : $value"
            }
            LogUtil.i("sunzhibin", "AppWidgetClickHandleService handleAppWidgetClickEvent: $content")
            TheRouter
                .build(RoutPath.WIDGET_APPWIDGET_SELECT)
                .apply {
                    extras.putAll(intent.extras)
                }.navigation()
        }
    }
}

@com.therouter.inject.ServiceProvider
fun appWidgetClickHandleServiceProvider(): IAppWidgetClickHandleService = AppWidgetClickHandleService()