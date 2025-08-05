package com.dreame.smartlife.account.account.password.modify

import android.dreame.module.RouteServiceProvider
import android.dreame.module.data.Result
import android.dreame.module.data.datasource.remote.PasswordRemoteDataSource
import android.dreame.module.data.getString
import android.dreame.module.data.repostitory.SettingPasswordRepository
import android.dreame.module.data.succeeded
import android.dreame.module.trace.EventCommonHelper.eventCommonPageInsert
import android.dreame.module.util.CommonUtil
import androidx.lifecycle.viewModelScope
import com.dreame.module.base.mvi.BaseViewModel
import com.dreame.module.base.mvi.UiAction
import com.dreame.module.service.app.ILogoutClearService
import com.dreame.module.service.app.flutter.IFlutterBridgeService
import com.dreame.smartlife.account.R
import com.dreame.smartlife.account.account.password.setting.SetPasswordUiEvent
import com.zj.mvi.core.setState
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.onCompletion
import kotlinx.coroutines.flow.onStart
import kotlinx.coroutines.launch

class ModifyPasswordViewModel : BaseViewModel<ModifyPasswordUiState, ModifyPasswordUiEvent>() {

    private val setPasswordRepository = SettingPasswordRepository(
        PasswordRemoteDataSource()
    )

    override fun createInitialState(): ModifyPasswordUiState {

        return ModifyPasswordUiState(
            password = "",
            newPassword = "",
            confirmPassword = "",
            enableConfirm = false,
            isLoading = false,
            showPasswordCipher = false,
            showNewCipher = false,
            showConfirmCipher = false,
        )
    }

    override fun dispatchAction(acton: UiAction) {
        if (acton is ModifyPasswordUiAction.InputPasswordAction) {
            val enableConfirm = acton.password.isNotBlank() && _uiStates.value.newPassword.isNotBlank() && _uiStates.value.confirmPassword.isNotBlank()
            val showPasswordCipher = acton.password.isNotBlank()
            _uiStates.setState {
                copy(
                    password = acton.password, enableConfirm = enableConfirm, showPasswordCipher = showPasswordCipher
                )
            }
        } else if (acton is ModifyPasswordUiAction.InputNewPasswordAction) {
            val enableConfirm = acton.newPassword.isNotBlank() && _uiStates.value.confirmPassword.isNotBlank() && _uiStates.value.password.isNotBlank()
            val showNewCipher = acton.newPassword.isNotBlank()
            _uiStates.setState {
                copy(
                    newPassword = acton.newPassword, enableConfirm = enableConfirm, showNewCipher = showNewCipher
                )
            }
        } else if (acton is ModifyPasswordUiAction.InputConfirmPasswordAction) {
            val enableConfirm = acton.confirmPassword.isNotBlank() && _uiStates.value.password.isNotBlank() && _uiStates.value.newPassword.isNotBlank()
            val showConfirmCipher = acton.confirmPassword.isNotBlank()
            _uiStates.setState {
                copy(
                    confirmPassword = acton.confirmPassword, enableConfirm = enableConfirm, showConfirmCipher = showConfirmCipher
                )
            }
        } else if (acton is ModifyPasswordUiAction.ModifyPasswordAction) {
            modifyPassword()
        }
    }

    private fun modifyPassword() {
        viewModelScope.launch {
            val (password, newPassword, confirmPassword) = _uiStates.value
            if (password.isNotBlank() && confirmPassword.isNotBlank()) {
                if (newPassword != confirmPassword) {
                    _uiEvents.send(ModifyPasswordUiEvent.ShowToast(getString(R.string.pwd_different)))
                    return@launch
                }
                if (!CommonUtil.isVerifyPwd(newPassword)) {
                    _uiEvents.send(ModifyPasswordUiEvent.ShowToast(getString(R.string.pwd_error)))
                    return@launch
                }
                if (password == newPassword) {
                    _uiEvents.send(ModifyPasswordUiEvent.ShowToast(getString(R.string.reset_original_password_duplicate)))
                    return@launch
                }
            }
            setPasswordRepository.modifyPassword(password, newPassword, confirmPassword).onStart {
                _uiStates.setState {
                    copy(isLoading = true)
                }
            }.onCompletion {
                _uiStates.setState {
                    copy(isLoading = false)
                }
            }.collect {
                eventCommonPageInsert(7, 6, this.hashCode(), if (it.succeeded) 1 else 0)
                if (it is Result.Success) {

                    RouteServiceProvider.getService<ILogoutClearService>()?.prepareLogout()
                    RouteServiceProvider.getService<IFlutterBridgeService>()?.logoff {
                        viewModelScope.launch {
                            _uiEvents.send(ModifyPasswordUiEvent.ShowToast(getString(R.string.reset_success)))
                            _uiEvents.send(ModifyPasswordUiEvent.ModifyPasswordSuccess)
                            RouteServiceProvider.getService<IFlutterBridgeService>()?.gotoFlutterPluginActivity()
                        }
                    }
                } else if (it is Result.Error) {
                    val message = when (it.exception.code) {
                        10009 -> getString(R.string.pwd_invalid)
                        30400 -> getString(R.string.phone_not_registered)
                        30401 -> getString(R.string.user_not_exist)

                        30916 -> getString(R.string.reset_original_password_error)
                        30917 -> getString(R.string.reset_original_password_too_much)
                        30918 -> getString(R.string.reset_original_password_duplicate)
                        -1 -> it.exception.message
                        else -> getString(R.string.operate_failed)
                    }
                    _uiEvents.send(ModifyPasswordUiEvent.ShowToast(message))
                }
            }
        }
    }
}
