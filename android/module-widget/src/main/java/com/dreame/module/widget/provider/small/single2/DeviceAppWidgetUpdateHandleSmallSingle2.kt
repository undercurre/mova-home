package com.dreame.module.widget.provider.small.single2

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.dreame.module.data.db.AppWidgetInfoEntity
import android.graphics.Bitmap
import android.view.View
import android.widget.RemoteViews
import com.dreame.module.widget.constant.STATUS_APPWIDGET_DEVICE_CLEAN_AREA
import com.dreame.module.widget.constant.STATUS_APPWIDGET_DEVICE_CLEAN_TIME
import com.dreame.module.widget.constant.STATUS_APPWIDGET_DEVICE_NAME
import com.dreame.module.widget.constant.STATUS_APPWIDGET_DEVICE_ONLINE
import com.dreame.module.widget.constant.STATUS_APPWIDGET_DEVICE_POWER
import com.dreame.module.widget.constant.STATUS_APPWIDGET_DEVICE_SHARE
import com.dreame.module.widget.constant.STATUS_APPWIDGET_DEVICE_STATUS
import com.dreame.module.widget.constant.STATUS_APPWIDGET_FAST_COMMAND_LIST
import com.dreame.module.widget.constant.STATUS_APPWIDGET_SUPPORT_VIDEO
import com.dreame.module.widget.constant.STATUS_APPWIDGET_SUPPORT_VIDEO_PERMISSION
import com.dreame.module.widget.service.AbstractDeviceAppWidgetUpdateHandle
import com.dreame.module.widget.service.utils.AppWidgetClickHelper
import com.dreame.module.widget.service.utils.AppWidgetEnum
import com.dreame.smartlife.widget.R

internal class DeviceAppWidgetUpdateHandleSmallSingle2 : AbstractDeviceAppWidgetUpdateHandle() {

    override fun appWidgetEnumCode(): Int = AppWidgetEnum.WIDGET_SMALL_SINGLE2.code

    override suspend fun buildUpdateRemoteView(
        context: Context, appWidgetId: Int, uid: String, did: String, model: String,
        appWidgetType: Int, supportVideo: Boolean, supportFastCmd: Boolean, isOnline: Boolean
    ): RemoteViews {
        // 清扫
        val pendingIntentClean: PendingIntent = AppWidgetClickHelper.buildCleanPendingIntent(context, appWidgetId, uid, did, model, appWidgetType)
        // 回充
        val pendingIntentCharging: PendingIntent = AppWidgetClickHelper.buildChargingPendingIntent(context, appWidgetId, uid, did, model, appWidgetType)

        val pendingIntentDevice: PendingIntent = AppWidgetClickHelper.buildMainActivityPendingIntent(context, appWidgetId, uid, did, model, appWidgetType)

        // 切换绑定设备
        val pendingIntentChange: PendingIntent = AppWidgetClickHelper.buildChangeDevicePendingIntent(context, appWidgetId, uid, did, model, appWidgetType)

        val layoutId = R.layout.widget_device_small_single_row2
        return RemoteViews(context.packageName, layoutId).apply {
            setOnClickPendingIntent(R.id.iv_device_clean, pendingIntentClean)
            setOnClickPendingIntent(R.id.iv_device_charging, pendingIntentCharging)
            setOnClickPendingIntent(R.id.iv_device, pendingIntentDevice)
            setOnClickPendingIntent(R.id.iv_change_device, pendingIntentChange)

            if (supportVideo) {
                // 视频监控
                if (isOnline) {
                    val pendingIntentMonitor: PendingIntent =
                        AppWidgetClickHelper.buildMainActivityClickVideoPendingIntent(context, appWidgetId, uid, did, model, appWidgetType)
                    setOnClickPendingIntent(R.id.iv_device_monitor, pendingIntentMonitor)
                }else {
                    setOnClickPendingIntent(R.id.iv_device_monitor,
                            PendingIntent.getBroadcast(context, 0, Intent(), PendingIntent.FLAG_IMMUTABLE))
                }
                setViewVisibility(R.id.fl_device_monitor, View.VISIBLE)
                setViewVisibility(R.id.fl_device_empty, View.GONE)
            } else {
                setViewVisibility(R.id.fl_device_monitor, View.GONE)
                setViewVisibility(R.id.fl_device_empty, View.VISIBLE)
            }
        }
    }

