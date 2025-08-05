package com.dreame.feature.connect.device.connect

import android.dreame.module.LocalApplication
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ModuleCode
import android.dreame.module.trace.PairNetEventCode
import android.dreame.module.util.GsonUtils
import android.dreame.module.util.SPUtil
import android.os.SystemClock
import androidx.lifecycle.viewModelScope
import com.dreame.feature.connect.constant.ExtraConstants
import com.dreame.feature.connect.device.connect.DeviceConnectUiEvent.StartSmartStepHelperUiEvent
import com.dreame.feature.connect.trace.BuriedConnectHelper
import com.dreame.module.base.mvi.BaseViewModel
import com.dreame.module.base.mvi.UiAction
import com.dreame.smartlife.config.step.StepData
import com.zj.mvi.core.setState
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class DeviceConnectViewModel : BaseViewModel<DeviceConnectUiState, DeviceConnectUiEvent>() {
    override fun createInitialState(): DeviceConnectUiState {
        return DeviceConnectUiState(
            false, null, false, "", -1, false,
            null, 0, 0, 0, null, null, ""
        )
    }

    override fun dispatchAction(action: UiAction) {
        when (action) {
            is DeviceConnectUiAction.InitData -> {
                val stepId = uiStates.value.stepId
                val currentStepId = uiStates.value.currentStepId ?: action.stepId
                _uiStates.setState {
                    copy(
                        productInfo = action.productInfo,
                        did = action.did,
                        stepId = action.stepId,
                        currentStepId = currentStepId,
                        stepResultState = action.stepResult,
                        pairQRKey = action.pairQRKey,
                        isFinishSuccess = 0
                    )
                }
                val newStepId = if (currentStepId > action.stepId) {
                    currentStepId
                } else {
                    stepId
                }
                StepData.init(action.productInfo, action.did, newStepId, action.pairQRKey)

            }

            is DeviceConnectUiAction.StartSmartStepHelperUiAction -> {
                viewModelScope.launch {
                    val stepId = uiStates.value.stepId
                    val currentStepId = uiStates.value.currentStepId ?: -1
                    val newStepId = if (stepId > currentStepId) {
                        stepId
                    } else {
                        currentStepId
                    }
                    // 开始
                    _uiEvents.send(StartSmartStepHelperUiEvent(newStepId))
                }
            }

            is DeviceConnectUiAction.InputPinCode -> {
                _uiStates.setState {
                    copy(pinCode = action.pinCode)
                }
            }

            is DeviceConnectUiAction.CurrentStepId -> {
                _uiStates.setState {
                    copy(currentStepId = action.stepId, stepResult = action.stepResult)
                }
            }

            is DeviceConnectUiAction.ConnectStatus -> {
                _uiStates.setState {
                    copy(isFinishSuccess = action.isFinishSuccess)
                }
            }

            is DeviceConnectUiAction.SaveWifiIInfo -> {
                saveWifiList()
            }

            is DeviceConnectUiAction.WaitCostTime -> {
                if (action.finish) {
                    val constTime = SystemClock.elapsedRealtime() - uiStates.value.waitCostTime
                    EventCommonHelper.eventCommonPageInsert(
                        ModuleCode.PairNetNew.code,
                        PairNetEventCode.PairRequest.code,
                        hashCode(),
                        StepData.deviceId,
                        StepData.deviceModel(),
                        int1 = if (action.success) 1 else 0,
                        int2 = (constTime / 1000).toInt(),
                        str1 = BuriedConnectHelper.currentSessionID()
                    )

                    EventCommonHelper.eventCommonPageInsert(
                        ModuleCode.PairNetNew.code,
                        PairNetEventCode.CostTime.code,
                        hashCode(),
                        StepData.deviceId,
                        StepData.deviceModel(),
                        int1 = if (action.success) 1 else 0,
                        int2 = BuriedConnectHelper.currentEnterType(),
                        int5 = BuriedConnectHelper.calculateCostTime(),
                        str1 = BuriedConnectHelper.currentSessionID()
                    )
                } else {
                    _uiStates.setState { copy(waitCostTime = SystemClock.elapsedRealtime()) }
                }
            }

            is DeviceConnectUiAction.QrNetWaitCostTime -> {
                if (action.finish) {
                    if (uiStates.value.qrNetCostTime > 0) {
                        val constTime = SystemClock.elapsedRealtime() - uiStates.value.qrNetCostTime
                        EventCommonHelper.eventCommonPageInsert(
                            ModuleCode.PairNetNew.code,
                            PairNetEventCode.QRPairRequest.code,
                            hashCode(),
                            StepData.deviceId,
                            StepData.deviceModel(),
                            int1 = if (action.success) 1 else 0,
                            int2 = (constTime / 1000).toInt(),
                            str1 = BuriedConnectHelper.currentSessionID()
                        )
                    }
                    EventCommonHelper.eventCommonPageInsert(
                        ModuleCode.PairNetNew.code,
                        PairNetEventCode.CostTime.code,
                        hashCode(),
                        StepData.deviceId,
                        StepData.deviceModel(),
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
            val wifiListStr = SPUtil.get(
                LocalApplication.getInstance(),
                ExtraConstants.SP_KEY_WIFI_LIST,
                ""
            ) as String
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
            SPUtil.put(
                LocalApplication.getInstance(),
                ExtraConstants.SP_KEY_WIFI_LIST,
                newWifiListStr
            )
        }
    }
}