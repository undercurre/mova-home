package com.dreame.smartlife.device.share.update

import android.dreame.module.data.datasource.remote.DeviceShareRemoteDataSource
import android.dreame.module.data.repostitory.DeviceShareRepository
import androidx.lifecycle.viewModelScope
import com.dreame.module.base.mvi.BaseViewModel
import com.dreame.module.base.mvi.UiAction
import com.zj.mvi.core.setState
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch
import android.dreame.module.data.Result
import android.dreame.module.data.getString
import android.dreame.module.util.LogUtil
import android.util.Log
import com.dreame.smartlife.device.R
import com.dreame.smartlife.device.share.confirm.FeatureShareConfirmUiEvent
import com.zj.mvi.core.setEvent
import kotlinx.coroutines.flow.onCompletion
import kotlinx.coroutines.flow.onStart

class FeatureUpdateViewModel : BaseViewModel<FeatureUpdateUiState, FeatureUpdateUiEvent>() {
    private val repo = DeviceShareRepository(DeviceShareRemoteDataSource())

    override fun createInitialState(): FeatureUpdateUiState {
        return FeatureUpdateUiState(
            did = "",
            pid = "",
            shareUser = null,
            isLoading = false,
            featureList = emptyList(),
            enableUpdate = false,
            oldFeatures = ""
        )
    }

    override fun dispatchAction(acton: UiAction) {
        when (acton) {
            is FeatureUpdateUiAction.InitAction -> {
                _uiStates.setState {
                    copy(
                        did = acton.did ?: "",
                        pid = acton.pid ?: "",
                        shareUser = acton.shareUser
                    )
                }
            }
            is FeatureUpdateUiAction.RefreshFeatureAction -> {
                getUserDeviceShareFeatures(
                    _uiStates.value.pid ?: "",
                    _uiStates.value.did ?: "",
                    _uiStates.value.shareUser?.uid ?: ""
                )
            }
            is FeatureUpdateUiAction.FeatureStatusUpdateAction -> {
                val featureList = mutableListOf<String>()
                _uiStates.value.featureList?.forEach {
                    if (it.open) {
                        featureList.add(it.permitKey)
                    }
                }
                val newFeatures = featureList.joinToString(",")
                LogUtil.i(
                    "dispatchAction: oldFeatures----${_uiStates.value.oldFeatures},newFeatures----$newFeatures"
                )
                _uiStates.setState {
                    copy(
                        enableUpdate = oldFeatures != newFeatures
                    )
                }
            }
            is FeatureUpdateUiAction.FeatureUpdateSubmitAction -> {
                updateUserFeature()
            }
            is FeatureUpdateUiAction.CheckBackAction -> {
                viewModelScope.launch {
                    _uiEvents.setEvent(FeatureUpdateUiEvent.CheckBackEvent(_uiStates.value.enableUpdate))
                }
            }
        }
    }

    private fun getUserDeviceShareFeatures(productId: String, did: String, shareUid: String) {
        viewModelScope.launch {
            repo.getUserDeviceShareFeatures(productId, did, shareUid)
                .collect {
                    when (it) {
                        is Result.Success -> {
                            val featureList = mutableListOf<String>()
                            it.data?.forEach { feature ->
                                if (feature.open) {
                                    featureList.add(feature.permitKey)
                                }
                            }
                            featureList.joinToString(",")
                            _uiStates.setState {
                                copy(
                                    featureList = it.data,
                                    oldFeatures = featureList.joinToString(",")
                                )
                            }
                            LogUtil.i(
                                "getUserDeviceShareFeatures: ${_uiStates.value.oldFeatures}"
                            )
                        }
                        is Result.Error -> {

                        }
                        else -> {

                        }
                    }
                }
        }
    }

    private fun updateUserFeature() {
        viewModelScope.launch {
            val featureList = mutableListOf<String>()
            _uiStates.value.featureList?.forEach {
                if (it.open) {
                    featureList.add(it.permitKey)
                }
            }
            repo.updateUserFeatures(
                _uiStates.value.did ?: "",
                _uiStates.value.shareUser?.uid ?: "",
                featureList.joinToString(",")
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
                        _uiEvents.setEvent(FeatureUpdateUiEvent.ShowToast(getString(R.string.text_permission_has_updated)))
                        _uiEvents.setEvent(FeatureUpdateUiEvent.UpdateSuccess)
                    } else if (it is Result.Error) {
                        if (it.exception.code == -1) {
                            _uiEvents.setEvent(FeatureUpdateUiEvent.ShowToast(it.exception.message))
                        } else {
                            _uiEvents.setEvent(FeatureUpdateUiEvent.ShowToast(getString(R.string.operate_failed)))
                        }
                    } else {
                    }
                }
        }
    }
}