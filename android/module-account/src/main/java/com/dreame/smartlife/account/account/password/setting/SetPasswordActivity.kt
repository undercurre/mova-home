package com.dreame.smartlife.account.account.password.setting

import android.app.Activity
import android.content.Intent
import android.dreame.module.ext.setOnShakeProofClickListener
import androidx.activity.viewModels
import com.therouter.router.Route
import android.dreame.module.RoutPath
import com.dreame.module.base.mvi.BaseActivity
import com.dreame.smartlife.account.databinding.ActivitySettingPasswordBinding
import android.dreame.module.util.toast.ToastUtils
import com.zj.mvi.core.observeEvent
import com.zj.mvi.core.observeState

/**
 * 修改密码， 未设置过密码，则设置密码
 */
@Route(path = RoutPath.PASSWORD_SETTING)
class SetPasswordActivity : BaseActivity<ActivitySettingPasswordBinding>() {
    private val viewModel by viewModels<SetPasswordViewModel>()

    override fun initData() {

    }

    override fun initView() {

    }

    override fun initListener() {
        binding.fieldPassword.addAfterTextChangedListener {
            viewModel.dispatchAction(SetPasswordUiAction.InputPasswordAction(it?.toString() ?: ""))
        }
        binding.fieldConfirmPassword.addAfterTextChangedListener {
            viewModel.dispatchAction(
                SetPasswordUiAction.InputConfirmPasswordAction(
                    it?.toString() ?: ""
                )
            )
        }
        binding.btnCommit.setOnShakeProofClickListener {
            viewModel.dispatchAction(SetPasswordUiAction.SetPasswordAction)
        }
        binding.tvBack.setOnShakeProofClickListener {
            finish()
        }
    }

    override fun observe() {
        viewModel.uiStates.let { states ->
            states.observeState(this, SetPasswordUiState::isLoading) {
                if (it) {
                    showLoading()
                } else {
                    dismissLoading()
                }
            }
            states.observeState(this, SetPasswordUiState::enableConfirm) {
                binding.btnCommit.isEnabled = it
            }

//            states.observeState(this, SetPasswordUiState::showPasswordCipher) {
//                binding.fieldPassword.setCiphertextVisible(it)
//            }
//
//            states.observeState(this, SetPasswordUiState::showConfirmCipher) {
//                binding.fieldConfirmPassword.setCiphertextVisible(it)
//            }

        }
        viewModel.uiEvents.observeEvent(this) {
            if (it is SetPasswordUiEvent.ShowToast) {
                ToastUtils.show(it.message)
            } else if (it is SetPasswordUiEvent.SetPasswordSuccess) {
                val data = Intent()
                data.putExtra("hasPassword",true)
                setResult(Activity.RESULT_OK,data)
                finish()
            }
        }
    }
}