package com.dreame.feature.connect.device.mower.connect.uiconfig

import android.app.Activity
import android.content.Intent
import android.dreame.module.RoutPath
import android.dreame.module.RouteServiceProvider
import android.dreame.module.util.LogUtil
import android.os.Message
import com.therouter.TheRouter
import com.dreame.feature.connect.constant.ExtraConstants
import com.dreame.feature.connect.device.mower.connect.DeviceConnectBleActivity
import com.dreame.feature.connect.device.mower.connect.DeviceConnectBleUiAction
import com.dreame.feature.connect.device.mower.connect.DeviceConnectBleViewModel
import com.dreame.feature.connect.utils.ObserverActivityLifecycle
import com.dreame.module.service.app.flutter.IFlutterBridgeService
import com.dreame.smartlife.config.step.SmartStepHelper
import com.dreame.smartlife.config.step.StepData
import com.dreame.smartlife.config.step.StepResult
import com.dreame.smartlife.config.step.WeakHandler
import com.dreame.smartlife.connect.databinding.ActivityDeviceConnectBleBinding

abstract class BaseUiConfig(
    val activity: DeviceConnectBleActivity, val viewModel: DeviceConnectBleViewModel,
    val binding: ActivityDeviceConnectBleBinding, val handler: WeakHandler
) : ObserverActivityLifecycle(activity) {

    protected var currentStepId = -1
    protected val CODE_PASSWORD = 12000

    open fun initData(params: Map<String, String> = emptyMap()) {
    }

    open fun initView() {


    }

    open fun initListener() {

    }

    open fun observe() {

    }

    open fun onDestroy() {

    }

    override fun onActivityStop() {
        super.onActivityStop()
        if (activity.isFinishing) {
            onDestroy()
        }
    }

    override fun onActivityDestroy() {
        onDestroy()
        super.onActivityDestroy()
    }

    open fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == CODE_PASSWORD && resultCode == Activity.RESULT_OK) {
            val bindDoamin = data?.getStringExtra(ExtraConstants.EXTRA_DOMAIN) ?: ""
            val wifiName = data?.getStringExtra(ExtraConstants.EXTRA_INPUT_WIFI_NAME) ?: ""
            val wifiPwd = data?.getStringExtra(ExtraConstants.EXTRA_INPUT_WIFI_PWD) ?: ""
            StepData.updateProductInfo(bindDoamin = bindDoamin, wifiName = wifiName, wifiPwd = wifiPwd)
            viewModel.dispatchAction(
                DeviceConnectBleUiAction.UpdateProductInfo(
                    bindDoamin = bindDoamin,
                    wifiName = wifiName,
                    wifiPwd = wifiPwd
                )
            )
            nextUiConfig(UiConfig.UI_CONFIG_WIFI_PASSWORD)
        }
    }

    open fun handleBackPressed() {
        activity.finish()
    }

    open fun onRightIconClick() {
        TheRouter.build(RoutPath.PRODUCT_CONNECT_PREPARE_BLE)
            .withBoolean(ExtraConstants.EXTRA_FEATURE, false)
            .navigation()
    }

    fun handleMessage(message: Message) {
        if (message.obj is StepResult) {
            val result = message.obj as StepResult
            val (stepName, state, stepId) = result
            LogUtil.i("Step", "handleMessage: result: $result, state: $state ,stepId: $stepId")
            currentStepId = stepId
            handleStepResultMessage(result, message)
        } else {
            if (!handleCustomMessage(message)) {
                SmartStepHelper.instance.handleMessage(message)
            }
        }
    }

    abstract fun handleStepResultMessage(result: StepResult, message: Message)

    open fun handleCustomMessage(message: Message): Boolean {
        return false
    }

    protected fun nextUiConfig(uiConfig: UiConfig, params: Map<String, String> = emptyMap()) {
        LogUtil.i("nextUiConfig: ${uiConfig.name}")
        val newInstance = findStep(uiConfig)
        if (newInstance != null) {
            onDestroy()
            newInstance.initView()
            newInstance.initData(params)
            newInstance.initListener()
            activity.nextUiConfig(newInstance)
        } else {
            // not step

        }
    }

    protected fun gotoFlutterMainPage() {
        activity.onStepDestroy()
        RouteServiceProvider.getService<IFlutterBridgeService>()?.sendMessage("resetApp")
        RouteServiceProvider.getService<IFlutterBridgeService>()?.gotoFlutterPluginActivity()
        activity.finish()
    }

    enum class UiConfig {
        UI_CONFIG_STEP_CONNECT,
        UI_CONFIG_PIN_CODE,
        UI_CONFIG_BLE_BIND_FAIL,
        UI_CONFIG_BLE_BIND_SUCCESS,
        UI_CONFIG_WIFI_PASSWORD,
    }

    fun findStep(step: UiConfig): BaseUiConfig? {
        return when (step) {
            UiConfig.UI_CONFIG_STEP_CONNECT -> BleStepConnectUiConfig(activity, viewModel, binding, handler)
            UiConfig.UI_CONFIG_PIN_CODE -> BleStepPinCodeUiConfig(activity, viewModel, binding, handler)
            UiConfig.UI_CONFIG_BLE_BIND_FAIL -> BleStepBindFailedConfig(activity, viewModel, binding, handler)
            UiConfig.UI_CONFIG_BLE_BIND_SUCCESS -> BleStepBindSuccessConfig(activity, viewModel, binding, handler)
            UiConfig.UI_CONFIG_WIFI_PASSWORD -> BleStepWifiPasswordUiConfig(activity, viewModel, binding, handler)
            else -> null
        }
    }
}


