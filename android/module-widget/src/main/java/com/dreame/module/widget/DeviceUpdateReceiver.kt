/*
 * Copyright (C) 2021 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.mova.module.widget

import android.appwidget.AppWidgetManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.dreame.module.GlobalMainScope
import android.dreame.module.RouteServiceProvider
import android.dreame.module.data.entry.FastCommand
import android.dreame.module.manager.AccountManager
import android.dreame.module.manager.AreaManager
import android.dreame.module.trace.AppWidgetEventCode
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ModuleCode
import android.dreame.module.util.GsonUtils
import android.dreame.module.util.LogUtil
import android.os.SystemClock
import android.util.Log
import com.dreame.module.service.appwidget.IAppWidgetDeviceService
import com.dreame.module.widget.AppWidgetCacheHelper
import com.dreame.module.widget.DeviceControlHelper
import com.dreame.module.widget.constant.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import java.util.*

private var isOperator = false
private var l = SystemClock.elapsedRealtime()

class DeviceUpdateReceiver : BroadcastReceiver() {
    private val help = DeviceControlHelper()
    override fun onReceive(context: Context, intent: Intent) {
        LogUtil.d("DeviceUpdateReceiver", "onReceive:  ${intent?.action} $isOperator")
        val temp = SystemClock.elapsedRealtime() - l
        if (isOperator && temp < 1500) {
            return
        }
        l = SystemClock.elapsedRealtime()
        isOperator = false
        val extras = intent.extras
        if (extras != null) {
            extras.keySet().forEach { key ->
                val value = extras.get(key)
                Log.d("DeviceUpdateReceiver", "onReceive: $key  $value")
            }
        }
        GlobalMainScope.launch(Dispatchers.IO) {
            val action = intent.getStringExtra(KEY_APPWIDGET_ACTION) ?: ""
            val uid = intent.getStringExtra(KEY_APPWIDGET_UID) ?: ""
            val did = intent.getStringExtra(KEY_APPWIDGET_DID) ?: ""
            val model = intent.getStringExtra(KEY_APPWIDGET_MODEL) ?: ""
            val appWidgetType = intent.getIntExtra(KEY_APPWIDGET_TYPE, -1)

            val appWidgetId = intent.getIntExtra(KEY_APPWIDGET_ID, -1)
            val currentUid = AccountManager.getInstance().account.uid ?: ""

            // 兼容第一版，没有绑定uid的小组件
            if (uid.isEmpty() || uid == currentUid) {
                val manager = AppWidgetManager.getInstance(context)
                val appWidgetOptions = manager.getAppWidgetOptions(appWidgetId)
                val host = appWidgetOptions.getString(KEY_APPWIDGET_HOST, "")
                val uid = appWidgetOptions.getString(KEY_APPWIDGET_UID, "")
                val deviceStatus = appWidgetOptions.getInt(STATUS_APPWIDGET_DEVICE_STATUS, -1)
                handleAction(context, action, intent, uid, deviceStatus, host, did, model, appWidgetId, appWidgetType)
            } else {
                // 绑定设备
                RouteServiceProvider.getService<IAppWidgetDeviceService>()?.buildWidgetUiAdd(
                    context, appWidgetId, Collections.emptyMap(), appWidgetType
                )
            }
        }
    }

    private suspend fun handleAction(
        context: Context, action: String, intent: Intent, uid: String,
        lastStatus: Int, host: String, did: String, model: String, appWidgetId: Int, appWidgetType: Int
    ) {
        LogUtil.i("DeviceUpdateReceiver", "handleAction: $action  $did  $appWidgetId")
        when (action) {
            ACTION_APPWIDGET_CLEAN -> {
                // 清扫
                isOperator = true
                help.deviceActionCleanBG(lastStatus, host, did, model, false) { ret, msg ->
                    if (handleDeviceActionResult(context, ret, uid, appWidgetId, did, appWidgetType)) {
                        isOperator = false
                        RouteServiceProvider.getService<IAppWidgetDeviceService>()
                            ?.updateWidget(context, CODE_OPERATOR_UPDATE, uid, appWidgetId, did, emptyMap(), appWidgetType)
                        return@deviceActionCleanBG
                    }
                    //查询机器状态
                    delay(1500)
                    LogUtil.i("DeviceUpdateReceiver", "deviceActionCleanBG : ")
                    help.deviceActionStatusBG(host, did).collect {
                        // handle result
                        LogUtil.i("DeviceUpdateReceiver", "deviceActionCleanBG deviceActionStatusBG: $it")
                        handleStatusResult(context, intent, it, appWidgetType)
                        isOperator = false
                    }
                }
            }

            ACTION_APPWIDGET_CHARGING -> {
                // 回充
                EventCommonHelper.eventCommonPageInsert(ModuleCode.AppWidget.code, AppWidgetEventCode.Charge.code, 0)
                isOperator = true
                help.deviceActionChargingBG(lastStatus, host, did, model, false) { ret, msg ->
                    if (handleDeviceActionResult(context, ret, uid, appWidgetId, did, appWidgetType)) {
                        isOperator = false
                        RouteServiceProvider.getService<IAppWidgetDeviceService>()
                            ?.updateWidget(context, CODE_OPERATOR_UPDATE, uid, appWidgetId, did, emptyMap(), appWidgetType)

                        return@deviceActionChargingBG
                    }
                    //查询机器状态
                    delay(1500)
                    LogUtil.i("DeviceUpdateReceiver", "deviceActionChargingBG : ")
                    help.deviceActionStatusBG(host, did).collect {
                        // handle result
                        LogUtil.i("DeviceUpdateReceiver", "deviceActionChargingBG deviceActionStatusBG: ")
                        handleStatusResult(context, intent, it, appWidgetType)
                        isOperator = false
                    }
                }
            }

            ACTION_APPWIDGET_OPEN_APP -> {
                context.applicationContext.startActivity(Intent("com.dreame.movahome.action.HOME").apply {
                    setPackage(context.packageName)
                    setFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
                    intent.extras?.let {
                        putExtras(it)
                    }
                })
            }

            ACTION_APPWIDGET_FLUSH -> {
                // 请求设备信息
                isOperator = true
                help.deviceActionStatusBG(host, did).collect {
                    // handle result
                    handleStatusResult(context, intent, it, appWidgetType)
                    isOperator = false
                }
            }

            ACTION_APPWIDGET_ADD -> {
                // 绑定设备
                RouteServiceProvider.getService<IAppWidgetDeviceService>()?.buildWidgetUiAdd(
                    context, appWidgetId, Collections.emptyMap(), appWidgetType
                )
            }

            ACTION_APPWIDGET_CLICK_LIST -> {
                try {
                    handleFastCommand(context, intent, appWidgetId, appWidgetType)
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }

            else -> {
            }
        }
    }

    private suspend fun handleFastCommand(
        context: Context,
        intent: Intent,
        appWidgetId: Int,
        appWidgetType: Int
    ) {
        isOperator = true
        val appWidgetManager = AppWidgetManager.getInstance(context)
        val appWidgetOptions = appWidgetManager.getAppWidgetOptions(appWidgetId)
        val uid = appWidgetOptions.getString(KEY_APPWIDGET_UID) ?: ""
        val host = appWidgetOptions.getString(KEY_APPWIDGET_HOST) ?: ""
        val did = appWidgetOptions.getString(KEY_APPWIDGET_DID) ?: ""
        val model = appWidgetOptions.getString(KEY_APPWIDGET_MODEL) ?: ""
        val lastStatus = appWidgetOptions.getInt(STATUS_APPWIDGET_DEVICE_STATUS, -1)
        // 快捷指令
        val fastcmdId = intent.getLongExtra(FASTCMD_ID, -1L)
        val fastcmdState = intent.getStringExtra(FASTCMD_STATE) ?: ""

        val executingFastCommand = if ("1" == fastcmdState || "0" == fastcmdState) {
            fastcmdId to fastcmdState
        } else {
            // 查询快捷指令列表
            val domain = AreaManager.getRegion()
            val entity = AppWidgetCacheHelper.readAppWidgetInfo(uid, appWidgetId, domain)
            entity?.let {
                if (it.fastCommandListStr.isNullOrBlank()) {
                    -1L to ""
                } else {
                    val parseLists = GsonUtils.parseLists(it.fastCommandListStr, FastCommand::class.java)
                    parseLists?.find { fsc ->
                        "1" == fsc.state || "0" == fsc.state
                    }?.let {
                        it.id to (it.state ?: "")
                    } ?: (-1L to "")
                }
            } ?: (-1L to "")
        }
        help.startOrStopFastCommand(lastStatus, host, did, model, fastcmdId, executingFastCommand) { ret, msg ->
            if (handleDeviceActionResult(context, ret, uid, appWidgetId, did, appWidgetType)) {
                isOperator = false
                RouteServiceProvider.getService<IAppWidgetDeviceService>()
                    ?.updateWidget(context, CODE_OPERATOR_UPDATE, uid, appWidgetId, did, emptyMap(), appWidgetType)
                return@startOrStopFastCommand
            }
            //查询机器状态
            delay(1500)
            LogUtil.i("DeviceUpdateReceiver", "startOrStopFastCommand : ")
            help.deviceActionStatusBG(host, did).collect {
                // handle result
                LogUtil.i("DeviceUpdateReceiver", " startOrStopFastCommand deviceActionStatusBG: -------------- ")
                handleStatusResult(context, intent, it, appWidgetType)
                isOperator = false
            }
        }
    }

    private fun handleStatusResult(context: Context, intent: Intent, params: Map<String, Any>, appWidgetType: Int) {
        // 更新小组件
        val did = intent.getStringExtra(KEY_APPWIDGET_DID) ?: ""
        RouteServiceProvider.getService<IAppWidgetDeviceService>()?.updateWidget(context, did, params)
    }

    private suspend fun handleDeviceActionResult(context: Context, ret: Int, uid: String, appWidgetId: Int, did: String, appWidgetType: Int): Boolean {
        if (ret == 401) {
            // 更新小组件UI展示
            RouteServiceProvider.getService<IAppWidgetDeviceService>()
                ?.updateWidget(context, CODE_OPERATOR_ERROR_TOKEN, uid, appWidgetId, did, emptyMap(), appWidgetType)
            return true
        }
        return false
    }

}