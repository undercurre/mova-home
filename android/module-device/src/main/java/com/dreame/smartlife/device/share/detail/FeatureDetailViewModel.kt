package com.dreame.smartlife.device.share.detail

import android.dreame.module.data.datasource.remote.DeviceShareRemoteDataSource
import android.dreame.module.data.repostitory.DeviceShareRepository
import androidx.lifecycle.viewModelScope
import com.dreame.module.base.mvi.BaseViewModel
import com.dreame.module.base.mvi.UiAction
import com.zj.mvi.core.setState
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.onCompletion
import kotlinx.coroutines.flow.onStart
import kotlinx.coroutines.launch
import android.dreame.module.data.Result

class FeatureDetailViewModel : BaseViewModel<FeatureDetailUiState, FeatureDetailUiEvent>() {
    private val repo = DeviceShareRepository(DeviceShareRemoteDataSource())

    override fun createInitialState(): FeatureDetailUiState {
        return FeatureDetailUiState(
            did = "",
            pid = "",
            featureList = emptyList()
        )
    }

    override fun dispatchAction(acton: UiAction) {
        when (acton) {
            is FeatureDetailUiAction.InitAction -> {
                _uiStates.setState {
                    copy(
                        did = acton.did ?: "",
                        pid = acton.pid ?: ""
                    )
                }
            }
            is FeatureDetailUiAction.RefreshFeatureAction -> {
                getAllDeviceShareFeatures(_uiStates.value.pid, _uiStates.value.did)
            }
        }
    }

    private fun getAllDeviceShareFeatures(productId: String, did: String) {
        viewModelScope.launch {
            repo.getUserDeviceShareFeatures(productId, did, null)
                .collect {
                    when (it) {
                        is Result.Success -> {
                            _uiStates.setState {
                                copy(
                                    featureList = it.data
                                )
                            }
                        }
                        is Result.Error -> {

                        }
                        else -> {

                        }
                    }
                }
        }
    }

}