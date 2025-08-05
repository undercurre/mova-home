package android.dreame.module.feature.connect.bluetooth.mower

import android.bluetooth.BluetoothManager
import android.bluetooth.le.ScanResult
import android.content.Context
import android.dreame.module.BuildConfig
import android.dreame.module.LocalApplication
import android.dreame.module.bean.device.BluetoothDeviceWrapper
import android.dreame.module.feature.connect.bluetooth.BluetoothLeManagerExt
import android.dreame.module.feature.connect.bluetooth.mower.event.BluetoothEvent
import android.dreame.module.util.LogUtil
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import android.provider.Settings
import android.dreame.module.feature.connect.bluetooth.BleException
import android.dreame.module.feature.connect.bluetooth.BluetoothLeManager
import android.dreame.module.feature.connect.bluetooth.DEFAULT_MAX_MTU
import android.dreame.module.feature.connect.bluetooth.DEFAULT_MTU
import android.dreame.module.feature.connect.bluetooth.callback.BleConnectGattCallback
import android.dreame.module.feature.connect.bluetooth.callback.BleMtuChangedCallback
import android.dreame.module.feature.connect.bluetooth.callback.BleNotifyCallback
import android.dreame.module.feature.connect.bluetooth.callback.BleReadCallback
import android.dreame.module.feature.connect.bluetooth.callback.BleRssiCallback
import android.dreame.module.feature.connect.bluetooth.callback.BleWriteCallback
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.WritableMap
import com.facebook.react.bridge.WritableNativeMap
import com.facebook.react.modules.core.DeviceEventManagerModule.RCTDeviceEventEmitter
import okhttp3.internal.EMPTY_BYTE_ARRAY

class MowerBleOperator(val reactContext: ReactApplicationContext) {
    private val mHandler = Handler(Looper.getMainLooper())

    val bluetoothManager by lazy { LocalApplication.getInstance().getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager }
    val bluetoothAdapter by lazy { bluetoothManager.adapter }
    val bluetoothDeviceMap = mutableMapOf<String, BluetoothDeviceWrapper>()
    val bleDeviceMap = mutableMapOf<String, Bundle>()

    /**
     * 蓝牙半开状态
     */
    private fun isHalfOpen(): Boolean {
        val state = Settings.Global.getInt(reactContext.applicationContext.contentResolver, "bluetooth_restricte_state", 0)
        return state == 1
    }

    fun onReceiveNativeEvent(eventName: String, event: WritableMap) {
        if (BuildConfig.DEBUG) {
            LogUtil.d("onReceiveNativeEvent: $eventName, map:$event")
        }
        reactContext.getJSModule(RCTDeviceEventEmitter::class.java)
            .emit(eventName, event)
    }

    fun onReceiveNativeEvent(eventName: String, event: String) {
        if (BuildConfig.DEBUG) {
            LogUtil.d("onReceiveNativeEvent: $eventName, map:$event")
        }
        reactContext.getJSModule(RCTDeviceEventEmitter::class.java)
            .emit(eventName, event)
    }

