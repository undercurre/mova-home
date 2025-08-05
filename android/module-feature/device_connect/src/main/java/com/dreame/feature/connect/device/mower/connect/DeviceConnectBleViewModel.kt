package com.dreame.feature.connect.device.mower.connect

import android.dreame.module.LocalApplication
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ModuleCode
import android.dreame.module.trace.PairNetEventCode
import android.dreame.module.util.GsonUtils
import android.dreame.module.util.SPUtil
import android.os.SystemClock
import androidx.lifecycle.viewModelScope
import com.dreame.feature.connect.constant.ExtraConstants
import com.dreame.feature.connect.trace.BuriedConnectHelper
import com.dreame.module.base.mvi.BaseViewModel
import com.dreame.module.base.mvi.UiAction
import com.dreame.smartlife.config.step.StepData
import com.zj.mvi.core.setState
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class DeviceConnectBleViewModel : BaseViewModel<DeviceConnectBleUiState, DeviceConnectBleUiEvent>() {
    override fun createInitialState(): DeviceConnectBleUiState {
        return DeviceConnectBleUiState(
            false, null, false, "", -1, false,
            null, 0, 0, 0, ""
        )
    }

    override fun dispatchAction(action: UiAction) {
        when (action) {
            is DeviceConnectBleUiAction.InitData -> {
                _uiStates.setState {
                    copy(
                        productInfo = action.productInfo,
                        did = action.did,
                        stepId = action.stepId,
                        stepResult = action.stepResult,
                        pairQRKey = action.pairQRKey,
                        isFinishSuccess = 0
                    )
                }
            }

            is DeviceConnectBleUiAction.InputPinCode -> {
                _uiStates.setState {
                    copy(pinCode = action.pinCode)
                }
            }

            is DeviceConnectBleUiAction.ShowLoading -> {
                _uiStates.setState {
                    copy(isLoading = action.show)
                }
            }

            is DeviceConnectBleUiAction.ConnectStatus -> {
                _uiStates.setState {
                    copy(isFinishSuccess = action.isFinishSuccess)
                }
            }

            is DeviceConnectBleUiAction.UpdateProductInfo -> {
                _uiStates.setState {
                    copy(
                        productInfo = this.productInfo?.copy(
                            targetDomain = action.bindDoamin,
                            targetWifiName = action.wifiName,
                            targetWifiPwd = action.wifiPwd
                        )
                    )
                }
            }

            is DeviceConnectBleUiAction.SaveWifiIInfo -> {
                saveWifiList()
            }

            is DeviceConnectBleUiAction.WaitCostTime -> {
                if (action.finish) {
                    val constTime = SystemClock.elapsedRealtime() - uiStates.value.waitCostTime
                    EventCommonHelper.eventCommonPageInsert(
                        ModuleCode.PairNetNew.code, PairNetEventCode.PairRequest.code, hashCode(),
                        StepData.deviceId, StepData.deviceModel(),
                        int1 = if (action.success) 1 else 0, int2 = (constTime / 1000).toInt(), str1 = BuriedConnectHelper.currentSessionID()
                    )

                    EventCommonHelper.eventCommonPageInsert(
                        ModuleCode.PairNetNew.code, PairNetEventCode.CostTime.code, hashCode(),
                        StepData.deviceId,StepData.deviceModel(),
                        int1 = if (action.success) 1 else 0, int2 = BuriedConnectHelper.currentEnterType(), int5 = BuriedConnectHelper.calculateCostTime(),
                        str1 = BuriedConnectHelper.currentSessionID()
                    )
                } else {
                    _uiStates.setState { copy(waitCostTime = SystemClock.elapsedRealtime()) }
                }
            }

            is DeviceConnectBleUiAction.QrNetWaitCostTime -> {
                if (action.finish) {
                    if (uiStates.value.qrNetCostTime > 0) {
                        val constTime = SystemClock.elapsedRealtime() - uiStates.value.qrNetCostTime
                        EventCommonHelper.eventCommonPageInsert(
                            ModuleCode.PairNetNew.code, PairNetEventCode.QRPairRequest.code, hashCode(),
                            StepData.deviceId,StepData.deviceModel(),
                            int1 = if (action.success) 1 else 0,
                            int2 = (constTime / 1000).toInt(),
                            str1 = BuriedConnectHelper.currentSessionID()
                        )
                    }
                    EventCommonHelper.eventCommonPageInsert(
                        ModuleCode.PairNetNew.code,
                        PairNetEventCode.CostTime.code,
                        hashCode(),
                        StepData.deviceId,StepData.deviceModel(),
                        int1 = if (action.success) 1 else 0,
                        int2 = BuriedConnectHelper.currentEnterType(),
                        int5 = BuriedConnectHelper.calculateCostTime(),
                        str1 = BuriedConnectHelper.currentSessionID()
                    )
                } else {
                    _uiStates.setState { copy(qrNetCostTime = action.pairClickTime) }
                }
            }

        }
    }

    private fun saveWifiList() {
        viewModelScope.launch(Dispatchers.IO) {
            val wifiListStr = SPUtil.get(LocalApplication.getInstance(), ExtraConstants.SP_KEY_WIFI_LIST, "") as String
            val map = GsonUtils.parseMaps<String>(wifiListStr) ?: emptyMap()
            val wifiCacheMap = map.toMap(LinkedHashMap())
            val wifiName = uiStates.value.productInfo?.targetWifiName ?: ""
            val wifiPassword = uiStates.value.productInfo?.targetWifiPwd
            if (wifiName.isNotEmpty()) {
                wifiCacheMap[wifiName] = wifiPassword
            }
            if (wifiCacheMap.size > 10) {
                val next = wifiCacheMap.keys.iterator().next()
                wifiCacheMap.remove(next)
            }
            val newWifiListStr = GsonUtils.toJson(wifiCacheMap)
            SPUtil.put(LocalApplication.getInstance(), ExtraConstants.SP_KEY_WIFI_LIST, newWifiListStr)
        }
    }
}