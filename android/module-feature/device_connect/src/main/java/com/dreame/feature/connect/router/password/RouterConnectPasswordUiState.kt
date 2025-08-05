package com.dreame.feature.connect.router.password

import com.dreame.module.base.mvi.UiAction
import com.dreame.module.base.mvi.UiEvent
import com.dreame.module.base.mvi.UiState
import com.dreame.smartlife.config.step.StepData


data class RouterConnectPasswordUiState(
    val isLoading: Boolean,
    val isAfterSale: Boolean,
    val wifiCacheMap: LinkedHashMap<String, String>,
    val productInfo: StepData.ProductInfo?,
    val currentWifiName: String,
    val wifiPassword: String?,
    val coundownTime: Int = 8,
    val isWifiConnect: Boolean,
    val frequency: Int,
    val capabilities: String,
    val buttonEnable: Boolean,
    val domain: String,
    val pairQRKey: String,
    val configType: Boolean,
) : UiState


sealed class RouterConnectPasswordUiEvent : UiEvent {
    data class ShowToast(val message: String?) : RouterConnectPasswordUiEvent()
    object ShowNetworkFrequencyBandError : RouterConnectPasswordUiEvent()
    object ShowConfirmNoPassword : RouterConnectPasswordUiEvent()
    object Success : RouterConnectPasswordUiEvent()


}

sealed class RouterConnectPasswordUiAction : UiAction {

    data class InitData(val productInfo: StepData.ProductInfo?, val configType: Boolean) : RouterConnectPasswordUiAction()

    data class WifiChange(val wifiName: String?, val isConnect: Boolean, val frequency: Int, val capabilities: String) :
        RouterConnectPasswordUiAction()

    data class WifiPassword(val password: String?) : RouterConnectPasswordUiAction()
    data class WifiPassword2(val wifiName: String, val password: String) : RouterConnectPasswordUiAction()

    // 检查网络频段
    object CheckNetworkCondition : RouterConnectPasswordUiAction()

    // 确认Wi-Fi频段
    object CheckNetworkFrequencyBandSkip : RouterConnectPasswordUiAction()

    // 确认Wi-Fi无密码
    object ConfirmNoPasswordSkip : RouterConnectPasswordUiAction()


}