    fun connect(mac: String, timeout: Int, pincode: Int, callback: BleOperatorRnCallback) {

//        val connectedDevices = bluetoothManager.getConnectedDevices(BluetoothProfile.GATT)
//        val devicesMatchingConnectionStates = bluetoothManager.getDevicesMatchingConnectionStates(
//            BluetoothProfile.GATT,
//            intArrayOf(BluetoothProfile.STATE_CONNECTED, BluetoothProfile.STATE_CONNECTING)
//        )
        val bluetoothDeviceWrapper = getBluetoothDeviceWrapper(mac)
        if (bluetoothDeviceWrapper == null) {
            callback.onFailed("device is null, need scan again")
            return
        }
        if (isHalfOpen()) {
            callback.onFailed("ble is half open")
            return
        }
        BluetoothLeManager.connectDevice(LocalApplication.getInstance(), bluetoothDeviceWrapper, false, object : BleConnectGattCallback() {
            override fun onConnectFail(device: BluetoothDeviceWrapper, exception: BleException) {
                LogUtil.d("onConnectFail: ")
                onConnectionStatusChangedReceiveNativeEvent(mac, uuid, false, device)
                callback.onFailed("device is null, need scan again")
            }

            override fun onConnectFail133(device: BluetoothDeviceWrapper, exception: BleException) {
                LogUtil.d("onConnectFail133: ")
//                val mac = device.device.address
                onConnectionStatusChangedReceiveNativeEvent(mac, uuid, false, device)
                callback.onFailed("device connect status 133")

            }

            override fun onConnectSuccess(device: BluetoothDeviceWrapper, status: Int) {
//                val mac = device.device.address
                onConnectionStatusChangedReceiveNativeEvent(mac, uuid, true, device)
                callback.onSuccess(true)
            }

            override fun onDiscoverFail(device: BluetoothDeviceWrapper, exception: BleException) {
                onReceiveNativeEvent(BluetoothEvent.BLUETOOTH_SEVICE_DISCOVER_FAILED, Arguments.createMap().apply {
                    putString("eventName", BluetoothEvent.BLUETOOTH_SEVICE_DISCOVER_FAILED)
                    putMap("bluetooth", Arguments.makeNativeMap(bleDeviceMap[device.device.address]))
                    putString("error", "${exception.code}  ${exception.description}")
                })
                //主动断开
                LogUtil.i("onDiscoverFail disconnect $mac ")
                disconnect(device.device.address, 0, true)
            }

            override fun onDiscoverSuccess(device: BluetoothDeviceWrapper, status: Int) {

                val mac1 = device.device.address
                val bleDevice = Bundle().apply {
                    putString("mac", mac)
                    putInt("deviceType", device.device.type)
                    putInt("rssi", device.rssi)
                    putBoolean("isConnected", BluetoothLeManager.isDeviceConnect(device))
                    putString("address", mac1)
                    putString("mac", mac1)
                    putString("name", "")
                    putString("serviceData", "")
                    putString("id", mac1)
                    putString("uuid", uuid)
                }
                bleDeviceMap.put(mac, bleDevice)
                BluetoothLeManager.setMtu(device, DEFAULT_MAX_MTU, object : BleMtuChangedCallback() {
                    override fun onSetMTUFailure(exception: BleException) {
                        val event = Arguments.createMap().apply {
                            putString("eventName", BluetoothEvent.BLUETOOTH_SEVICE_DISCOVERED)
                            putMap("bluetooth", Arguments.makeNativeMap(bleDeviceMap[mac1]))
                            putArray("services", Arguments.fromList(BluetoothLeManagerExt.getBluetoothGattServices(mac1).map {
                                it.uuid.toString()
                            }))
                        }
                        onReceiveNativeEvent(BluetoothEvent.BLUETOOTH_SEVICE_DISCOVERED, event)
                    }

                    override fun onMtuChanged(mtu: Int) {
                        val event = Arguments.createMap().apply {
                            putString("eventName", BluetoothEvent.BLUETOOTH_SEVICE_DISCOVERED)
                            putMap("bluetooth", Arguments.makeNativeMap(bleDeviceMap[mac1]))
                            putArray("services", Arguments.fromList(BluetoothLeManagerExt.getBluetoothGattServices(mac1).map {
                                it.uuid.toString()
                            }))
                        }
                        onReceiveNativeEvent(BluetoothEvent.BLUETOOTH_SEVICE_DISCOVERED, event)
                    }
                })
            }

            override fun onDisConnected(isActiveDisConnected: Boolean, device: BluetoothDeviceWrapper, status: Int) {
//                val mac = device.device.address
                onConnectionStatusChangedReceiveNativeEvent(mac, uuid, false, device)
            }
        }, timeout.toLong())
    }

