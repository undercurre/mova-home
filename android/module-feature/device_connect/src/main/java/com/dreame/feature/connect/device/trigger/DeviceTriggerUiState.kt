package com.dreame.feature.connect.device.trigger

import com.dreame.module.base.mvi.UiAction
import com.dreame.module.base.mvi.UiEvent
import com.dreame.module.base.mvi.UiState
import com.dreame.smartlife.config.step.StepData


data class DeviceTriggerUiState(
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


sealed class DeviceTriggerUiEvent : UiEvent {
    data class ShowToast(val message: String?) : DeviceTriggerUiEvent()
    object ShowStayTips : DeviceTriggerUiEvent()
    object GotoNext : DeviceTriggerUiEvent()
    data class OpenBluetooth(val forceOpen: Boolean, val again: Boolean) : DeviceTriggerUiEvent()


}

sealed class DeviceTriggerUiAction : UiAction {
    // 确认Wi-Fi无密码
    data class InitData(val language: String?, val productInfo: StepData.ProductInfo?) : DeviceTriggerUiAction()
    data class ClickReset(val isSelect: Boolean, val isSettingView: Boolean) : DeviceTriggerUiAction()
    object NewIntent : DeviceTriggerUiAction()
    object CheckStayTime : DeviceTriggerUiAction()
    object CheckBluetoothOpen : DeviceTriggerUiAction()
    object ClickGotoNext : DeviceTriggerUiAction()

}
