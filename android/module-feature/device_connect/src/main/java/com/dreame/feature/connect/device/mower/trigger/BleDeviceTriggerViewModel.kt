package com.dreame.feature.connect.device.mower.trigger

import android.dreame.module.data.Result
import android.dreame.module.data.datasource.local.ProductLocalDataSource
import android.dreame.module.data.datasource.remote.ProductRemoteDataSource
import android.dreame.module.data.getString
import android.dreame.module.data.repostitory.ProductRepository
import android.dreame.module.manager.AreaManager
import androidx.lifecycle.viewModelScope
import com.dreame.feature.connect.router.password.RouterConnectPasswordUiEvent
import com.dreame.module.base.mvi.BaseViewModel
import com.dreame.module.base.mvi.UiAction
import com.dreame.smartlife.config.step.ScanType
import com.dreame.smartlife.connect.R
import com.zj.mvi.core.setState
import kotlinx.coroutines.flow.onCompletion
import kotlinx.coroutines.flow.onStart
import kotlinx.coroutines.launch
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlin.coroutines.resume

class BleDeviceTriggerViewModel : BaseViewModel<BleDeviceTriggerUiState, BleDeviceTriggerUiEvent>() {
    private val repository = ProductRepository(ProductRemoteDataSource(), ProductLocalDataSource())
    override fun createInitialState(): BleDeviceTriggerUiState {
        return BleDeviceTriggerUiState(
            false, false, false, false, System.currentTimeMillis(),
            null, null, null, null, null
        )
    }

    override fun dispatchAction(acton: UiAction) {
        when (acton) {
            is BleDeviceTriggerUiAction.InitData -> {
                _uiStates.setState {
                    copy(language = acton.language, productInfo = acton.productInfo)
                }
                viewModelScope.launch {
                    queryDeviceConnectDesc()
                }
            }

            is BleDeviceTriggerUiAction.ClickReset -> {
                _uiStates.setState { copy(isReset = acton.isSelect, isSettingView = acton.isSettingView) }
            }

            is BleDeviceTriggerUiAction.NewIntent -> {
                _uiStates.setState { copy(isReset = false, isSettingView = true, timestamp = System.currentTimeMillis()) }
            }

            is BleDeviceTriggerUiAction.CheckBluetoothOpen -> {
                checkBluetoothIsOpen()
            }

            is BleDeviceTriggerUiAction.ClickGotoNext -> {
                viewModelScope.launch {
                    _uiEvents.send(BleDeviceTriggerUiEvent.GotoNext)
                }
            }
        }
    }

    private fun checkBluetoothIsOpen() {
        viewModelScope.launch {
            val productInfo = uiStates.value.productInfo
            if (productInfo?.scType == ScanType.WIFI_BLE || productInfo?.scType == ScanType.BLE) {
                // 一定要打开权限，且打开蓝牙
                _uiEvents.send(BleDeviceTriggerUiEvent.OpenBluetooth(productInfo.scType == ScanType.BLE, uiStates.value.isBleAgain))
            } else {
                _uiEvents.send(BleDeviceTriggerUiEvent.GotoNext)
            }
            _uiStates.setState { copy(isBleAgain = true) }
        }
    }


    /**
     * 查询机器配网指引
     */
    private suspend fun queryDeviceConnectDesc() {
        repository.getProductConnectIns(uiStates.value.productInfo?.productId ?: "", uiStates.value.language ?: "")
            .onStart {
                _uiStates.setState { copy(isLoading = true) }
            }.onCompletion {
                _uiStates.setState { copy(isLoading = false) }
            }.collect {
                if (it is Result.Success) {
                    it.data?.let {
                        val imageUrl = it.instruction?.image?.imageUrl
                        val intro = it.instruction?.intro
                        val title = it.instruction?.title
                        _uiStates.setState { copy(productImageUrl = imageUrl, productIntro = intro, productTitle = title) }
                    }
                } else if (it is Result.Error) {

                }
            }
    }


}