    private fun onConnectionStatusChangedReceiveNativeEvent(
        mac: String,
        uuid: String,
        isConnected: Boolean,
        deviceWrapper: BluetoothDeviceWrapper
    ) {
        val iBluetooth = Arguments.createMap().apply {
            putString("mac", deviceWrapper.device.address)
            putString("name", deviceWrapper.result)
            putString("localName", deviceWrapper.result)
            putString("id", deviceWrapper.device.address)
            putString("uuid", uuid)
            putBoolean("isConnected", isConnected)
        }
        onReceiveNativeEvent(BluetoothEvent.BLUETOOTH_CONNECTION_STATUS_CHANGED, Arguments.createMap().apply {
            putString("eventName", BluetoothEvent.BLUETOOTH_CONNECTION_STATUS_CHANGED)
            putMap("peripheral", iBluetooth)
            putBoolean("isConnected", isConnected)
        })
        bleDeviceMap.get(mac)?.let {
            it.putBoolean("isConnected", isConnected)
        }
    }

    fun disconnect(mac: String, delay: Int, force: Boolean) {
        BluetoothLeManager.disConnectDevice(mac)
        mHandler.postDelayed({
            onReceiveNativeEvent(BluetoothEvent.BLUETOOTH_CONNECTION_STATUS_CHANGED, Arguments.createMap().apply {
                putString("eventName", BluetoothEvent.BLUETOOTH_CONNECTION_STATUS_CHANGED)
                putMap("peripheral", Arguments.makeNativeMap(bleDeviceMap[mac]))
                putBoolean("isConnected", false)
            })
            bleDeviceMap.get(mac)?.let {
                it.putBoolean("isConnected", false)
            }
        }, delay.toLong())
    }

    fun startDiscoverServices(mac: String, services: List<String>) {
//        BluetoothLeManager.discoverServices(mac)
    }

    fun startDiscoverCharacteristics(mac: String, services: String, charactersArray: List<String>) {
        val characteristics = BluetoothLeManagerExt.getCharacteristics(mac, services, charactersArray.toTypedArray())
        val uuidList = characteristics.map {
            it.uuid.toString()
        }
        if (uuidList.isNotEmpty()) {
            onReceiveNativeEvent(BluetoothEvent.BLUETOOTH_CHARACTERISTIC_DISCOVERED, Arguments.createMap().apply {
                putString("eventName", BluetoothEvent.BLUETOOTH_CHARACTERISTIC_DISCOVERED)
                putString("bluetooth", mac)
                putString("services", services)
                putArray("characteristics", Arguments.fromList(uuidList))
            })
        } else {
            onReceiveNativeEvent(BluetoothEvent.BLUETOOTH_CHARACTERISTIC_DISCOVER_FAILED, Arguments.createMap().apply {
                putString("eventName", BluetoothEvent.BLUETOOTH_CHARACTERISTIC_DISCOVER_FAILED)
                putString("bluetooth", mac)
                putString("service", services)
                putString("error", "-1, DiscoverCharacteristics fail")
            })
        }

    }

    fun getBluetoothDeviceWrapper(mac: String, did: String? = null): BluetoothDeviceWrapper? {
        var deviceWrapper = bluetoothDeviceMap[mac]
        if (deviceWrapper == null) {
            LogUtil.i("------getBluetoothDeviceWrapper deviceWrapper == null  $mac")
            val device = bluetoothManager.adapter.getRemoteDevice(mac)
            val value = BluetoothDeviceWrapper("", device, byteArrayOf(), -1, SystemClock.elapsedRealtime(), true)
            bluetoothDeviceMap.put(mac, value)
        }
        deviceWrapper = bluetoothDeviceMap[mac]
        if (did == null || deviceWrapper?.result?.contains(did) == true) {
            return deviceWrapper
        }
        return null
    }

