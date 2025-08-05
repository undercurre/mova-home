package com.dreame.smartlife.device.share.detail

import android.dreame.module.data.entry.device.DeviceFeatureShareRes
import com.dreame.module.base.mvi.UiAction
import com.dreame.module.base.mvi.UiEvent
import com.dreame.module.base.mvi.UiState

data class FeatureDetailUiState(
    val did:String,
    val pid:String,
    val featureList: List<DeviceFeatureShareRes>?
) : UiState

sealed class FeatureDetailUiEvent : UiEvent {
    data class ShowToast(val message: String?) : FeatureDetailUiEvent()
}

sealed class FeatureDetailUiAction : UiAction {
    data class InitAction(val did: String?, val pid: String?) :
        FeatureDetailUiAction()
    object RefreshFeatureAction :
        FeatureDetailUiAction()
}