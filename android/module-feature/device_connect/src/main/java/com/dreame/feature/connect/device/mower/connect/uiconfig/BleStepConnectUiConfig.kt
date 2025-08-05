package com.dreame.feature.connect.device.mower.connect.uiconfig

import android.dreame.module.RoutPath
import android.dreame.module.data.getString
import android.dreame.module.ext.setOnShakeProofClickListener
import android.graphics.Paint
import android.os.Message
import android.view.View
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.content.ContextCompat
import androidx.lifecycle.lifecycleScope
import com.therouter.TheRouter
import com.dreame.feature.connect.constant.ExtraConstants
import com.dreame.feature.connect.device.mower.connect.DeviceConnectBleActivity
import com.dreame.feature.connect.device.mower.connect.DeviceConnectBleViewModel
import com.dreame.feature.connect.device.mower.solution.BleSolutionActivity
import com.dreame.smartlife.config.step.StepName
import com.dreame.smartlife.config.step.StepResult
import com.dreame.smartlife.config.step.StepState
import com.dreame.smartlife.config.step.WeakHandler
import com.dreame.smartlife.connect.R
import com.dreame.smartlife.connect.databinding.ActivityDeviceConnectBleBinding
import com.dreame.smartlife.connect.databinding.LayoutConnectStepBleBinding
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

/**
 * 连接蓝牙， 检查是否设置 pin code ui
 */
