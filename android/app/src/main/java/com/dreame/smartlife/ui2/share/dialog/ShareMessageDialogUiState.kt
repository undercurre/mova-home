package com.dreame.smartlife.ui2.share.dialog

import com.dreame.module.base.mvi.UiAction
import com.dreame.module.base.mvi.UiEvent
import com.dreame.module.base.mvi.UiState

data class ShareMessageDialogUiState(
    val isLoading:Boolean,
):UiState

sealed class ShareMessageDialogUiEvent : UiEvent {
    data class ShowToast(val message: String?) : ShareMessageDialogUiEvent()
    object DismissDialog: ShareMessageDialogUiEvent()
}

sealed class ShareMessageDialogUiAction : UiAction {
    data class AckShareFromMessageAction(val messageId:String,val accept:Boolean) : ShareMessageDialogUiAction()
    data class AckShareFromDeviceAction(val accept: Boolean,
                                        val deviceId: String,
                                        val model: String,
                                        val ownUid: String) : ShareMessageDialogUiAction()

    data class ReadMessageByIdAction(val messageId: String?) : ShareMessageDialogUiAction()
}