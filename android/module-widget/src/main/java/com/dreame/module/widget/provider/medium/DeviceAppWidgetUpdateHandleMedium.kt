package com.dreame.module.widget.provider.medium

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.dreame.module.data.db.AppWidgetInfoEntity
import android.dreame.module.manager.LanguageManager
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
import com.dreame.module.widget.constant.STATUS_APPWIDGET_SUPPORT_FAST_COMMAND
import com.dreame.module.widget.constant.STATUS_APPWIDGET_SUPPORT_VIDEO
import com.dreame.module.widget.constant.STATUS_APPWIDGET_SUPPORT_VIDEO_PERMISSION
import com.dreame.module.widget.service.AbstractDeviceAppWidgetUpdateHandle
import com.dreame.module.widget.service.utils.AppWidgetClickHelper
import com.dreame.module.widget.service.utils.AppWidgetEnum
import com.dreame.smartlife.widget.R

internal class DeviceAppWidgetUpdateHandleMedium : AbstractDeviceAppWidgetUpdateHandle() {

    override fun appWidgetEnumCode(): Int = AppWidgetEnum.WIDGET_MIDDLE_SINGLE.code

    override fun buildDefaultLayoutId(): Int = R.layout.layout_appwidget_default_medium
    override suspend fun buildUpdateRemoteView(
        context: Context, appWidgetId: Int, uid: String, did: String, model: String,
        appWidgetType: Int, supportVideo: Boolean, supportFastCmd: Boolean, isOnline: Boolean
    ): RemoteViews {
        // 清扫
        val pendingIntentClean: PendingIntent = AppWidgetClickHelper.buildCleanPendingIntent(context, appWidgetId, uid, did, model, appWidgetType)
        // 回充
        val pendingIntentCharging: PendingIntent = AppWidgetClickHelper.buildChargingPendingIntent(context, appWidgetId, uid, did, model, appWidgetType)
        // 设备图片
        val pendingIntentDevice: PendingIntent = AppWidgetClickHelper.buildMainActivityPendingIntent(context, appWidgetId, uid, did, model, appWidgetType)

        // 切换绑定设备
        val pendingIntentChange: PendingIntent = AppWidgetClickHelper.buildChangeDevicePendingIntent(context, appWidgetId, uid, did, model, appWidgetType)

        val layoutId = if (supportFastCmd || supportVideo) {
            R.layout.widget_device_medium_with_status
        } else {
            R.layout.widget_device_medium
        }
        return RemoteViews(context.packageName, layoutId).apply {
            setOnClickPendingIntent(R.id.iv_device_clean, pendingIntentClean)
            setOnClickPendingIntent(R.id.iv_device_charging, pendingIntentCharging)
            setOnClickPendingIntent(R.id.iv_device, pendingIntentDevice)
            setOnClickPendingIntent(R.id.iv_change_device, pendingIntentChange)

            if (supportVideo && isOnline) {
                // 视频监控
                val pendingIntentMonitor: PendingIntent =
                    AppWidgetClickHelper.buildMainActivityClickVideoPendingIntent(context, appWidgetId, uid, did, model, appWidgetType)
                setOnClickPendingIntent(R.id.iv_device_monitor, pendingIntentMonitor)
            }else {
                setOnClickPendingIntent(R.id.iv_device_monitor,
                        PendingIntent.getBroadcast(context, 0, Intent(), PendingIntent.FLAG_IMMUTABLE))
            }
            if (supportFastCmd) {
                // 快捷指令
                val pendingIntentFastCmd: PendingIntent =
                    AppWidgetClickHelper.buildMainActivityClickFastCommandPendingIntent(context, appWidgetId, uid, did, model, appWidgetType)
                setOnClickPendingIntent(R.id.iv_device_fast_command, pendingIntentFastCmd)
            }
            setViewVisibility(R.id.fl_device_monitor, View.GONE)
            setViewVisibility(R.id.fl_device_fast_command, View.GONE)
            if (supportVideo && supportFastCmd) {
                setViewVisibility(R.id.fl_device_monitor, View.VISIBLE)
                setViewVisibility(R.id.fl_device_fast_command, View.VISIBLE)
//                setViewVisibility(R.id.fl_device_empty, View.GONE)
            } else if (supportVideo) {
                setViewVisibility(R.id.fl_device_monitor, View.VISIBLE)
                setViewVisibility(R.id.fl_device_fast_command, View.GONE)
            } else if (supportFastCmd) {
                setViewVisibility(R.id.fl_device_monitor, View.GONE)
                setViewVisibility(R.id.fl_device_fast_command, View.VISIBLE)
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

        val deviceBattery = entity.deviceBattery
        val deviceCleanArea = entity.cleanArea
        val deviceCleanTime = entity.cleanTime
        val online = entity.deviceOnline
        updateButtonStatusRemoteView(contextOld, remoteViews, appWidgetEnumCode(), deviceName, deviceStatus, supportVideo, supportFastCmd, online, entity)
        updateMultiFunction(appWidgetEnumCode(), remoteViews, deviceBattery, deviceCleanArea, deviceCleanTime, online)
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
            || mapCache[STATUS_APPWIDGET_SUPPORT_FAST_COMMAND] != mapNew[STATUS_APPWIDGET_SUPPORT_FAST_COMMAND]
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
            || entityOld.supportFastCommand != entityNew.supportFastCommand
            || entityOld.fastCommandListStr != entityNew.fastCommandListStr
        ) {
            return true
        }
        return false
    }


}