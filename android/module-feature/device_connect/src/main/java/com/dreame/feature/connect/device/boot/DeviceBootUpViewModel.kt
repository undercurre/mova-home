package com.dreame.feature.connect.device.boot

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
import com.dreame.smartlife.connect.R
import com.zj.mvi.core.setState
import kotlinx.coroutines.flow.onCompletion
import kotlinx.coroutines.flow.onStart
import kotlinx.coroutines.launch
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlin.coroutines.resume

class DeviceBootUpViewModel : BaseViewModel<DeviceBootUpUiState, DeviceBootUpUiEvent>() {
    private val repository = ProductRepository(ProductRemoteDataSource(), ProductLocalDataSource())

    override fun createInitialState(): DeviceBootUpUiState {
        return DeviceBootUpUiState(false, null, null, null)
    }

    override fun dispatchAction(acton: UiAction) {
        when (acton) {
            is DeviceBootUpUiAction.InitData -> {
                val bindDomain = acton.productInfo?.targetDomain
                _uiStates.setState { copy(productInfo = acton.productInfo, bindDomain = bindDomain) }
                viewModelScope.launch {
                    queryOpenDeviceImage()
                }
                if (bindDomain.isNullOrBlank()) {
                    /// 其他配网不需要 设置Wi-Fi信息，在开机时校验bindDomain
                    getMqttDomainV2()
                }
            }

        }
    }

    private fun getMqttDomainV2() {
        viewModelScope.launch {
            repository.getMqttDomainV2(AreaManager.getRegion(), false).collect {
                if (it is Result.Success) {
                    _uiStates.setState { copy(productInfo = uiStates.value.productInfo?.copy(targetDomain = it.data?.regionUrl ?: "")) }
                }
            }
        }
    }

    /**
     * 获取开启设备图片
     */
    private fun queryOpenDeviceImage() {
        viewModelScope.launch {
            val productId = uiStates.value.productInfo?.productId ?: ""
            val stepDescription = "turnOnDevice"
            repository.getOpenDeviceInfo(productId, stepDescription)
                .onStart {
                    _uiStates.setState { copy(isLoading = true) }
                }
                .onCompletion {
                    _uiStates.setState { copy(isLoading = false) }
                }
                .collect { result ->
                    val filePath = (result as? Result.Success)?.data?.filePath
                    if (!filePath.isNullOrEmpty()) {
                        _uiStates.setState {
                            copy(filePath = filePath)
                        }
                    } else if (result is Result.Error) {
                        ///显示默认图片
                    }
                }
        }
    }
}