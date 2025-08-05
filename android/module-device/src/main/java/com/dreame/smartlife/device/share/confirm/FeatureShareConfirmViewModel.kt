package com.dreame.smartlife.device.share.confirm

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
import android.dreame.module.data.getString
import android.util.Log
import com.dreame.smartlife.device.R
import com.zj.mvi.core.setEvent

class FeatureShareConfirmViewModel :
    BaseViewModel<FeatureShareConfirmUiState, FeatureShareConfirmUiEvent>() {
    private val repo = DeviceShareRepository(DeviceShareRemoteDataSource())

    override fun createInitialState(): FeatureShareConfirmUiState {
        return FeatureShareConfirmUiState(
            did = "",
            pid = "",
            shareUser = null,
            isLoading = false,
            featureList = emptyList()
        )
    }

    override fun dispatchAction(acton: UiAction) {
        when (acton) {
            is FeatureShareConfirmUiAction.InitAction -> {
                _uiStates.setState {
                    copy(
                        did = acton.did ?: "",
                        pid = acton.pid ?: "",
                        shareUser = acton.shareUser
                    )
                }
            }
            is FeatureShareConfirmUiAction.RefreshFeatureAction -> {
                getAllDeviceShareFeatures(
                    _uiStates.value.pid ?: ""
                )
            }
            is FeatureShareConfirmUiAction.ShareFeatureAction -> {
                shareWithFeatures()
            }
        }
    }

    private fun getAllDeviceShareFeatures(productId: String) {
        viewModelScope.launch {
            repo.getAllDeviceShareFeatures(productId)
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

    private fun shareWithFeatures() {
        viewModelScope.launch {
            val featureList = mutableListOf<String>()
            _uiStates.value.featureList?.forEach {
                if (it.open) {
                    featureList.add(it.permitKey)
                }
            }
            repo.shareWithFeatures(
                _uiStates.value.did ?: "",
                _uiStates.value.shareUser?.uid ?: "",
                if (featureList.isNotEmpty()) featureList.joinToString(",") else null
            )
                .onStart {
                    _uiStates.setState {
                        copy(isLoading = true)
                    }
                }
                .onCompletion {
                    _uiStates.setState {
                        copy(isLoading = false)
                    }
                }
                .collect {
                    if (it is Result.Success) {
                        _uiEvents.setEvent(FeatureShareConfirmUiEvent.ShowToast(getString(R.string.share_device_success)))
                        _uiEvents.setEvent(FeatureShareConfirmUiEvent.SharedSuccess)
                    } else if (it is Result.Error) {
                        if (it.exception.code == -1) {
                            _uiEvents.setEvent(FeatureShareConfirmUiEvent.ShowToast(it.exception.message))
                        } else {
                            _uiEvents.setEvent(FeatureShareConfirmUiEvent.ShowToast(getString(R.string.share_device_to_user_error)))
                        }
                    } else {
                    }
                }
        }
    }
}