    fun read(mac: String, serviceUUID: String, characteristicUUID: String, callback: BleOperatorRnCallback) {
        if (BuildConfig.DEBUG) {
            LogUtil.d("read ------- $mac $serviceUUID  $characteristicUUID  ${callback.rnCallback.hashCode()}")
        }
        BluetoothLeManager.read(mac, uuid_service = serviceUUID, uuid_read = characteristicUUID, object : BleReadCallback() {
            override fun onReadSuccess(data: ByteArray) {
                val encodeHex = data.map {
                    (it.toInt() and 0xFF)
                }
                if (BuildConfig.DEBUG) {
                    LogUtil.d("read ---onReadSuccess---- $mac $uuid_service  $uuid  ${this.hashCode()}")
                }
                onReceiveNativeEvent(BluetoothEvent.BLUETOOTH_CHARACTERISTIC_VALUE_CHANGED, Arguments.createMap().apply {
                    putString("peripheral", mac)
                    putString("service", uuid_service)
                    putString("characteristic", uuid)
                    putArray("value", Arguments.fromList(encodeHex))
                })
                callback.onSuccess(Arguments.fromList(encodeHex))
            }

            override fun onReadFailure(exception: BleException) {
                LogUtil.d("read ---onReadFailure---- $mac $uuid_service  $uuid ${exception.code} ${exception.description} ${hashCode()}")
                callback.onFailed("${exception.code} ${exception.description}")
            }
        })
    }

    fun writeData(
        mac: String,
        serviceUUID: String,
        characteristicUUID: String,
        dataArray: ReadableArray,
        maxByteSize: Int,
        callback: BleOperatorRnCallback
    ) {
        val toTypedArray = dataArray.toArrayList().map {
            if (it is Number) {
                it.toByte()
            } else if (it is String) {
                it.toInt(16).toByte()
            } else {
                0.toByte()
            }
        }.toByteArray()
        if (BuildConfig.DEBUG) {
            LogUtil.d("writeData ------- $mac $serviceUUID  $characteristicUUID  ${callback.rnCallback.hashCode()}")
        }
        BluetoothLeManager.write(mac, serviceUUID, characteristicUUID, toTypedArray, maxByteSize > 512, object : BleWriteCallback() {
            override fun onWriteSuccess(current: Int, total: Int, justWrite: ByteArray) {
                if (BuildConfig.DEBUG) {
                    LogUtil.d(" ---onWriteSuccess---- $mac $uuid_service  $uuid  ${this.hashCode()}")
                }
                val encodeHex = justWrite.map {
                    (it.toInt() and 0xFF)
                }
                callback.onSuccess(Arguments.fromList(encodeHex))
            }

            override fun onWriteFailure(exception: BleException) {
                LogUtil.e(" ---onWriteFailure---- $mac $uuid_service  $uuid  ${this.hashCode()}  ${exception.code} ${exception.description} ")
                callback.onFailed("${exception.code} ${exception.description}")
            }
        }, isNoResponse = false)
    }

    fun writeWithoutResponse(
        mac: String,
        serviceUUID: String,
        characteristicUUID: String,
        dataArray: ByteArray,
        maxByteSize: Int,
        callback: BleOperatorRnCallback
    ) {
        if (BuildConfig.DEBUG) {
            LogUtil.d("writeWithoutResponse ------- $mac $serviceUUID  $characteristicUUID  ${callback.rnCallback.hashCode()}")
        }
        BluetoothLeManager.write(mac, serviceUUID, characteristicUUID, dataArray, maxByteSize > 512, object : BleWriteCallback() {
            override fun onWriteSuccess(current: Int, total: Int, justWrite: ByteArray) {
                if (BuildConfig.DEBUG) {
                    LogUtil.d(" ---onWriteSuccess---- $mac $uuid_service  $uuid  ${this.hashCode()}")
                }
                val encodeHex = justWrite.map {
                    (it.toInt() and 0xFF)
                }
                callback.onSuccess(Arguments.fromList(encodeHex))
            }

            override fun onWriteFailure(exception: BleException) {
                LogUtil.d(" ---onWriteFailure---- $mac $uuid_service  $uuid  ${this.hashCode()} ${exception.code} ${exception.description}")
                callback.onFailed("${exception.code} ${exception.description}")
            }
        }, isNoResponse = true)
    }

