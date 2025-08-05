package com.dreame.feature.connect.config.step.bluetooth

import android.dreame.module.data.Result
import android.dreame.module.data.entry.device.DeviceBlePairNonceReq
import android.dreame.module.data.network.service.DreameService
import android.dreame.module.ext.processApiResponse
import android.dreame.module.feature.connect.bluetooth.BleException
import android.dreame.module.feature.connect.bluetooth.BleGattAttributes
import android.dreame.module.feature.connect.bluetooth.BleGattException
import android.dreame.module.feature.connect.bluetooth.BleTimeoutException
import android.dreame.module.feature.connect.bluetooth.BluetoothLeManager
import android.dreame.module.manager.AreaManager
import android.dreame.module.util.LogUtil
import android.os.Message
import com.dreame.feature.connect.config.step.bluetooth.protocol.McuSendDataParam
import com.dreame.smartlife.config.step.SmartStepConfig
import com.dreame.smartlife.config.step.StepData
import com.dreame.smartlife.config.step.StepName
import com.dreame.smartlife.config.step.StepResult
import com.dreame.smartlife.config.step.StepState
import android.dreame.module.feature.connect.bluetooth.callback.BleReadCallback
import android.dreame.module.feature.connect.bluetooth.callback.BleWriteCallback
import android.dreame.module.feature.connect.bluetooth.formatHexString
import kotlinx.coroutines.Job
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch
import okhttp3.internal.EMPTY_BYTE_ARRAY
import kotlin.coroutines.cancellation.CancellationException

/**
 * 单片机配网协议
 */
class StepSendDataBleMcu : SmartStepConfig() {
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
    private val sendDataParam by lazy { McuSendDataParam() }

    override fun stepName(): Step = Step.STEP_SEND_DATA_BLE

    override fun handleMessage(msg: Message) {


    }

    override fun stepCreate() {
        super.stepCreate()
        LogUtil.d(TAG, "stepCreate: StepBleSendData")
        getHandler().sendMessage(Message.obtain().apply {
            obj = StepResult(StepName.STEP_TRANSFORM, StepState.START, canManualConnect = StepData.stepModeDefault == StepData.StepMode.MODE_BOTH)
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
                sendDataParam.packageRandomCode()
            }

            STEP_SEND_SETTING -> {
                sendDataParam.packageConfigNet(1)
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
            obj = StepResult(
                StepName.STEP_TRANSFORM,
                StepState.STOP,
                reason = "connect fail",
                canManualConnect = StepData.stepModeDefault == StepData.StepMode.MODE_BOTH
            )
        })
        // 设备断开连接
        disconnectBleDevice()
        resetRetryCount(stepName())
    }

