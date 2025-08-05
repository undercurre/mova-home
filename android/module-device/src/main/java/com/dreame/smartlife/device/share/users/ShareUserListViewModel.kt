package com.dreame.smartlife.device.share.users

import android.dreame.module.data.Result
import android.dreame.module.data.datasource.remote.DeviceShareRemoteDataSource
import android.dreame.module.data.getString
import android.dreame.module.data.repostitory.DeviceShareRepository
import android.dreame.module.event.EventCode
import android.dreame.module.event.EventMessage
import androidx.lifecycle.viewModelScope
import com.dreame.module.base.mvi.BaseViewModel
import com.dreame.module.base.mvi.UiAction
import com.dreame.smartlife.device.R
import com.zj.mvi.core.setEvent
import com.zj.mvi.core.setState
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.onCompletion
import kotlinx.coroutines.flow.onStart
import kotlinx.coroutines.launch
import org.greenrobot.eventbus.EventBus

class ShareUserListViewModel : BaseViewModel<ShareUserListUiState, ShareUserListUiEvent>() {
    private val repo = DeviceShareRepository(DeviceShareRemoteDataSource())

    override fun createInitialState(): ShareUserListUiState {
        return ShareUserListUiState(
            did = "",
            deviceName = "",
            pid = "",
            showShareFeature = false,
            isRefresh = false,
            isLoading = false,
            shareUserList = emptyList()
        )
    }

    override fun dispatchAction(acton: UiAction) {
        when (acton) {
            is ShareUserListUiAction.InitAction -> {
                _uiStates.setState {
                    copy(
                        did = acton.did ?: "",
                        deviceName = acton.deviceName ?: "",
                        pid = acton.pid ?: "",
                        showShareFeature = acton.showShareFeature ?: false
                    )
                }
            }
            is ShareUserListUiAction.RefreshUserListAction -> {
                getShareUserList(_uiStates.value.did)
            }
            is ShareUserListUiAction.DeleteShareUserAction -> {
                deleteShareUser(_uiStates.value.did, acton.shareUid)
            }
        }
    }

    private fun getShareUserList(did: String) {
        viewModelScope.launch {
            repo.getShareUserListByDid(did)
                .onStart {
                    _uiStates.setState {
                        copy(
                            isRefresh = true
                        )
                    }
                }
                .onCompletion {
                    _uiStates.setState {
                        copy(
                            isRefresh = false
                        )
                    }
                }
                .collect {
                    when (it) {
                        is Result.Success -> {
                            _uiStates.setState {
                                copy(
                                    shareUserList = it.data
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

    private fun deleteShareUser(did: String, shareUid: String) {
        viewModelScope.launch {
            repo.deleteShareUser(did, shareUid)
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
                    if (it is Result.Success && it.data == true) {
                        val list = _uiStates.value.shareUserList?.toMutableList()
                        val removeUser = list?.find { deleteShareUserRet ->
                            deleteShareUserRet.uid == shareUid
                        }
                        removeUser?.let {
                            list?.remove(removeUser)
                        }
                        _uiStates.setState {
                            copy(
                                shareUserList = list
                            )
                        }
                        EventBus.getDefault()
                            .post(EventMessage<Any?>(EventCode.SHARE_OR_DELETE_DEVICE_SUCCESS))
                        _uiEvents.setEvent(ShareUserListUiEvent.ShowToast(getString(R.string.delete_success)))
                    } else if (it is Result.Error) {
                        if (it.exception.code == -1) {
                            _uiEvents.setEvent(ShareUserListUiEvent.ShowToast(it.exception.message))
                        } else {
                            _uiEvents.setEvent(ShareUserListUiEvent.ShowToast(getString(R.string.delete_failed)))
                        }
                    } else {
                    }
                }
        }
    }
}