package com.dreame.module.widget.service

import android.content.Context
import android.dreame.module.data.db.AppWidgetInfoEntity
import android.graphics.Bitmap
import android.os.Bundle
import android.widget.RemoteViews

internal interface IDeviceAppWidgetUpdateHandle {
    fun appWidgetEnumCode(): Int

    /**
     *  小组件 UI更新
     */
    suspend fun buildUpdateRemoteView(
        context: Context,
        appWidgetId: Int,
        uid: String,
        did: String,
        model: String,
        appWidgetType: Int,
        supportVideo: Boolean,
        supportFastCmd: Boolean,
        isOnline: Boolean
    ): RemoteViews

    /**
     * 设置remoteView
     */
    suspend fun settingRemoteView(
        context: Context,
        remoteViews: RemoteViews,
        entity: AppWidgetInfoEntity,
        bitmap: Bitmap?,
        supportVideo: Boolean,
        supportFastCmd: Boolean
    )

    /**
     * 小组件UI 待绑定设备状态
     */
    suspend fun buildLinkDevice(context: Context, appWidgetId: Int, uid: String, did: String, appWidgetType: Int, isSingleFunc: Boolean): RemoteViews


    /**
     * 小组件 token过期
     */
    suspend fun buildTokenError(context: Context, appWidgetId: Int, uid: String, did: String, appWidgetType: Int, isSingleFunc: Boolean): RemoteViews

    /**
     * 检查机器状态和小组件状态是否一致，是否需要更新小组件
     */
    suspend fun checkNeedUpdateAppWidget(cacheMap: Map<String, Any>, newMap: Map<String, Any>): Boolean

    suspend fun checkNeedUpdateAppWidget(entityOld: AppWidgetInfoEntity, entityNew: AppWidgetInfoEntity): Boolean


}