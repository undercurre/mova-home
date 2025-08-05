package com.dreame.smartlife.device.share

import android.dreame.module.data.entry.device.ShareUserRes
import com.dreame.module.base.mvi.UiAction
import com.dreame.module.base.mvi.UiEvent
import com.dreame.module.base.mvi.UiState

data class DeviceShareUiState(
    val did: String?,
    val pid: String?,
    val inputText: String?,
    val enableNext: Boolean,
    val isLoading: Boolean,
    val shareUserList: List<ShareUserRes>?
) : UiState

sealed class DeviceShareUiEvent : UiEvent {
    data class ShowToast(val message: String?) : DeviceShareUiEvent()
    data class CheckSuccess(val shareUser: ShareUserRes) : DeviceShareUiEvent()
}

sealed class DeviceShareUiAction : UiAction {
    data class InitAction(val did: String, val pid: String) : DeviceShareUiAction()
    object QueryRecentContacts : DeviceShareUiAction()
    data class InputTextAction(val text: String) : DeviceShareUiAction()
    object QueryKeywordAction :
        DeviceShareUiAction()

    data class CheckUserAction(val shareUser: ShareUserRes) :
        DeviceShareUiAction()
}