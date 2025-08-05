package com.dreame.feature.connect.device.mower.trigger

import com.dreame.module.base.mvi.UiAction
import com.dreame.module.base.mvi.UiEvent
import com.dreame.module.base.mvi.UiState
import com.dreame.smartlife.config.step.StepData


data class BleDeviceTriggerUiState(
    val isLoading: Boolean,
    val isReset: Boolean,
    val isBleAgain: Boolean,
    val isSettingView: Boolean,
    val timestamp: Long,

    val productInfo: StepData.ProductInfo?,
    val language: String?,

    val productImageUrl: String?,
    val productTitle: String?,
    val productIntro: String?,
) : UiState


sealed class BleDeviceTriggerUiEvent : UiEvent {
    data class ShowToast(val message: String?) : BleDeviceTriggerUiEvent()
    object GotoNext : BleDeviceTriggerUiEvent()
    data class OpenBluetooth(val forceOpen: Boolean, val again: Boolean) : BleDeviceTriggerUiEvent()


}

sealed class BleDeviceTriggerUiAction : UiAction {
    // 确认Wi-Fi无密码
    data class InitData(val language: String?, val productInfo: StepData.ProductInfo?) : BleDeviceTriggerUiAction()
    data class ClickReset(val isSelect: Boolean, val isSettingView: Boolean) : BleDeviceTriggerUiAction()
    object NewIntent : BleDeviceTriggerUiAction()
    object CheckBluetoothOpen : BleDeviceTriggerUiAction()
    object ClickGotoNext : BleDeviceTriggerUiAction()

}
