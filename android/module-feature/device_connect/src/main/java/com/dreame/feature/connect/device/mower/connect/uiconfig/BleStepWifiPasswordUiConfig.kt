package com.dreame.feature.connect.device.mower.connect.uiconfig

import android.app.Activity
import android.content.Intent
import android.dreame.module.RoutPath
import android.dreame.module.RouteServiceProvider
import android.dreame.module.data.Result
import android.dreame.module.data.entry.device.DeviceBlePairReq
import android.dreame.module.data.getString
import android.dreame.module.data.network.service.DreameService
import android.dreame.module.ext.processApiResponse
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.util.okhttp3.convert.ErrorCode
import android.dreame.module.util.toast.ToastUtils
import android.os.Message
import android.view.View
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.content.ContextCompat
import androidx.lifecycle.lifecycleScope
import com.therouter.TheRouter
import com.dreame.feature.connect.constant.ExtraConstants
import com.dreame.feature.connect.device.mower.connect.DeviceConnectBleActivity
import com.dreame.feature.connect.device.mower.connect.DeviceConnectBleUiAction
import com.dreame.feature.connect.device.mower.connect.DeviceConnectBleViewModel
import com.dreame.feature.connect.device.mower.solution.BleSolutionActivity
import com.dreame.module.service.app.flutter.IFlutterBridgeService
import com.dreame.smartlife.config.step.CLICK_PIN_CODE_BIND_WIFI
import com.dreame.smartlife.config.step.CLICK_PIN_CODE_CONFIG
import com.dreame.smartlife.config.step.StepData
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
 * 发送密码页
 */
