package com.dreame.feature.connect.device.boot

import com.dreame.module.base.mvi.UiAction
import com.dreame.module.base.mvi.UiEvent
import com.dreame.module.base.mvi.UiState
import com.dreame.smartlife.config.step.StepData

data class DeviceBootUpUiState(
    val isLoading: Boolean,
    val productInfo: StepData.ProductInfo?,
    val bindDomain: String?,
    val filePath: String?
) : UiState

sealed class DeviceBootUpUiEvent : UiEvent {

}

sealed class DeviceBootUpUiAction : UiAction {
    data class InitData(val productInfo: StepData.ProductInfo?) : DeviceBootUpUiAction()
}
