package com.dreame.feature.connect.device.qrnet

import android.graphics.Bitmap
import com.dreame.module.base.mvi.UiAction
import com.dreame.module.base.mvi.UiEvent
import com.dreame.module.base.mvi.UiState
import com.dreame.smartlife.config.step.StepData


data class DeviceQrNetUiState(
    val isLoading: Boolean,
    val productInfo: StepData.ProductInfo?,

    val targetWifiName: String,
    val targetWifiPwd: String,
    val langTag: String,
    val domain: String,
    val pairQRKey: String,
    val qrcodeBitmap: Bitmap?,
    val timestamp: Long,
    val isGenerating: Boolean,
    val clickTime: Long,
) : UiState


sealed class DeviceQrNetUiEvent : UiEvent {
    data class ShowToast(val message: String?) : DeviceQrNetUiEvent()
    data class QueryDomainError(val message: String) : DeviceQrNetUiEvent()
    data class CreateQRCodeError(val message: String) : DeviceQrNetUiEvent()
    data class GotoNext(val bindSuccess: Boolean, val did: String, val clickTime: Long = 0) : DeviceQrNetUiEvent()

}

sealed class DeviceQrNetUiAction : UiAction {
    data class InitData(
        val productInfo: StepData.ProductInfo?, val langTag: String,
        val targetWifiName: String, val targetWifiPwd: String
    ) : DeviceQrNetUiAction()

    object CreateQRCodeRetry : DeviceQrNetUiAction()
    object QueryDomainRetry : DeviceQrNetUiAction()
    object QueryQRNetResult : DeviceQrNetUiAction()
    object OnStart : DeviceQrNetUiAction()
    object OnStop : DeviceQrNetUiAction()
    data class GotoNext(val bindSuccess: Boolean, val clickTime: Long = 0) : DeviceQrNetUiAction()
}
