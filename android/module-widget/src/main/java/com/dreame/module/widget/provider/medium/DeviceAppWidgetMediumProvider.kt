package com.dreame.module.widget.provider.medium

import android.content.Context
import com.dreame.module.widget.provider.BaseAbstractAppWidgetProvider
import com.dreame.module.widget.service.utils.AppWidgetEnum

class DeviceAppWidgetMediumProvider : BaseAbstractAppWidgetProvider() {
    override fun appWidgetEnumCode() = AppWidgetEnum.WIDGET_MIDDLE_SINGLE.code

    override fun queryAndUpdateDeviceStatusBG(context: Context, uid: String, appWidgetId: List<Int>, host: String, did: String) {
        super.queryAndUpdateDeviceStatusBG(context, uid, appWidgetId, host, did)
    }


}