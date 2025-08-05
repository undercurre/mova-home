package com.dreame.module.widget.select

import android.dreame.module.LocalApplication
import android.dreame.module.data.Result
import android.dreame.module.data.datasource.local.DeviceLocalDataSource
import android.dreame.module.data.datasource.remote.DeviceRemoteDataSource
import android.dreame.module.data.entry.Device
import android.dreame.module.data.entry.DeviceCatagory
import android.dreame.module.data.entry.DeviceListReq
import android.dreame.module.data.entry.FastCommand
import android.dreame.module.data.entry.STATUS_CONFIRMED
import android.dreame.module.data.getString
import android.dreame.module.data.repostitory.DeviceRepository
import android.dreame.module.manager.AccountManager
import android.dreame.module.manager.AreaManager
import android.dreame.module.manager.LanguageManager
import android.dreame.module.util.GsonUtils
import android.dreame.module.util.LogUtil
import android.text.TextUtils
import androidx.lifecycle.viewModelScope
import com.dreame.module.base.mvi.BaseViewModel
import com.dreame.module.base.mvi.UiAction
import com.dreame.module.widget.AppWidgetCacheHelper
import com.dreame.module.widget.DeviceControlHelper
import com.dreame.module.widget.constant.KEY_APPWIDGET_CATEGORY
import com.dreame.module.widget.constant.KEY_APPWIDGET_DID
import com.dreame.module.widget.constant.KEY_APPWIDGET_DOMAIN
import com.dreame.module.widget.constant.KEY_APPWIDGET_HOST
import com.dreame.module.widget.constant.KEY_APPWIDGET_IMGURL
import com.dreame.module.widget.constant.KEY_APPWIDGET_MODEL
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
import com.dreame.module.widget.select.bean.SelectDevice
import com.dreame.module.widget.select.utils.PhotoUtils
import com.dreame.module.widget.select.utils.PhotoUtils.STATUS_GLIDE_SUCCESS
import com.dreame.smartlife.widget.R
import com.google.gson.reflect.TypeToken
import com.zj.mvi.core.setState
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.onCompletion
import kotlinx.coroutines.flow.onStart
import kotlinx.coroutines.launch