    override suspend fun settingRemoteView(
        contextOld: Context,
        remoteViews: RemoteViews,
        entity: AppWidgetInfoEntity,
        bitmap: Bitmap?,
        supportVideo: Boolean,
        supportFastCmd: Boolean
    ) {
        val deviceName = entity.deviceName
        val deviceStatus = entity.deviceStatus
        val online = entity.deviceOnline
        updateButtonStatusRemoteView(contextOld, remoteViews, appWidgetEnumCode(), deviceName, deviceStatus, supportVideo, supportFastCmd, online, entity)
        bitmap?.let {
            remoteViews.setImageViewBitmap(R.id.iv_device, bitmap)
        } ?: remoteViews.setImageViewResource(R.id.iv_device, R.drawable.icon_robot_placeholder)
    }

    override suspend fun checkNeedUpdateAppWidget(mapCache: Map<String, Any>, mapNew: Map<String, Any>): Boolean {
        if (mapCache[STATUS_APPWIDGET_DEVICE_NAME] != mapNew[STATUS_APPWIDGET_DEVICE_NAME]
            || mapCache[STATUS_APPWIDGET_DEVICE_STATUS] != mapNew[STATUS_APPWIDGET_DEVICE_STATUS]
            || mapCache[STATUS_APPWIDGET_DEVICE_ONLINE] != mapNew[STATUS_APPWIDGET_DEVICE_ONLINE]
            || mapCache[STATUS_APPWIDGET_DEVICE_POWER] != mapNew[STATUS_APPWIDGET_DEVICE_POWER]
            || mapCache[STATUS_APPWIDGET_DEVICE_SHARE] != mapNew[STATUS_APPWIDGET_DEVICE_SHARE]
            || mapCache[STATUS_APPWIDGET_DEVICE_CLEAN_AREA] != mapNew[STATUS_APPWIDGET_DEVICE_CLEAN_AREA]
            || mapCache[STATUS_APPWIDGET_DEVICE_CLEAN_TIME] != mapNew[STATUS_APPWIDGET_DEVICE_CLEAN_TIME]
            || mapCache[STATUS_APPWIDGET_SUPPORT_VIDEO_PERMISSION] != mapNew[STATUS_APPWIDGET_SUPPORT_VIDEO_PERMISSION]
            || mapCache[STATUS_APPWIDGET_SUPPORT_VIDEO] != mapNew[STATUS_APPWIDGET_SUPPORT_VIDEO]
            || mapCache[STATUS_APPWIDGET_FAST_COMMAND_LIST] != mapNew[STATUS_APPWIDGET_FAST_COMMAND_LIST]
        ) {
            return true
        }
        return false
    }

    override suspend fun checkNeedUpdateAppWidget(entityOld: AppWidgetInfoEntity, entityNew: AppWidgetInfoEntity): Boolean {
        if (entityOld.deviceName != entityNew.deviceName
            || entityOld.deviceStatus != entityNew.deviceStatus
            || entityOld.deviceOnline != entityNew.deviceOnline
            || entityOld.deviceBattery != entityNew.deviceBattery
            || entityOld.deviceShare != entityNew.deviceShare
            || entityOld.cleanArea != entityNew.cleanArea
            || entityOld.cleanTime != entityNew.cleanTime
            || entityOld.videoPermission != entityNew.videoPermission
            || entityOld.supportVideo != entityNew.supportVideo
            || entityOld.fastCommandListStr != entityNew.fastCommandListStr
        ) {
            return true
        }
        return false
    }


}