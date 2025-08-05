package com.dreame.smartlife.account.account.password.setting

import android.dreame.module.data.Result
import android.dreame.module.data.datasource.remote.PasswordRemoteDataSource
import android.dreame.module.data.getString
import android.dreame.module.data.repostitory.SettingPasswordRepository
import android.dreame.module.event.EventCode
import android.dreame.module.event.EventMessage
import android.dreame.module.util.CommonUtil
import androidx.lifecycle.viewModelScope
import com.dreame.module.base.mvi.BaseViewModel
import com.dreame.module.base.mvi.UiAction
import com.dreame.smartlife.account.R
import com.zj.mvi.core.setState
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.onCompletion
import kotlinx.coroutines.flow.onStart
import kotlinx.coroutines.launch
import org.greenrobot.eventbus.EventBus

class SetPasswordViewModel :
    BaseViewModel<SetPasswordUiState, SetPasswordUiEvent>() {

    private val setPasswordRepository = SettingPasswordRepository(
        PasswordRemoteDataSource()
    )

    override fun createInitialState(): SetPasswordUiState {

        return SetPasswordUiState(
            password = "",
            confirmPassword = "",
            enableConfirm = false,
            isLoading = false,
            showPasswordCipher = false,
            showConfirmCipher = false,
        )
    }

    override fun dispatchAction(acton: UiAction) {
        if (acton is SetPasswordUiAction.SetPasswordInitAction) {

        } else if (acton is SetPasswordUiAction.InputPasswordAction) {
            val enableConfirm =
                acton.password.isNotBlank() && _uiStates.value.confirmPassword.isNotBlank()
            val showConfirmCipher = acton.password.isNotBlank()
            _uiStates.setState {
                copy(
                    password = acton.password,
                    enableConfirm = enableConfirm,
                    showPasswordCipher = showConfirmCipher
                )
            }
        } else if (acton is SetPasswordUiAction.InputConfirmPasswordAction) {
            val enableConfirm =
                acton.confirmPassword.isNotBlank() && _uiStates.value.password.isNotBlank()
            val showConfirmCipher = acton.confirmPassword.isNotBlank()
            _uiStates.setState {
                copy(
                    confirmPassword = acton.confirmPassword,
                    enableConfirm = enableConfirm,
                    showConfirmCipher = showConfirmCipher,
                )
            }
        } else if (acton is SetPasswordUiAction.SetPasswordAction) {
            setPassword()
        }
    }

    private fun setPassword() {
        viewModelScope.launch {
            val (password, confirmPassword) = _uiStates.value
            if (password.isNotBlank() && confirmPassword.isNotBlank()) {
                if (password != confirmPassword) {
                    _uiEvents.send(SetPasswordUiEvent.ShowToast(getString(R.string.pwd_different)))
                    return@launch
                }
                if (!CommonUtil.isVerifyPwd(password)) {
                    _uiEvents.send(SetPasswordUiEvent.ShowToast(getString(R.string.pwd_error)))
                    return@launch
                }
            }
            setPasswordRepository.settingPassword(password, confirmPassword)
                .onStart {
                    _uiStates.setState {
                        copy(isLoading = true)
                    }
                }.onCompletion {
                    _uiStates.setState {
                        copy(isLoading = false)
                    }
                }.collect {
                    if (it is Result.Success) {
                        EventBus.getDefault().post(EventMessage(EventCode.REFRESH_USER_INFO_WITH_REQUEST, ""))
                        _uiEvents.send(SetPasswordUiEvent.ShowToast(getString(R.string.setting_success)))
                        _uiEvents.send(SetPasswordUiEvent.SetPasswordSuccess)
                    } else if (it is Result.Error) {
                        val message = when (it.exception.code) {
                            11006 -> getString(R.string.sms_code_invalid_expired)
                            10009 -> getString(R.string.pwd_invalid)
                            30400 -> getString(R.string.phone_not_registered)
                            30401 -> getString(R.string.user_not_exist)
                            30918 -> getString(R.string.reset_original_password_duplicate)
                            -1 -> it.exception.message
                            else -> getString(R.string.setting_failure)
                        }
                        _uiEvents.send(SetPasswordUiEvent.ShowToast(message))
                    }
                }
        }
    }
}
