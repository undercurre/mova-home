package com.dreame.feature.connect.config.step.bluetooth

import android.dreame.module.feature.connect.bluetooth.BleException
import android.dreame.module.feature.connect.bluetooth.BleGattAttributes
import android.dreame.module.feature.connect.bluetooth.BleGattException
import android.dreame.module.feature.connect.bluetooth.BleTimeoutException
import android.dreame.module.feature.connect.bluetooth.BluetoothLeManager
import android.dreame.module.feature.connect.bluetooth.BluetoothLeProtocol
import android.dreame.module.util.LogUtil
import android.os.Message
import com.dreame.smartlife.config.event.StepId
import com.dreame.smartlife.config.step.*
import android.dreame.module.feature.connect.bluetooth.callback.BleReadCallback
import android.dreame.module.feature.connect.bluetooth.callback.BleWriteCallback
import android.dreame.module.feature.connect.bluetooth.formatHexString
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.Job
import kotlinx.coroutines.cancel
import okhttp3.internal.EMPTY_BYTE_ARRAY
import org.json.JSONObject

class StepSendDataBle : SmartStepConfig() {
    private var connectionReqJob: Job? = null

    /**
     * 配网数据，发送步骤
     */
    private var sendStep: Int = STEP_SEND_DEFAULT
    private var retryReadCount = 0

    private var retryWriteCount = 0

    companion object {
        const val STEP_SEND_DEFAULT = 0
        const val STEP_SEND_QUERY = 1
        const val STEP_SEND_SETTING = 2
        const val STEP_SEND_FINISH = 3
        const val RETRY_READ_COUNT_MAX = 3
        const val RETRY_WRITE_COUNT_MAX = 2
    }

    /**
     * 配网参数组装
     */
    private val sendDataParam by lazy { SendDataParam() }

    // 保存服务端的密钥
    private var serverKeyValue: String? = null

    override fun stepName(): Step = Step.STEP_SEND_DATA_BLE

    override fun handleMessage(msg: Message) {


    }

    override fun stepCreate() {
        super.stepCreate()
        LogUtil.d(TAG, "stepCreate: StepBleSendData")
        getHandler().sendMessage(Message.obtain().apply {
            obj = StepResult(StepName.STEP_TRANSFORM, StepState.START)
        })
        sendData()
    }

    private fun readData() {
        LogUtil.d(TAG, "readData: ---------------")

        if (!BluetoothLeManager.isDeviceConnect(StepData.bleDeviceWrapper?.deviceWrapper)) {
            connectionReqJob?.cancel(CancellationException("device is disconnect !!!"))
            // 连接断开，直接跳转手动处理
            connectFail()
            return
        }
        StepData.bleDeviceWrapper?.deviceWrapper?.let {
            BluetoothLeManager.read(
                it,
                BleGattAttributes.CLIENT_CHARACTERISTIC_SERVICE,
                BleGattAttributes.CLIENT_CHARACTERISTIC_READ,
                readCallback
            )
        }
    }

    private fun sendData() {
        writeBleData()
    }

    private fun writeBleData() {
        LogUtil.i(TAG, "writeBleData sendData: $sendStep ")
        if (StepData.bleDeviceWrapper == null || !BluetoothLeManager.isDeviceConnect(StepData.bleDeviceWrapper?.deviceWrapper)) {
            connectionReqJob?.cancel(CancellationException("device is disconnect !!!"))
            // 连接断开，直接跳转手动处理
            connectFail()
            return
        }

        val data = when (sendStep) {
            STEP_SEND_DEFAULT, STEP_SEND_QUERY -> {
                val content = sendDataParam.requestConnectionParam()
                BluetoothLeProtocol.packageQueryData(content)
            }
            STEP_SEND_SETTING -> {
                val sendContent = sendDataParam.configureRouterParam(StepData.deviceId, serverKeyValue)
                BluetoothLeProtocol.packageSettingData(sendContent)
            }
            else -> {
                connectionReqJob?.cancel("send complete")
                EMPTY_BYTE_ARRAY
            }
        }
        LogUtil.i(TAG, "writeBleData sendData: $sendStep  ,size: ${data.size}  ,data: ${data.formatHexString()}")
        if (data.isNotEmpty()) {
            StepData.bleDeviceWrapper?.deviceWrapper?.let {
                BluetoothLeManager.write(
                    it,
                    BleGattAttributes.CLIENT_CHARACTERISTIC_SERVICE,
                    BleGattAttributes.CLIENT_CHARACTERISTIC_WRITE, data, writeCallback
                )
            }
        } else {
            connectFail()
        }
    }

    private fun sendDataError() {
        sendStep = STEP_SEND_FINISH
        LogUtil.i(TAG, "sendDataError: fail")
        if (canRetryStep(stepName())) {
            updateRetryCount(stepName())
            if (isGrantedPermission(permissionList)) {
                nextStep(Step.STEP_DEVICE_SCAN_BLE)
            } else {
                connectFail()
            }
        } else {
            connectFail()
        }
    }