    private val readCallback = object : BleReadCallback() {
        override fun onReadSuccess(data: ByteArray) {
            LogUtil.i(TAG, "onReadSuccess------0-----: $sendStep  ${data.formatHexString()}")
            // 解析协议内容
            when (sendStep) {
                STEP_SEND_DEFAULT, STEP_SEND_QUERY -> {
                    val result = sendDataParam.parseRandomCode(data)
                    LogUtil.i(TAG, "onReadSuccess -------1------:$sendStep  ${result}")
                    if (result.isNotEmpty()) {
                        // 成功，json解析
                        periodicNetwork(result)
                    } else {
                        sendStep = STEP_SEND_QUERY
                    }
                }

                STEP_SEND_SETTING -> {
                    val result = sendDataParam.packageConfigNet(data)
                    LogUtil.i(TAG, "onReadSuccess ----STEP_SEND_SETTING------- :$sendStep  ${result}")
                    if (result["code"] == "1") {
                        connectionReqJob?.cancel(CancellationException("send data is complete !!!"))
                        // fixme 成功，json解析
                        sendStep = STEP_SEND_FINISH
                        getHandler().sendMessage(Message.obtain().apply {
                            obj = StepResult(
                                StepName.STEP_TRANSFORM,
                                StepState.SUCCESS,
                                canManualConnect = StepData.stepModeDefault == StepData.StepMode.MODE_BOTH
                            )
                        })
                        resetRetryCount(stepName())
                        getHandler().sendMessage(Message.obtain().apply {
                            obj = StepResult(StepName.STEP_CHECK, StepState.SUCCESS, canManualConnect = StepData.stepModeDefault == StepData.StepMode.MODE_BOTH)
                        })
                        finish(true)
                    } else {
                        sendStep = STEP_SEND_SETTING
                        getHandler().sendMessage(Message.obtain().apply {
                            obj = StepResult(
                                StepName.STEP_TRANSFORM,
                                StepState.SUCCESS,
                                canManualConnect = StepData.stepModeDefault == StepData.StepMode.MODE_BOTH
                            )
                        })
                        resetRetryCount(stepName())
                        getHandler().sendMessage(Message.obtain().apply {
                            obj = StepResult(StepName.STEP_CHECK, StepState.FAILED, canManualConnect = StepData.stepModeDefault == StepData.StepMode.MODE_BOTH)
                        })
                        finish(false)
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
//            if (sendStep >= STEP_SEND_SETTING) {
//
//            } else {
            sendDataError()
//            }

        }
    }


    private val writeCallback = object : BleWriteCallback() {
        override fun onWriteSuccess(current: Int, total: Int, justWrite: ByteArray) {
            super.onWriteSuccess(current, total, justWrite)
            LogUtil.i(TAG, "onWriteSuccess: $current $total ${justWrite.formatHexString()}")

            if (sendStep == STEP_SEND_SETTING) {
                connectionReqJob?.cancel(CancellationException("package2 send  data success !!!"))
//                sendStep = STEP_SEND_FINISH
//                getHandler().sendMessage(Message.obtain().apply {
//                    obj = StepResult(StepName.STEP_TRANSFORM, StepState.SUCCESS, canManualConnect = StepData.stepModeDefault == StepData.StepMode.MODE_BOTH)
//                })
//                resetRetryCount(stepName())
//                val packageConfigNet = sendDataParam.packageConfigNet(justWrite)["code"] == "1"
//                getHandler().sendMessage(Message.obtain().apply {
//                    val state = if (packageConfigNet) {
//                        StepState.SUCCESS
//                    } else {
//                        StepState.FAILED
//                    }
//                    obj = StepResult(StepName.STEP_CHECK, state, canManualConnect = StepData.stepModeDefault == StepData.StepMode.MODE_BOTH)
//                })
//                finish(packageConfigNet)
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
        periodicNetworkJob?.cancel("stepDestroy").also { periodicNetworkJob = null }
        // 清空所有连接
        disconnectBleDevice()
    }

    private fun disconnectBleDevice() {
        BluetoothLeManager.onDestroy()
    }

    // 周期性的网络请求
    var periodicNetworkJob: Job? = null
    private fun periodicNetwork(map: Map<String, Any>) {
        periodicNetworkJob = launch {
            val ret = getDevicePair(map)
        }
    }

    // 请求网络
    private suspend fun getDevicePair(map: Map<String, Any>): Boolean {
        val did = map["did"]?.let { it as String } ?: ""
        val mac = map["mac"]?.let { it as String } ?: ""
        val ver = map["ver"]?.let { it as String } ?: ""
        val nonce = map["nonce"]?.let { it as String } ?: ""
        val encryptUid = map["encryptUid"]?.let { it as String } ?: ""
        val model = StepData.productModel
        val property = emptyMap<String, String>()
        var bindDomain = StepData.targetDomain

        /// 如果bindDomain为空，需要重新获取
        if (bindDomain.isBlank()) {
            val bindDomainResult = processApiResponse {
                DreameService.getMqttDomainV2(AreaManager.getRegion(), false)
            }
            if (bindDomainResult is Result.Success) {
                bindDomain = bindDomainResult.data?.regionUrl ?: ""
            }
        }

        val req = DeviceBlePairNonceReq(
            did = did,
            model = model,
            nonce = nonce,
            bindDomain = bindDomain,
            mac = mac,
            ver = ver,
            encryptUid = encryptUid,
            property = property
        )

        val result = processApiResponse {
            DreameService.getDevicePairByNonce(req)
        }
        if (result is Result.Success) {
            LogUtil.i(TAG, "getDevicePair: ${result}")
            if (result.data == true) {
                // 绑定成功
                nextSendStep(true)
            } else {
                // 绑定失败
                nextSendStep(false)
            }
            return true
        } else {
            // 绑定失败
            nextSendStep(false)
        }
        return false
    }

    private fun nextSendStep(success: Boolean) {
        // 下一步
        sendStep = STEP_SEND_SETTING
        retryWriteCount = 0
        val settingData = sendDataParam.packageConfigNet(if (success) 1 else 0)
        LogUtil.i(TAG, "onReadSuccess send : ${settingData.size}")
        StepData.bleDeviceWrapper?.deviceWrapper?.let {
            BluetoothLeManager.write(
                it,
                BleGattAttributes.CLIENT_CHARACTERISTIC_SERVICE,
                BleGattAttributes.CLIENT_CHARACTERISTIC_WRITE, settingData, writeCallback
            )
        }

    }
}