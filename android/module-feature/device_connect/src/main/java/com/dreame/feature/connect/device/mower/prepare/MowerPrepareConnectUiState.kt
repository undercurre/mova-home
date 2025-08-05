package com.dreame.feature.connect.device.mower.prepare

import com.dreame.module.base.mvi.UiAction
import com.dreame.module.base.mvi.UiEvent
import com.dreame.module.base.mvi.UiState
import com.dreame.smartlife.config.step.StepData

data class MowerPrepareConnectUiState(
    val isLoading: Boolean,
    val productInfo: StepData.ProductInfo?,
    val image: String?,
    val video: String?,
    val isShowBtn: Boolean,
    val bind_domain: String?,
) : UiState

sealed class MowerPrepareConnectUiEvent : UiEvent {
    object GotoNext : MowerPrepareConnectUiEvent()
}

sealed class MowerPrepareConnectUiAction : UiAction {
    data class InitData(val productInfo: StepData.ProductInfo?, val isShowBtn: Boolean = true) :
        MowerPrepareConnectUiAction()

    object RequestBindDomain : MowerPrepareConnectUiAction()
}
