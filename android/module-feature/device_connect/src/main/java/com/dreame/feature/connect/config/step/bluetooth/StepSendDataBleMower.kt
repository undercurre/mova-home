package android.dreame.module.feature.connect.bluetooth

import android.dreame.module.bean.device.BluetoothDeviceWrapper
import android.dreame.module.manager.AccountManager
import android.dreame.module.util.LogUtil
import android.os.Message
import com.dreame.smartlife.config.event.StepId
import com.dreame.smartlife.config.step.CLICK_PIN_CODE_BIND
import com.dreame.smartlife.config.step.CLICK_PIN_CODE_BIND_WIFI
import com.dreame.smartlife.config.step.CLICK_PIN_CODE_CONFIG
import com.dreame.smartlife.config.step.CLICK_PIN_CODE_CONFIG_SKIP
import com.dreame.smartlife.config.step.CLICK_PIN_CODE_CONNECT
import com.dreame.smartlife.config.step.CODE_DISCONNECT_BLE
import com.dreame.smartlife.config.step.MowerSendDataParam
import com.dreame.smartlife.config.step.SmartStepConfig
import com.dreame.smartlife.config.step.StepData
import com.dreame.smartlife.config.step.StepName
import com.dreame.smartlife.config.step.StepResult
import com.dreame.smartlife.config.step.StepState
import android.dreame.module.feature.connect.bluetooth.callback.BleConnectGattCallback
import android.dreame.module.feature.connect.bluetooth.callback.BleReadCallback
import android.dreame.module.feature.connect.bluetooth.callback.BleWriteCallback

/**
 * 割草机配网协议
 */
class StepSendDataBleMower : SmartStepConfig() {
    /**
     * 配网数据，发送步骤
     */
    private var sendStep: Int = STEP_SEND_CHECK
    private var retryReadCount = 0

    private var retryWriteCount = 0

    // 保存机器回复数据
    private var mapData: Map<String, Any>? = null

    companion object {
        const val STEP_SEND_CHECK = 0
        const val STEP_SEND_PIN_CODE = 1
        const val STEP_SEND_CONNECT_SERVER = 2
        const val STEP_SEND_BINDING = 3
        const val STEP_SEND_CONFIG_NET = 4
        const val STEP_SEND_CONFIG_NET_SKIP = 5
        const val STEP_SEND_BINDING_WIFI = 6
        const val STEP_SEND_FINISH = 100
        const val RETRY_READ_COUNT_MAX = 2
        const val RETRY_WRITE_COUNT_MAX = 2
    }

    /**
     * 配网参数组装
     */
    private val sendDataParam by lazy { MowerSendDataParam() }

    private var currentData = byteArrayOf()

    override fun stepName(): Step = Step.STEP_SEND_DATA_BLE_MOWER

