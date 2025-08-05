package android.dreame.module.feature.connect.bluetooth

import android.bluetooth.*
import android.content.Context
import android.dreame.module.bean.device.*
import android.dreame.module.feature.connect.bluetooth.callback.BleConnectGattCallback
import android.dreame.module.util.LogUtil
import android.os.Handler
import android.os.Looper
import android.os.Message
import android.dreame.module.feature.connect.bluetooth.BleMsg.MSG_CONNECT_133
import android.dreame.module.feature.connect.bluetooth.BleMsg.MSG_CONNECT_FAIL
import android.dreame.module.feature.connect.bluetooth.BleMsg.MSG_CONNECT_OVER_TIME
import android.dreame.module.feature.connect.bluetooth.BleMsg.MSG_DISCONNECTED
import android.dreame.module.feature.connect.bluetooth.BleMsg.MSG_DISCOVER_FAIL
import android.dreame.module.feature.connect.bluetooth.BleMsg.MSG_DISCOVER_SERVICES
import android.dreame.module.feature.connect.bluetooth.BleMsg.MSG_DISCOVER_SERVICES_AGAIN
import android.dreame.module.feature.connect.bluetooth.BleMsg.MSG_DISCOVER_SERVICES_OVER_TIME
import android.dreame.module.feature.connect.bluetooth.BleMsg.MSG_DISCOVER_SUCCESS
import android.dreame.module.feature.connect.bluetooth.BleMsg.MSG_RECONNECT
import android.dreame.module.feature.connect.bluetooth.callback.*
import android.dreame.module.feature.connect.bluetooth.callback.bleIndicateCallbackHashMap
import android.dreame.module.feature.connect.bluetooth.callback.bleNotifyCallbackHashMap
import android.dreame.module.feature.connect.bluetooth.callback.bleReadCallbackHashMap
import android.dreame.module.feature.connect.bluetooth.callback.bleWriteCallbackHashMap
import android.dreame.module.feature.connect.bluetooth.callback.characterCallbackMap
import android.dreame.module.feature.connect.bluetooth.callback.connectGattCallbackMap
import android.dreame.module.feature.connect.bluetooth.callback.deviceGattMap
import android.dreame.module.feature.connect.bluetooth.callback.deviceStatusMap
import android.dreame.module.feature.connect.bluetooth.callback.deviceWrapperMap
import android.dreame.module.feature.connect.bluetooth.callback.mtuChangedCallbackMap
import android.dreame.module.feature.connect.bluetooth.callback.rssiCallbackMap

val mainHandler by lazy { BleRealConnectHelper.ConnectGattHandler() }

const val DEFAULT_SCAN_TIME = 10000
const val DEFAULT_MAX_MULTIPLE_DEVICE = 7
const val DEFAULT_OPERATE_TIME = 10_000
const val DEFAULT_CONNECT_RETRY_COUNT = 0
const val DEFAULT_CONNECT_RETRY_INTERVAL = 5000
const val DEFAULT_MTU = 23
const val DEFAULT_MAX_MTU = 512
const val DEFAULT_WRITE_DATA_SPLIT_COUNT = 20

// 蓝牙连接超时
const val DEFAULT_CONNECT_OVER_TIME = 30_000
const val DISCOVER_SERVICES_OVER_TIME = 10_000

/**
 * 蓝牙连接操作类
 */
object BleRealConnectHelper {
    const val TAG = "BleRealConnectHelper"

    var maxConnectCount = DEFAULT_MAX_MULTIPLE_DEVICE
    var operateTimeout = DEFAULT_OPERATE_TIME
    var reConnectCount = DEFAULT_CONNECT_RETRY_COUNT
    var reConnectInterval = DEFAULT_CONNECT_RETRY_INTERVAL.toLong()
    var splitWriteNum = DEFAULT_WRITE_DATA_SPLIT_COUNT
    var connectOverTime = DEFAULT_CONNECT_OVER_TIME.toLong()
    var discoverServicesOverTime = DISCOVER_SERVICES_OVER_TIME.toLong()

    // 当前连接状态
    private var lastState: LastState = LastState.CONNECT_IDLE
    private var isActiveDisconnect = false

