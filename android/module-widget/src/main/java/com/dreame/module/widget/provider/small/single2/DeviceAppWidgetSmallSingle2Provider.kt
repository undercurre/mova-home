package com.dreame.module.widget.provider.small.single2

import android.content.Context
import com.dreame.module.widget.provider.BaseAbstractAppWidgetProvider
import com.dreame.module.widget.service.utils.AppWidgetEnum

class DeviceAppWidgetSmallSingle2Provider : BaseAbstractAppWidgetProvider() {
    override fun appWidgetEnumCode() = AppWidgetEnum.WIDGET_SMALL_SINGLE2.code

    override fun queryAndUpdateDeviceStatusBG(context: Context, uid: String, appWidgetId: List<Int>, host: String, did: String) {
        super.queryAndUpdateDeviceStatusBG(context, uid, appWidgetId, host, did)
    }


}

