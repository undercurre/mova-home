package com.dreame.smartlife.config.step

import android.app.Activity
import android.content.Intent
import android.dreame.module.constant.ParameterConstants
import android.dreame.module.util.LogUtil
import android.net.ConnectivityManager
import android.os.*
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity
import com.dreame.feature.connect.config.step.bluetooth.BleDeviceScanner
import com.dreame.feature.connect.scan.DeviceScanCache
import com.dreame.smartlife.config.event.StepId
import android.dreame.module.feature.connect.bluetooth.BluetoothLeManager
import java.util.*

/**
 * # 设备配网步骤帮助类
 * - 调用[startFirstPage]开始配网,配往前需要设置[StepData]
 * - 配网Activity需要处理[handleMessage]事件,确保当前[handler]与配网页面Handler为同一个
 * - 关闭配网页面,需要调用[onDestroy]方法释放资源
 * - 正常流程
 * 1. [STEP_WIFI_PERMISSION_CHECK]
 * 2. [STEP_APP_WIFI_SCAN]
 * 3. [STEP_CONNECT_DEVICE_AP]
 * 4. [STEP_CONNECT_CHECK]
 * 5. [STEP_SEND_DATA_WIFI]
 * 6. [STEP_CHECK_DEVICE_PAIR_STATE]
 * 7. [STEP_CHECK_DEVICE_ONLINE_STATE]
 * 8. [STEP_BIND_ALI_DEVICE]
 * ## [配网流程图](https://www.processon.com/diagraming/6143fee37d9c083db05e8027)
 */
class SmartStepHelper private constructor() {

    companion object {
        val instance by lazy(mode = LazyThreadSafetyMode.SYNCHRONIZED) { SmartStepHelper() }
    }

    private val TAG = SmartStepHelper::class.simpleName
    private val stepStack: Stack<SmartStepConfig> = Stack()
    private val stepRetryMap = mutableMapOf<SmartStepConfig.Step, Int>()
    private var activity: Activity? = null
    private var handler: WeakHandler? = null

    private val stepConfigCallback: SmartStepConfig.StepConfigCallback by lazy {
        object : SmartStepConfig.StepConfigCallback {

            override fun bindHandler(): Handler {
                return handler ?: Handler(Looper.getMainLooper())
            }

            override fun nextStep(step: SmartStepConfig.Step) {
                popStep()
                switchToStep(step)
            }

            override fun finish(success: Boolean) {
                if (success) {
                    DeviceScanCache.clear()
                }
            }

            override fun updateRetryCount(step: SmartStepConfig.Step) {
                val count = stepRetryMap[step] ?: 0
                stepRetryMap[step] = count.plus(1)
            }

            override fun stepRetryCount(step: SmartStepConfig.Step): Int {
                return stepRetryMap[step] ?: 0
            }

            override fun resetRetryCount(step: SmartStepConfig.Step) {
                stepRetryMap[step] = 0
            }

        }
    }

    /**
     * 出栈
     */
    private fun popStep() {
        while (!stepStack.isEmpty()) {
            val pop = stepStack.pop()
            if (pop.isStepRunning()) {
                // 隐藏在后台的step,销毁，注意stepDestroy方法重复调用问题
                pop.stepDestroy()
            }
        }
    }

    /**
     * 当前step
     */
    fun isManualConnectStep(): Boolean {
        if (stepStack.isEmpty()) {
            return false;
        }
        return stepStack.peek() is StepManualConnect;
    }

    /**
     * Android Q以上热点连接callback
     */
    @RequiresApi(Build.VERSION_CODES.Q)
    var networkCallback: ConnectivityManager.NetworkCallback? = null

