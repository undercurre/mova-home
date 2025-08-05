package com.dreame.feature.connect.device.qrtips

import com.dreame.module.base.mvi.UiAction
import com.dreame.module.base.mvi.UiEvent
import com.dreame.module.base.mvi.UiState
import com.dreame.smartlife.config.step.StepData

data class DeviceScanQRTipsUiState(
    val isLoading: Boolean,
    val productInfo: StepData.ProductInfo?
) : UiState

sealed class DeviceScanQRTipsUiEvent : UiEvent {

}

sealed class DeviceScanQRTipsUiAction : UiAction {
    data class InitData(val productInfo: StepData.ProductInfo?) : DeviceScanQRTipsUiAction()
}
