package com.dreame.module.widget.select.widget

import android.dreame.module.LocalApplication
import android.dreame.module.data.entry.Device
import android.dreame.module.data.entry.FastCommand
import android.dreame.module.manager.AccountManager
import android.dreame.module.manager.AreaManager
import android.dreame.module.util.GsonUtils
import android.dreame.module.util.LogUtil
import android.text.TextUtils
import androidx.lifecycle.viewModelScope
import com.dreame.module.base.mvi.BaseViewModel
import com.dreame.module.base.mvi.UiAction
import com.dreame.module.widget.DeviceControlHelper
import com.dreame.module.widget.constant.KEY_APPWIDGET_CATEGORY
import com.dreame.module.widget.constant.KEY_APPWIDGET_DID
import com.dreame.module.widget.constant.KEY_APPWIDGET_DOMAIN
import com.dreame.module.widget.constant.KEY_APPWIDGET_HOST
import com.dreame.module.widget.constant.KEY_APPWIDGET_ID
import com.dreame.module.widget.constant.KEY_APPWIDGET_IMGURL
import com.dreame.module.widget.constant.KEY_APPWIDGET_MODEL
import com.dreame.module.widget.constant.KEY_APPWIDGET_TYPE
import com.dreame.module.widget.constant.KEY_APPWIDGET_UID
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
import com.dreame.module.widget.constant.STATUS_APPWIDGET_SUPPORT_VIDEO_MULTITASK
import com.dreame.module.widget.constant.STATUS_APPWIDGET_SUPPORT_VIDEO_PERMISSION
import com.dreame.module.widget.select.utils.PhotoUtils
import com.dreame.module.widget.select.utils.PhotoUtils.STATUS_GLIDE_SUCCESS
import com.dreame.module.widget.select.widget.AppWidgetSelectActivity.Companion.APPWIDGET_TYPE_LARGE
import com.dreame.module.widget.select.widget.AppWidgetSelectActivity.Companion.APPWIDGET_TYPE_MEDIUM
import com.dreame.module.widget.select.widget.AppWidgetSelectActivity.Companion.APPWIDGET_TYPE_SMALL
import com.dreame.module.widget.select.widget.AppWidgetSelectActivity.Companion.APPWIDGET_TYPE_SMALL1
import com.dreame.module.widget.select.widget.AppWidgetSelectActivity.Companion.APPWIDGET_TYPE_SMALL2
import com.dreame.module.widget.service.utils.AppWidgetEnum
import com.google.gson.reflect.TypeToken
import com.zj.mvi.core.setState
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.onCompletion
import kotlinx.coroutines.flow.onStart
import kotlinx.coroutines.launch


