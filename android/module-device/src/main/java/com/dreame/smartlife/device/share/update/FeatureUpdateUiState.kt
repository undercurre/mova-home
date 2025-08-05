package com.dreame.smartlife.device.share.update

import android.dreame.module.data.entry.device.DeviceFeatureShareRes
import android.dreame.module.data.entry.device.ShareUserRes
import com.dreame.module.base.mvi.UiAction
import com.dreame.module.base.mvi.UiEvent
import com.dreame.module.base.mvi.UiState

data class FeatureUpdateUiState(
    val did: String?,
    val pid: String?,
    val shareUser: ShareUserRes?,
    val isLoading: Boolean,
    val featureList: List<DeviceFeatureShareRes>?,
    val enableUpdate: Boolean,
    val oldFeatures:String,
) : UiState

sealed class FeatureUpdateUiEvent : UiEvent {
    data class ShowToast(val message: String?) : FeatureUpdateUiEvent()

    object UpdateSuccess : FeatureUpdateUiEvent()
    data class CheckBackEvent(val needUpdate: Boolean) : FeatureUpdateUiEvent()
}

sealed class FeatureUpdateUiAction : UiAction {
    data class InitAction(val did: String?, val pid: String?, val shareUser: ShareUserRes?) :
        FeatureUpdateUiAction()

    object RefreshFeatureAction : FeatureUpdateUiAction()

    object FeatureStatusUpdateAction : FeatureUpdateUiAction()

    object CheckBackAction : FeatureUpdateUiAction()

    object FeatureUpdateSubmitAction: FeatureUpdateUiAction()
}