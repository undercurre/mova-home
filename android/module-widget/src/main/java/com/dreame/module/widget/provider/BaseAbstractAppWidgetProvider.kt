package com.dreame.module.widget.provider

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.dreame.module.GlobalMainScope
import android.dreame.module.RouteServiceProvider
import android.dreame.module.manager.AccountManager
import android.dreame.module.trace.AppWidgetEventCode
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ModuleCode
import android.dreame.module.util.LogUtil
import android.os.Bundle
import android.util.Log
import com.dreame.module.service.appwidget.IAppWidgetDeviceService
import com.dreame.module.widget.AppWidgetCacheHelper
import com.dreame.module.widget.AppWidgetPinnedReceiver
import com.dreame.module.widget.DeviceControlHelper
import com.dreame.module.widget.constant.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import java.util.*

abstract class BaseAbstractAppWidgetProvider : AppWidgetProvider() {

    private val help = DeviceControlHelper()

    // key appwidgetId value did
    private val deviceMap = mutableMapOf<String, MutableList<Pair<Int, Bundle?>>>()

    abstract fun appWidgetEnumCode(): Int
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        onUpdate(context, appWidgetEnumCode(), appWidgetManager, appWidgetIds)
    }

    override fun onEnabled(context: Context?) {
        super.onEnabled(context)
        LogUtil.i("AppWidgetDeviceProvider", "onEnabled: ")
        EventCommonHelper.eventCommonPageInsert(ModuleCode.AppWidget.code, AppWidgetEventCode.Add.code, 0)
    }

    override fun onDisabled(context: Context?) {
        super.onDisabled(context)
        LogUtil.i("AppWidgetDeviceProvider", "onDisabled: ")
    }

    override fun onAppWidgetOptionsChanged(context: Context?, appWidgetManager: AppWidgetManager?, appWidgetId: Int, newOptions: Bundle?) {
        super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions)
        LogUtil.i("AppWidgetDeviceProvider", "onAppWidgetOptionsChanged: $appWidgetId  ${newOptions}")
        val list = newOptions?.keySet()?.map {
            newOptions.get(it)
        }
        LogUtil.d("AppWidgetDeviceProvider", "onAppWidgetOptionsChanged: $appWidgetId  ${list?.joinToString()}")
    }

    override fun onRestored(context: Context?, oldWidgetIds: IntArray?, newWidgetIds: IntArray?) {
        super.onRestored(context, oldWidgetIds, newWidgetIds)
        LogUtil.i("AppWidgetDeviceProvider", "onRestored: ${oldWidgetIds?.joinToString()}  ${newWidgetIds?.joinToString()}")
    }

    override fun onDeleted(context: Context, appWidgetIds: IntArray) {
        super.onDeleted(context, appWidgetIds)
        LogUtil.i("AppWidgetDeviceProvider", "onDeleted: ${appWidgetIds.joinToString()}")
        GlobalMainScope.launch {
            AppWidgetCacheHelper.removeInvalidAppWidgetInfo(appWidgetIds)
        }
    }

    protected fun onUpdate(context: Context, appWidgetType: Int, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray?) {
        LogUtil.d("AppWidgetDeviceProvider", "onUpdate: --------------------------------------")
        GlobalMainScope.launch {
            appWidgetIds?.forEach { appWidgetId ->
                // 更新 options
                val bundle = RouteServiceProvider.getService<IAppWidgetDeviceService>()?.maybeUpdateAppwidgetOptions(context, appWidgetId, appWidgetType)
                val did = bundle?.getString(KEY_APPWIDGET_DID, "") ?: ""
                val uid = bundle?.getString(KEY_APPWIDGET_UID, "") ?: ""
                // 1、绑定过设备，判断是否是当前用户的设备，
                if (did?.isNotBlank() == true) {
                    LogUtil.i("AppWidgetDeviceProvider", "updateWidget: $appWidgetId  $did")
                    val currentUid = AccountManager.getInstance().account.uid ?: ""
                    // 刷新UI，
                    // 1.1、判断是否是当前用户的设备，是当前用户则更新状态
                    if (did.isNotBlank() || uid == currentUid) {
                        val list = deviceMap.get(did) ?: mutableListOf()
                        list.add(appWidgetId to bundle)
                        deviceMap.put(did, list)
                        RouteServiceProvider.getService<IAppWidgetDeviceService>()?.updateWidget(
                            context,
                            CODE_OPERATOR_UPDATE, uid, appWidgetId, did, Collections.emptyMap(), appWidgetType
                        )
                    } else {
                        // 1.2、不当前用户的设备，待绑定
                        RouteServiceProvider.getService<IAppWidgetDeviceService>()
                            ?.buildWidgetUiAdd(context, appWidgetId, Collections.emptyMap(), appWidgetType)
                    }
                } else {
                    // 2、没绑定过设备，待绑定
                    LogUtil.i("AppWidgetDeviceProvider", "addWidget: $appWidgetId  $did")
                    context.sendBroadcast(
                        Intent(context, AppWidgetPinnedReceiver::class.java)
                            .putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
                            .setAction(ACTION_APPWIDGET_PIN_ID)
                    )
                    RouteServiceProvider.getService<IAppWidgetDeviceService>()
                        ?.buildWidgetUiAdd(context, appWidgetId, Collections.emptyMap(), appWidgetType)
                }

            }
            deviceMap.entries.onEach {
                val did = it.key
                val bundle = it.value[0]?.second
                val uid = bundle?.getString(KEY_APPWIDGET_UID, "") ?: ""
                val host = bundle?.getString(KEY_APPWIDGET_HOST, "") ?: ""
                val idList = it.value.map { pair ->
                    pair.first
                }
                queryDeviceStatusBG(context, uid, idList, host, did)
                delay(100)
                queryDeviceShare(context, did, uid)
                delay(100)
            }
        }
    }

    protected open fun queryAndUpdateDeviceStatusBG(context: Context, uid: String, appWidgetId: List<Int>, host: String, did: String) {
        queryDeviceStatusBG(context, uid, appWidgetId, host, uid)
    }

    private fun queryDeviceStatusBG(context: Context, uid: String, appWidgetIds: List<Int>, host: String, did: String) {
        GlobalMainScope.launch(Dispatchers.IO) {
            // 请求设备信息
            help.deviceActionStatusBG(host, did).collect {
                val ret = it[STATUS_APPWIDGET_RET] ?: 0
                if (ret != 0) {
                    if (ret == 401) {
                        appWidgetIds.onEach { appWidgetId ->
                            RouteServiceProvider.getService<IAppWidgetDeviceService>()
                                ?.updateWidget(context, CODE_OPERATOR_ERROR_TOKEN, uid, appWidgetId, did, emptyMap(), appWidgetEnumCode())
                        }
                    } else {
                        RouteServiceProvider.getService<IAppWidgetDeviceService>()?.updateWidget(context, did, it)
                    }
                } else {
                    // handle result
                    RouteServiceProvider.getService<IAppWidgetDeviceService>()?.updateWidget(context, did, emptyMap())
                }
            }
        }
    }

    private fun queryDeviceShare(context: Context, did: String, shareUid: String) {
        GlobalMainScope.launch {
            help.getUserFeatures(did, shareUid) { ret, result, msg ->
                if (ret == 0) {
                    val map = mapOf(STATUS_APPWIDGET_SUPPORT_VIDEO_PERMISSION to result)
                    RouteServiceProvider.getService<IAppWidgetDeviceService>()?.updateWidget(context, did, map)
                } else {
                    // error
                }
            }
        }
    }

}