    override fun handleMessage(msg: Message) {
        when (msg.what) {
            CLICK_PIN_CODE_CONNECT -> {
                sendStep = STEP_SEND_PIN_CODE
                getHandler().sendMessage(Message.obtain().apply {
                    obj = StepResult(StepName.STEP_PIN_CODE_INPUT, StepState.START, stepId = StepId.STEP_CONNECT_DEVICE_BLE)
                })
                if (msg.obj != null) {
                    val pcode = msg.obj as String
                    val uid = AccountManager.getInstance().account?.uid ?: ""
                    val param = sendDataParam.requestConnectionParam(uid, pcode)
                    LogUtil.i(TAG, "writeBleData sendData: STEP_SEND_CONNECT  $param")
                    val data = BluetoothLeProtocol.packageQueryData(param)
                    writeBleData(data)
                }
            }

            CLICK_PIN_CODE_BIND -> {
                sendStep = STEP_SEND_BINDING
                getHandler().sendMessage(Message.obtain().apply {
                    obj = StepResult(StepName.STEP_PIN_CODE_BIND, StepState.START, stepId = StepId.STEP_CONNECT_DEVICE_BLE)
                })
                val param = sendDataParam.requestBindParam(msg.arg1)
                LogUtil.i(TAG, "writeBleData sendData: STEP_SEND_BINDING  $param")
                val data = BluetoothLeProtocol.packageQueryData(param)
                writeBleData(data)
            }

            CLICK_PIN_CODE_BIND_WIFI -> {
                sendStep = STEP_SEND_BINDING_WIFI
                getHandler().sendMessage(Message.obtain().apply {
                    obj = StepResult(StepName.STEP_PIN_CODE_BIND, StepState.START, stepId = StepId.STEP_CONNECT_DEVICE_BLE)
                })
                val param = sendDataParam.requestBindParam(msg.arg1)
                LogUtil.i(TAG, "writeBleData sendData: STEP_SEND_BINDING  $param")
                val data = BluetoothLeProtocol.packageQueryData(param)
                writeBleData(data)
            }

            CLICK_PIN_CODE_CONFIG -> {
                sendStep = STEP_SEND_CONFIG_NET
                getHandler().sendMessage(Message.obtain().apply {
                    obj = StepResult(StepName.STEP_ROUTE_CONFIG_NET, StepState.START, stepId = StepId.STEP_CONNECT_DEVICE_BLE)
                })
                val param = sendDataParam.configureRouterParam(msg.arg1 == 0)
                LogUtil.i(TAG, "writeBleData sendData: STEP_SEND_CONFIG  $param")
                val data = BluetoothLeProtocol.packageQueryData(param)
                writeBleData(data)
            }

            CLICK_PIN_CODE_CONFIG_SKIP -> {
                sendStep = STEP_SEND_CONFIG_NET_SKIP
                getHandler().sendMessage(Message.obtain().apply {
                    obj = StepResult(StepName.STEP_ROUTE_CONFIG_NET, StepState.START, stepId = StepId.STEP_CONNECT_DEVICE_BLE)
                })
                val param = sendDataParam.configureRouterParam(msg.arg1 == 0)
                LogUtil.i(TAG, "writeBleData sendData: STEP_SEND_CONFIG  $param")
                val data = BluetoothLeProtocol.packageQueryData(param)
                writeBleData(data)
            }

            CODE_DISCONNECT_BLE -> {
                disconnectBleDevice()
            }

            else -> {}
        }
    }

    val callback = object : BleConnectGattCallback() {
        override fun onDisConnected(isActiveDisConnected: Boolean, device: BluetoothDeviceWrapper, status: Int) {
            connectFail(false, true)
        }
    }

    override fun stepCreate() {
        super.stepCreate()
        LogUtil.d(TAG, "stepCreate: StepBleSendData")

        getHandler().sendMessage(Message.obtain().apply {
            obj = StepResult(StepName.STEP_PIN_CODE_INPUT, StepState.START)
        })
    }

    private fun readData() {
        LogUtil.d(TAG, "readData: ---------------")

        if (!BluetoothLeManager.isDeviceConnect(StepData.bleDeviceWrapper?.deviceWrapper)) {
            // 连接断开，直接跳转手动处理
            connectFail(true, isStop = true)
            return
        }
        StepData.bleDeviceWrapper?.deviceWrapper?.let {
            val timeout = if (sendStep == STEP_SEND_CONFIG_NET) {
                getHandler().sendMessage(Message.obtain().apply {
                    obj = StepResult(StepName.STEP_ROUTE_CONNECT_NET, StepState.START, stepId = StepId.STEP_CONNECT_DEVICE_BLE)
                })
                41 * 1000
            } else {
                BleRealConnectHelper.operateTimeout
            }
            BluetoothLeManager.read(
                it,
                BleGattAttributes.CLIENT_CHARACTERISTIC_SERVICE,
                BleGattAttributes.CLIENT_CHARACTERISTIC_READ,
                readCallback, timeout
            )
        }
    }

    private fun sendData() {
        writeBleData(currentData)
    }

    private fun writeBleData(data: ByteArray) {
        currentData = data
        if (StepData.bleDeviceWrapper == null || !BluetoothLeManager.isDeviceConnect(StepData.bleDeviceWrapper?.deviceWrapper)) {
            // 连接断开，直接跳转手动处理
            connectFail(false, true)
            return
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
            connectFail(false)
        }
    }

