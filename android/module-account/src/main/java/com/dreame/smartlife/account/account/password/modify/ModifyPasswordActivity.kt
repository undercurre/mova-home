package com.dreame.smartlife.account.account.password.modify

import android.dreame.module.RoutPath
import android.dreame.module.RouteServiceProvider
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.util.toast.ToastUtils
import androidx.activity.viewModels
import com.therouter.router.Route
import com.dreame.module.base.mvi.BaseActivity
import com.dreame.module.service.app.flutter.IFlutterBridgeService
import com.dreame.smartlife.account.databinding.ActivityModifyPasswordBinding
import com.zj.mvi.core.observeEvent
import com.zj.mvi.core.observeState

/**
 * 修改密码
 */
@Route(path = RoutPath.PASSWORD_MODIFY)
class ModifyPasswordActivity : BaseActivity<ActivityModifyPasswordBinding>() {

    private val viewModel by viewModels<ModifyPasswordViewModel>()

    override fun initData() {

    }

    override fun initView() {

    }

    override fun initListener() {
        binding.fieldPassword.addAfterTextChangedListener {
            viewModel.dispatchAction(ModifyPasswordUiAction.InputPasswordAction(it?.toString() ?: ""))
        }
        binding.fieldNewPassword.addAfterTextChangedListener {
            viewModel.dispatchAction(
                ModifyPasswordUiAction.InputNewPasswordAction(
                    it?.toString() ?: ""
                )
            )
        }
        binding.fieldConfirmPassword.addAfterTextChangedListener {
            viewModel.dispatchAction(
                ModifyPasswordUiAction.InputConfirmPasswordAction(
                    it?.toString() ?: ""
                )
            )
        }

        binding.btnConfirm.setOnShakeProofClickListener {
            viewModel.dispatchAction(ModifyPasswordUiAction.ModifyPasswordAction)
        }

        binding.tvBack.setOnShakeProofClickListener {
            finish()
        }
    }

    override fun observe() {
        viewModel.uiStates.let { states ->
            states.observeState(this, ModifyPasswordUiState::isLoading) {
                if (it) {
                    showLoading()
                } else {
                    dismissLoading()
                }
            }

            states.observeState(this, ModifyPasswordUiState::enableConfirm) {
                binding.btnConfirm.isEnabled = it
            }
        }
        viewModel.uiEvents.observeEvent(this) {
            if (it is ModifyPasswordUiEvent.ShowToast) {
                ToastUtils.show(it.message)
            } else if (it is ModifyPasswordUiEvent.ModifyPasswordSuccess) {
                showModifySuccess()
            }
        }
    }

    private fun showModifySuccess() {
        // 跳转登录界面，重新登录
        RouteServiceProvider.getService<IFlutterBridgeService>()?.sendMessage("resetApp")
        RouteServiceProvider.getService<IFlutterBridgeService>()?.gotoFlutterPluginActivity()
        finish()
    }

}