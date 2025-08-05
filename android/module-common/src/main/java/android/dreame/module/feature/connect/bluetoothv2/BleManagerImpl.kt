package android.dreame.module.feature.connect.bluetoothv2

import android.annotation.SuppressLint
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic
import android.dreame.module.BuildConfig
import android.dreame.module.bean.device.BluetoothDeviceWrapper
import android.dreame.module.feature.connect.bluetooth.mower.BleOperatorRnCallback
import android.dreame.module.feature.connect.bluetooth.mower.event.BluetoothEvent
import android.dreame.module.feature.connect.bluetoothv2.ktx.FailCallbackStatus
import android.dreame.module.util.LogUtil
import android.os.Bundle
import android.util.Log
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.WritableMap
import com.facebook.react.bridge.WritableNativeMap
import com.facebook.react.modules.core.DeviceEventManagerModule.RCTDeviceEventEmitter
import no.nordicsemi.android.ble.BleManager
import no.nordicsemi.android.ble.callback.FailCallback
import no.nordicsemi.android.ble.observer.ConnectionObserver
import java.util.UUID


class BleManagerImpl(val reactContext: ReactApplicationContext) : BleManager(reactContext) {
    private var gatt: BluetoothGatt? = null
    private var isDisposed = false

    init {
        connectionObserver = object : ConnectionObserver {
            override fun onDeviceConnecting(device: BluetoothDevice) {
                LogUtil.i("-----onDeviceConnecting:----- $device $this")
            }

            override fun onDeviceConnected(device: BluetoothDevice) {
                LogUtil.i("-----onDeviceConnected:----- $device isDisposed:$isDisposed $this")
                /// 存储
                if (isDisposed) {
                    release()
                } else {
                    MyBleConnectStateManager.pushBtDevice(device)
                }
            }

            override fun onDeviceFailedToConnect(device: BluetoothDevice, reason: Int) {
                LogUtil.i("-----onDeviceFailedToConnect:----- $device ,reason: $reason $this")
                onConnectionStatusChangedReceiveNativeEvent(device.address, "", false, device)
            }

            override fun onDeviceReady(device: BluetoothDevice) {
                LogUtil.i("-----onDeviceReady:----- $device $this")
                if (isDisposed) {
                    release()
                }
            }

            override fun onDeviceDisconnecting(device: BluetoothDevice) {
                LogUtil.i("-----onDeviceDisconnecting:----- $device $this")
                onConnectionStatusChangedReceiveNativeEvent(device.address, "", false, device)
            }

            @SuppressLint("MissingPermission")
            override fun onDeviceDisconnected(device: BluetoothDevice, reason: Int) {
                LogUtil.i("-----onDeviceDisconnected:----- $device ,reason: $reason $this")
                MyBleConnectStateManager.removeBtDevice(device.address)
                onConnectionStatusChangedReceiveNativeEvent(device.address, "", false, device)
            }

        }
    }

    /**
     * 释放资源, 断开连接, 只有在[isDisposed] = true时,才会执行
     */
    private fun release() {
        cancelQueue()
        LogUtil.i("release isConnected: $isConnected isDisposed: $isDisposed mac: ${bluetoothDevice?.address} $this")
        disconnect().enqueue()
    }


    override fun isRequiredServiceSupported(gatt: BluetoothGatt): Boolean {
        this.gatt = gatt
        LogUtil.i("isRequiredServiceSupported isConnected $isConnected ,isDisposed:$isDisposed ,mac: ${bluetoothDevice?.address} $this")
        return !isDisposed
    }

    override fun getMinLogPriority(): Int {
        return if (BuildConfig.DEBUG) Log.DEBUG else Log.INFO
    }

    override fun shouldClearCacheWhenDisconnected(): Boolean {
        return true
    }

    @SuppressLint("MissingPermission")
    fun startDiscoverServices(services: List<UUID>) {
        LogUtil.i("startDiscoverServices isDisposed:$isDisposed ,mac: ${bluetoothDevice?.address} services:$services $this")
        if (isDisposed) {
            release()
            return
        }
        discoverServices()

    }

