package com.dreame.smartlife.device.share.confirm

import android.dreame.module.data.entry.device.DeviceFeatureShareRes
import android.dreame.module.data.entry.device.ShareUserRes
import com.dreame.module.base.mvi.UiAction
import com.dreame.module.base.mvi.UiEvent
import com.dreame.module.base.mvi.UiState

data class FeatureShareConfirmUiState(
    val did: String?,
    val pid: String?,
    val shareUser: ShareUserRes?,
    val isLoading: Boolean,
    val featureList: List<DeviceFeatureShareRes>?
) : UiState

sealed class FeatureShareConfirmUiEvent : UiEvent {
    data class ShowToast(val message: String?) : FeatureShareConfirmUiEvent()
    object SharedSuccess : FeatureShareConfirmUiEvent()
}

sealed class FeatureShareConfirmUiAction : UiAction {
    data class InitAction(val did: String?, val pid: String?, val shareUser: ShareUserRes?) :
        FeatureShareConfirmUiAction()

    object RefreshFeatureAction : FeatureShareConfirmUiAction()

    object ShareFeatureAction: FeatureShareConfirmUiAction()
}