class AppWidgetDeviceSelectViewModel :
    BaseViewModel<AppWidgetDeviceSelectUiState, AppWidgetDeviceSelectUiEvent>() {
    private val repo = DeviceRepository(DeviceRemoteDataSource(), DeviceLocalDataSource())
    private val deviceControlHelper by lazy { DeviceControlHelper() }

    override fun createInitialState(): AppWidgetDeviceSelectUiState {
        return AppWidgetDeviceSelectUiState(
            "", "", "", null, null,
            -1, -1, emptyList(), false, false, 1, 100,
            null, mutableMapOf(), false, false, false
        )
    }

    override fun dispatchAction(acton: UiAction) {
        when (acton) {
            is AppWidgetDeviceSelectUiAction.InitData -> {
                _uiStates.setState {
                    copy(
                        appWidgetId = acton.appWidgetId,
                        appWidgetType = acton.appWidgetType,
                        appWidgetIds = acton.appWidgetIds,
                        did = "",
                        enable = false,
                        isChangeDevice = acton.isChangeDevice,
                        isSelectOrBind = acton.isSelectOrBind
                    )
                }
            }

            is AppWidgetDeviceSelectUiAction.RefreshDevice -> {
                _uiStates.setState {
                    copy(
                        page = 1
                    )
                }
                requestDevice()
            }

            is AppWidgetDeviceSelectUiAction.LoadMoreDevice -> {
                _uiStates.setState {
                    copy(
                        page = page + 1
                    )
                }
                requestDevice()
            }

            is AppWidgetDeviceSelectUiAction.DeviceSelected -> {
                deviceSelect(acton.did)
            }

            is AppWidgetDeviceSelectUiAction.DeviceLinked -> {
                //
                if (uiStates.value.deviceList?.isNotEmpty() == true) {
                    viewModelScope.launch {
                        deviceActionStatusBG(uiStates.value.currentDevice)
                    }
                } else {
                    // 配网设备
                    viewModelScope.launch {
                        _uiEvents.send(AppWidgetDeviceSelectUiEvent.DeviceAdd)
                    }
                }
            }

            is AppWidgetDeviceSelectUiAction.DeviceSelect -> {
                //
                if (uiStates.value.deviceList?.isNotEmpty() == true) {
                    gotoAddAndLinkAppwidget()
                } else {
                    // 配网设备
                    viewModelScope.launch {
                        _uiEvents.send(AppWidgetDeviceSelectUiEvent.DeviceAdd)
                    }
                }
            }
        }
    }

    private fun requestDevice() {
        viewModelScope.launch(Dispatchers.IO) {
            val lang = LanguageManager.getInstance().getLangTag(LocalApplication.getInstance())
            val req = DeviceListReq(_uiStates.value.page, _uiStates.value.pageSize, lang)
            req.sharedStatus = STATUS_CONFIRMED
            repo.queryDeviceList(
                hashMapOf<String, Any>().apply {
                    put("current", _uiStates.value.page)
                    put("size", 100)
                    put("lang", lang)
                    put("sharedStatus", 1)
                }
            )
                .onStart {
                    _uiStates.setState {
                        copy(isRefresh = true)
                    }
                }.onCompletion {
                    _uiStates.setState {
                        copy(isRefresh = false)
                    }
                }.collect { response ->
                    if (response is Result.Success) {
                        //
                        val deviceList = response.data?.page?.records
                        handleResult(deviceList)
                    } else if (response is Result.Error) {
                        if (response.exception.code == 401) {
                            _uiEvents.send(AppWidgetDeviceSelectUiEvent.SignIn)
                        }
                        _uiStates.setState {
                            copy(
                                deviceList = emptyList()
                            )
                        }
                    }
                }
        }
    }

    private suspend fun handleResult(deviceList: List<Device>?) {
        if (deviceList == null || deviceList.isEmpty()) {
            return
        }
        val appWidgetIds = uiStates.value.appWidgetIds
        val didBindedList = getDidFromWidgetInfo(appWidgetIds)
        val list = deviceList.filter {
            it.deviceInfo?.categoryPath == DeviceCatagory.DEVICE_CATEGORY_VACUUM.categoryPath
        }.map { device ->
            val deviceName = if (!TextUtils.isEmpty(device.customName)) {
                device.customName
            } else if (device.deviceInfo != null && !TextUtils.isEmpty(device.deviceInfo?.displayName)) {
                device.deviceInfo?.displayName
            } else {
                device.model
            }
            val imageUrl = device.deviceInfo?.mainImage?.imageUrl ?: ""
            //
            val isUsed = didBindedList.contains(device.did)
            SelectDevice(
                deviceName ?: "", device.did ?: "", imageUrl,
                device, false, isUsed, device.master ?: false
            )
        }
        //
        val did = uiStates.value.did
        list.filter {
            did.isNotEmpty() && it.did == did
        }.onEach {
            it.isSelect = true
        }
        _uiStates.setState {
            copy(
                deviceList = list
            )
        }
    }

    private suspend fun getDidFromWidgetInfo(widgetIds: List<Int>): List<String?> {
        AppWidgetCacheHelper.clearInvalidAppWidgetInfo(widgetIds)
        val uid = AccountManager.getInstance().account.uid ?: ""
        val domain = AreaManager.getRegion()
        val appWidgetType = uiStates.value.appWidgetType
        if (appWidgetType != -1) {
            return AppWidgetCacheHelper.getAppWidgetBindDids(uid, appWidgetType, domain)
        } else {
            // 查询当前账号所有绑定的
            return emptyList(); // AppWidgetCacheHelper.getAppWidgetBindDids(uid, domain)
        }
    }

    private fun deviceSelect(did: String) {
        val device = _uiStates.value.deviceList?.onEach {
            it.isSelect = false
        }?.find {
            it.did == did
        }
        device?.let {
            it.isSelect = true
            _uiStates.setState {
                copy(
                    did = did,
                    currentDevice = it.device,
                    deviceName = device.deviceName,
                    deviceImageUrl = device.imgUrl,
                    enable = true
                )
            }
        }
    }

    /**
     * 关联小部件
     */
    private suspend fun linkedAppWidget() {
        paramMaps()
        PhotoUtils.loadBitmap(
            LocalApplication.getInstance(),
            uiStates.value.deviceImageUrl,
            uiStates.value.appWidgetType
        ) { ret, msg, bitmap ->
            if (ret == STATUS_GLIDE_SUCCESS) {
                _uiStates.setState {
                    copy(
                        deviceBitmap = bitmap,
                        isLoading = false
                    )
                }
                viewModelScope.launch {
                    //
                    _uiEvents.send(AppWidgetDeviceSelectUiEvent.DeviceLinkedSuccess)
                }
            } else {
                viewModelScope.launch {
                    _uiEvents.send(AppWidgetDeviceSelectUiEvent.ShowToast(getString(R.string.operate_failed)))
                }
            }

        }
    }


    /**
     * 跳转添加并绑定页面
     */
    private fun gotoAddAndLinkAppwidget() {
        viewModelScope.launch {
            paramMaps()
            _uiEvents.send(AppWidgetDeviceSelectUiEvent.DeviceSelectSuccess)
        }
    }

    private fun paramMaps() {
        val paramsMap = mutableMapOf<String, Any>()
        _uiStates.value.let {
            paramsMap[KEY_APPWIDGET_DID] = it.did
            it.currentDevice?.let { device ->
                paramsMap[KEY_APPWIDGET_UID] = AccountManager.getInstance().account.uid ?: ""
                paramsMap[KEY_APPWIDGET_HOST] = device.getDeviceHost()
                paramsMap[KEY_APPWIDGET_MODEL] = device.model ?: ""
                paramsMap[KEY_APPWIDGET_CATEGORY] = device.deviceInfo?.categoryPath ?: ""
                paramsMap[KEY_APPWIDGET_IMGURL] = it.deviceImageUrl
                paramsMap[STATUS_APPWIDGET_DEVICE_NAME] = it.deviceName
                paramsMap[STATUS_APPWIDGET_DEVICE_STATUS] = device.latestStatus ?: -1
                paramsMap[STATUS_APPWIDGET_DEVICE_POWER] = device.battery ?: 100
                paramsMap[STATUS_APPWIDGET_DEVICE_ONLINE] = device.online ?: true

                paramsMap[STATUS_APPWIDGET_DEVICE_SHARE] = if (device.master == null) {
                    -1
                } else {
                    if (device.master == true) 0 else 1
                }
                paramsMap[STATUS_APPWIDGET_DEVICE_CLEAN_AREA] = device.cleanArea ?: -1f
                paramsMap[STATUS_APPWIDGET_DEVICE_CLEAN_TIME] = device.cleanTime ?: -1
                paramsMap[KEY_APPWIDGET_DOMAIN] = AreaManager.getRegion()
                //
                paramsMap[STATUS_APPWIDGET_SUPPORT_VIDEO] = device.isShowVideo()
                paramsMap[STATUS_APPWIDGET_SUPPORT_VIDEO_PERMISSION] =
                    device.permissions?.uppercase()?.contains("VIDEO") == true
                paramsMap[STATUS_APPWIDGET_SUPPORT_VIDEO_MULTITASK] = device.supportVideoMultitask()
                paramsMap[STATUS_APPWIDGET_SUPPORT_FAST_COMMAND] = device.isSupportFastCommand()
                paramsMap[STATUS_APPWIDGET_FAST_COMMAND_LIST] =
                    device.fastCommandList?.let { GsonUtils.toJson(device.fastCommandList) } ?: ""
            }
            _uiStates.setState {
                copy(
                    params = paramsMap
                )
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
                    val supportFastCmdStr =
                        map[STATUS_APPWIDGET_FAST_COMMAND_LIST]?.let { it as String }
                    val cleanArea =
                        map[STATUS_APPWIDGET_DEVICE_CLEAN_AREA]?.let { it as Float } ?: -1f
                    val cleanTime = map[STATUS_APPWIDGET_DEVICE_CLEAN_TIME]?.let { it as Int } ?: -1

                    val featureCode = map["featureCode"]?.let { it as Int } ?: 0
                    val featureCode2 = map["featureCode2"]?.let { it as Int } ?: 0

                    val commandList = if (!TextUtils.isEmpty(supportFastCmdStr)) {
                        var fastCommandList: List<FastCommand>? = null
                        try {
                            fastCommandList = GsonUtils.fromJson<List<FastCommand>>(
                                supportFastCmdStr,
                                object : TypeToken<List<FastCommand>>() {}.type
                            )
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


    override fun onCleared() {
        super.onCleared()

    }

}