class BleStepWifiPasswordUiConfig(
    activity: DeviceConnectBleActivity,
    viewmodel: DeviceConnectBleViewModel,
    binding: ActivityDeviceConnectBleBinding,
    handler: WeakHandler
) : BaseUiConfig(activity, viewmodel, binding, handler) {
    private lateinit var stepBinding: LayoutConnectStepBleBinding
    private var isSuccess = false

    override fun initView() {
        binding.flRoot.removeAllViews()
        val rootView = ConstraintLayout.inflate(activity, R.layout.layout_connect_step_ble, null)
        stepBinding = LayoutConnectStepBleBinding.bind(rootView)
        binding.flRoot.addView(rootView)
        stepBinding.btnFinish.text = getString(R.string.complete)
        isSuccess = false
        handler.sendMessage(Message.obtain().apply {
            what = CLICK_PIN_CODE_CONFIG
            arg1 = 1
        })
    }

    override fun handleBackPressed() {
        TheRouter.build(RoutPath.DEVICE_ROUTER_PASSWORD)
            .withBoolean("CONFIG_TYPE", true)
            .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, viewModel.uiStates.value.productInfo)
            .navigation(activity, CODE_PASSWORD)
    }

    override fun initListener() {
        stepBinding.btnFinish.setOnShakeProofClickListener {
            // 判断失败返回上一页
            if (isSuccess) {
                // 返回到首页
                activity.onStepDestroy()
                RouteServiceProvider.getService<IFlutterBridgeService>()?.gotoFlutterHomeActivity(activity)
                activity.finish()
            } else {
                // 重新配对,返回上一级
                TheRouter.build(RoutPath.DEVICE_ROUTER_PASSWORD)
                    .withBoolean("CONFIG_TYPE", true)
                    .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, viewModel.uiStates.value.productInfo)
                    .navigation(activity, CODE_PASSWORD)
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == CODE_PASSWORD && resultCode != Activity.RESULT_OK) {
            // 返回上一级
            nextUiConfig(UiConfig.UI_CONFIG_BLE_BIND_SUCCESS)
        }
    }

    override fun handleStepResultMessage(result: StepResult, message: Message) {
        val (stepName, stepState, stepId) = result
        when (stepName) {
            StepName.STEP_ROUTE_CONFIG_NET -> {
                isSuccess = false
                stepTransformWifiInfo(stepState)
            }

            StepName.STEP_ROUTE_CONNECT_NET -> {
                isSuccess = false
                stepDeviceConnectNet(stepState)

                if (stepState == StepState.SUCCESS) {
                    stepUserBindDevice(StepState.START, 0)
                    val map = result.map ?: return stepUserBindDevice(StepState.FAILED, 0)
                    lifecycleOwner.lifecycleScope.launch {
                        getDevicePair(map)
                    }
                }
            }

            StepName.STEP_PIN_CODE_BIND -> {
                stepUserBindDevice(stepState, 0)
            }

            else -> {}
        }
    }

    private fun stepTransformWifiInfo(state: StepState) {
        stepBinding.llStep1.visibility = View.VISIBLE
        stepBinding.llStep2.visibility = View.VISIBLE
        stepBinding.llStep3.visibility = View.INVISIBLE
        stepBinding.tvFailReason.visibility = View.INVISIBLE
        when (state) {
            StepState.START -> {
                binding.titleView.setTitle(activity.getString(R.string.device_connecting))
                stepBinding.pbStep1.visibility = View.GONE
                stepBinding.ivStep1.visibility = View.VISIBLE
                stepBinding.ivStep1.setImageResource(R.drawable.icon_step_success)
                stepBinding.tvStep1.setText(activity.getString(R.string.phone_connect_device_success))

                stepBinding.tvStep2.setText(activity.getString(R.string.sending_data_to_device))
                stepBinding.tvStep2.setTextColor(ContextCompat.getColor(activity, R.color.common_textSecond))
                stepBinding.ivStep2.visibility = View.GONE
                stepBinding.pbStep2.visibility = View.VISIBLE
                stepBinding.btnFinish.text = getString(R.string.complete)
            }

            StepState.SUCCESS -> {
                stepBinding.pbStep2.visibility = View.GONE
                stepBinding.ivStep2.visibility = View.VISIBLE
                stepBinding.ivStep2.setImageResource(R.drawable.icon_step_success)
                stepBinding.tvStep2.setText(activity.getString(R.string.send_data_to_device_success))
                stepBinding.btnFinish.text = getString(R.string.complete)
            }


            StepState.FAILED, StepState.STOP -> {
                stepBinding.tvStep2.setText(activity.getString(R.string.send_data_to_device_failed))
                stepBinding.tvStep2.setTextColor(ContextCompat.getColor(activity, R.color.common_red1))
                stepBinding.ivStep2.setImageResource(R.drawable.icon_step_failed)
                stepBinding.pbStep2.visibility = View.GONE
                stepBinding.ivStep2.visibility = View.VISIBLE
                stepBinding.tvFailReason.visibility = View.VISIBLE
                stepBinding.btnFinish.isEnabled = true
                stepBinding.btnFinish.text = getString(R.string.text_reconfigure_network)

                stepBinding.tvFailReason.setOnShakeProofClickListener {
                    // 查看解决方案
                    TheRouter.build(RoutPath.DEVICE_CONNECT_BLE_SOLUTION)
                        .withInt(BleSolutionActivity.STEP_PARAM, BleSolutionActivity.STEP_ROBOT_CONNECT_NET_FAIL)
                        .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, viewModel.uiStates.value.productInfo)
                        .navigation()
                }
                if (state == StepState.STOP) {
                    stepBinding.btnFinish.setOnShakeProofClickListener {
                        // 判断失败返回上一页
                        activity.onStepDestroy()
                        TheRouter.build(RoutPath.DEVICE_TRIGGER_BLE)
                            .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, viewModel.uiStates.value.productInfo)
                            .navigation()
                        activity.finish()
                    }
                }
            }
        }

    }

    private fun stepDeviceConnectNet(state: StepState) {
        stepBinding.llStep1.visibility = View.VISIBLE
        stepBinding.llStep2.visibility = View.VISIBLE
        stepBinding.llStep3.visibility = View.VISIBLE
        stepBinding.tvFailReason.visibility = View.INVISIBLE
        when (state) {
            StepState.START -> {
                binding.titleView.setTitle(activity.getString(R.string.query_devices_state))
                stepBinding.tvStep3.setText(activity.getString(R.string.query_devices_state))
                stepBinding.tvStep3.setTextColor(ContextCompat.getColor(activity, R.color.common_textSecond))
                stepBinding.ivStep3.visibility = View.GONE
                stepBinding.pbStep3.visibility = View.VISIBLE
                stepBinding.btnFinish.text = getString(R.string.complete)
            }

            StepState.SUCCESS -> {
                binding.titleView.setTitle(activity.getString(R.string.pair_success))
                stepBinding.pbStep3.visibility = View.GONE
                stepBinding.ivStep3.visibility = View.VISIBLE
                stepBinding.ivStep3.setImageResource(R.drawable.icon_step_success)
                stepBinding.tvStep3.setText(activity.getString(R.string.query_devices_state_success))
                stepBinding.btnFinish.isEnabled = false
                stepBinding.btnFinish.text = getString(R.string.complete)

                /// 保存配网密码
                viewModel.dispatchAction(DeviceConnectBleUiAction.SaveWifiIInfo)

            }

            StepState.FAILED -> {
                binding.titleView.setTitle(activity.getString(R.string.pair_failure))

                stepBinding.tvStep3.setText(activity.getString(R.string.query_devices_state_failed))
                stepBinding.tvStep3.setTextColor(ContextCompat.getColor(activity, R.color.common_red1))
                stepBinding.ivStep3.setImageResource(R.drawable.icon_step_failed)
                stepBinding.pbStep3.visibility = View.GONE
                stepBinding.ivStep3.visibility = View.VISIBLE
                stepBinding.tvFailReason.visibility = View.VISIBLE
                stepBinding.btnFinish.isEnabled = true
                stepBinding.btnFinish.text = getString(R.string.text_reconfigure_network)

                stepBinding.tvFailReason.setOnShakeProofClickListener {
                    // 查看解决方案
                    TheRouter.build(RoutPath.DEVICE_CONNECT_BLE_SOLUTION)
                        .withInt(BleSolutionActivity.STEP_PARAM, BleSolutionActivity.STEP_ROBOT_CONNECT_NET_FAIL)
                        .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, viewModel.uiStates.value.productInfo)
                        .navigation()
                }
            }

            StepState.STOP -> {
                /// 断开链接了
                stepBinding.btnFinish.setOnShakeProofClickListener {
                    // 判断失败返回上一页
                    activity.onStepDestroy()
                    TheRouter.build(RoutPath.DEVICE_TRIGGER_BLE)
                        .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, viewModel.uiStates.value.productInfo)
                        .navigation()
                    activity.finish()
                }
                nextUiConfig(
                    UiConfig.UI_CONFIG_BLE_BIND_FAIL,
                    mapOf(BleSolutionActivity.STEP_PARAM to BleSolutionActivity.STEP_CONNECT_FAIL.toString())
                )
            }

        }

    }

    private fun stepUserBindDevice(state: StepState, code: Int) {
        stepBinding.llStep1.visibility = View.VISIBLE
        stepBinding.llStep2.visibility = View.VISIBLE
        stepBinding.llStep3.visibility = View.VISIBLE
        stepBinding.llStep4.visibility = View.VISIBLE
        stepBinding.tvFailReason.visibility = View.INVISIBLE
        when (state) {
            StepState.START -> {
                binding.titleView.setTitle(activity.getString(R.string.text_robot_binding))
                stepBinding.tvStep4.setText(activity.getString(R.string.text_robot_binding))
                stepBinding.tvStep4.setTextColor(ContextCompat.getColor(activity, R.color.common_textSecond))
                stepBinding.ivStep4.visibility = View.GONE
                stepBinding.pbStep4.visibility = View.VISIBLE
                stepBinding.btnFinish.text = getString(R.string.complete)
            }

            StepState.SUCCESS -> {
                binding.titleView.setTitle(activity.getString(R.string.pair_success))
                isSuccess = true
                stepBinding.pbStep4.visibility = View.GONE
                stepBinding.ivStep4.visibility = View.VISIBLE
                stepBinding.ivStep4.setImageResource(R.drawable.icon_step_success)
                stepBinding.tvStep4.setText(activity.getString(R.string.text_robot_binding_success))
                stepBinding.btnFinish.isEnabled = true
                stepBinding.btnFinish.text = getString(R.string.complete)

                /// 保存配网密码
                viewModel.dispatchAction(DeviceConnectBleUiAction.SaveWifiIInfo)
                // 通知flutter
                RouteServiceProvider.getService<IFlutterBridgeService>()?.devicePairSuccess()

            }

            StepState.FAILED, StepState.STOP -> {
                binding.titleView.setTitle(activity.getString(R.string.pair_failure))
                // text_robot_bind_failed
                when (code) {
                    ErrorCode.CODE_PRODUCT_HAS_OWNER -> {
                        stepBinding.tvStep4.setText(activity.getString(R.string.text_robot_is_bound))
                        stepBinding.tvFailReason.setOnShakeProofClickListener {
                            // 查看解决方案
                            TheRouter.build(RoutPath.DEVICE_CONNECT_BLE_SOLUTION)
                                .withInt(BleSolutionActivity.STEP_PARAM, BleSolutionActivity.STEP_HAS_OWN_FAIL)
                                .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, viewModel.uiStates.value.productInfo)
                                .navigation()
                        }
                    }

                    else -> {
                        stepBinding.tvStep4.setText(activity.getString(R.string.text_robot_bind_failed))
                        stepBinding.tvFailReason.setOnShakeProofClickListener {
                            // 查看解决方案
                            TheRouter.build(RoutPath.DEVICE_CONNECT_BLE_SOLUTION)
                                .withInt(BleSolutionActivity.STEP_PARAM, BleSolutionActivity.STEP_ROBOT_CONNECT_NET_FAIL)
                                .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, viewModel.uiStates.value.productInfo)
                                .navigation()
                        }
                    }
                }
                stepBinding.tvStep4.setTextColor(ContextCompat.getColor(activity, R.color.common_red1))
                stepBinding.ivStep4.setImageResource(R.drawable.icon_step_failed)
                stepBinding.pbStep4.visibility = View.GONE
                stepBinding.ivStep4.visibility = View.VISIBLE
                stepBinding.tvFailReason.visibility = View.VISIBLE
                stepBinding.btnFinish.isEnabled = true
                stepBinding.btnFinish.text = getString(R.string.text_reconfigure_network)
                stepBinding.btnFinish.setOnShakeProofClickListener {
                    // 判断失败返回上一页
                    activity.onStepDestroy()
                    TheRouter.build(RoutPath.DEVICE_TRIGGER_BLE)
                        .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, viewModel.uiStates.value.productInfo)
                        .navigation()
                    activity.finish()
                }
            }

            else -> {}
        }

    }


    // 请求网络
    private suspend fun getDevicePair(map: Map<String, Any>): Boolean {
        // viewModel.dispatchAction(DeviceConnectBleUiAction.ShowLoading(true))
        val did = map["did"]?.let { it as String } ?: ""
        val session = map["session"]?.let { it as String } ?: ""
        val secret = map["secret"]?.let { it as String } ?: ""
        val mac = map["mac"]?.let { it as String } ?: ""
        val ver = map["ver"]?.let { it as String } ?: ""
        val bindDomain = StepData.targetDomain
        val model = StepData.productModel
        val property = mapOf("session" to session)

        val req = DeviceBlePairReq(did, mac, ver, secret, model, property, bindDomain)
        var result = processApiResponse {
            DreameService.getDevicePair4Ble(req)
        }
        if (result is Result.Error) {
            // 2秒后重试一次
            delay(2000)
            result = processApiResponse {
                DreameService.getDevicePair4Ble(req)
            }
        }
        // viewModel.dispatchAction(DeviceConnectBleUiAction.ShowLoading(false))
        if (result is Result.Success) {
            if (result.data == true) {
                handler.sendMessage(Message.obtain().apply {
                    what = CLICK_PIN_CODE_BIND_WIFI
                    arg1 = 0
                })
                stepUserBindDevice(StepState.SUCCESS, 0)
                // 绑定
                return true
            } else {
                // 辣鸡，报错了 绑定失败
                handler.sendMessage(Message.obtain().apply {
                    what = CLICK_PIN_CODE_BIND_WIFI
                    arg1 = -1
                })
                stepUserBindDevice(StepState.FAILED, 0)
                return false
            }
        } else if (result is Result.Error) {
            when (result.exception.code) {
                -1 -> {
                    handler.sendMessage(Message.obtain().apply {
                        what = CLICK_PIN_CODE_BIND_WIFI
                        arg1 = result.exception.code
                    })
                    ToastUtils.show(result.exception.message)
                }

                else -> {
                    // 其他异常
                    handler.sendMessage(Message.obtain().apply {
                        what = CLICK_PIN_CODE_BIND_WIFI
                        arg1 = result.exception.code
                    })
                    stepUserBindDevice(StepState.FAILED, result.exception.code)
                }
            }

            return false
        }
        return false
    }


}