    private fun connectFail(isRead: Boolean = false, isStop: Boolean = false) {
        val stepName = when (sendStep) {
            STEP_SEND_CHECK -> {
                StepName.STEP_PIN_CODE_GET
            }

            STEP_SEND_PIN_CODE -> {
                StepName.STEP_PIN_CODE_INPUT
            }

            STEP_SEND_CONNECT_SERVER -> {
                StepName.STEP_PIN_CODE_BIND
            }

            STEP_SEND_BINDING -> {
                StepName.STEP_ROUTE_CONFIG_NET
            }

            STEP_SEND_CONFIG_NET -> {
                if (isRead) {
                    StepName.STEP_ROUTE_CONNECT_NET
                } else {
                    StepName.STEP_ROUTE_CONFIG_NET
                }
            }

            else -> {
                StepName.STEP_TRANSFORM
            }
        }
        val stepState = if (isStop) StepState.STOP else StepState.FAILED
        getHandler().sendMessage(Message.obtain().apply {
            obj = StepResult(stepName, stepState, stepId = StepId.STEP_CONNECT_DEVICE_BLE, reason = "connect fail")
        })
        // 设备断开连接
        disconnectBleDevice()
        resetRetryCount(stepName())
    }

    private val readCallback = object : BleReadCallback() {
        override fun onReadSuccess(data: ByteArray) {
            LogUtil.i(TAG, "onReadSuccess------0-----: $sendStep  ${data.formatHexString()}")
            retryReadCount = 0
            // 解析协议内容
            when (sendStep) {
                STEP_SEND_CHECK -> {
                    val ackData = BluetoothLeProtocol.parseQueryACKData(data)
                    if (ackData.first == 0) {
                        val map = sendDataParam.parseRequestCheckResult(ackData.second)
                        // 割草机 要求不再校验pincode是否设置 add by sunzhibin 2024/04/23 18:58
                        // if (map["code"] == 0) {
                            // 下一步, 输入pin码
                            getHandler().sendMessage(Message.obtain().apply {
                                obj = StepResult(StepName.STEP_PIN_CODE_GET, StepState.SUCCESS, stepId = StepId.STEP_CONNECT_DEVICE_BLE)
                            })
                        // } else {
                        //     // 未设置 pin 码
                        //     getHandler().sendMessage(Message.obtain().apply {
                        //         obj = StepResult(
                        //             StepName.STEP_PIN_CODE_GET,
                        //             StepState.FAILED,
                        //             stepId = StepId.STEP_CONNECT_DEVICE_BLE,
                        //             reason = "pin code isnt reset"
                        //         )
                        //     })
                        // }
                    }
                }

                STEP_SEND_PIN_CODE -> {
                    val ackData = BluetoothLeProtocol.parseQueryACKData(data)
                    if (ackData.first == 0) {
                        val map = sendDataParam.parseRequestConnectionResult(ackData.second)
                        /// 保存数据
                        mapData = map
                        if (map["code"] == 0) {
                            // 下一步
                            getHandler().sendMessage(Message.obtain().apply {
                                obj = StepResult(
                                    StepName.STEP_PIN_CODE_INPUT,
                                    StepState.SUCCESS,
                                    stepId = StepId.STEP_CONNECT_DEVICE_BLE,
                                    map = map
                                )
                            })
                            sendStep = STEP_SEND_CONNECT_SERVER
                        } else {
                            val code = map["code"] as Int
                            val remain = map["remain"] as Int
                            // -1 pcode 错误 -2 被锁定 remain 剩余次数或时间
                            getHandler().sendMessage(Message.obtain().apply {
                                obj = StepResult(StepName.STEP_PIN_CODE_INPUT, StepState.FAILED, stepId = StepId.STEP_CONNECT_DEVICE_BLE)
                                arg1 = code
                                arg2 = remain
                            })
                        }
                    }
                }

                STEP_SEND_BINDING, STEP_SEND_BINDING_WIFI -> {
                    val ackData = BluetoothLeProtocol.parseQueryACKData(data)
                    if (ackData.first == 0) {
                        val map = sendDataParam.parseRequestBindResult(ackData.second)
                        if (map["code"] == 0) {
                            // 下一步
                            if (sendStep == STEP_SEND_BINDING_WIFI) {
                                disconnectBleDevice()
                            }
                            getHandler().sendMessage(Message.obtain().apply {
                                obj = StepResult(StepName.STEP_PIN_CODE_BIND, StepState.SUCCESS, stepId = StepId.STEP_CONNECT_DEVICE_BLE)
                            })
                        } else {
                            // error
                            getHandler().sendMessage(Message.obtain().apply {
                                arg1 = sendDataParam.bindCode
                                obj = StepResult(StepName.STEP_PIN_CODE_BIND, StepState.FAILED, stepId = StepId.STEP_CONNECT_DEVICE_BLE)
                            })
                        }
                    }
                }

                STEP_SEND_CONFIG_NET, STEP_SEND_CONFIG_NET_SKIP -> {
                    val ackData = BluetoothLeProtocol.parseQueryACKData(data)
                    if (ackData.first == 0) {
                        val map = sendDataParam.parseConfigureRouterResult(ackData.second)
                        if (map["code"] == 0) {
                            // // 下一步
                            if (sendStep == STEP_SEND_CONFIG_NET_SKIP) {
                                disconnectBleDevice()
                            }
                            getHandler().sendMessage(Message.obtain().apply {
                                obj = StepResult(
                                    StepName.STEP_ROUTE_CONNECT_NET,
                                    StepState.SUCCESS,
                                    stepId = StepId.STEP_CONNECT_DEVICE_BLE,
                                    map = mapData
                                )
                            })
                        } else {
                            // error
                            getHandler().sendMessage(Message.obtain().apply {
                                obj = StepResult(StepName.STEP_ROUTE_CONNECT_NET, StepState.FAILED, stepId = StepId.STEP_CONNECT_DEVICE_BLE)
                                arg1 = map["code"]?.let { it as Int } ?: -100
                            })
                        }
                    }
                }

                STEP_SEND_FINISH -> {

                }
            }
        }

        override fun onReadFailure(exception: BleException) {
            super.onReadFailure(exception)
            LogUtil.e(TAG, "onReadFailure: ${exception.code} ${exception.description}")

//            if (exception is BleTimeoutException) {
            LogUtil.e(TAG, "onReadFailure: BleTimeoutException ${exception.code} ${exception.description}")
            // 重试一次
            if (retryReadCount < RETRY_READ_COUNT_MAX) {
                retryReadCount++
                readData()
                return
            }
//            }
            connectFail(true, true)

        }
    }