    fun connect(
        context: Context,
        autoConnect: Boolean = false,
        deviceWrapper: BluetoothDeviceWrapper,
        timeout: Long = connectOverTime,
        callback: BleConnectGattCallback,
    ) {
        val mac = deviceWrapper.device.address
        LogUtil.i("connect: ${mac}")
        var bluetoothGatt = deviceGattMap.get(mac)
        bluetoothGatt = deviceWrapper.device.connectGatt(context, autoConnect, coreGattCallback, BluetoothDevice.TRANSPORT_LE)
        deviceGattMap[mac] = bluetoothGatt
        deviceWrapperMap[mac] = deviceWrapper
        connectGattCallbackMap[mac] = callback
        lastState = LastState.CONNECT_CONNECTING
        if (bluetoothGatt != null) {
            callback.onStartConnect()
            val message: Message = mainHandler.obtainMessage()
            message.what =
                MSG_CONNECT_OVER_TIME
            message.obj = deviceWrapper
            mainHandler.sendMessageDelayed(message, timeout)
        } else {
            disconnectGatt(mac)
            closeBluetoothGatt(mac)
            connectGattCallbackMap.remove(mac)?.let {
                callback.onConnectFail(deviceWrapper, BleConnectException())
            }
            lastState = LastState.CONNECT_FAILURE
        }

    }

    fun discoverServices(
        mac: String,
        timeout: Long = discoverServicesOverTime,
        callback: BleConnectGattCallback? = null,
        isAgain: Boolean = false
    ) {
        val lastState1 = deviceStatusMap[mac] ?: LastState.DISCOVER_SERVICE_IDLE
        LogUtil.d(TAG, "discoverServices $lastState1")
        if (!isAgain && lastState1 == LastState.DISCOVER_SERVICE_ING) {
            return
        }
        val parameter = BleStateParameter(mac, -1)
        deviceStatusMap[mac] = LastState.DISCOVER_SERVICE_ING
        if (!isAgain) {
            mainHandler.sendMessageDelayed(mainHandler.obtainMessage().apply {
                this.what = MSG_DISCOVER_SERVICES_OVER_TIME
                this.obj = parameter
            }, timeout)
        }
        callback?.let {
            connectGattCallbackMap[mac] = callback
        }
        // 连接成功，发现service
        val discoverServiceResult = deviceGattMap[mac]?.run {
            discoverServices()
        } ?: false
        // 重试一次
        mainHandler.sendMessageDelayed(mainHandler.obtainMessage(MSG_DISCOVER_SERVICES_AGAIN).apply {
            obj = mac
        }, 2000)

        if (!discoverServiceResult) {
            LogUtil.i(TAG, "discoverServices discoverServiceResult: $discoverServiceResult")
            deviceStatusMap[mac] = LastState.DISCOVER_SERVICE_FAILURE
            val message = mainHandler.obtainMessage()
            message.what = MSG_DISCOVER_FAIL
            message.obj = parameter
            mainHandler.sendMessage(message)
        }
    }

    @Synchronized
    fun disconnect(mac: String) {
        LogUtil.i("disconnect ${mac} ")
        connectGattCallbackMap.remove(mac)
        deviceWrapperMap[mac]?.runCatching {
            LogUtil.i("disconnect deviceWrapperMap ${device.address} ")
            isActive = true
        }
        disconnectGatt(mac)
        closeBluetoothGatt(mac)

    }


    @Synchronized
    private fun disconnectGatt(mac: String) {
        LogUtil.i("disconnectGatt $mac ")
        deviceGattMap[mac]?.runCatching {
            LogUtil.i("disconnectGatt BluetoothGatt disconnect $mac ")
            disconnect()
        }
    }

    @Synchronized
    private fun closeBluetoothGatt(mac: String) {
        LogUtil.i("closeBluetoothGatt $mac ")
        BleReflectTool.refreshDeviceCache(mac)
        deviceGattMap[mac]?.runCatching {
            LogUtil.i("closeBluetoothGatt BluetoothGatt close $mac ")
            close()
            deviceGattMap.remove(mac)
        }
    }

