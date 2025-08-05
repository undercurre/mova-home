package com.dreame.feature.connect.device.connect

import com.dreame.module.base.mvi.UiAction
import com.dreame.module.base.mvi.UiEvent
import com.dreame.module.base.mvi.UiState
import com.dreame.smartlife.config.step.StepData
import com.dreame.smartlife.config.step.StepResult

data class DeviceConnectUiState(
    val isLoading: Boolean,
    val productInfo: StepData.ProductInfo?,
    val isAfterSales: Boolean,
    val did: String,
    val stepId: Int,
    val stepResultState: Boolean,
    val pairQRKey: String?,
    val isFinishSuccess: Int,
    val waitCostTime: Long,
    val qrNetCostTime: Long,
    val currentStepId: Int?,
    val stepResult: StepResult?,
    val pinCode: String,
) : UiState

sealed class DeviceConnectUiEvent : UiEvent {
    data class StartSmartStepHelperUiEvent(val stepId: Int) : DeviceConnectUiEvent()
}

sealed class DeviceConnectUiAction : UiAction {
    data class InitData(
        val productInfo: StepData.ProductInfo?,
        val did: String,
        val stepId: Int,
        val stepResult: Boolean,
        val pairQRKey: String?
    ) :
        DeviceConnectUiAction()

    data class ConnectStatus(val isFinishSuccess: Int) : DeviceConnectUiAction()
    object SaveWifiIInfo : DeviceConnectUiAction()
    data class WaitCostTime(val success: Boolean, val finish: Boolean = false) :
        DeviceConnectUiAction()

    data class QrNetWaitCostTime(
        val success: Boolean,
        val finish: Boolean = false,
        val pairClickTime: Long = 0
    ) : DeviceConnectUiAction()

    object StartSmartStepHelperUiAction : DeviceConnectUiAction()

    data class InputPinCode(val pinCode: String) : DeviceConnectUiAction()

    data class CurrentStepId(val stepId: Int, val stepResult: StepResult) : DeviceConnectUiAction()
}
