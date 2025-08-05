package com.dreame.feature.connect.device.mower.connect.uiconfig

import android.dreame.module.RoutPath
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.util.okhttp3.convert.ErrorCode
import android.os.Message
import android.view.View
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.content.ContextCompat
import com.therouter.TheRouter
import com.dreame.feature.connect.constant.ExtraConstants
import com.dreame.feature.connect.device.mower.connect.DeviceConnectBleActivity
import com.dreame.feature.connect.device.mower.connect.DeviceConnectBleViewModel
import com.dreame.feature.connect.device.mower.solution.BleSolutionActivity
import com.dreame.smartlife.config.step.CLICK_PIN_CODE_BIND_ERROR
import com.dreame.smartlife.config.step.StepResult
import com.dreame.smartlife.config.step.WeakHandler
import com.dreame.smartlife.connect.R
import com.dreame.smartlife.connect.databinding.ActivityDeviceConnectBleBinding
import com.dreame.smartlife.connect.databinding.LayoutConnectStepBleBinding

/**
 * 绑定结果页
 */
class BleStepBindFailedConfig(
    activity: DeviceConnectBleActivity,
    viewmodel: DeviceConnectBleViewModel,
    binding: ActivityDeviceConnectBleBinding,
    handler: WeakHandler
) : BaseUiConfig(activity, viewmodel, binding, handler) {

    lateinit var stepBinding: LayoutConnectStepBleBinding
    private var errorCode = -1

    private var stepParam = 0
    override fun initView() {
        binding.flRoot.removeAllViews()
        val rootView = ConstraintLayout.inflate(activity, R.layout.layout_connect_step_ble, null)
        stepBinding = LayoutConnectStepBleBinding.bind(rootView)
        binding.flRoot.addView(rootView)

        binding.titleView.setTitleBackgroundColor(R.color.common_layoutBg)
        binding.titleView.setTitle(activity.getString(R.string.text_robot_bind_failed))

        stepBinding.tvStep1.setText(activity.getString(R.string.text_robot_bind_failed))
        stepBinding.tvStep1.setTextColor(ContextCompat.getColor(activity, R.color.common_red1))
        stepBinding.ivStep1.setImageResource(R.drawable.icon_step_failed)
        stepBinding.pbStep1.visibility = View.GONE
        stepBinding.ivStep1.visibility = View.VISIBLE
        stepBinding.llBtn.visibility = View.VISIBLE
        stepBinding.tvFailReason.visibility = View.VISIBLE
        stepBinding.llStep1.visibility = View.VISIBLE
        stepBinding.btnFinish.isEnabled = true
    }

    override fun initData(params: Map<String, String>) {
        super.initData(params)
        stepParam = params[BleSolutionActivity.STEP_PARAM]?.toInt() ?: 0
        val title = when (stepParam) {
            BleSolutionActivity.STEP_CONNECT_FAIL -> activity.getString(R.string.text_ble_pairing_failure)
            BleSolutionActivity.STEP_NO_PIN_CODE_FAIL -> activity.getString(R.string.text_ble_pairing_failure)
            BleSolutionActivity.STEP_HAS_OWN_FAIL -> activity.getString(R.string.text_robot_bind_failed)
            BleSolutionActivity.STEP_ROBOT_CONNECT_NET_FAIL -> activity.getString(R.string.pair_failure)
            BleSolutionActivity.STEP_PAIR_NET_FAIL -> activity.getString(R.string.pair_failure)
            else -> activity.getString(R.string.text_robot_bind_failed)
        }
        val text = when (stepParam) {
            BleSolutionActivity.STEP_CONNECT_FAIL -> activity.getString(R.string.text_unreceive_pair_request)
            BleSolutionActivity.STEP_NO_PIN_CODE_FAIL -> activity.getString(R.string.text_pincode_unset)
            BleSolutionActivity.STEP_HAS_OWN_FAIL -> activity.getString(R.string.text_robot_is_bound)
            BleSolutionActivity.STEP_ROBOT_CONNECT_NET_FAIL -> activity.getString(R.string.query_devices_state_failed)
            BleSolutionActivity.STEP_PAIR_NET_FAIL -> activity.getString(R.string.text_robot_bind_failed)
            else -> activity.getString(R.string.text_robot_bind_failed)
        }

        binding.titleView.setTitle(title)
        stepBinding.tvStep1.setText(text)
    }

    override fun initListener() {
        stepBinding.tvFailReason.setOnShakeProofClickListener {
            // 查看解决方案，跳转到解决方案页面
            TheRouter.build(RoutPath.DEVICE_CONNECT_BLE_SOLUTION)
                .withInt(BleSolutionActivity.STEP_PARAM, stepParam)
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

    }

    override fun handleCustomMessage(message: Message): Boolean {
        when (message.what) {
            CLICK_PIN_CODE_BIND_ERROR -> {
                stepBinding.btnFinish.text = activity.getString(R.string.text_reparing)
                val code = message.arg1
                errorCode = code
                when (code) {
                    ErrorCode.CODE_PRODUCT_SIGN_ERROR -> {
                        stepParam = BleSolutionActivity.STEP_CONNECT_FAIL
                        stepBinding.tvFailReason.visibility = View.VISIBLE
                        stepBinding.tvStep1.setText(activity.getString(R.string.text_robot_bind_failed))
                    }

                    ErrorCode.CODE_PRODUCT_HAS_OWNER -> {
                        stepParam = BleSolutionActivity.STEP_HAS_OWN_FAIL
                        stepBinding.tvFailReason.visibility = View.VISIBLE
                        stepBinding.tvStep1.setText(activity.getString(R.string.text_robot_is_bound))
                    }

                    else -> {
                        stepParam = BleSolutionActivity.STEP_CONNECT_FAIL
                        stepBinding.tvFailReason.visibility = View.VISIBLE
                        stepBinding.tvStep1.setText(activity.getString(R.string.text_robot_bind_failed))
                    }
                }
                return true
            }
        }

        return super.handleCustomMessage(message)
    }

}