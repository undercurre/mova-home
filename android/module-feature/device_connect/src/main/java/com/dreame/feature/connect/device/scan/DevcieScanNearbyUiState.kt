package com.dreame.feature.connect.device.scan

import android.dreame.module.bean.device.DreameWifiDeviceBean
import com.dreame.feature.connect.device.scan.uiconfig.DeviceUiConfig
import com.dreame.module.base.mvi.UiAction
import com.dreame.module.base.mvi.UiEvent
import com.dreame.module.base.mvi.UiState
import com.dreame.smartlife.config.step.StepData


data class DevcieScanNearbyUiState(
    val isLoading: Boolean,
    val productInfo: StepData.ProductInfo?,
    val uiConfig: DeviceUiConfig?
) : UiState


sealed class DevcieScanNearbyUiEvent : UiEvent {
    data class ShowToast(val message: String?) : DevcieScanNearbyUiEvent()
}

sealed class DevcieScanNearbyUiAction : UiAction {
    data class InitData(val productInfo: StepData.ProductInfo?) : DevcieScanNearbyUiAction()

    data class SelectDevice(val bean: DreameWifiDeviceBean?) : DevcieScanNearbyUiAction()

    data class InitScanUiConfig(val scanUiConfig: DeviceUiConfig) : DevcieScanNearbyUiAction()
    data class ChangeScanUiConfig(
        val scanUiConfig: DeviceUiConfig,
        val list: MutableList<DreameWifiDeviceBean>
    ) : DevcieScanNearbyUiAction()
}