    override fun initialize() {
        LogUtil.i("-----initialize:-----isDisposed:$isDisposed $this")
        setMtu(512)
    }

    fun setMtu(mtu: Int, cb: BleOperatorRnCallback? = null) {
        if (!isDisposed) {
            requestMtu(mtu)
                .with { device, data ->
                    LogUtil.i("-----requestMtu:-----mac:${device.address} $data $this")
                }
                .done { dev ->
                    LogUtil.w("-----requestMtu:-----device = $dev  $this")
                    cb?.successWithArgs(0,getMtu(), dev.address)
                }
                .fail { device, status ->
                    LogUtil.e("-----requestMtu:-----device = $device  $this")
                    cb?.failedWithArgs(-1,status, device.address)
                }
                .enqueue()
        }
    }


    @SuppressLint("MissingPermission")
    private fun discoverServices() {
        // 不需要实现
        val mac1 = bluetoothDevice?.address ?: ""
        val bleDevice = Bundle().apply {
            putString("mac", mac1)
            putInt("deviceType", bluetoothDevice?.type ?: 0)
            putInt("rssi", -1)
            putBoolean("isConnected", true)
            putString("address", mac1)
            putString("name", bluetoothDevice?.name ?: mac1)
            putString("serviceData", "")
            putString("id", mac1)
            putString("uuid", "")
        }
        val event = Arguments.createMap().apply {
            putString("eventName", BluetoothEvent.BLUETOOTH_SEVICE_DISCOVERED)
            putMap("bluetooth", Arguments.makeNativeMap(bleDevice))
            putArray("services", Arguments.fromList(gatt?.services?.map {
                it.uuid.toString().uppercase()
            } ?: emptyList<String>()))
        }
        onReceiveNativeEvent(BluetoothEvent.BLUETOOTH_SEVICE_DISCOVERED, event)
    }


    fun readReliableMTU(callback: BleOperatorRnCallback) {
        LogUtil.i("readReliableMTU mac: ${bluetoothDevice?.address}. mtu:$mtu $this")
        val map = WritableNativeMap()
        map.putBoolean("reliable", true)
        map.putInt("mtu", mtu)
        callback.onSuccess(map)
    }

    fun realConnectDevice(
        deviceWrapper: BluetoothDeviceWrapper,
        timeout: Long,
        pincode: Int,
        callback: BleOperatorRnCallback
    ) {
        isDisposed = false
        LogUtil.i("realConnectDevice mac: ${deviceWrapper.device.address} $this")
        connect(deviceWrapper.device)
            .useAutoConnect(false)
            .timeout(timeout)
            .done {
                LogUtil.e("realConnectDevice connect:done: mac: ${deviceWrapper.device.address} isDisposed:$isDisposed $this")
                if (isDisposed) {
                    onConnectionStatusChangedReceiveNativeEvent(
                        deviceWrapper.device.address,
                        "",
                        false,
                        deviceWrapper.device
                    )
                    callback.onSuccess(false)
                } else {
                    onConnectionStatusChangedReceiveNativeEvent(
                        deviceWrapper.device.address,
                        "",
                        true,
                        deviceWrapper.device
                    )
                    callback.onSuccess(true)
                }
            }
            .fail { device, state ->
                LogUtil.e("realConnectDevice fail:device: $device ,state: $state $this")
                /// 断开链接
                onConnectionStatusChangedReceiveNativeEvent(
                    deviceWrapper.device.address,
                    "",
                    false,
                    deviceWrapper.device
                )
                callback.onFailed(state, FailCallbackStatus.failException2String(state))
            }.enqueue()

    }


