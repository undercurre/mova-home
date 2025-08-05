package com.dreame.smartlife.device.share.users

import android.dreame.module.data.entry.device.ShareUserRes
import com.dreame.module.base.mvi.UiAction
import com.dreame.module.base.mvi.UiEvent
import com.dreame.module.base.mvi.UiState

data class ShareUserListUiState(
    val did: String,
    val deviceName: String,
    val pid: String,
    val showShareFeature: Boolean,
    val isRefresh: Boolean,
    val isLoading: Boolean,
    val shareUserList: List<ShareUserRes>?
) : UiState

sealed class ShareUserListUiEvent : UiEvent {
    data class ShowToast(val message: String?) : ShareUserListUiEvent()
}

sealed class ShareUserListUiAction : UiAction {
    data class InitAction(val did: String?, val deviceName: String?, val pid: String?,val showShareFeature: Boolean?) :
        ShareUserListUiAction()

    object RefreshUserListAction : ShareUserListUiAction()
    data class DeleteShareUserAction(val shareUid: String) : ShareUserListUiAction()
}