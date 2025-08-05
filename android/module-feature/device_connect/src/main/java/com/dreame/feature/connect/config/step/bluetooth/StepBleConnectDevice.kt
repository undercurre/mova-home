package android.dreame.module.feature.connect.bluetooth

import android.app.Activity
import android.dreame.module.bean.device.BluetoothDeviceWrapper
import android.dreame.module.util.LogUtil
import android.os.Message
import android.os.SystemClock
import com.dreame.smartlife.config.event.StepId
import com.dreame.smartlife.config.step.SmartStepConfig
import com.dreame.smartlife.config.step.StepData
import com.dreame.smartlife.config.step.StepName
import com.dreame.smartlife.config.step.StepResult
import com.dreame.smartlife.config.step.StepState
import android.dreame.module.feature.connect.bluetooth.callback.BleConnectGattCallback

class StepBleConnectDevice : SmartStepConfig() {
    /**
     * 133 重试一次
     */
    companion object {
        private const val MSG_RETRY = 23100
        private const val MSG_RETRY_DELAY = 5_000L
    }

    @Volatile
    private var retryCount = 5

    /**
     *    是否是直连模式
     */
    private var isConnectDirectly = false
    private var connectDirectlyBlock: ((success: Boolean) -> Unit)? = null

    override fun stepName(): Step = Step.STEP_CONNECT_DEVICE_BLE

    override fun handleMessage(msg: Message) {
        when (msg.what) {
            MSG_RETRY -> {
                LogUtil.i("onConnectFail133:handleMessage  retry")
                // retry 一次
                connectDevice()
            }
        }
    }

    override fun stepCreate() {
        super.stepCreate()
        retryCount = 5
        LogUtil.i("stepCreate: $this")
        connectDevice()
    }

    /**
     * 直连一次
     */
    fun connectDeviceDirectly(context: Activity, block: (success: Boolean) -> Unit) {
        stepRunning = true
        this.context = context
        isConnectDirectly = true
        connectDirectlyBlock = block
        retryCount = 0
        LogUtil.i("connectDeviceDirectly: $this")
        connectDevice()
    }

    /**
     * 连接设备
     */
    private fun connectDevice() {
        LogUtil.i("connectDevice: ${StepData.bleDeviceWrapper?.deviceWrapper}")
        if (StepData.bleDeviceWrapper?.deviceWrapper == null) {
            //
            getHandler().sendMessage(Message.obtain().apply {
                obj = StepResult(
                    StepName.STEP_CONNECT,
                    StepState.FAILED,
                    stepId = StepId.STEP_CONNECT_DEVICE_BLE,
                    reason = "disconnect",
                    canManualConnect = StepData.stepModeDefault == StepData.StepMode.MODE_BOTH
                )
            })
            gotoNextStep()
            return
        }
        StepData.connectStartTime = SystemClock.elapsedRealtime();
        StepData.pairNetMethod = 2
        if (BluetoothLeManager.isDeviceConnect(StepData.bleDeviceWrapper?.deviceWrapper)) {
            nextStep(Step.STEP_SETTING_CHECK_BLE)
        } else {
            StepData.bleDeviceWrapper?.deviceWrapper?.let {
                BluetoothLeManager.connectDevice(context, it, false, callback)
            }
        }
    }

