package com.dreame.smartlife.device.share.manage

import android.dreame.module.LocalApplication
import android.dreame.module.data.Result
import android.dreame.module.data.datasource.remote.DeviceShareRemoteDataSource
import android.dreame.module.data.getString
import android.dreame.module.data.repostitory.DeviceShareRepository
import android.dreame.module.manager.LanguageManager
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

class ShareDeviceListViewModel : BaseViewModel<ShareDeviceListUiState, ShareDeviceListUiEvent>() {

    private val repo = DeviceShareRepository(DeviceShareRemoteDataSource())

    override fun createInitialState(): ShareDeviceListUiState {
        return ShareDeviceListUiState(
            isRefresh = false,
            isLoadingMore = false,
            deviceList = emptyList(),
            currentPage = 0,
            pageSize = 100,
            enableLoadMore = false,
            isLoading = false
        )
    }

    override fun dispatchAction(acton: UiAction) {
        if (acton is ShareDeviceListUiAction.RefreshDeviceListAction) {
            getDeviceList(true, acton.isMaster)
        } else if (acton is ShareDeviceListUiAction.LoadMoreDeviceListAction) {
            getDeviceList(false, acton.isMaster)
        } else if (acton is ShareDeviceListUiAction.DeleteDeviceAction) {
            deleteDeviceByDid(acton.did)
        }
    }

    private fun getDeviceList(isRefresh: Boolean, isMaster: Boolean) {
        val currentPage = _uiStates.value.currentPage
        val pageSize = _uiStates.value.pageSize
        val lan = LanguageManager.getInstance().getLangTag(LocalApplication.getInstance())
        viewModelScope.launch {
            repo.queryDeviceList(currentPage, pageSize, lan, isMaster)
                .onStart {
                    if (isRefresh) {
                        _uiStates.setState {
                            copy(
                                isRefresh = true
                            )
                        }
                    } else {
                        _uiStates.setState {
                            copy(
                                isLoadingMore = true
                            )
                        }
                    }
                }
                .onCompletion {
                    if (isRefresh) {
                        _uiStates.setState {
                            copy(
                                isRefresh = false
                            )
                        }
                    } else {
                        _uiStates.setState {
                            copy(
                                isLoadingMore = false
                            )
                        }
                    }
                }
                .collect { result ->
                    if (result is Result.Success) {
                        val deviceList = result.data?.page?.records
                        val recordsSize = if (deviceList.isNullOrEmpty()) 0 else deviceList.size
                        val enableLoadMore = recordsSize >= _uiStates.value.pageSize
                        if (enableLoadMore) {
                            _uiStates.setState {
                                copy(
                                    pageSize = _uiStates.value.pageSize + 1
                                )
                            }
                        }
                        if (isRefresh) {
                            _uiStates.setState {
                                copy(
                                    deviceList = deviceList,
                                    enableLoadMore = enableLoadMore
                                )
                            }
                        } else {
                            val list = _uiStates.value.deviceList?.toMutableList()
                            list?.addAll(result.data?.page?.records ?: emptyList())
                            _uiStates.setState {
                                copy(
                                    deviceList = deviceList,
                                    enableLoadMore = enableLoadMore
                                )
                            }
                        }

                    } else if (result is Result.Error) {

                    } else {
                    }
                }
        }
    }

    private fun deleteDeviceByDid(did: String) {
        viewModelScope.launch {
            repo.deleteDeviceByDid(did)
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
                }.collect {
                    if (it is Result.Success && it.data == true) {
                        _uiEvents.setEvent(ShareDeviceListUiEvent.DeleteDeviceSuccess)
                        _uiEvents.setEvent(ShareDeviceListUiEvent.ShowToast(getString(R.string.delete_success)))
                    } else if (it is Result.Error) {
                        if (it.exception.code == -1) {
                            _uiEvents.setEvent(ShareDeviceListUiEvent.ShowToast(it.exception.message))
                        } else {
                            _uiEvents.setEvent(ShareDeviceListUiEvent.ShowToast(getString(R.string.delete_failed)))
                        }
                    } else {
                    }
                }
        }
    }
}