    /**
     * 外部调用， 断开连接， 刷新缓存， 关闭连接
     */
    @Synchronized
    fun disconnectAndCloseAll() {
        deviceWrapperMap.values.onEach {
            LogUtil.i("disconnectAndCloseAll ${it.device.address}")
            disconnect(it.device.address)
        }
    }

    @Synchronized
    private fun disconnectGattAll() {
        deviceGattMap.values.forEach {
            // 判断连接状态
            it.disconnect()
        }
    }

    @Synchronized
    private fun refreshDeviceCacheAll() {
        deviceGattMap.values.forEach { gatt ->
            BleReflectTool.refreshDeviceCache(gatt)
        }
    }

    @Synchronized
    private fun closeBluetoothGattAll() {
        refreshDeviceCacheAll()
        deviceGattMap.values.forEach {
            it.close()
        }
        deviceGattMap.clear()

    }

    fun onDestroy() {
        lastState = LastState.CONNECT_IDLE
        disconnectGattAll()
        closeBluetoothGattAll()
        connectGattCallbackMap.clear()
        rssiCallbackMap.clear()
        mtuChangedCallbackMap.clear()
        characterCallbackMap.clear()
        mainHandler.removeCallbacksAndMessages(null)
    }


    private fun clearCharacterCallback(mac: String) {
        bleNotifyCallbackHashMap.clear()
        bleIndicateCallbackHashMap.clear()
        bleWriteCallbackHashMap.clear()
        bleReadCallbackHashMap.clear()
    }