    /**
     * 开始配网
     * @param activity 当前所依附的Activity
     * @param handler 当前Activity提供的Handler
     */
    fun startFirstPage(activity: AppCompatActivity, handler: WeakHandler, stepId: Int = StepData.nextStepId) {
        this.activity = activity
        this.handler = handler
        stepStack.clear()
        stepRetryMap.clear()

        if (stepId < StepId.STEP_MANUAL_CONNECT) {
            this.handler?.sendMessage(Message.obtain().apply {
                obj = StepResult(StepName.STEP_CONNECT, StepState.START)
            })
        }
        // 初始化 模式
        Log.i(TAG, "startFirstPage current mode is : ${StepData.stepMode}")
        // 配网码配网
        if (stepId == StepId.STEP_QR_NET_PAIR) {
            switchToStep(SmartStepConfig.Step.STEP_QR_NET_PAIR)
        } else if (stepId == StepId.STEP_MANUAL_CONNECT) {
            switchToStep(SmartStepConfig.Step.STEP_MANUAL_CONNECT)
        } else if (stepId == StepId.STEP_CONNECT_DEVICE_AP) {
            switchToStep(SmartStepConfig.Step.STEP_CONNECT_DEVICE_AP)
        } else if (stepId == StepId.STEP_SEND_DATA_WIFI) {
            handler.sendMessage(Message.obtain().apply {
                obj = StepResult(StepName.STEP_CONNECT, StepState.SUCCESS)
            })
            switchToStep(SmartStepConfig.Step.STEP_SEND_DATA_WIFI)
        } else if (stepId == StepId.STEP_SEND_DATA_BLE) {
            switchToStep(SmartStepConfig.Step.STEP_MANUAL_CONNECT)
        } else if (stepId == StepId.STEP_CONNECT_DEVICE_BLE) {
            switchToStep(SmartStepConfig.Step.STEP_MANUAL_CONNECT)
        } else if (stepId == StepId.STEP_CHECK_DEVICE_PAIR_STATE) {
            switchToStep(SmartStepConfig.Step.STEP_CHECK_DEVICE_PAIR_STATE)
        } else if (stepId == StepId.STEP_CHECK_DEVICE_ONLINE_STATE) {
            switchToStep(SmartStepConfig.Step.STEP_CHECK_DEVICE_ONLINE_STATE)
        } else if (stepId == StepId.STEP_BIND_ALI_DEVICE) {
            switchToStep(SmartStepConfig.Step.STEP_BIND_ALI_DEVICE)
        } else if (StepData.enterOrigin == ParameterConstants.ORIGIN_QR && !StepData.productWifiName.isNullOrBlank()) {
            switchToStep(SmartStepConfig.Step.STEP_CONNECT_DEVICE_AP_QR)
        } else if (stepId == StepId.STEP_DEVICE_SCAN_BLE) {
            switchToStep(SmartStepConfig.Step.STEP_DEVICE_SCAN_BLE)
        } else {
            switchToStep(SmartStepConfig.Step.STEP_WIFI_PERMISSION_CHECK)
        }
    }

    /**
     * Activity handler处理step消息
     * msg.what  定义规则：> 1000 并且10进制 1_x000 wifi 2_x000 ble
     * x 代表step递增 checkpermission > scan > connect > check connect > send data -> pair -> online
     *                        1      >  2   >   3     >        4      >      5     >  6     >  7
     */
    fun handleMessage(message: Message) {
        if (!stepStack.empty()) {
            stepStack.peek().handleMessage(message)
        } else {
            LogUtil.i(TAG, "handleMessage: ${message.what}")
        }
    }

