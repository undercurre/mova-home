package com.dreame.smartlife.account.account.password.modify

import com.dreame.module.base.mvi.UiAction
import com.dreame.module.base.mvi.UiEvent
import com.dreame.module.base.mvi.UiState

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2022/09/05
 *     desc   :
 *     version: 1.0
 * </pre>
 */
data class ModifyPasswordUiState(
    val password: String,
    val newPassword: String,
    val confirmPassword: String,
    val enableConfirm: Boolean,
    val isLoading: Boolean,

    val showPasswordCipher: Boolean,
    val showNewCipher: Boolean,
    val showConfirmCipher: Boolean,
) : UiState

sealed class ModifyPasswordUiEvent : UiEvent {
    data class ShowToast(val message: String?) : ModifyPasswordUiEvent()
    object ModifyPasswordSuccess : ModifyPasswordUiEvent()
}

sealed class ModifyPasswordUiAction : UiAction {

    data class InputPasswordAction(val password: String) : ModifyPasswordUiAction()
    data class InputNewPasswordAction(val newPassword: String) : ModifyPasswordUiAction()
    data class InputConfirmPasswordAction(val confirmPassword: String) : ModifyPasswordUiAction()
    object ModifyPasswordAction : ModifyPasswordUiAction()
}