    private fun connectFail() {
        getHandler().sendMessage(Message.obtain().apply
        {
            obj = StepResult(StepName.STEP_TRANSFORM, StepState.FAILED, stepId = StepId.STEP_CONNECT_DEVICE_BLE, reason = "connect fail")
        })
        // 设备断开连接
        disconnectBleDevice()
        resetRetryCount(stepName())
        // 第二步失败，跳转到手动UI，此处 step 切到手动
        if (StepData.stepModeDefault == StepData.StepMode.MODE_BOTH) {
            nextStep(Step.STEP_MANUAL_CONNECT)
        }
    }

    private val readCallback = object : BleReadCallback() {
        override fun onReadSuccess(data: ByteArray) {
            LogUtil.i(TAG, "onReadSuccess------0-----: $sendStep  ${data.formatHexString()}")
            // 解析协议内容
            when (sendStep) {
                STEP_SEND_DEFAULT, STEP_SEND_QUERY -> {
                    val result = BluetoothLeProtocol.parseQueryACKData(data)
                    LogUtil.i(TAG, "onReadSuccess -------1------:$sendStep  ${result.first}  ${result.second}")
                    if (result.first == 0) {
                        val sendContent = if (result.second.startsWith("{") || result.second.startsWith("[")) {
                            val resultJson = JSONObject(result.second)
                            val method = resultJson.getString("method")
                            connectionReqJob?.cancel("connect success").also { connectionReqJob = null }
                            val deviceId = resultJson.optString("did")
                            StepData.deviceId = deviceId
                            val value = resultJson.optString("value")
                            serverKeyValue = value
                            sendDataParam.configureRouterParam(deviceId, value)
                        } else {
                            //
                            serverKeyValue = ""
                            StepData.deviceId = result.second
                            sendDataParam.configureRouterParam(result.second, serverKeyValue)
                        }
                        LogUtil.i(TAG, "onReceive: router request: $sendContent")
                        // 下一步
                        sendStep = STEP_SEND_SETTING
                        retryWriteCount = 0
                        LogUtil.i(TAG, "onReadSuccess send : $sendContent")
                        val settingData = BluetoothLeProtocol.packageSettingData(sendContent)
                        LogUtil.i(TAG, "onReadSuccess send : ${settingData.size}")
                        StepData.bleDeviceWrapper?.deviceWrapper?.let {
                            BluetoothLeManager.write(
                                it,
                                BleGattAttributes.CLIENT_CHARACTERISTIC_SERVICE,
                                BleGattAttributes.CLIENT_CHARACTERISTIC_WRITE, settingData, writeCallback
                            )
                        }

                    } else {
                        serverKeyValue = null
                        sendStep = STEP_SEND_QUERY
                    }
                }

                STEP_SEND_SETTING -> {
                    val result = BluetoothLeProtocol.parseSettingACKData(data)
                    LogUtil.i(TAG, "onReadSuccess ----STEP_SEND_SETTING------- :$sendStep  ${result.first}  ${result.second}")
                    if (result.first == 0) {
                        connectionReqJob?.cancel(CancellationException("send data is complete !!!"))
                        // fixme 成功，json解析
                        serverKeyValue = null
                        sendStep = STEP_SEND_FINISH
                        getHandler().sendMessage(Message.obtain().apply {
                            obj = StepResult(StepName.STEP_TRANSFORM, StepState.SUCCESS)
                        })
                        resetRetryCount(stepName())
                        nextStep(Step.STEP_CHECK_DEVICE_PAIR_STATE)
                    } else {
                        sendStep = STEP_SEND_SETTING
                    }
                }
                STEP_SEND_FINISH -> {

                }
            }
        }

        override fun onReadFailure(exception: BleException) {
            super.onReadFailure(exception)
            LogUtil.e(TAG, "onReadFailure: ${exception.code} ${exception.description}")

            if (exception is BleTimeoutException) {
                LogUtil.e(TAG, "onReadFailure: BleTimeoutException ${exception.code} ${exception.description}")
                // 重试一次
                if (retryReadCount < RETRY_READ_COUNT_MAX) {
                    readData()
                    retryReadCount++
                    return
                }
            }
            sendDataError()

        }
    }
    private val writeCallback = object : BleWriteCallback() {
        override fun onWriteSuccess(current: Int, total: Int, justWrite: ByteArray) {
            super.onWriteSuccess(current, total, justWrite)
            LogUtil.i(TAG, "onWriteSuccess: $current $total ${justWrite.contentToString()}")

            if (sendStep == STEP_SEND_SETTING) {
                connectionReqJob?.cancel(CancellationException("package2 send  data success !!!"))
            }
            // 发送成功，读
            readData()
        }

        override fun onWriteFailure(exception: BleException) {
            super.onWriteFailure(exception)
            LogUtil.e(TAG, "onWriteFailure: ${exception.code} ${exception.description}")

            if (exception is BleGattException) {
                if (exception.gattStatus == 133) {
                    // 断开重连
                    sendDataError()
                    return
                }
            }
            if (retryWriteCount < RETRY_WRITE_COUNT_MAX) {
                retryWriteCount++
                sendData()
            }

        }
    }

    override fun stepDestroy() {
        connectionReqJob?.cancel("stepDestroy").also { connectionReqJob = null }
        // 清空所有连接
        disconnectBleDevice()
    }

    private fun disconnectBleDevice() {
        BluetoothLeManager.onDestroy()
    }
}