    fun getCurrentStepId(): Int {
        return if (!stepStack.empty()) {
            val peek = stepStack.peek()
            peek?.let {
                when (it.stepName()) {
                    SmartStepConfig.Step.STEP_APP_WIFI_SCAN -> StepId.STEP_APP_WIFI_SCAN
                    SmartStepConfig.Step.STEP_DEVICE_SCAN_BLE -> StepId.STEP_DEVICE_SCAN_BLE
                    SmartStepConfig.Step.STEP_CONNECT_DEVICE_AP -> StepId.STEP_CONNECT_DEVICE_AP
                    SmartStepConfig.Step.STEP_CONNECT_DEVICE_BLE -> StepId.STEP_CONNECT_DEVICE_BLE
                    SmartStepConfig.Step.STEP_CONNECT_CHECK -> StepId.STEP_CONNECT_CHECK
                    SmartStepConfig.Step.STEP_SETTING_CHECK_BLE -> StepId.STEP_SETTING_CHECK_BLE
                    SmartStepConfig.Step.STEP_SEND_DATA_WIFI -> StepId.STEP_SEND_DATA_WIFI
                    SmartStepConfig.Step.STEP_SEND_DATA_WIFI_QR -> StepId.STEP_SEND_DATA_WIFI
                    SmartStepConfig.Step.STEP_SEND_DATA_BLE, SmartStepConfig.Step.STEP_SEND_DATA_BLE_MOWER,
                    SmartStepConfig.Step.STEP_SEND_DATA_BLE_MCU -> StepId.STEP_SEND_DATA_BLE

                    SmartStepConfig.Step.STEP_MANUAL_CONNECT -> StepId.STEP_MANUAL_CONNECT
                    SmartStepConfig.Step.STEP_MANUAL_CONNECT_QR -> StepId.STEP_MANUAL_CONNECT
                    SmartStepConfig.Step.STEP_CHECK_DEVICE_PAIR_STATE -> StepId.STEP_CHECK_DEVICE_PAIR_STATE
                    SmartStepConfig.Step.STEP_CHECK_DEVICE_ONLINE_STATE -> StepId.STEP_CHECK_DEVICE_ONLINE_STATE
                    SmartStepConfig.Step.STEP_WIFI_PERMISSION_CHECK -> StepId.STEP_APP_WIFI_PERMISSION
                    SmartStepConfig.Step.STEP_BIND_ALI_DEVICE -> StepId.STEP_BIND_ALI_DEVICE
                    SmartStepConfig.Step.STEP_QR_NET_PAIR -> StepId.STEP_QR_NET_PAIR
                    else -> {
                        -1
                    }
                }
            } ?: -1

        } else {
            return -1
        }
    }

    /**
     * 页面销毁，release资源
     */
    fun onDestroy() {
        if (!stepStack.isEmpty()) {
            stepStack.peek().disconnectWifi()
        }
        // clear ble
        BluetoothLeManager.onDestroy()
        popStep()
        handler = null
        activity = null

    }

    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (!stepStack.isEmpty()) {
            stepStack.peek().onActivityResult(requestCode, resultCode, data)
        }
    }

    fun currentWifiName(): String {
        if (!stepStack.isEmpty()) {
            return stepStack.peek().currentConnectedSsid()
        }
        return ""
    }

    private fun switchToStep(step: SmartStepConfig.Step?) {
        if (step == null) {
            return
        }
        val stepConfig = SmartStepConfig.findStep(step)
        if (stepConfig != null) {
            LogUtil.i(TAG, "switchToStep: $stepConfig")
            // 蓝牙打开，则优先使用蓝牙
            if (BleDeviceScanner.isOpen() && StepData.stepModeDefault == StepData.StepMode.MODE_BOTH) {
                if (addBleScanStep(step)) {
                    // 设置优先级，优先蓝牙连接
                    StepData.stepModeDelay = DELAY_WIFI_TIME
                    // 设置优先级，优先蓝牙连接

                    // 此处控制同时开始单个
//                    return
                }
            }
            stepStack.push(stepConfig)
            stepConfig.stepConfigCallback = stepConfigCallback
            activity?.let {
                stepConfig.bindActivity(it)
            }

        }
        if (step == SmartStepConfig.Step.STEP_APP_WIFI_SCAN || step == SmartStepConfig.Step.STEP_DEVICE_SCAN_BLE) {
            // 切换状态到扫描态
            StepData.stepMode = StepData.StepMode.MODE_SCANNING
        }
    }

    private fun addBleScanStep(step: SmartStepConfig.Step): Boolean {
        if (step == SmartStepConfig.Step.STEP_APP_WIFI_SCAN) {
            Log.i(TAG, "switchToStep change current mode is : ${StepData.stepMode}   ${StepData.stepModeDefault}")
            if (StepData.stepModeDefault == StepData.StepMode.MODE_BOTH) {
                val stepConfig = SmartStepConfig.findStep(SmartStepConfig.Step.STEP_DEVICE_SCAN_BLE)
                if (stepConfig != null) {
                    LogUtil.i(TAG, "addBleScanStep: $stepConfig")
                    stepStack.push(stepConfig)
                    stepConfig.stepConfigCallback = stepConfigCallback
                    stepConfig.bindActivity(activity!!)
                    return true
                }
            }
        }
        return false

    }

}