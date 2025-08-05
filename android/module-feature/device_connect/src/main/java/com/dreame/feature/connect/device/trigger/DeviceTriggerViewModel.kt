package com.dreame.feature.connect.device.trigger

import android.dreame.module.data.Result
import android.dreame.module.data.datasource.local.ProductLocalDataSource
import android.dreame.module.data.datasource.remote.ProductRemoteDataSource
import android.dreame.module.data.repostitory.ProductRepository
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ModuleCode
import android.dreame.module.trace.PairNetEventCode
import androidx.lifecycle.viewModelScope
import com.dreame.feature.connect.trace.BuriedConnectHelper
import com.dreame.module.base.mvi.BaseViewModel
import com.dreame.module.base.mvi.UiAction
import com.dreame.smartlife.config.step.ScanType
import com.zj.mvi.core.setState
import kotlinx.coroutines.flow.onCompletion
import kotlinx.coroutines.flow.onStart
import kotlinx.coroutines.launch

class DeviceTriggerViewModel : BaseViewModel<DeviceTriggerUiState, DeviceTriggerUiEvent>() {
    private val repository = ProductRepository(ProductRemoteDataSource(), ProductLocalDataSource())
    override fun createInitialState(): DeviceTriggerUiState {
        return DeviceTriggerUiState(
            false, false, false, false, System.currentTimeMillis(),
            null, null, null, null, null
        )
    }

    override fun dispatchAction(acton: UiAction) {
        when (acton) {
            is DeviceTriggerUiAction.InitData -> {
                _uiStates.setState {
                    copy(language = acton.language, productInfo = acton.productInfo)
                }
                queryDeviceConnectDesc()
            }

            is DeviceTriggerUiAction.ClickReset -> {
                _uiStates.setState { copy(isReset = acton.isSelect, isSettingView = acton.isSettingView) }
            }

            is DeviceTriggerUiAction.NewIntent -> {
                _uiStates.setState { copy(isReset = false, isSettingView = true, timestamp = System.currentTimeMillis()) }
            }

            is DeviceTriggerUiAction.CheckStayTime -> {
                // 判断小于8秒，弹弹框
                checkStayTime()
            }

            is DeviceTriggerUiAction.CheckBluetoothOpen -> {
                checkBluetoothIsOpen()
            }

            is DeviceTriggerUiAction.ClickGotoNext -> {
                viewModelScope.launch {
                    _uiEvents.send(DeviceTriggerUiEvent.GotoNext)
                }
            }
        }
    }

    private fun checkBluetoothIsOpen() {
        viewModelScope.launch {
            val productInfo = uiStates.value.productInfo
            if (productInfo?.scType == ScanType.WIFI_BLE || productInfo?.scType == ScanType.BLE) {
                // 一定要打开权限，且打开蓝牙
                _uiEvents.send(DeviceTriggerUiEvent.OpenBluetooth(productInfo.scType == ScanType.BLE, uiStates.value.isBleAgain))
            } else {
                _uiEvents.send(DeviceTriggerUiEvent.GotoNext)
            }
            _uiStates.setState { copy(isBleAgain = true) }
        }
    }

    private fun checkStayTime() {
        val l = System.currentTimeMillis() - uiStates.value.timestamp
        if (l < 8 * 1000) {
            viewModelScope.launch {
                EventCommonHelper.eventCommonPageInsert(
                    ModuleCode.PairNetNew.code, PairNetEventCode.TriggerApAlert.code, hashCode(),
                    "", uiStates.value.productInfo?.realProductModel ?: uiStates.value.productInfo?.productModel ?: "",
                    int1 = (l / 1000).toInt(), str1 = BuriedConnectHelper.currentSessionID()
                )
                _uiEvents.send(DeviceTriggerUiEvent.ShowStayTips)
            }
        } else {
            checkBluetoothIsOpen()
        }
    }

    /**
     * 查询机器配网指引
     */
    private fun queryDeviceConnectDesc() {
        viewModelScope.launch {
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
}