    fun startNotification(mac: String, serviceUUID: String, characteristicUUID: String, callback: BleOperatorRnCallback) {
        if (BuildConfig.DEBUG) {
            LogUtil.d("startNotification ------- $mac $serviceUUID  $characteristicUUID  ${callback.rnCallback.hashCode()}")
        }
        BluetoothLeManager.notify(mac, serviceUUID, characteristicUUID, false, object : BleNotifyCallback() {
            override fun onNotifySuccess() {
                if (BuildConfig.DEBUG) {
                    LogUtil.d("------onNotifySuccess------ $key")
                }
                callback.onSuccess(true)
            }

            override fun onNotifyFailure(exception: BleException) {
                LogUtil.e("------onNotifyFailure------ $key")
                callback.onFailed("${exception.code} ${exception.description}")
            }

            override fun onCharacteristicChanged(data: ByteArray) {
                if (BuildConfig.DEBUG) {
                    LogUtil.v("onCharacteristicChanged ------- $key  ${data.joinToString()}")
                }

                val encodeHex = data.map {
                    (it.toInt() and 0xFF)
                }
                onReceiveNativeEvent(BluetoothEvent.BLUETOOTH_CHARACTERISTIC_VALUE_CHANGED, Arguments.createMap().apply {
                    putString("peripheral", mac)
                    putString("service", uuid_service)
                    putString("characteristic", uuid)
                    putArray("value", Arguments.fromList(encodeHex))
                })
            }
        })
    }

    fun stopNotification(mac: String, serviceUUID: String, characteristicUUID: String, callback: BleOperatorRnCallback) {
        BluetoothLeManager.stopNotify(mac, serviceUUID, characteristicUUID, false)
    }

    fun onScanResult(callbackType: Int, result: ScanResult, ret: String, mac: String) {
        try {
            val device = result.device
            bluetoothDeviceMap[mac] =
                BluetoothDeviceWrapper(
                    ret,
                    device,
                    result.scanRecord?.bytes ?: EMPTY_BYTE_ARRAY,
                    result.rssi,
                    SystemClock.elapsedRealtime(),
                    true
                )

            // 回调
            val bleDevice = Bundle().apply {
                putString("mac", mac)
                putInt("rssi", result.rssi)
                putBoolean("isConnected", BluetoothLeManager.isDeviceConnect(device))
                val address = device.address
                putString("address", address)
                putString("mac", address)
                putString("name", ret)
                putString("serviceData", ret)
                putString("id", address)
            }
            bleDeviceMap.put(mac, bleDevice)
            val makeNativeMap = Arguments.makeNativeMap(bleDevice)
            onReceiveNativeEvent(BluetoothEvent.BLUETOOTH_DEVICE_DISCOVERED, makeNativeMap)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    fun onScanFailed(errorCode: Int, message: String) {
        onReceiveNativeEvent(BluetoothEvent.BLUETOOTH_DEVICE_DISCOVER_FAILED, "$errorCode $message")
    }

    fun readRSSI(mac: String, callback: BleOperatorRnCallback) {
        BluetoothLeManager.readRssi(mac, object : BleRssiCallback() {
            override fun onRssiFailure(exception: BleException) {
                super.onRssiFailure(exception)
                callback.onFailed(exception.code, exception.description)
            }

            override fun onRssiSuccess(rssi: Int) {
                super.onRssiSuccess(rssi)
                callback.onSuccess(rssi)
            }
        }, 5000)
    }

    fun readReliableMTU(mac: String, callback: BleOperatorRnCallback) {
        BluetoothLeManager.setMtu(mac, DEFAULT_MAX_MTU, object : BleMtuChangedCallback() {
            override fun onSetMTUFailure(exception: BleException) {
                val map = WritableNativeMap()
                map.putBoolean("reliable", false)
                map.putInt("mtu", DEFAULT_MTU)
                callback.onSuccess(map)
            }

            override fun onMtuChanged(mtu: Int) {
                val map = WritableNativeMap()
                map.putBoolean("reliable", true)
                map.putInt("mtu", mtu)
                callback.onSuccess(map)
            }

        }, 5000)
    }


}