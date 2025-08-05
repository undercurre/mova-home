package com.dreame.feature.connect.qr

import android.dreame.module.bean.device.DreameWifiDeviceBean
import com.dreame.module.base.mvi.UiAction
import com.dreame.module.base.mvi.UiEvent
import com.dreame.module.base.mvi.UiState
import com.dreame.smartlife.config.step.StepData

data class QRDeviceScanUiState(
    val language: String,
    val isLoading: Boolean,
    val isFlashlightOpen: Boolean,
    val fromSettingPage: Boolean,
    val fromHome: Boolean,
    val isCheckFirst: Boolean = true,
    val filterQrCode: Boolean = false,
    val time: Long = 0L,
    val productInfo: StepData.ProductInfo?,
    val nearbyDevice: DreameWifiDeviceBean?,
    val qrPositionUrl: String?,
    val scanType: Int,
) : UiState


sealed class QRDeviceScanUiEvent : UiEvent {
    data class ShowToast(val message: String?) : QRDeviceScanUiEvent()
    object ManualConnect : QRDeviceScanUiEvent()
    object ShowFailedDialog : QRDeviceScanUiEvent()
    object RestQrScan : QRDeviceScanUiEvent()
    data class QrCodeAddPluginList(val result: String) : QRDeviceScanUiEvent()

    data class BarcodeSuccess(val result: String) : QRDeviceScanUiEvent()
}

sealed class QrDeviceScanUiAction : UiAction {

    data class InitData(val language: String, val fromHome: Boolean, val filterQrCode: Boolean, val scanType: Int) : QrDeviceScanUiAction()

    data class FlashlightOpen(val open: Boolean) : QrDeviceScanUiAction()
    object FromSettingPage : QrDeviceScanUiAction()
    object ViewQRPoistion : QrDeviceScanUiAction()

    data class SettingIsCheckFirst(val isCheckFirst: Boolean) : QrDeviceScanUiAction()
    data class OnQRScanTouchSuccess(val result: String?) : QrDeviceScanUiAction()
    data class NearbyDevice(val device: DreameWifiDeviceBean?) : QrDeviceScanUiAction()
    object NearbyDeviceClick : QrDeviceScanUiAction()

}
