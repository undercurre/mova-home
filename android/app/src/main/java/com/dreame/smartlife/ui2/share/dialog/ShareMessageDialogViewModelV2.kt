package com.dreame.smartlife.ui2.share.dialog

import android.dreame.module.RouteServiceProvider
import android.dreame.module.data.Result
import android.dreame.module.data.datasource.remote.MessageRemoteDataSource
import android.dreame.module.data.getString
import android.dreame.module.data.repostitory.MessageRepository
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.dreame.module.base.mvi.UiAction
import com.dreame.module.service.app.flutter.IFlutterBridgeService
import com.dreame.smartlife.R
import kotlinx.coroutines.flow.onCompletion
import kotlinx.coroutines.flow.onStart
import kotlinx.coroutines.launch

class ShareMessageDialogViewModelV2 : ViewModel() {

    private val messageRepo: MessageRepository =
        MessageRepository(MessageRemoteDataSource())

    var showLoading: ((Boolean) -> Unit)? = null
    var uiEvents: ((ShareMessageDialogUiEvent) -> Unit)? = null

    fun dispatchAction(acton: UiAction) {
        if (acton is ShareMessageDialogUiAction.AckShareFromMessageAction) {
            ackShareFromMessage(acton.messageId, acton.accept)
        } else if (acton is ShareMessageDialogUiAction.AckShareFromDeviceAction) {
            ackShareFromDevice(acton.accept, acton.deviceId, acton.model, acton.ownUid)
        } else if (acton is ShareMessageDialogUiAction.ReadMessageByIdAction) {
            readShareMessageById(acton.messageId)
        }
    }

    private fun ackShareFromMessage(
        messageId: String,
        accept: Boolean
    ) {
        viewModelScope.launch {
            messageRepo.ackShareFromMessage(messageId, accept)
                .onStart {
                    showLoading?.invoke(true)
                }
                .onCompletion {
                    showLoading?.invoke(false)
                }
                .collect {
                    ackResult(it)
                }
        }
    }

    private fun ackShareFromDevice(
        accept: Boolean,
        deviceId: String,
        model: String,
        ownUid: String
    ) {
        viewModelScope.launch {
            messageRepo.ackShareFromDevice(accept, deviceId, model, ownUid)
                .onStart {
                    showLoading?.invoke(true)
                }
                .onCompletion {
                    showLoading?.invoke(false)
                }
                .collect {
                    ackResult(it)
                }
        }
    }

    private suspend fun ackResult(it: Result<Nothing>) {
        if (it is Result.Success) {
            uiEvents?.invoke(ShareMessageDialogUiEvent.ShowToast(getString(R.string.operate_success)))
        } else if (it is Result.Error) {
            when (it.exception.code) {
                60000, 60400, 60900, 60901, 40040 -> {
                    uiEvents?.invoke(ShareMessageDialogUiEvent.ShowToast(getString(R.string.share_msg_already_invalid)))
                }

                else -> {
                    uiEvents?.invoke(ShareMessageDialogUiEvent.ShowToast(getString(R.string.toast_server_error)))
                }
            }
        }
        uiEvents?.invoke(ShareMessageDialogUiEvent.DismissDialog)
    }

    private fun readShareMessageById(id: String?) {
        if (!id.isNullOrEmpty()) {
            viewModelScope.launch {
                messageRepo.readShareMessageByIds(id)
                    .onStart {
//                        _uiStates.setState {
//                            copy(isLoading = true)
//                        }
                    }
                    .onCompletion {
//                        _uiStates.setState {
//                            copy(isLoading = false)
//                        }
                    }
                    .collect {
                        if (it is Result.Success) {
                            RouteServiceProvider.getService<IFlutterBridgeService>()
                                ?.readShareMessage()
                        }
                    }
            }
        }

    }
}