    fun realDisconnectDevice(mac: String, dispose: Boolean = false) {
        isDisposed = true
        val bundle = Bundle().apply {
            putString("mac", mac)
            putString("address", mac)
            putBoolean("isConnected", false)
        }
        cancelQueue()
        LogUtil.i("realDisconnectDevice isConnected $isConnected mac: $mac dispose:$dispose ,this.isDisposed:${this.isDisposed} $this")
        disconnect()
            .done {
                LogUtil.i("realDisconnectDevice done mac: $mac")
                onReceiveNativeEvent(
                    BluetoothEvent.BLUETOOTH_CONNECTION_STATUS_CHANGED,
                    Arguments.createMap().apply {
                        putString("eventName", BluetoothEvent.BLUETOOTH_CONNECTION_STATUS_CHANGED)
                        putMap("peripheral", Arguments.makeNativeMap(bundle))
                        putBoolean("isConnected", false)
                    },
                    skipDispose = true,
                )
            }
            .fail { device, state ->
                LogUtil.e("realDisconnectDevice fail:device: $device ,state: $state $this")
                onReceiveNativeEvent(
                    BluetoothEvent.BLUETOOTH_CONNECTION_STATUS_CHANGED,
                    Arguments.createMap().apply {
                        putString("eventName", BluetoothEvent.BLUETOOTH_CONNECTION_STATUS_CHANGED)
                        putMap("peripheral", Arguments.makeNativeMap(bundle))
                        putBoolean("isConnected", false)
                    },
                    skipDispose = true,
                )
            }
            .enqueue()
    }

    fun writeData(
        serverUUID: String,
        uuid: String,
        value: ByteArray,
        callback: BleOperatorRnCallback
    ) {

        if (gatt == null) {
            LogUtil.e("-----writeData:----- gatt == null")
            callback.onFailed(
                FailCallback.REASON_DEVICE_DISCONNECTED,
                FailCallbackStatus.failException2String(FailCallback.REASON_DEVICE_DISCONNECTED)
            )
            return
        }
        val characteristic =
            gatt?.getService(UUID.fromString(serverUUID))?.getCharacteristic(UUID.fromString(uuid))
        if (characteristic == null) {
            LogUtil.e("-----writeData:----- characteristic == null")
            callback.onFailed(
                FailCallback.REASON_DEVICE_NOT_SUPPORTED,
                FailCallbackStatus.failException2String(FailCallback.REASON_DEVICE_NOT_SUPPORTED)
            )
            return
        }
        val isSupportProperty =
            characteristic.properties and BluetoothGattCharacteristic.PROPERTY_WRITE != 0
        if (!isSupportProperty) {
            LogUtil.e("-----writeData:----- characteristic not support PROPERTY_WRITE service: $serverUUID, characteristic: $uuid")
            callback.onFailed(
                FailCallback.REASON_DEVICE_NOT_SUPPORTED,
                FailCallbackStatus.failException2String(FailCallback.REASON_DEVICE_NOT_SUPPORTED)
            )
            return
        }
        writeCharacteristic(characteristic, value, BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT)
            .with { device, data ->
                val encodeHex = data.value?.map {
                    (it.toInt() and 0xFF)
                } ?: emptyList()
                if (BuildConfig.DEBUG) {
                    LogUtil.d("writeData writeCharacteristic: $device ,encodeHex: $encodeHex")
                }
                callback.onSuccess(Arguments.fromList(encodeHex))
            }
            .fail { device, status ->
                LogUtil.e("writeData fail:device: $device ,status: $status")
                callback.onFailed(status, FailCallbackStatus.failException2String(status))
            }
            .split()
            .enqueue()
    }

