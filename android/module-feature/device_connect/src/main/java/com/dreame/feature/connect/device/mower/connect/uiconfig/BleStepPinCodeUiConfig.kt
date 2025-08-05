package com.dreame.feature.connect.device.mower.connect.uiconfig

import android.dreame.module.RoutPath
import android.dreame.module.data.Result
import android.dreame.module.data.entry.device.DeviceBlePairReq
import android.dreame.module.data.getString
import android.dreame.module.data.network.service.DreameService
import android.dreame.module.ext.processApiResponse
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.util.LogUtil
import android.dreame.module.util.toast.ToastUtils
import android.os.Message
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.lifecycle.lifecycleScope
import com.therouter.TheRouter
import com.dreame.feature.connect.constant.ExtraConstants
import com.dreame.feature.connect.device.mower.connect.DeviceConnectBleActivity
import com.dreame.feature.connect.device.mower.connect.DeviceConnectBleUiAction
import com.dreame.feature.connect.device.mower.connect.DeviceConnectBleViewModel
import com.dreame.feature.connect.device.mower.connect.fix._MOWER_PINCODE_
import com.dreame.feature.connect.device.mower.solution.BleSolutionActivity
import com.dreame.feature.connect.views.PinCodeEditText
import com.dreame.module.res.CenterKnowDialog
import com.dreame.smartlife.config.step.CLICK_PIN_CODE_BIND
import com.dreame.smartlife.config.step.CLICK_PIN_CODE_BIND_ERROR
import com.dreame.smartlife.config.step.CLICK_PIN_CODE_CONNECT
import com.dreame.smartlife.config.step.DeviceFeature
import com.dreame.smartlife.config.step.StepData
import com.dreame.smartlife.config.step.StepName
import com.dreame.smartlife.config.step.StepResult
import com.dreame.smartlife.config.step.StepState
import com.dreame.smartlife.config.step.WeakHandler
import android.dreame.module.feature.connect.bluetooth.BluetoothLeManager
import com.dreame.smartlife.connect.BuildConfig
import com.dreame.smartlife.connect.R
import com.dreame.smartlife.connect.databinding.ActivityDeviceConnectBleBinding
import com.dreame.smartlife.connect.databinding.LayoutConnectStepPinCodeBinding
import io.reactivex.Flowable
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.Disposable
import kotlinx.coroutines.launch
import java.util.concurrent.TimeUnit

/**
 * 输入并绑定 pin code ui
 */
