package com.dreame.smartlife.device.share.manage

import android.dreame.module.data.entry.Device
import com.dreame.module.base.mvi.UiAction
import com.dreame.module.base.mvi.UiEvent
import com.dreame.module.base.mvi.UiState

data class ShareDeviceListUiState(
    val isRefresh: Boolean,
    val isLoadingMore: Boolean,
    val deviceList: List<Device>?,
    val currentPage: Int,
    val pageSize: Int,
    val enableLoadMore: Boolean? = false,
    val isLoading: Boolean
) : UiState

sealed class ShareDeviceListUiEvent : UiEvent {
    data class ShowToast(val message: String?) : ShareDeviceListUiEvent()
    object DeleteDeviceSuccess: ShareDeviceListUiEvent()
}

sealed class ShareDeviceListUiAction : UiAction {
    data class RefreshDeviceListAction(val isMaster: Boolean) : ShareDeviceListUiAction()
    data class LoadMoreDeviceListAction(val isMaster: Boolean) : ShareDeviceListUiAction()
    data class DeleteDeviceAction(val did: String) : ShareDeviceListUiAction()
}