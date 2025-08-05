package com.dreame.feature.connect.device.mower.connect.uiconfig

import android.app.Activity
import android.content.Intent
import android.dreame.module.RoutPath
import android.dreame.module.RouteServiceProvider
import android.dreame.module.ext.setOnShakeProofClickListener
import android.os.Message
import android.view.View
import androidx.constraintlayout.widget.ConstraintLayout
import com.therouter.TheRouter
import com.dreame.feature.connect.constant.ExtraConstants
import com.dreame.feature.connect.device.mower.connect.DeviceConnectBleActivity
import com.dreame.feature.connect.device.mower.connect.DeviceConnectBleUiAction
import com.dreame.feature.connect.device.mower.connect.DeviceConnectBleViewModel
import com.dreame.module.service.app.flutter.IFlutterBridgeService
import com.dreame.smartlife.config.step.CLICK_PIN_CODE_CONFIG_SKIP
import com.dreame.smartlife.config.step.DeviceFeature
import com.dreame.smartlife.config.step.StepData
import com.dreame.smartlife.config.step.StepName
import com.dreame.smartlife.config.step.StepResult
import com.dreame.smartlife.config.step.StepState
import com.dreame.smartlife.config.step.WeakHandler
import com.dreame.smartlife.connect.R
import com.dreame.smartlife.connect.databinding.ActivityDeviceConnectBleBinding
import com.dreame.smartlife.connect.databinding.LayoutConnectStepSuccessBleBinding

/**
 * 绑定结果页
 */
class BleStepBindSuccessConfig(
    activity: DeviceConnectBleActivity,
    viewmodel: DeviceConnectBleViewModel,
    binding: ActivityDeviceConnectBleBinding,
    handler: WeakHandler
) : BaseUiConfig(activity, viewmodel, binding, handler) {
    private lateinit var stepBinding: LayoutConnectStepSuccessBleBinding
    private var isSettingSuccess = false
    override fun initView() {
        binding.flRoot.removeAllViews()
        val rootView = ConstraintLayout.inflate(activity, R.layout.layout_connect_step_success_ble, null)
        stepBinding = LayoutConnectStepSuccessBleBinding.bind(rootView)
        binding.flRoot.addView(rootView)
        val forceBindWifi = StepData.feature.contains(DeviceFeature.FORCE_BIND_WIFI)
        val title = if (forceBindWifi) R.string.text_ble_connected_success else R.string.text_ble_binding_success
        binding.titleView.setTitle(activity.getString(title))
        binding.titleView.setTitleBackgroundColor(R.color.common_layoutBg)


        stepBinding.llStep1.visibility = View.VISIBLE
        stepBinding.pbStep1.visibility = View.GONE
        stepBinding.ivStep1.visibility = View.VISIBLE
        stepBinding.ivStep1.setImageResource(R.drawable.icon_step_success)
        val content = if (forceBindWifi) R.string.text_ble_connected_success_desc else R.string.text_pairng_succeed_and_connect_wifi
        stepBinding.tvStep1.setText(activity.getString(content))

        stepBinding.btnFinish.visibility = if (forceBindWifi) View.INVISIBLE else View.VISIBLE
    }


    override fun initListener() {

        stepBinding.tvConfirm.setOnShakeProofClickListener {
            // 连接Wi-Fi
            TheRouter.build(RoutPath.DEVICE_ROUTER_PASSWORD)
                .withBoolean("CONFIG_TYPE", true)
                .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, viewModel.uiStates.value.productInfo)
                .navigation(activity, CODE_PASSWORD)
        }
        stepBinding.btnFinish.setOnShakeProofClickListener {
            /// 暂不连接Wi-Fi
            isSettingSuccess = false
            handler.sendMessage(Message.obtain().apply {
                what = CLICK_PIN_CODE_CONFIG_SKIP
                arg1 = 0
            })
        }

    }

    override fun handleBackPressed() {
        if (isSettingSuccess) {
            // 如果是跳过，则 返回首页
            activity.onStepDestroy()
            RouteServiceProvider.getService<IFlutterBridgeService>()?.gotoFlutterHomeActivity(activity)
            activity.finish()
        } else {
            activity.onStepDestroy()
            TheRouter.build(RoutPath.DEVICE_TRIGGER_BLE)
                .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, viewModel.uiStates.value.productInfo)
                .navigation()
            activity.finish()
        }
    }

    override fun handleStepResultMessage(result: StepResult, message: Message) {
        val (stepName, stepState) = result
        when (stepName) {
            StepName.STEP_ROUTE_CONFIG_NET -> {
                when (stepState) {
                    StepState.START -> {
                        viewModel.dispatchAction(DeviceConnectBleUiAction.ShowLoading(true))
                    }

                    StepState.SUCCESS -> {
                        isSettingSuccess = true
                        // 通知flutter
                        RouteServiceProvider.getService<IFlutterBridgeService>()?.devicePairSuccess()
                        viewModel.dispatchAction(DeviceConnectBleUiAction.ShowLoading(false))
                        gotoFlutterMainPage()
                    }

                    StepState.FAILED, StepState.STOP -> {
                        viewModel.dispatchAction(DeviceConnectBleUiAction.ShowLoading(false))
                        nextUiConfig(UiConfig.UI_CONFIG_BLE_BIND_FAIL)
                    }

                }
            }

            StepName.STEP_ROUTE_CONNECT_NET -> {
                when (stepState) {
                    StepState.SUCCESS -> {
                        // 如果是跳过，则 返回首页
                        RouteServiceProvider.getService<IFlutterBridgeService>()?.devicePairSuccess()
                        gotoFlutterMainPage()
                    }

                    StepState.FAILED, StepState.STOP -> {

                    }

                    else -> {}
                }
            }

            else -> {}
        }
    }
}