class AppWidgetSelectViewModel :
    BaseViewModel<AppWidgetSelectUiState, AppWidgetSelectUiEvent>() {
    private val deviceControlHelper by lazy { DeviceControlHelper() }

    override fun createInitialState(): AppWidgetSelectUiState {
        return AppWidgetSelectUiState(
            "", "", "", null, null,
            -1, -1, mutableMapOf(), false, false,
        )
    }

    override fun dispatchAction(acton: UiAction) {
        when (acton) {
            is AppWidgetSelectUiAction.InitData -> {
                _uiStates.setState {
                    copy(
                        deviceName = acton.deviceName,
                        deviceImageUrl = acton.deviceImageUrl,
                        did = acton.did,
                        currentDevice = acton.currentDevice,
                    )
                }
            }

            is AppWidgetSelectUiAction.AddAppWidget -> {
                val appWidgetType = when (acton.position) {
                    APPWIDGET_TYPE_SMALL -> AppWidgetEnum.WIDGET_SMALL_SINGLE.code
                    APPWIDGET_TYPE_SMALL1 -> AppWidgetEnum.WIDGET_SMALL_SINGLE1.code
                    APPWIDGET_TYPE_SMALL2 -> AppWidgetEnum.WIDGET_SMALL_SINGLE2.code
                    APPWIDGET_TYPE_MEDIUM -> AppWidgetEnum.WIDGET_MIDDLE_SINGLE.code
                    APPWIDGET_TYPE_LARGE -> AppWidgetEnum.WIDGET_LARGE_SINGLE.code
                    else -> -1
                }
                _uiStates.setState {
                    copy(
                        appWidgetType = appWidgetType,
                        isLoading = true,
                        isNeedShowTipsPopup = true
                    )
                }
                checkShowTips()
            }

            is AppWidgetSelectUiAction.LinkAppWidget -> {
                if (acton.appWidgetId == -1 || uiStates.value.appWidgetType == -1) {
                    return
                }
                _uiStates.setState {
                    copy(
                        appWidgetId = acton.appWidgetId,
                        isNeedShowTipsPopup = false
                    )
                }
                checkAppWidgetTypeIsLinked(acton.appWidgetId)
            }
        }
    }

    private fun checkShowTips() {
        viewModelScope.launch {
            delay(8000)
            if (uiStates.value.isNeedShowTipsPopup) {
                _uiEvents.send(AppWidgetSelectUiEvent.ShowTips)
            }
            _uiStates.setState {
                copy(
                    isNeedShowTipsPopup = false,
                    isLoading = false
                )
            }
        }
    }

    /**
     * 检查当前小组件类型是否已绑定
     */
    private fun checkAppWidgetTypeIsLinked(appWidgetId: Int) {
        viewModelScope.launch {
            _uiEvents.send(AppWidgetSelectUiEvent.DismissTips)
            if (appWidgetId == -1) {
                return@launch
            }
            if (uiStates.value.appWidgetType == -1) {
                return@launch
            }
            deviceActionStatusBG(uiStates.value.currentDevice)
        }
    }

    /**
     * 关联小部件
     */
    private fun linkedAppWidget() {
        viewModelScope.launch {
            val paramsMap = mutableMapOf<String, Any>()
            uiStates.value.let {
                paramsMap[KEY_APPWIDGET_DID] = it.did
                paramsMap[KEY_APPWIDGET_ID] = it.appWidgetId
                it.currentDevice?.let { device ->
                    paramsMap[KEY_APPWIDGET_UID] = AccountManager.getInstance().account.uid ?: ""
                    paramsMap[KEY_APPWIDGET_HOST] = device.getDeviceHost()
                    paramsMap[KEY_APPWIDGET_MODEL] = device.model ?: ""
                    paramsMap[KEY_APPWIDGET_CATEGORY] = device.deviceInfo?.categoryPath ?: ""
                    paramsMap[KEY_APPWIDGET_IMGURL] = it.deviceImageUrl
                    paramsMap[STATUS_APPWIDGET_DEVICE_NAME] = it.deviceName
                    paramsMap[STATUS_APPWIDGET_SUPPORT_VIDEO] = device.isShowVideo()
                    paramsMap[STATUS_APPWIDGET_SUPPORT_VIDEO_PERMISSION] = device.permissions?.uppercase()?.contains("VIDEO") == true
                    paramsMap[STATUS_APPWIDGET_SUPPORT_VIDEO_MULTITASK] = device.supportVideoMultitask()

                    paramsMap[STATUS_APPWIDGET_DEVICE_STATUS] = device.latestStatus ?: -1
                    paramsMap[STATUS_APPWIDGET_DEVICE_POWER] = device.battery ?: 100
                    paramsMap[STATUS_APPWIDGET_DEVICE_ONLINE] = device.online ?: true

                    paramsMap[KEY_APPWIDGET_TYPE] = it.appWidgetType
                    paramsMap[STATUS_APPWIDGET_DEVICE_SHARE] = if (device.master == null) {
                        -1
                    } else {
                        if (device.master == true) 0 else 1
                    }
                    paramsMap[STATUS_APPWIDGET_DEVICE_CLEAN_AREA] = device.cleanArea ?: -1f
                    paramsMap[STATUS_APPWIDGET_DEVICE_CLEAN_TIME] = device.cleanTime ?: -1
                    paramsMap[STATUS_APPWIDGET_SUPPORT_FAST_COMMAND] = device.isSupportFastCommand()
                    paramsMap[STATUS_APPWIDGET_FAST_COMMAND_LIST] = device.fastCommandList?.let { GsonUtils.toJson(device.fastCommandList) } ?: ""

                    paramsMap[KEY_APPWIDGET_DOMAIN] = AreaManager.getRegion()

                }
                _uiStates.setState {
                    copy(
                        params = paramsMap
                    )
                }
            }
            PhotoUtils.loadBitmap(LocalApplication.getInstance(), _uiStates.value.deviceImageUrl, uiStates.value.appWidgetType) { ret, _, bitmap ->
                if (ret == STATUS_GLIDE_SUCCESS) {
                    _uiStates.setState {
                        copy(
                            deviceBitmap = bitmap
                        )
                    }
                    viewModelScope.launch {
                        _uiEvents.send(AppWidgetSelectUiEvent.DeviceLinked)
                    }
                } else {
                    _uiStates.setState {
                        copy(
                            deviceBitmap = bitmap
                        )
                    }
                    LogUtil.e("download device pic fail  ${bitmap == null}  ${_uiStates.value.deviceImageUrl}")
                    viewModelScope.launch {
                        _uiEvents.send(AppWidgetSelectUiEvent.DeviceLinked)
                    }
                }
            }

        }
    }

    private suspend fun deviceActionStatusBG(currentDevice: Device?) {
        currentDevice?.let { device ->
            val did = device.did ?: ""
            val host = if (!device.bindDomain.isNullOrEmpty()) {
                device.bindDomain!!.split(".").toTypedArray()[0]
            } else {
                ""
            }
            deviceControlHelper.deviceActionStatusBG(host, did, true)
                .onStart {
                    _uiStates.setState {
                        copy(isLoading = true)
                    }
                }.onCompletion {
                    _uiStates.setState {
                        copy(isLoading = false)
                    }
                }
                .collect { map ->
                    // handle result
                    LogUtil.i("AppWidgetSelectViewModel", "deviceActionStatusBG: $map")
                    if (map.isEmpty()) {
                        linkedAppWidget()
                        return@collect
                    }
                    val deviceStatus = map[STATUS_APPWIDGET_DEVICE_STATUS]?.let { it as Int } ?: -1
                    val deviceBattery = map[STATUS_APPWIDGET_DEVICE_POWER]?.let { it as Int } ?: -1
                    val supportFastCmdStr = map[STATUS_APPWIDGET_FAST_COMMAND_LIST]?.let { it as String }
                    val cleanArea = map[STATUS_APPWIDGET_DEVICE_CLEAN_AREA]?.let { it as Float } ?: -1f
                    val cleanTime = map[STATUS_APPWIDGET_DEVICE_CLEAN_TIME]?.let { it as Int } ?: -1

                    val featureCode = map["featureCode"]?.let { it as Int } ?: 0
                    val featureCode2 = map["featureCode2"]?.let { it as Int } ?: 0

                    val commandList = if (!TextUtils.isEmpty(supportFastCmdStr)) {
                        var fastCommandList: List<FastCommand>? = null
                        try {
                            fastCommandList = GsonUtils.fromJson<List<FastCommand>>(supportFastCmdStr, object : TypeToken<List<FastCommand>>() {}.type)
                            if (fastCommandList.isNotEmpty()) {
                                if (deviceStatus == 3 || deviceStatus == 4) {
                                    fastCommandList.forEach {
                                        if (it.state == "1") {
                                            it.state = "0"
                                        }
                                    }
                                }
                            }
                        } catch (e: Exception) {
                            e.printStackTrace()
                        }
                        fastCommandList
                    } else {
                        null
                    }

                    val device = uiStates.value.currentDevice?.let {
                        it.copy(
                            battery = deviceBattery,
                            latestStatus = deviceStatus,
                            featureCode = featureCode,
                            featureCode2 = featureCode2,
                            cleanArea = cleanArea,
                            cleanTime = cleanTime,
                            fastCommandList = commandList
                        )
                    }
                    _uiStates.setState {
                        copy(
                            currentDevice = device
                        )
                    }

                    linkedAppWidget()
                }
        }
    }


}