    fun writeWithoutResponse(
        serverUUID: String,
        uuid: String,
        value: ByteArray,
        callback: BleOperatorRnCallback
    ) {
        if (gatt == null) {
            LogUtil.e("-----writeDataNoResponse:----- gatt == null")
            callback.onFailed(
                FailCallback.REASON_DEVICE_DISCONNECTED,
                FailCallbackStatus.failException2String(FailCallback.REASON_DEVICE_DISCONNECTED)
            )
            return
        }
        val characteristic =
            gatt?.getService(UUID.fromString(serverUUID))?.getCharacteristic(UUID.fromString(uuid))
        if (characteristic == null) {
            LogUtil.e("-----writeDataNoResponse:----- characteristic == null")
            callback.onFailed(
                FailCallback.REASON_DEVICE_NOT_SUPPORTED,
                FailCallbackStatus.failException2String(FailCallback.REASON_DEVICE_NOT_SUPPORTED)
            )
            return
        }
        val isSupportProperty =
            characteristic.properties and BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE != 0
        if (!isSupportProperty) {
            LogUtil.e("-----writeDataNoResponse:----- characteristic not support WRITE_TYPE_NO_RESPONSE service: $serverUUID, characteristic: $uuid")
            callback.onFailed(
                FailCallback.REASON_DEVICE_NOT_SUPPORTED,
                FailCallbackStatus.failException2String(FailCallback.REASON_DEVICE_NOT_SUPPORTED)
            )
            return
        }
        writeCharacteristic(
            characteristic,
            value,
            BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE
        )
            .with { device, data ->
                val encodeHex = data.value?.map {
                    (it.toInt() and 0xFF)
                } ?: emptyList()
                if (BuildConfig.DEBUG) {
                    LogUtil.d("writeWithoutResponse writeCharacteristic: $device ,encodeHex: $encodeHex")
                }
                callback.onSuccess(Arguments.fromList(encodeHex))
            }
            .fail { device, status ->
                LogUtil.e("writeDataNoResponse fail: device: $device ,status: $status")
                callback.onFailed(status, FailCallbackStatus.failException2String(status))
            }
            .split()
            .enqueue()
    }

    fun readData(serverUUID: String, uuid: String, callback: BleOperatorRnCallback) {
        if (gatt == null) {
            LogUtil.e("-----readData:----- gatt == null")
            callback.onFailed(
                FailCallback.REASON_DEVICE_DISCONNECTED,
                FailCallbackStatus.failException2String(FailCallback.REASON_DEVICE_DISCONNECTED)
            )
            return
        }
        val characteristic =
            gatt?.getService(UUID.fromString(serverUUID))?.getCharacteristic(UUID.fromString(uuid))
        if (characteristic == null) {
            LogUtil.e("-----readData:----- characteristic == null")
            callback.onFailed(
                FailCallback.REASON_DEVICE_NOT_SUPPORTED,
                FailCallbackStatus.failException2String(FailCallback.REASON_DEVICE_NOT_SUPPORTED)
            )
            return
        }
        val isSupportProperty =
            characteristic.properties and BluetoothGattCharacteristic.PROPERTY_READ != 0
        if (!isSupportProperty) {
            LogUtil.e("-----readData:----- characteristic not support PROPERTY_READ service: $serverUUID, characteristic: $uuid")
            callback.onFailed(
                FailCallback.REASON_DEVICE_NOT_SUPPORTED,
                FailCallbackStatus.failException2String(FailCallback.REASON_DEVICE_NOT_SUPPORTED)
            )
            return
        }
        readCharacteristic(characteristic).with { device, data ->
            /// 读成功数据
//            LogUtil.d("-----readData:----- $data")
            val encodeHex = data.value?.map {
                (it.toInt() and 0xFF)
            }
            onReceiveNativeEvent(
                BluetoothEvent.BLUETOOTH_CHARACTERISTIC_VALUE_CHANGED,
                Arguments.createMap().apply {
                    putString("peripheral", gatt?.device?.address)
                    putString("service", serverUUID)
                    putString("characteristic", uuid)
                    putArray("value", Arguments.fromList(encodeHex))
                })
            callback.onSuccess(Arguments.fromList(encodeHex))
        }.fail { device, status ->
            LogUtil.e("readData fail: device: $device ,status: $status")
            callback.onFailed("readData fail: $status")
        }
            .enqueue()
    }

