package com.dreame.feature.connect.device.scan

import com.dreame.module.base.mvi.BaseViewModel
import com.dreame.module.base.mvi.UiAction
import com.zj.mvi.core.setState

class DevcieScanNearbyViewModel :
    BaseViewModel<DevcieScanNearbyUiState, DevcieScanNearbyUiEvent>() {
    override fun createInitialState(): DevcieScanNearbyUiState {
        return DevcieScanNearbyUiState(false, null, null)
    }

    override fun dispatchAction(acton: UiAction) {
        when (acton) {
            is DevcieScanNearbyUiAction.InitData -> {
                _uiStates.setState { copy(productInfo = acton.productInfo) }
            }

            is DevcieScanNearbyUiAction.InitScanUiConfig -> {
                _uiStates.setState { copy(uiConfig = acton.scanUiConfig) }
            }

            is DevcieScanNearbyUiAction.ChangeScanUiConfig -> {
                val uiConfig = uiStates.value.uiConfig
                if (uiConfig != acton.scanUiConfig) {
                    uiConfig?.onHide()
                    _uiStates.setState { copy(uiConfig = acton.scanUiConfig) }
                    acton.scanUiConfig.onShow()
                }
                //
                acton.scanUiConfig.onScanUpdateList(acton.list)
            }
        }
    }
}