class BleStepPinCodeUiConfig(
    activity: DeviceConnectBleActivity,
    viewmodel: DeviceConnectBleViewModel,
    binding: ActivityDeviceConnectBleBinding,
    handler: WeakHandler
) : BaseUiConfig(activity, viewmodel, binding, handler) {

    lateinit var stepBinding: LayoutConnectStepPinCodeBinding

    // 锁定起始时间
    private var lockStartTime = 0L

    // 锁定时长
    private var lockRemain = 0

    private var mCountDown: Disposable? = null
    private var pincode = "";
    override fun initView() {
        binding.flRoot.removeAllViews()
        val rootView = ConstraintLayout.inflate(activity, R.layout.layout_connect_step_pin_code, null)
        stepBinding = LayoutConnectStepPinCodeBinding.bind(rootView)
        binding.flRoot.addView(rootView)

        binding.titleView.setTitle(activity.getString(R.string.text_verify_pincode))
        binding.titleView.setTitleBackgroundColor(R.color.common_bgWhite)
        stepBinding.pinCode.setText("")
        stepBinding.tvConfirm.isEnabled = false
        stepBinding.tvTips.text = getString(R.string.text_input_your_pincode)

        ///
        handler.sendMessage(Message.obtain().apply {
            what = CLICK_PIN_CODE_CONNECT
        })
    }

    override fun initListener() {
        stepBinding.pinCode.setOnTextInputListener(object : PinCodeEditText.OnSimpleTextInputListener() {
            override fun onTextInputCompleted(text: String?) {
                stepBinding.tvConfirm.isEnabled = stepBinding.pinCode.length() == 4
            }
        })
        stepBinding.tvConfirm.setOnShakeProofClickListener {
            viewModel.dispatchAction(DeviceConnectBleUiAction.ShowLoading(true))
            // 绑定
            pincode = stepBinding.pinCode.text?.toString() ?: ""
            handler.sendMessage(Message.obtain().apply {
                what = CLICK_PIN_CODE_CONNECT
                obj = pincode
            })
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
        val (stepName, state, stepId) = result
        LogUtil.i("Step", "handleMessage: result: $result, state: $state ,stepId: $stepId")
        currentStepId = stepId
        when (stepName) {
            StepName.STEP_PIN_CODE_INPUT -> {
                stepConfigUI(state, message)
            }

            StepName.STEP_PIN_CODE_BIND -> {
                stepBindUI(state)
            }

            else -> {}
        }
    }

    private fun stepBindUI(state: StepState) {
        when (state) {
            StepState.START -> {

            }

            StepState.SUCCESS -> {
                nextUiConfig(UiConfig.UI_CONFIG_BLE_BIND_SUCCESS)
            }

            StepState.FAILED, StepState.STOP -> {
                nextUiConfig(
                    UiConfig.UI_CONFIG_BLE_BIND_FAIL,
                    mapOf(BleSolutionActivity.STEP_PARAM to BleSolutionActivity.STEP_CONNECT_FAIL.toString())
                )
            }
        }
    }

    private fun stepConfigUI(state: StepState, message: Message?) {
        when (state) {
            StepState.START -> {
                binding.titleView.setTitle(activity.getString(R.string.text_verify_pincode))
                stepBinding.pinCode.setText("")
                stepBinding.tvConfirm.isEnabled = false
                stepBinding.tvTips.text = getString(R.string.text_input_your_pincode)
            }

            StepState.SUCCESS -> {
                // 调接口 绑定
                activity.lifecycleScope.launch {
                    val map = (message?.obj as StepResult).map ?: emptyMap()
                    if (map.isNotEmpty() && !StepData.feature.contains(DeviceFeature.FORCE_BIND_WIFI)) {
                        // 非强制绑定，需要调接口
                        getDevicePair(map)
                    } else {
                        viewModel.dispatchAction(DeviceConnectBleUiAction.ShowLoading(false))
                        // handler.sendMessage(Message.obtain().apply { what = CLICK_PIN_CODE_BIND
                        //     arg1 = 0
                        // })
                        nextUiConfig(UiConfig.UI_CONFIG_BLE_BIND_SUCCESS)
                    }
                }
            }

            StepState.FAILED -> {
                viewModel.dispatchAction(DeviceConnectBleUiAction.ShowLoading(false))
                // 未设置pin code
                message?.let {
                    val code = message.arg1
                    val remain = message.arg2
                    when (code) {
                        -2 -> {
                            // 锁定 计时
                            val remainNew = if (remain < 0) {
                                5 * 60
                            } else {
                                remain
                            }
                            showPinCodeLock(remainNew)
                        }

                        -1 -> {
                            // PIN 码错误
                            showPinCodeError()
                        }

                        else -> {
                            // 直接失败
                            nextUiConfig(UiConfig.UI_CONFIG_BLE_BIND_FAIL)
                            handler.sendMessage(Message.obtain().apply {
                                what = CLICK_PIN_CODE_BIND_ERROR
                                arg1 = -1
                            })
                        }
                    }
                }
            }

            StepState.STOP -> {
                viewModel.dispatchAction(DeviceConnectBleUiAction.ShowLoading(false))
                nextUiConfig(
                    UiConfig.UI_CONFIG_BLE_BIND_FAIL,
                    mapOf(BleSolutionActivity.STEP_PARAM to BleSolutionActivity.STEP_CONNECT_FAIL.toString())
                )
            }
        }

    }

    private fun showPinCodeLock(remain: Int) {
        // 开启倒计时
        lockStartTime = System.currentTimeMillis()
        lockRemain = remain
        countDownByFlow()
        val showTime = if (remain > 60) {
            "${remain / 60}min"
        } else {
            "${remain}s"
        }
        val content = activity.getString(R.string.text_max_attempts_try_later, showTime)
        CenterKnowDialog(activity).show(
            content,
            activity.getString(R.string.know)
        ) {
            it.dismiss()
            // 修改UI
            binding.titleView.setTitle(activity.getString(R.string.text_verify_pincode))
            stepBinding.pinCode.setText("")
            stepBinding.tvConfirm.isEnabled = false
            stepBinding.tvTips.text = content
        }
    }

    private fun showPinCodeError() {
        /**
         * 配网判断PIN码过程中检查是否为所提供清单的PIN码组合
         * 如果不在清单中 & PIN码错误：正常提示“PIN码输入错误，请重试”
         * 如果在清单中：
         * 提示用户将PIN码修改成0001，先完成配网升级后重新修改PIN码。
         * 然后APP端退出配网流。（退到蓝牙断开的程度，割草机机器端才能从“配网中”的界面中跳出来）
         */
        if (_MOWER_PINCODE_.contains(pincode) && "dreame.mower.p2255".equals(viewModel.uiStates.value.productInfo?.productModel)) {
            // 提示用户将PIN码修改成0001，先完成配网升级后重新修改PIN码，然后APP端退出配网流
            CenterKnowDialog(activity).show(
                activity.getString(R.string.text_pincode_invalid_and_reset),
                activity.getString(R.string.know)
            ) {
                it.dismiss()
                BluetoothLeManager.onDestroy()
                /// 退回到上一页
                TheRouter.build(RoutPath.DEVICE_TRIGGER_BLE)
                    .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, viewModel.uiStates.value.productInfo)
                    .navigation()
                activity.finish()
            }
        } else {
            CenterKnowDialog(activity).show(
                activity.getString(R.string.text_pincode_invalid_and_retry),
                activity.getString(R.string.know)
            ) { it.dismiss() }
        }

    }


    private fun countDownByFlow() {
        val totalTime = lockRemain - ((System.currentTimeMillis() - lockStartTime) / 1000).toInt()
        if (totalTime <= 0) {
            LogUtil.i("countDownByFlow  totalTime <= 0 ")
            stepBinding.tvTips.text = getString(R.string.text_input_your_pincode)
            return
        }
        cancelCountDown()
        LogUtil.d("countDownByFlow  $totalTime")
        mCountDown = startSendCodeCountdown(totalTime,
            {
                LogUtil.d("countDownByFlow onStart: $totalTime")
                settingLockTime(totalTime)
            },
            {
                if (BuildConfig.DEBUG) {
                    LogUtil.d("startSendCodeCountdown countDown: $totalTime $it")
                }
                settingLockTime(it)
            }, {
                LogUtil.d("startSendCodeCountdown finish: $totalTime ")
                val time = lockRemain - ((System.currentTimeMillis() - lockStartTime) / 1000).toInt()
                settingLockTime(time)
            })
    }

    private fun settingLockTime(totalTime: Int) {
        val content = if (totalTime > 0) {
            val showTime = if (totalTime > 60) {
                "${totalTime / 60}min"
            } else {
                "${totalTime}s"
            }
            stepBinding.pinCode.isEnabled = false
            activity.getString(R.string.text_max_attempts_try_later, showTime)
        } else {
            stepBinding.pinCode.isEnabled = true
            activity.getString(R.string.text_input_your_pincode)
        }
        stepBinding.tvTips.text = content
    }

    override fun onActivityResume() {
        super.onActivityResume()
        val totalTime = lockRemain - ((System.currentTimeMillis() - lockStartTime) / 1000).toInt()
        if (totalTime > 0) {
            LogUtil.d("onActivityResume  $totalTime    $mCountDown   ${mCountDown?.isDisposed}")
            countDownByFlow()
        }
    }

    override fun onDestroy() {
        cancelCountDown()

    }

    private fun cancelCountDown() {
        LogUtil.d("cancelCountDown  $mCountDown   ${mCountDown?.isDisposed}")
        mCountDown?.let {
            if (!it.isDisposed) {
                it.dispose()
                mCountDown = null
            }
        }
    }

    private fun startSendCodeCountdown(
        time: Int,
        onStart: (() -> Unit)?,
        onCountdown: ((Int) -> Unit)?,
        onFinish: (() -> Unit)?
    ): Disposable {
        return Flowable.intervalRange(1, time.toLong() + 1, 0, 1, TimeUnit.SECONDS)
            .onBackpressureLatest()
            .observeOn(AndroidSchedulers.mainThread())
            .doOnSubscribe {
                onStart?.invoke()
            }
            .doOnNext {
                onCountdown?.invoke(time - it.toInt())
            }
            .doOnComplete {
                onFinish?.invoke()
            }
            .subscribe()
    }

    // 请求网络
    private suspend fun getDevicePair(map: Map<String, Any>): Boolean {
        val did = map["did"]?.let { it as String } ?: ""
        val session = map["session"]?.let { it as String } ?: ""
        val secret = map["secret"]?.let { it as String } ?: ""
        val mac = map["mac"]?.let { it as String } ?: ""
        val ver = map["ver"]?.let { it as String } ?: ""
        val bindDomain = StepData.targetDomain
        val model = StepData.productModel
        val property = mapOf("session" to session)

        val req = DeviceBlePairReq(did, mac, ver, secret, model, property, bindDomain)
        val result = processApiResponse {
            DreameService.getDevicePair4Ble(req)
        }
        viewModel.dispatchAction(DeviceConnectBleUiAction.ShowLoading(false))
        if (result is Result.Success) {
            if (result.data == true) {
                handler.sendMessage(Message.obtain().apply {
                    what = CLICK_PIN_CODE_BIND
                    arg1 = 0
                })
                // 绑定
                return true
            } else {
                // 辣鸡，报错了 绑定失败
                nextUiConfig(UiConfig.UI_CONFIG_BLE_BIND_FAIL)
                handler.sendMessage(Message.obtain().apply {
                    what = CLICK_PIN_CODE_BIND_ERROR
                    arg1 = -1
                })
                return false
            }
        } else if (result is Result.Error) {
            when (result.exception.code) {
                -1 -> {
                    ToastUtils.show(result.exception.message)
                }

                else -> {
                    // 其他异常
                    handler.sendMessage(Message.obtain().apply {
                        what = CLICK_PIN_CODE_BIND
                        arg1 = result.exception.code
                    })

                    nextUiConfig(UiConfig.UI_CONFIG_BLE_BIND_FAIL)
                    handler.sendMessage(Message.obtain().apply {
                        what = CLICK_PIN_CODE_BIND_ERROR
                        arg1 = result.exception.code
                    })
                }
            }

            return false
        }
        return false
    }

}