package com.dreame.smartlife.device.share

import android.dreame.module.data.Result
import android.dreame.module.data.datasource.remote.DeviceShareRemoteDataSource
import android.dreame.module.data.entry.device.ShareUserRes
import android.dreame.module.data.getString
import android.dreame.module.data.repostitory.DeviceShareRepository
import androidx.lifecycle.viewModelScope
import com.dreame.module.base.mvi.BaseViewModel
import com.dreame.module.base.mvi.UiAction
import com.dreame.smartlife.device.R
import com.zj.mvi.core.setEvent
import com.zj.mvi.core.setState
import kotlinx.coroutines.flow.onCompletion
import kotlinx.coroutines.flow.onStart
import kotlinx.coroutines.launch

class DeviceShareViewModel : BaseViewModel<DeviceShareUiState, DeviceShareUiEvent>() {

    private val repo = DeviceShareRepository(DeviceShareRemoteDataSource())
    override fun createInitialState(): DeviceShareUiState {
        return DeviceShareUiState(
            did = null,
            pid = null,
            inputText = null,
            enableNext = false,
            isLoading = false,
            shareUserList = emptyList()
        )
    }

    override fun dispatchAction(acton: UiAction) {
        when (acton) {
            is DeviceShareUiAction.InitAction -> {
                _uiStates.setState {
                    copy(
                        did = acton.did,
                        pid = acton.pid
                    )
                }
            }
            is DeviceShareUiAction.QueryRecentContacts -> {
                queryShareContactList()
            }
            is DeviceShareUiAction.QueryKeywordAction -> {
                checkUserByKeyword(_uiStates.value.inputText ?: "")
            }
            is DeviceShareUiAction.CheckUserAction -> {
                checkUser(acton.shareUser)
            }
            is DeviceShareUiAction.InputTextAction -> {
                val enableNext = !acton.text.isNullOrEmpty()
                _uiStates.setState {
                    copy(
                        inputText = acton.text,
                        enableNext = enableNext
                    )
                }
            }
        }
    }

    private fun checkUserByKeyword(keyword: String) {
        viewModelScope.launch {
            repo.queryUserInfoByKeyword(keyword, _uiStates.value.did ?: "").onStart {
                _uiStates.setState {
                    copy(
                        isLoading = true
                    )
                }
            }
                .onCompletion {
                    _uiStates.setState {
                        copy(
                            isLoading = false
                        )
                    }
                }
                .collect {
                    if (it is Result.Success && it.data != null) {
                        _uiEvents.setEvent(DeviceShareUiEvent.CheckSuccess(it.data!!))
                    } else if (it is Result.Error) {
                        handleError(it)
                    } else {
                    }
                }
        }
    }

    private fun checkUser(shareUser: ShareUserRes) {
        viewModelScope.launch {
            repo.checkUser(_uiStates.value.did ?: "", shareUser.uid ?: "").onStart {
                _uiStates.setState {
                    copy(
                        isLoading = true
                    )
                }
            }
                .onCompletion {
                    _uiStates.setState {
                        copy(
                            isLoading = false
                        )
                    }
                }
                .collect {
                    if (it is Result.Success) {
                        if (it.data == true) {
                            _uiEvents.setEvent(DeviceShareUiEvent.CheckSuccess(shareUser))
                        }
                    } else if (it is Result.Error) {
                        handleError(it)
                    } else {
                    }
                }
        }
    }

    private fun queryShareContactList() {
        viewModelScope.launch {
            repo.getShareContactList(20)
                .onStart {
                    _uiStates.setState {
                        copy(
                            isLoading = true
                        )
                    }
                }
                .onCompletion {
                    _uiStates.setState {
                        copy(
                            isLoading = false
                        )
                    }
                }
                .collect {
                    if (it is Result.Success) {
                        _uiStates.setState {
                            copy(
                                shareUserList = it.data
                            )
                        }
                    }
                }
        }
    }

    private suspend fun handleError(error: Result.Error) {
        when (error.exception.code) {
            -1 -> _uiEvents.setEvent(DeviceShareUiEvent.ShowToast(error.exception.message))
            -2 -> _uiEvents.setEvent(DeviceShareUiEvent.ShowToast(getString(R.string.invalid_account_to_retry)))
            40010 -> _uiEvents.setEvent(DeviceShareUiEvent.ShowToast(getString(R.string.share_device_over_times)))
            40030 -> _uiEvents.setEvent(DeviceShareUiEvent.ShowToast(getString(R.string.share_wait_deal)))
            40031 -> _uiEvents.setEvent(DeviceShareUiEvent.ShowToast(getString(R.string.share_already_share)))
            40040 -> _uiEvents.setEvent(DeviceShareUiEvent.ShowToast(getString(R.string.share_device_not_exist)))
            40033 -> _uiEvents.setEvent(DeviceShareUiEvent.ShowToast(getString(R.string.share_reject_with_yourself)))
            40070 -> _uiEvents.setEvent(DeviceShareUiEvent.ShowToast(getString(R.string.Toast_DeviceShare_UserOutOfService)))
            else -> _uiEvents.setEvent(DeviceShareUiEvent.ShowToast(getString(R.string.operate_failed)))
        }
    }
}