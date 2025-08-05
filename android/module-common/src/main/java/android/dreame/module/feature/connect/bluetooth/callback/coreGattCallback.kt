package android.dreame.module.feature.connect.bluetooth.callback

import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCallback
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothProfile
import android.dreame.module.bean.device.BluetoothDeviceWrapper
import android.dreame.module.feature.connect.bluetooth.BleMsg
import android.dreame.module.feature.connect.bluetooth.BleStateParameter
import android.dreame.module.feature.connect.bluetooth.DISCOVER_SERVICES_OVER_TIME
import android.dreame.module.feature.connect.bluetooth.LastState
import android.dreame.module.feature.connect.bluetooth.mainHandler
import android.dreame.module.util.LogUtil
import android.os.Bundle
import android.os.Message
import java.util.concurrent.ConcurrentHashMap

private const val TAG = "CoreGattCallback"

/**
 * 设备管理
 */
internal val deviceGattMap = mutableMapOf<String, BluetoothGatt>()
internal val deviceWrapperMap = ConcurrentHashMap<String, BluetoothDeviceWrapper>()
internal val deviceStatusMap = ConcurrentHashMap<String, LastState>()

/// mtu
internal val deviceMTUMap = ConcurrentHashMap<String, Int>()

/**
 * 连接callback
 */
internal val connectGattCallbackMap = ConcurrentHashMap<String, BleConnectGattCallback>()
internal val rssiCallbackMap = ConcurrentHashMap<String, BleCallback>()
internal val mtuChangedCallbackMap = ConcurrentHashMap<String, BleCallback>()
internal val characterCallbackMap = ConcurrentHashMap<String, BleCallback>()

/**
 * 读写 callback
 */
internal val bleNotifyCallbackHashMap = ConcurrentHashMap<String, BleNotifyCallback>()
internal val bleIndicateCallbackHashMap = ConcurrentHashMap<String, BleIndicateCallback>()
internal val bleWriteCallbackHashMap = ConcurrentHashMap<String, BleWriteCallback>()
internal val bleReadCallbackHashMap = ConcurrentHashMap<String, BleReadCallback>()


/**
 * 蓝牙gatt协议回调
 * [https://android.googlesource.com/platform/external/bluetooth/bluedroid/+/refs/heads/main/stack/include/gatt_api.h]
 * [https://android.googlesource.com/platform/system/bt/+/refs/heads/main/stack/include/gatt_api.h]
 */