    fun startNotification(serverUUID: String, uuid: String, callback: BleOperatorRnCallback) {
        if (gatt == null) {
            LogUtil.e("-----startNotification:----- gatt == null")
            callback.onFailed(
                FailCallback.REASON_DEVICE_DISCONNECTED,
                FailCallbackStatus.failException2String(FailCallback.REASON_DEVICE_DISCONNECTED)
            )
            return
        }
        val characteristic =
            gatt?.getService(UUID.fromString(serverUUID))?.getCharacteristic(UUID.fromString(uuid))
        if (characteristic == null) {
            LogUtil.e("-----startNotification:----- characteristic == null")
            callback.onFailed(
                FailCallback.REASON_DEVICE_NOT_SUPPORTED,
                FailCallbackStatus.failException2String(FailCallback.REASON_DEVICE_NOT_SUPPORTED)
            )
            return
        }
        val isSupportPropertyNotify =
            characteristic.properties and BluetoothGattCharacteristic.PROPERTY_NOTIFY != 0
        if (!isSupportPropertyNotify) {
            LogUtil.e("-----startNotification:----- characteristic not support PROPERTY_NOTIFY service: $serverUUID, characteristic: $uuid")
            callback.onFailed(
                FailCallback.REASON_DEVICE_NOT_SUPPORTED,
                FailCallbackStatus.failException2String(FailCallback.REASON_DEVICE_NOT_SUPPORTED)
            )
            return
        }
        setNotificationCallback(characteristic)
            .with { device, data ->
                if (BuildConfig.DEBUG) {
                    LogUtil.d("-----startNotification setNotificationCallback:----- $data")
                }
                val encodeHex = data.value?.map {
                    (it.toInt() and 0xFF)
                }
                onReceiveNativeEvent(
                    BluetoothEvent.BLUETOOTH_CHARACTERISTIC_VALUE_CHANGED,
                    Arguments.createMap().apply {
                        putString("peripheral", gatt?.device?.address ?: "")
                        putString("service", serverUUID.toString().uppercase())
                        putString("characteristic", uuid.toString().uppercase())
                        putArray("value", Arguments.fromList(encodeHex))
                    })
            }
        enableNotifications(characteristic)
            .done {
                LogUtil.i("-----startNotification enableNotifications: success -----device: ${gatt?.device?.address} service: $serverUUID, characteristic: $uuid")
                callback.onSuccess(true)
            }
            .fail { device, status ->
                LogUtil.e("-----startNotification enableNotifications: fail-----device: $device ,data: $status servierUUID: $serverUUID, characteristicUUID: $uuid")
                callback.onFailed(status, FailCallbackStatus.failException2String(status))
            }
            .enqueue()

    }

    fun stopNotification(serverUUID: String, uuid: String, callback: BleOperatorRnCallback) {
        if (gatt == null) {
            LogUtil.e("-----stopNotification:----- gatt == null")
            callback.onFailed(
                FailCallback.REASON_DEVICE_DISCONNECTED,
                FailCallbackStatus.failException2String(FailCallback.REASON_DEVICE_DISCONNECTED)
            )
            return
        }
        val characteristic =
            gatt?.getService(UUID.fromString(serverUUID))?.getCharacteristic(UUID.fromString(uuid))
        if (characteristic == null) {
            LogUtil.e("-----stopNotification:----- characteristic == null")
            callback.onFailed(
                FailCallback.REASON_DEVICE_NOT_SUPPORTED,
                FailCallbackStatus.failException2String(FailCallback.REASON_DEVICE_NOT_SUPPORTED)
            )
            return
        }
        val isSupportPropertyNotify =
            characteristic.properties and BluetoothGattCharacteristic.PROPERTY_NOTIFY != 0
        if (!isSupportPropertyNotify) {
            LogUtil.e("-----stopNotification:----- characteristic not support PROPERTY_NOTIFY service: $serverUUID, characteristic: $uuid")
            callback.onFailed(
                FailCallback.REASON_DEVICE_NOT_SUPPORTED,
                FailCallbackStatus.failException2String(FailCallback.REASON_DEVICE_NOT_SUPPORTED)
            )
            return
        }

        disableNotifications(characteristic)
            .done {
                callback.onSuccess(true)
            }.fail { device, status ->
                LogUtil.e("stopNotification fail: device: $device ,status: $status")
                callback.onFailed(status, FailCallbackStatus.failException2String(status))
            }
            .enqueue()
    }

