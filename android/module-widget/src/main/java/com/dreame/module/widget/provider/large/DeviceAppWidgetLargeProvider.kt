package com.dreame.module.widget.provider.large

import android.content.Context
import com.dreame.module.widget.provider.BaseAbstractAppWidgetProvider
import com.dreame.module.widget.service.utils.AppWidgetEnum

class DeviceAppWidgetLargeProvider : BaseAbstractAppWidgetProvider() {
    override fun appWidgetEnumCode() = AppWidgetEnum.WIDGET_LARGE_SINGLE.code

    override fun queryAndUpdateDeviceStatusBG(context: Context, uid: String, appWidgetId: List<Int>, host: String, did: String) {
        super.queryAndUpdateDeviceStatusBG(context, uid, appWidgetId, host, did)
    }

}