class BleStepConnectUiConfig(
    activity: DeviceConnectBleActivity,
    viewmodel: DeviceConnectBleViewModel,
    binding: ActivityDeviceConnectBleBinding,
    handler: WeakHandler
) : BaseUiConfig(activity, viewmodel, binding, handler) {
    lateinit var stepBinding: LayoutConnectStepBleBinding
    override fun initView() {
        binding.flRoot.removeAllViews()
        val rootView = ConstraintLayout.inflate(activity, R.layout.layout_connect_step_ble, null)
        stepBinding = LayoutConnectStepBleBinding.bind(rootView)
        binding.flRoot.addView(rootView)
        stepBinding.tvFailReason.paint.apply {
            flags = flags or Paint.UNDERLINE_TEXT_FLAG
        }
        stepConnectUI(StepState.START)
    }

    override fun initListener() {
        stepBinding.tvFailReason.setOnShakeProofClickListener {
            // 查看解决方案
            TheRouter.build(RoutPath.DEVICE_CONNECT_BLE_SOLUTION)
                .withInt(BleSolutionActivity.STEP_PARAM, BleSolutionActivity.STEP_NO_PIN_CODE_FAIL)
                .navigation()
        }
        stepBinding.btnFinish.setOnShakeProofClickListener {
            // 重新配对,返回上一级
            activity.onStepDestroy()
            TheRouter.build(RoutPath.DEVICE_TRIGGER_BLE)
                .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, viewModel.uiStates.value.productInfo)
                .navigation()
            activity.finish()
        }
    }

    override fun handleBackPressed() {
        activity.onStepDestroy()
        TheRouter.build(RoutPath.DEVICE_TRIGGER_BLE)
            .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, viewModel.uiStates.value.productInfo)
            .navigation()
        activity.finish()
    }

    override fun handleStepResultMessage(result: StepResult, message: Message) {
        val (stepName, stepState, stepId) = result
        when (stepName) {
            StepName.STEP_CONNECT -> {
                stepConnectUI(stepState)
            }

            StepName.STEP_PIN_CODE_GET -> {
                stepPinCodeCheck(stepState)
            }

            else -> {}
        }
    }

    private fun stepConnectUI(state: StepState) {
        stepBinding.llStep1.visibility = View.VISIBLE
        stepBinding.llStep2.visibility = View.INVISIBLE
        stepBinding.llStep3.visibility = View.INVISIBLE
        stepBinding.llBtn.visibility = View.INVISIBLE
        stepBinding.tvFailReason.visibility = View.INVISIBLE
        when (state) {
            StepState.START -> {
                binding.titleView.setTitle(activity.getString(R.string.text_ble_pairing))
                stepBinding.tvStep1.setText(activity.getString(R.string.text_quering_pair_request))
                stepBinding.tvStep1.setTextColor(ContextCompat.getColor(activity, R.color.common_textSecond))
                stepBinding.ivStep1.visibility = View.GONE
                stepBinding.pbStep1.visibility = View.VISIBLE
            }

            StepState.SUCCESS -> {
                binding.titleView.setTitle(activity.getString(R.string.text_ble_pairing))

                stepBinding.pbStep1.visibility = View.GONE
                stepBinding.ivStep1.visibility = View.VISIBLE
                stepBinding.ivStep1.setImageResource(R.drawable.icon_step_success)
                stepBinding.tvStep1.setText(activity.getString(R.string.text_receive_pair_request))

                activity.lifecycleScope.launch {
                    delay(300)
                    nextUiConfig(UiConfig.UI_CONFIG_PIN_CODE)
                }

            }

            StepState.FAILED -> {
                binding.titleView.setTitle(activity.getString(R.string.text_ble_pairing_failure))

                stepBinding.tvStep1.setText(activity.getString(R.string.text_unreceive_pair_request))
                stepBinding.tvStep1.setTextColor(ContextCompat.getColor(activity, R.color.common_red1))
                stepBinding.ivStep1.setImageResource(R.drawable.icon_step_failed)
                stepBinding.pbStep1.visibility = View.GONE
                stepBinding.ivStep1.visibility = View.VISIBLE
                stepBinding.llBtn.visibility = View.VISIBLE
                stepBinding.tvFailReason.visibility = View.VISIBLE
                stepBinding.btnFinish.isEnabled = true
                stepBinding.btnFinish.text = getString(R.string.text_reparing)
            }

            StepState.STOP -> {
                binding.titleView.setTitle(activity.getString(R.string.text_ble_pairing_failure))

                stepBinding.tvStep1.setText(activity.getString(R.string.text_unreceive_pair_request))
                stepBinding.tvStep1.setTextColor(ContextCompat.getColor(activity, R.color.common_red1))
                stepBinding.ivStep1.setImageResource(R.drawable.icon_step_failed)
                stepBinding.pbStep1.visibility = View.GONE
                stepBinding.ivStep1.visibility = View.VISIBLE
                stepBinding.llBtn.visibility = View.VISIBLE
                stepBinding.tvFailReason.visibility = View.VISIBLE
                stepBinding.btnFinish.isEnabled = true
                stepBinding.btnFinish.text = getString(R.string.text_reparing)
            }

            else -> {}
        }

    }

    private fun stepPinCodeCheck(state: StepState) {
        stepBinding.llStep1.visibility = View.VISIBLE
        stepBinding.llStep2.visibility = View.VISIBLE
        stepBinding.llStep3.visibility = View.INVISIBLE
        stepBinding.llBtn.visibility = View.INVISIBLE
        stepBinding.tvFailReason.visibility = View.INVISIBLE
        when (state) {
            StepState.START -> {
                binding.titleView.setTitle(activity.getString(R.string.text_ble_pairing))

                stepBinding.tvStep2.setText(activity.getString(R.string.text_check_pincode))
                stepBinding.tvStep2.setTextColor(ContextCompat.getColor(activity, R.color.common_textSecond))
                stepBinding.ivStep2.visibility = View.GONE
                stepBinding.pbStep2.visibility = View.VISIBLE
            }

            StepState.SUCCESS -> {
                binding.titleView.setTitle(activity.getString(R.string.text_ble_pairing_success))

                stepBinding.tvStep2.setText(activity.getString(R.string.text_pincode_has_set))
                stepBinding.pbStep2.visibility = View.GONE
                stepBinding.ivStep2.visibility = View.VISIBLE
                stepBinding.ivStep2.setImageResource(R.drawable.icon_step_success)

                activity.lifecycleScope.launch {
                    delay(300)
                    nextUiConfig(UiConfig.UI_CONFIG_PIN_CODE)
                }
            }

            StepState.FAILED -> {
                binding.titleView.setTitle(activity.getString(R.string.text_ble_pairing_failure))

                stepBinding.tvStep2.setText(activity.getString(R.string.text_pincode_unset))
                stepBinding.tvStep2.setTextColor(ContextCompat.getColor(activity, R.color.common_red1))
                stepBinding.ivStep2.setImageResource(R.drawable.icon_step_failed)
                stepBinding.pbStep2.visibility = View.GONE
                stepBinding.ivStep2.visibility = View.VISIBLE
                stepBinding.llBtn.visibility = View.VISIBLE
                stepBinding.tvFailReason.visibility = View.VISIBLE
                stepBinding.btnFinish.isEnabled = true
                stepBinding.btnFinish.text = getString(R.string.text_reparing)
            }

            StepState.STOP -> {
                binding.titleView.setTitle(activity.getString(R.string.text_ble_pairing_failure))
                stepBinding.tvStep2.setText(activity.getString(R.string.text_unreceive_pair_request))
                stepBinding.tvStep2.setTextColor(ContextCompat.getColor(activity, R.color.common_red1))
                stepBinding.ivStep2.setImageResource(R.drawable.icon_step_failed)
                stepBinding.pbStep2.visibility = View.GONE
                stepBinding.ivStep2.visibility = View.VISIBLE
                stepBinding.llBtn.visibility = View.VISIBLE
                stepBinding.tvFailReason.visibility = View.VISIBLE
                stepBinding.btnFinish.isEnabled = true
                stepBinding.btnFinish.text = getString(R.string.text_reparing)
            }

            else -> {}
        }

    }

}