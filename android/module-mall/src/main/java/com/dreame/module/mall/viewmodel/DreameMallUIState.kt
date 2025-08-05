package com.dreame.module.mall.viewmodel

import com.dreame.module.base.mvi.UiAction
import com.dreame.module.base.mvi.UiEvent
import com.dreame.module.base.mvi.UiState

data class DreameMallUIState(
    val sessionId: String,
    val userId: String,
    val timestamp: Long,
    val coupon: Int,
    val score: Int,

    ) : UiState

sealed class DreameMallUiEvent : UiEvent {
    data class ShowToast(val message: String?) : DreameMallUiEvent()
}

sealed class DreameMallUiAction : UiAction {
    object DreameMallLoginAction : DreameMallUiAction()
    object DreameMallPersonInfoAction : DreameMallUiAction()
}