    val callback = object : BleConnectGattCallback() {
        override fun onStartConnect() {
            LogUtil.i("onStartConnect: ")
            getHandler().sendMessage(Message.obtain().apply {
                obj = StepResult(StepName.STEP_CONNECT, StepState.START)
            })
        }

        override fun onConnectFail(device: BluetoothDeviceWrapper, exception: BleException) {
            // 手动
            LogUtil.i("onConnectFail: ${exception.description}")
            getHandler().sendMessage(Message.obtain().apply {
                obj = StepResult(
                    StepName.STEP_CONNECT,
                    StepState.FAILED,
                    stepId = StepId.STEP_CONNECT_DEVICE_BLE,
                    reason = "connect fail",
                    canManualConnect = StepData.stepModeDefault == StepData.StepMode.MODE_BOTH
                )
            })
            gotoNextStep()
        }


        override fun onConnectFail133(device: BluetoothDeviceWrapper, exception: BleException) {
            LogUtil.i("onConnectFail133: ${exception.description}")
            if (retryCount > 0) {
                LogUtil.i("onConnectFail133:disConnectDevice ")
                retryCount--;
                StepData.bleDeviceWrapper?.timestamp = SystemClock.elapsedRealtime()
                StepData.bleDeviceWrapper?.deviceWrapper?.let { BluetoothLeManager.disConnectDevice(it) }
                getHandler().sendEmptyMessageDelayed(MSG_RETRY, MSG_RETRY_DELAY)
            } else {
                onConnectFail(device, exception)
            }
        }

        override fun onConnectSuccess(device: BluetoothDeviceWrapper, status: Int) {
            LogUtil.i("onConnectSuccess: $status")

        }

        override fun onDiscoverFail(device: BluetoothDeviceWrapper, exception: BleException) {
            LogUtil.i("onDiscoverFail: ${exception.description}")
            getHandler().sendMessage(Message.obtain().apply {
                obj = StepResult(
                    StepName.STEP_CONNECT,
                    StepState.FAILED,
                    stepId = StepId.STEP_CONNECT_DEVICE_BLE,
                    reason = "connect fail",
                    canManualConnect = StepData.stepModeDefault == StepData.StepMode.MODE_BOTH
                )
            })
            BluetoothLeManager.disConnectDevice(device)
            gotoNextStep()
        }

        override fun onDiscoverSuccess(device: BluetoothDeviceWrapper, status: Int) {
            super.onDiscoverSuccess(device, status)
            LogUtil.i("onDiscoverSuccess: device: $device  ,status: $status")
            getHandler().sendMessage(Message.obtain().apply {
                obj = StepResult(StepName.STEP_CONNECT, StepState.SUCCESS)
            })
            gotoNextStep(true)
        }

        override fun onDisConnected(isActiveDisConnected: Boolean, device: BluetoothDeviceWrapper, status: Int) {
            LogUtil.i("onDisConnected: $isActiveDisConnected  $device  $status")
            if (!isActiveDisConnected) {
                // 手动
                getHandler().sendMessage(Message.obtain().apply {
                    obj = StepResult(
                        StepName.STEP_CONNECT,
                        StepState.FAILED,
                        stepId = StepId.STEP_CONNECT_DEVICE_BLE,
                        reason = "disconnect",
                        canManualConnect = StepData.stepModeDefault == StepData.StepMode.MODE_BOTH
                    )
                })
                gotoNextStep()
            }
        }
    }

    /**
     * 下一步， 默认失败
     */
    private fun gotoNextStep(success: Boolean = false) {
        // 成功
        if (success) {
            connectDirectlyBlock?.invoke(true)
            nextStep(Step.STEP_SETTING_CHECK_BLE)
            StepData.deviceApName = StepData.bleDeviceWrapper?.wifiName ?: ""
            return
        }
        // 失败
        if (isConnectDirectly) {
            // 回退
            if (connectDirectlyBlock != null) {
                connectDirectlyBlock?.invoke(false)
            } else {
                if (StepData.stepModeDefault == StepData.StepMode.MODE_BOTH) {
                    nextStep(Step.STEP_MANUAL_CONNECT)
                }
            }

        } else {
            if (StepData.stepModeDefault == StepData.StepMode.MODE_BOTH) {
                nextStep(Step.STEP_MANUAL_CONNECT)
            }
        }
    }

    override fun stepDestroy() {
        StepData.bleDeviceWrapper?.deviceWrapper?.let {
            BluetoothLeManager.removeConnectCallback(it, callback)
        }
    }
}
