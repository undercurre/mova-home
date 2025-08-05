package com.dreame.feature.connect.device.mower.connect

import com.dreame.module.base.mvi.UiAction
import com.dreame.module.base.mvi.UiEvent
import com.dreame.module.base.mvi.UiState
import com.dreame.smartlife.config.step.StepData

data class DeviceConnectBleUiState(
    val isLoading: Boolean,
    val productInfo: StepData.ProductInfo?,
    val isAfterSales: Boolean,
    val did: String,
    val stepId: Int,
    val stepResult: Boolean,
    val pairQRKey: String?,
    val isFinishSuccess: Int,
    val waitCostTime: Long,
    val qrNetCostTime: Long,

    val pinCode: String,
) : UiState

sealed class DeviceConnectBleUiEvent : UiEvent {

}

sealed class DeviceConnectBleUiAction : UiAction {
    data class InitData(val productInfo: StepData.ProductInfo?, val did: String, val stepId: Int, val stepResult: Boolean, val pairQRKey: String?) :
        DeviceConnectBleUiAction()

    data class ConnectStatus(val isFinishSuccess: Int) : DeviceConnectBleUiAction()
    data class UpdateProductInfo(val bindDoamin: String, val wifiName: String, val wifiPwd: String) : DeviceConnectBleUiAction()
    object SaveWifiIInfo : DeviceConnectBleUiAction()
    data class WaitCostTime(val success: Boolean, val finish: Boolean = false) : DeviceConnectBleUiAction()
    data class QrNetWaitCostTime(val success: Boolean, val finish: Boolean = false, val pairClickTime: Long = 0) : DeviceConnectBleUiAction()

    data class ShowLoading(val show: Boolean) : DeviceConnectBleUiAction()

    data class InputPinCode(val pinCode: String) : DeviceConnectBleUiAction()
}
