package com.dreame.smartlife.account.account.password.setting

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
data class SetPasswordUiState(
    val password: String,
    val confirmPassword: String,
    val enableConfirm: Boolean,
    val isLoading: Boolean,
    val showPasswordCipher: Boolean,
    val showConfirmCipher: Boolean,

    ) : UiState

sealed class SetPasswordUiEvent : UiEvent {
    data class ShowToast(val message: String?) : SetPasswordUiEvent()
    object SetPasswordSuccess : SetPasswordUiEvent()
}

sealed class SetPasswordUiAction : UiAction {
    data class InputPasswordAction(val password: String) : SetPasswordUiAction()
    object SetPasswordInitAction : SetPasswordUiAction()
    data class InputConfirmPasswordAction(val confirmPassword: String) : SetPasswordUiAction()
    object SetPasswordAction : SetPasswordUiAction()
}