    fun enableIndications(serverUUID: String, uuid: String, callback: BleOperatorRnCallback) {
        if (gatt == null) {
            LogUtil.e("-----startNotification:----- gatt == null")
            callback.onFailed(
                FailCallback.REASON_DEVICE_DISCONNECTED,
                FailCallbackStatus.failException2String(FailCallback.REASON_DEVICE_DISCONNECTED)
            )
            return
        }
        val characteristic =
            gatt?.getService(UUID.fromString(serverUUID))?.getCharacteristic(UUID.fromString(uuid))
        if (characteristic == null) {
            callback.onFailed(
                FailCallback.REASON_DEVICE_NOT_SUPPORTED,
                FailCallbackStatus.failException2String(FailCallback.REASON_DEVICE_NOT_SUPPORTED)
            )
            return
        }
        val isSupportProperty =
            characteristic.properties and BluetoothGattCharacteristic.PROPERTY_INDICATE != 0
        if (!isSupportProperty) {
            LogUtil.e("-----startNotification:----- characteristic not support PROPERTY_INDICATE service: $serverUUID, characteristic: $uuid")
            callback.onFailed(
                FailCallback.REASON_DEVICE_NOT_SUPPORTED,
                FailCallbackStatus.failException2String(FailCallback.REASON_DEVICE_NOT_SUPPORTED)
            )
            return
        }
        setIndicationCallback(characteristic)
            .with { device, data ->
                if (BuildConfig.DEBUG) {
                    LogUtil.d("-----enableIndications setNotificationCallback:----- $data")
                }
                val encodeHex = data.value?.map {
                    (it.toInt() and 0xFF)
                }
                onReceiveNativeEvent(
                    BluetoothEvent.BLUETOOTH_CHARACTERISTIC_VALUE_CHANGED,
                    Arguments.createMap().apply {
                        putString("peripheral", gatt?.device?.address ?: "")
                        putString("service", serverUUID.toString().uppercase())
                        putString("characteristic", uuid.toString().uppercase())
                        putArray("value", Arguments.fromList(encodeHex))
                    })
            }
        enableIndications(characteristic)
            .done {
                LogUtil.i("-----startNotification enableNotifications: success -----device: ${gatt?.device?.address} service: $serverUUID, characteristic: $uuid")
                callback.onSuccess(true)
            }
            .fail { device, status ->
                LogUtil.e("-----startNotification enableNotifications: fail-----device: $device ,data: $status servierUUID: $serverUUID, characteristicUUID: $uuid")
                callback.onFailed(status, FailCallbackStatus.failException2String(status))
            }
            .enqueue()

    }

    fun disableIndications(serverUUID: String, uuid: String, callback: BleOperatorRnCallback) {
        if (gatt == null) {
            LogUtil.e("-----stopNotification:----- gatt == null")
            callback.onFailed(
                FailCallback.REASON_DEVICE_DISCONNECTED,
                FailCallbackStatus.failException2String(FailCallback.REASON_DEVICE_DISCONNECTED)
            )
            return
        }
        val characteristic =
            gatt?.getService(UUID.fromString(serverUUID))?.getCharacteristic(UUID.fromString(uuid))
        if (characteristic == null) {
            LogUtil.e("-----stopNotification:----- characteristic == null")
            callback.onFailed(
                FailCallback.REASON_DEVICE_NOT_SUPPORTED,
                FailCallbackStatus.failException2String(FailCallback.REASON_DEVICE_NOT_SUPPORTED)
            )
            return
        }
        val isSupportProperty =
            characteristic.properties and BluetoothGattCharacteristic.PROPERTY_INDICATE != 0
        if (!isSupportProperty) {
            LogUtil.e("-----stopNotification:----- characteristic not support PROPERTY_NOTIFY service: $serverUUID, characteristic: $uuid")
            callback.onFailed(
                FailCallback.REASON_DEVICE_NOT_SUPPORTED,
                FailCallbackStatus.failException2String(FailCallback.REASON_DEVICE_NOT_SUPPORTED)
            )
            return
        }
        disableIndications(characteristic)
            .done {
                callback.onSuccess(true)
            }.fail { device, status ->
                LogUtil.e("stopNotification fail: device: $device ,status: $status")
                callback.onFailed(status, FailCallbackStatus.failException2String(status))
            }
            .enqueue()
    }