val coreGattCallback by lazy {
    object : BluetoothGattCallback() {

        override fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
            super.onConnectionStateChange(gatt, status, newState)
            val mac = gatt.device.address
            deviceGattMap[mac] = gatt
            LogUtil.i(
                TAG,
                "BluetoothGattCallback：onConnectionStateChange gatt $mac status: $status newState: $newState   $this "
            )
            mainHandler.removeMessages(BleMsg.MSG_CONNECT_OVER_TIME)
            //  替换, 暂时只支持一个设备连接
            when (status) {
                BluetoothGatt.GATT_SUCCESS -> {
                    connectionStateChange(gatt, newState, status, mac)
                }

                133 -> {
                    // retry
                    deviceMTUMap.remove(mac)
                    val message: Message = mainHandler.obtainMessage()
                    message.what = BleMsg.MSG_CONNECT_133
                    message.arg1 = status
                    message.arg2 = newState
                    message.obj = BleStateParameter(mac, status)
                    mainHandler.sendMessageDelayed(message, 500)
                }

                else -> {
                    deviceMTUMap.remove(mac)
                    val message: Message = mainHandler.obtainMessage()
                    message.what = BleMsg.MSG_CONNECT_FAIL
                    message.arg1 = status
                    message.arg2 = newState
                    message.obj = BleStateParameter(mac, status)
                    mainHandler.sendMessageDelayed(message, 500)
                }
            }
        }

        private fun connectionStateChange(gatt: BluetoothGatt, newState: Int, status: Int, mac: String) {
            when (newState) {
                BluetoothProfile.STATE_CONNECTING -> {
                }

                BluetoothProfile.STATE_CONNECTED -> {
                    // 连接成功
                    val message: Message = mainHandler.obtainMessage()
                    message.what = BleMsg.MSG_DISCOVER_SERVICES
                    message.arg1 = status
                    message.arg2 = newState
                    message.obj = BleStateParameter(mac, newState)
                    mainHandler.sendMessageDelayed(message, 500)
                }

                BluetoothProfile.STATE_DISCONNECTING -> {

                }

                BluetoothProfile.STATE_DISCONNECTED -> {
                    // 断开成功
                    // gatt close
                    deviceMTUMap.remove(mac)
                    deviceGattMap[mac] = gatt
                    val lastState = deviceStatusMap[mac]
                    if (lastState == LastState.CONNECT_CONNECTING) {
                        val message = mainHandler.obtainMessage()
                        message.what = BleMsg.MSG_CONNECT_FAIL
                        message.arg1 = status
                        message.arg2 = newState
                        message.obj = BleStateParameter(mac, status)
                        mainHandler.sendMessage(message)
                    } else if (lastState == LastState.CONNECT_CONNECTED) {
                        val message = mainHandler.obtainMessage()
                        message.what = BleMsg.MSG_DISCONNECTED
                        message.arg1 = status
                        message.arg2 = newState
                        message.obj = BleStateParameter(mac, status)
                        mainHandler.sendMessage(message)
                    } else {
                        val message = mainHandler.obtainMessage()
                        message.what = BleMsg.MSG_CONNECT_FAIL
                        message.arg1 = status
                        message.arg2 = newState
                        message.obj = BleStateParameter(mac, status)
                        mainHandler.sendMessage(message)
                    }
                }

                else -> {
                }
            }
        }

        override fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {
            super.onServicesDiscovered(gatt, status)
            mainHandler.removeMessages(DISCOVER_SERVICES_OVER_TIME)
            mainHandler.removeMessages(BleMsg.MSG_DISCOVER_SERVICES_AGAIN)
            val mac = gatt.device.address
            deviceGattMap[mac] = gatt
            LogUtil.i(TAG, "BluetoothGattCallback：onServicesDiscovered gatt $mac status: $status $this ")
            if (status == BluetoothGatt.GATT_SUCCESS) {
                val message = mainHandler.obtainMessage()
                message.what = BleMsg.MSG_DISCOVER_SUCCESS
                message.obj = BleStateParameter(mac, status)
                mainHandler.sendMessage(message)
            } else {
                val message = mainHandler.obtainMessage()
                message.what = BleMsg.MSG_DISCOVER_FAIL
                message.arg1 = status
                message.obj = BleStateParameter(mac, status)
                mainHandler.sendMessage(message)
            }

        }

        @Deprecated("Deprecated in Java")
        override fun onCharacteristicChanged(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic) {
            super.onCharacteristicChanged(gatt, characteristic)
            val mac = gatt.device.address
            val uuid_service = characteristic.service.uuid.toString()
            val uuid = characteristic.uuid.toString()
            bleNotifyCallbackHashMap.forEach { entry ->
                val key = entry.key
                val callback = entry.value
                if (key.equals("${mac}_${uuid_service}_${uuid}", ignoreCase = true)) {
                    val message = callback.handler.obtainMessage()
                    message.what = BleMsg.MSG_CHA_NOTIFY_DATA_CHANGE
                    message.obj = callback
                    val bundle = Bundle()
                    bundle.putByteArray(BleMsg.KEY_NOTIFY_BUNDLE_VALUE, characteristic.value ?: byteArrayOf())
                    message.data = bundle
                    callback.handler.sendMessage(message)
                    return@forEach
                }
            }
            bleIndicateCallbackHashMap.forEach { entry ->
                val key = entry.key
                val callback = entry.value
                if (key.equals("${mac}_${uuid_service}_${uuid}", ignoreCase = true)) {
                    val message = callback.handler.obtainMessage()
                    message.what = BleMsg.MSG_CHA_INDICATE_DATA_CHANGE
                    message.obj = callback
                    val bundle = Bundle()
                    bundle.putByteArray(BleMsg.KEY_INDICATE_BUNDLE_VALUE, characteristic.value ?: byteArrayOf())
                    message.data = bundle
                    callback.handler.sendMessage(message)
                    return@forEach
                }
            }

        }

        override fun onDescriptorWrite(gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int) {
            super.onDescriptorWrite(gatt, descriptor, status)
            val mac = gatt.device.address
            val uuid_service = descriptor.characteristic.service.uuid.toString()
            val uuid = descriptor.characteristic.uuid.toString()

            bleNotifyCallbackHashMap.forEach { entry ->
                val key = entry.key
                val callback = entry.value
                if (key.equals("${mac}_${uuid_service}_${uuid}", ignoreCase = true)) {
                    val message = callback.handler.obtainMessage()
                    message.what = BleMsg.MSG_CHA_NOTIFY_RESULT
                    message.obj = callback
                    val bundle = Bundle()
                    bundle.putInt(BleMsg.KEY_NOTIFY_BUNDLE_STATUS, status)
                    message.data = bundle
                    callback.handler.sendMessage(message)
                    return@forEach
                }
            }

            bleIndicateCallbackHashMap.forEach { entry ->
                val key = entry.key
                val callback = entry.value
                if (key.equals("${mac}_${uuid_service}_${uuid}", ignoreCase = true)) {
                    val message = callback.handler.obtainMessage()
                    message.what = BleMsg.MSG_CHA_INDICATE_RESULT
                    message.obj = callback
                    val bundle = Bundle()
                    bundle.putInt(BleMsg.KEY_INDICATE_BUNDLE_STATUS, status)
                    message.data = bundle
                    callback.handler.sendMessage(message)
                    return@forEach
                }
            }
        }

        override fun onCharacteristicWrite(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, status: Int) {
            super.onCharacteristicWrite(gatt, characteristic, status)
            val mac = gatt.device.address
            val uuid_service = characteristic.service.uuid.toString()
            val uuid = characteristic.uuid.toString()

            bleWriteCallbackHashMap.forEach { entry ->
                val key = entry.key
                val callback = entry.value
                if (key.equals("${mac}_${uuid_service}_${uuid}", ignoreCase = true)) {
                    val message = callback.handler.obtainMessage()
                    message.what = BleMsg.MSG_CHA_WRITE_RESULT
                    message.obj = callback
                    val bundle = Bundle()
                    bundle.putInt(BleMsg.KEY_WRITE_BUNDLE_STATUS, status)
                    bundle.putByteArray(BleMsg.KEY_WRITE_BUNDLE_VALUE, characteristic.value ?: byteArrayOf())
                    message.data = bundle
                    callback.handler.sendMessage(message)
                    return@forEach
                }
            }
        }

        @Deprecated("Deprecated in Java")
        override fun onCharacteristicRead(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, status: Int) {
            super.onCharacteristicRead(gatt, characteristic, status)
            val mac = gatt.device.address
            val uuid_service = characteristic.service.uuid.toString()
            val uuid = characteristic.uuid.toString()
//            LogUtil.d(
//                TAG,
//                "BluetoothGattCallback：onCharacteristicRead gatt ${mac} ,uuid_service: $uuid_service ,uuid: $uuid ,value: ${characteristic.value.formatHexString()} $this "
//            )
            bleReadCallbackHashMap.forEach { entry ->
                val key = entry.key
                val callback = entry.value
//                LogUtil.d(
//                    TAG,
//                    "BluetoothGattCallback：onCharacteristicRead 1 key: $key  ${"${mac}_${uuid_service}_${uuid}"} $this "
//                )
                if (key.equals("${mac}_${uuid_service}_${uuid}", ignoreCase = true)) {
//                    LogUtil.d(
//                        TAG,
//                        "BluetoothGattCallback：onCharacteristicRead 2 key: $key  ${"${mac}_${uuid_service}_${uuid}"} $this "
//                    )
                    val message = callback.handler.obtainMessage()
                    message.what = BleMsg.MSG_CHA_READ_RESULT
                    message.obj = callback
                    val bundle = Bundle()
                    bundle.putInt(BleMsg.KEY_READ_BUNDLE_STATUS, status)
                    bundle.putByteArray(BleMsg.KEY_READ_BUNDLE_VALUE, characteristic.value ?: byteArrayOf())
                    message.data = bundle
                    callback.handler.sendMessage(message)
                    return@forEach
                }
            }

        }

        @Deprecated("Deprecated in Java")
        override fun onDescriptorRead(gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int) {
            super.onDescriptorRead(gatt, descriptor, status)
            val mac = gatt.device.address
            val uuid_service = descriptor.characteristic.service.uuid.toString()
            val uuid = descriptor.characteristic.uuid.toString()
//            LogUtil.d(
//                TAG,
//                "BluetoothGattCallback：onDescriptorRead gatt ${mac} ,uuid_service: $uuid_service ,uuid: $uuid ,value: ${descriptor.value.formatHexString()} $this "
//            )
        }


        override fun onReliableWriteCompleted(gatt: BluetoothGatt, status: Int) {
            super.onReliableWriteCompleted(gatt, status)
//            LogUtil.d(
//                TAG,
//                "BluetoothGattCallback：onReliableWriteCompleted gatt ${gatt.device.address} status: $status $this "
//            )
        }

        override fun onReadRemoteRssi(gatt: BluetoothGatt, rssi: Int, status: Int) {
            super.onReadRemoteRssi(gatt, rssi, status)
            LogUtil.i(
                TAG,
                "BluetoothGattCallback：onReadRemoteRssi gatt ${gatt.device.address} status: $status  rssi: $rssi $this "
            )
            val mac = gatt.device.address
            rssiCallbackMap[mac]?.run {
                val message = handler.obtainMessage()
                message.what = BleMsg.MSG_READ_RSSI_RESULT
                message.obj = this
                val bundle = Bundle()
                bundle.putInt(BleMsg.KEY_READ_RSSI_BUNDLE_STATUS, status)
                bundle.putInt(BleMsg.KEY_READ_RSSI_BUNDLE_VALUE, rssi)
                message.data = bundle
                handler.sendMessage(message)
            }

        }

        override fun onMtuChanged(gatt: BluetoothGatt, mtu: Int, status: Int) {
            super.onMtuChanged(gatt, mtu, status)
            LogUtil.i(
                TAG,
                "BluetoothGattCallback：onMtuChanged gatt ${gatt.device.address} status: $status  mtu: $mtu ${this.hashCode()} "
            )
            val mac = gatt.device.address
            deviceMTUMap[mac] = mtu
            mtuChangedCallbackMap[mac]?.run {
                val message = handler.obtainMessage()
                message.what = BleMsg.MSG_SET_MTU_RESULT
                message.obj = this
                val bundle = Bundle()
                bundle.putInt(BleMsg.KEY_SET_MTU_BUNDLE_STATUS, status)
                bundle.putInt(BleMsg.KEY_SET_MTU_BUNDLE_VALUE, mtu)
                message.data = bundle
                handler.sendMessage(message)
            }
        }
    }
}
