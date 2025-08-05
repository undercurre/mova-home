package com.dreame.module.service.appwidget

import android.appwidget.AppWidgetManager
import android.content.Context
import android.graphics.Bitmap
import android.os.Bundle


interface IAppWidgetDeviceService  {

    /**
     * 查询所有的appwidgetIds
     * @param context
     * @param code -1 所有
     */
    fun getAppWidgetIds(context: Context, appWidgetType: Int = -1): List<Pair<Int, IntArray>>

    /**
     * 小组件的添加UI
     * @param context
     * @param code
     * @param appWidgetId  appWidgetId
     * @param did did
     * @param params 其他参数
     */
    fun buildWidgetUiAdd(context: Context, appWidgetId: Int, params: Map<String, Any>, appWidgetType: Int)

    /**
     * 小组件绑定设备
     * @param context
     * @param code
     * @param appWidgetId  appWidgetId
     * @param did did
     * @param params 其他参数
     */
    fun linkedWidget(context: Context, code: Int, appWidgetId: Int, appWidgetType: Int, did: String, bitmap: Bitmap, params: Map<String, Any>)

    /**
     * 解除关联
     * @param context
     * @param deviceId did
     */
    fun unlinkedWidget(context: Context, deviceId: String)

    /**
     * 通知更新小组件UI
     * @param context
     * @param code
     * @param currentUid
     * @param appWidgetId  appWidgetId
     * @param did did
     * @param params 其他参数
     */
    suspend fun updateWidget(context: Context, code: Int, currentUid: String, appWidgetId: Int, did: String, params: Map<String, Any>, appWidgetType: Int)

    suspend fun updateWidget(context: Context, code: Int, appWidgetId: Int, did: String, appWidgetInfoEntity: Any)

    /**
     * 根据did 通知更新小组件UI
     * @param context
     * @param deviceId did
     * @param params 其他参数
     */
    fun updateWidget(context: Context, deviceId: String, params: Map<String, Any>)

    /**
     * 通知更新小组件UI
     * @param context
     * @param deviceList List<DeviceListBean.Device>
     */
    fun updateWidget(context: Context, deviceList: List<*>)

    /**
     * 刷新所有的小组件UI
     * @param context
     */
    fun flushAllWidget(context: Context)

    /**
     * 刷新所有的小组件UI
     * @param context
     */
    fun flushAllWidget(context: Context, code: Int)

    /**
     * 刷新 Options
     * @param context
     * @param appWidgetId
     * @return did host uid
     */
    suspend fun maybeUpdateAppwidgetOptions(context: Context, appWidgetId: Int, appWidgetType: Int, updateAppWidgetOptions: Boolean = true): Bundle

    suspend fun maybeUpdateAppwidgetOptions(manager: AppWidgetManager, appWidgetId: Int, appWidgetType: Int, updateAppWidgetOptions: Boolean = true): Bundle


}