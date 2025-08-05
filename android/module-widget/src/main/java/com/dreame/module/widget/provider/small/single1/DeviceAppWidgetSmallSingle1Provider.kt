package com.dreame.module.widget.provider.small.single1

import android.content.Context
import com.dreame.module.widget.provider.BaseAbstractAppWidgetProvider
import com.dreame.module.widget.service.utils.AppWidgetEnum

class DeviceAppWidgetSmallSingle1Provider : BaseAbstractAppWidgetProvider() {
    override fun appWidgetEnumCode() = AppWidgetEnum.WIDGET_SMALL_SINGLE1.code

    override fun queryAndUpdateDeviceStatusBG(context: Context, uid: String, appWidgetId: List<Int>, host: String, did: String) {
        super.queryAndUpdateDeviceStatusBG(context, uid, appWidgetId, host, did)
    }


}