    fun startDiscoverCharacteristics(serverUUID: String, characteristicUUID: List<String>) {
        if (isDisposed) {
            release()
            return
        }
        val characteristics = gatt?.getService(UUID.fromString(serverUUID))?.characteristics?.map {
            it.uuid.toString().uppercase()
        }
        val uuidList = characteristics?.filter { uuid ->
            characteristicUUID.isEmpty() || characteristicUUID.contains(uuid)
        } ?: emptyList()
        if (uuidList.isNotEmpty()) {
            onReceiveNativeEvent(
                BluetoothEvent.BLUETOOTH_CHARACTERISTIC_DISCOVERED,
                Arguments.createMap().apply {
                    putString("eventName", BluetoothEvent.BLUETOOTH_CHARACTERISTIC_DISCOVERED)
                    putString("bluetooth", bluetoothDevice?.address ?: "")
                    putString("services", serverUUID)
                    putArray("characteristics", Arguments.fromList(uuidList))
                })
        } else {
            onReceiveNativeEvent(
                BluetoothEvent.BLUETOOTH_CHARACTERISTIC_DISCOVER_FAILED,
                Arguments.createMap().apply {
                    putString("eventName", BluetoothEvent.BLUETOOTH_CHARACTERISTIC_DISCOVER_FAILED)
                    putString("bluetooth", bluetoothDevice?.address ?: "")
                    putString("services", serverUUID)
                    putArray("characteristics", Arguments.fromList(uuidList))
                    putString("error", "-1, DiscoverCharacteristics fail")
                })
        }
    }

    fun readRemoteRssi(callback: BleOperatorRnCallback) {
        readRssi()
            .with { device, rssi ->
                callback.onSuccess(rssi)
            }
            .fail { device, status ->
                LogUtil.e("readRemoteRssi fail: device: $device ,status: $status")
                callback.onFailed(
                    status,
                    FailCallbackStatus.failException2String(status)
                )

            }.enqueue()

    }

    @SuppressLint("MissingPermission")
    private fun onConnectionStatusChangedReceiveNativeEvent(
        mac: String,
        uuid: String,
        isConnected: Boolean,
        device: BluetoothDevice
    ) {
        val iBluetooth = Arguments.createMap().apply {
            putString("mac", device.address)
            putString("name", device.name)
            putString("localName", device.name)
            putString("id", device.address)
            putString("uuid", uuid)
            putBoolean("isConnected", isConnected)
        }
        onReceiveNativeEvent(
            BluetoothEvent.BLUETOOTH_CONNECTION_STATUS_CHANGED,
            Arguments.createMap().apply {
                putString("eventName", BluetoothEvent.BLUETOOTH_CONNECTION_STATUS_CHANGED)
                putMap("peripheral", iBluetooth)
                putBoolean("isConnected", isConnected)
            },
            skipDispose = true
        )
        /// fixme: 保存连接状态
//        bleDeviceMap.get(mac)?.let {
//            it.putBoolean("isConnected", isConnected)
//        }
    }

    private fun onReceiveNativeEvent(
        eventName: String,
        event: WritableMap,
        skipDispose: Boolean = false
    ) {
        if (BuildConfig.DEBUG) {
            LogUtil.d("onReceiveNativeEvent: $eventName, map:$event isDisposed:$isDisposed")
        }
        if (isDisposed && !skipDispose) {
            LogUtil.d("onReceiveNativeEvent: $eventName, map:$event isDisposed:$isDisposed ,skipDispose:$skipDispose")
            return
        }
        reactContext.getJSModule(RCTDeviceEventEmitter::class.java)
            .emit(eventName, event)
    }

}