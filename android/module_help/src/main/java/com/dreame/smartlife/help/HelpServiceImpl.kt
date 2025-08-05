package com.dreame.smartlife.help

import android.app.Activity
import android.content.Context
import android.dreame.module.GlobalMainScope
import android.dreame.module.RoutPath
import android.dreame.module.RouteServiceProvider
import android.dreame.module.util.ActivityUtil
import android.dreame.module.util.GsonUtils
import com.dreame.module.service.app.flutter.IFlutterBridgeService
import com.therouter.router.Route
import com.dreame.module.service.help.IHelpService

@Route(path = RoutPath.HELP_SERVICE)
class HelpServiceImpl : IHelpService {

    override fun openZendeskChat() {
        val activity = ActivityUtil.getInstance().topActivity
        if (activity != null)
            GlobalMainScope.launch {
                val paramsMap = RouteServiceProvider.getService<IFlutterBridgeService>()?.getZendeskKey()
                if (paramsMap != null && paramsMap.isNotEmpty()) {
                    CustomerServiceManager.openChat(activity, true, HashMap(paramsMap))
                }
            }
    }

    override fun openCustomerServiceChat(activity: Activity, countryCode: String) {
        GlobalMainScope.launch {
            val paramsMap = RouteServiceProvider.getService<IFlutterBridgeService>()?.getZendeskKey()
            if (paramsMap != null) {
                CustomerServiceManager.openChat(activity, HashMap(paramsMap), countryCode)
            }
        }
    }


}

@com.therouter.inject.ServiceProvider
fun helpServiceProvider(): com.dreame.module.service.help.IHelpService = HelpServiceImpl()