    private val writeCallback = object : BleWriteCallback() {
        override fun onWriteSuccess(current: Int, total: Int, justWrite: ByteArray) {
            super.onWriteSuccess(current, total, justWrite)
            retryWriteCount = 0
            LogUtil.i(TAG, "onWriteSuccess: $current $total ${justWrite.contentToString()}")
            // 暂不连接Wi-Fi
            if (sendStep == STEP_SEND_CONFIG_NET_SKIP) {
                getHandler().sendEmptyMessageDelayed(CODE_DISCONNECT_BLE, 300)
                getHandler().sendMessageDelayed(Message.obtain().apply {
                    obj = StepResult(StepName.STEP_ROUTE_CONFIG_NET, StepState.SUCCESS, stepId = StepId.STEP_CONNECT_DEVICE_BLE)
                }, 500)
                return
            } else if (sendStep == STEP_SEND_CONFIG_NET) {
                getHandler().sendMessage(Message.obtain().apply {
                    obj = StepResult(StepName.STEP_ROUTE_CONFIG_NET, StepState.SUCCESS, stepId = StepId.STEP_CONNECT_DEVICE_BLE)
                })
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
                    connectFail(false, true)
                    return
                }
            }
//            if (exception is BleTimeoutException) {
            if (retryWriteCount < RETRY_WRITE_COUNT_MAX) {
                retryWriteCount++
                sendData()
                return
            }
//            }
            connectFail(false, true)

        }
    }

    override fun stepDestroy() {
        // 清空所有连接
        disconnectBleDevice()
    }

    private fun disconnectBleDevice() {
        BluetoothLeManager.onDestroy()
    }

}