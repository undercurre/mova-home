package com.dreame.feature.connect.device.qrtips

import com.dreame.module.base.mvi.BaseViewModel
import com.dreame.module.base.mvi.UiAction
import com.zj.mvi.core.setState

class DeviceScanQRTipsViewModel : BaseViewModel<DeviceScanQRTipsUiState, DeviceScanQRTipsUiEvent>() {
    override fun createInitialState(): DeviceScanQRTipsUiState {
        return DeviceScanQRTipsUiState(false, null)
    }

    override fun dispatchAction(acton: UiAction) {
        when (acton) {
            is DeviceScanQRTipsUiAction.InitData -> {
                _uiStates.setState { copy(productInfo = acton.productInfo) }
            }
        }
    }
}