    class ConnectGattHandler : Handler(Looper.getMainLooper()) {
        override fun handleMessage(msg: Message) {
            when (msg.what) {
                MSG_CONNECT_FAIL -> {
                    mainHandler.removeMessages(MSG_DISCOVER_SERVICES_AGAIN)
                    LogUtil.i(TAG, "handleMessage: MSG_CONNECT_FAIL！！！  ${msg.arg1}  ${msg.arg2}")
                    val obj = msg.obj as BleStateParameter
                    deviceStatusMap[obj.mac] = LastState.CONNECT_FAILURE
                    disconnectGatt(obj.mac)
                    closeBluetoothGatt(obj.mac)
                    connectGattCallbackMap.remove(obj.mac)?.let {
                        it.onConnectFail(deviceWrapperMap[obj.mac]!!, BleConnectException(msg.arg1))
                    }
                    deviceStatusMap.remove(obj.mac)
                    deviceWrapperMap.remove(obj.mac)
                }

                MSG_DISCONNECTED -> {
                    LogUtil.d(TAG, "handleMessage: MSG_DISCONNECTED！！！  ${msg.arg1}  ${msg.arg2}")
                    mainHandler.removeMessages(MSG_DISCOVER_SERVICES_AGAIN)
                    val obj = msg.obj as BleStateParameter
                    deviceStatusMap[obj.mac] = LastState.CONNECT_DISCONNECT

                    disconnect(obj.mac)
                    closeBluetoothGatt(obj.mac)

                    rssiCallbackMap.remove(obj.mac)
                    mtuChangedCallbackMap.remove(obj.mac)
                    clearCharacterCallback(obj.mac)

                    mainHandler.removeCallbacksAndMessages(null)
                    val status: Int = obj.status
                    connectGattCallbackMap.remove(obj.mac)?.let { callback ->
                        val deviceWrapper = deviceWrapperMap.remove(obj.mac)
                        callback.onDisConnected(deviceWrapper?.isActive == true, deviceWrapper!!, status)
                    }
                    deviceStatusMap.remove(obj.mac)
                }

                MSG_RECONNECT -> {
                    // 暂不支持
                    LogUtil.d(TAG, "handleMessage: MSG_RECONNECT！！！")

                }

                MSG_CONNECT_OVER_TIME -> {
                    LogUtil.e(TAG, "handleMessage: MSG_CONNECT_OVER_TIME！！！${msg.obj}")
                    if (msg.obj != null) {
                        val device = msg.obj as BluetoothDeviceWrapper
                        val mac = device.device.address
                        disconnectGatt(mac)
                        closeBluetoothGatt(mac)

                        lastState = LastState.CONNECT_FAILURE
                        connectGattCallbackMap.remove(mac)?.run {
                            onConnectFail(device, BleTimeoutException())
                        }
                    }


                }

                MSG_DISCOVER_SERVICES_OVER_TIME -> {
                    LogUtil.e(TAG, "handleMessage: MSG_DISCOVER_SERVICES_OVER_TIME！！！${msg.obj}")
                    mainHandler.removeMessages(MSG_DISCOVER_SERVICES_AGAIN)
                    if (msg.obj != null) {
                        val device = msg.obj as BleStateParameter
                        val mac = device.mac
                        lastState = LastState.CONNECT_FAILURE
                        connectGattCallbackMap.get(mac)?.run {
                            onDiscoverFail(deviceWrapperMap.get(mac)!!, BleTimeoutException())
                        }
                    }


                }

                MSG_DISCOVER_SERVICES -> {
                    LogUtil.i(TAG, "handleMessage: MSG_DISCOVER_SERVICES！！！")
                    mainHandler.removeMessages(MSG_CONNECT_OVER_TIME)
                    val obj = msg.obj as BleStateParameter
                    // 连接成功
                    deviceStatusMap[obj.mac] = LastState.CONNECT_CONNECTED
                    discoverServices(obj.mac, discoverServicesOverTime)
                }

                MSG_DISCOVER_SERVICES_AGAIN -> {
                    val mac = msg.obj as String
                    LogUtil.i(TAG, "handleMessage: MSG_DISCOVER_SERVICES_AGAIN！！！")
                    if (mainHandler.hasMessages(MSG_DISCOVER_SERVICES_OVER_TIME)) {
                        discoverServices(mac, discoverServicesOverTime, isAgain = true)
                    }
                }

                MSG_DISCOVER_FAIL -> {
                    LogUtil.i(TAG, "handleMessage: MSG_DISCOVER_FAIL！！！   ${msg.arg1}  ${msg.arg2} ")
                    val obj = msg.obj as BleStateParameter
                    deviceStatusMap[obj.mac] = LastState.DISCOVER_SERVICE_FAILURE
                    disconnectGatt(obj.mac)
                    closeBluetoothGatt(obj.mac)
                    connectGattCallbackMap.remove(obj.mac)?.run {
                        onDiscoverFail(deviceWrapperMap[obj.mac]!!, BleConnectException(msg.arg1, "GATT discover services exception occurred!"))
                    }
                    deviceStatusMap.remove(obj.mac)
                }

                MSG_DISCOVER_SUCCESS -> {
                    mainHandler.removeMessages(MSG_CONNECT_OVER_TIME)
                    mainHandler.removeMessages(MSG_DISCOVER_SERVICES_OVER_TIME)
                    LogUtil.d(TAG, "handleMessage: MSG_DISCOVER_SUCCESS！！！")
                    val obj = msg.obj as BleStateParameter
                    deviceStatusMap[obj.mac] = LastState.DISCOVER_SERVICE_SUCCESS
                    connectGattCallbackMap[obj.mac]?.run {
                        onConnectSuccess(deviceWrapperMap[obj.mac]!!, obj.status)
                    }
                    connectGattCallbackMap[obj.mac]?.run {
                        onDiscoverSuccess(deviceWrapperMap[obj.mac]!!, obj.status)
                    }
                }

                MSG_CONNECT_133 -> {
                    // retry
                    LogUtil.i(TAG, "handleMessage: MSG_CONNECT_133！！！  ${msg.arg1}  ${msg.arg2}")
                    if (msg.obj != null) {
                        val obj = msg.obj as BleStateParameter
                        deviceStatusMap[obj.mac] = LastState.CONNECT_FAILURE
                        connectGattCallbackMap[obj.mac]?.run {
                            onConnectFail133(deviceWrapperMap[obj.mac]!!, BleConnectException(msg.arg1, "GATT connect exception occurred 133 !"))
                        }
                    }
                }

                else -> {
                    LogUtil.d(TAG, "handleMessage: else！！！")
                    super.handleMessage(msg)
                }
            }
        }
    }

}