package android.dreame.module.feature.connect.bluetooth.callback

import android.os.Handler
import android.dreame.module.bean.device.BluetoothDeviceWrapper
import android.dreame.module.feature.connect.bluetooth.BleException
import android.dreame.module.feature.connect.bluetooth.mainHandler

interface Callback

/**
 * 蓝牙回调基类
 */
abstract class BleCallback : Callback {
    var uuid: String = ""
    var uuid_service: String = ""
    var key: String = ""
    var handler: Handler = mainHandler
}


abstract class BleConnectGattCallback : BleCallback() {
    open fun onStartConnect() {}
    open fun onConnectFail(device: BluetoothDeviceWrapper, exception: BleException) {}
    open fun onConnectFail133(device: BluetoothDeviceWrapper, exception: BleException) {}
    open fun onConnectSuccess(device: BluetoothDeviceWrapper, status: Int) {}
    open fun onDiscoverSuccess(device: BluetoothDeviceWrapper, status: Int) {}
    open fun onDiscoverFail(device: BluetoothDeviceWrapper, exception: BleException) {}
    open fun onDisConnected(isActiveDisConnected: Boolean, device: BluetoothDeviceWrapper, status: Int) {}
}

abstract class BleIndicateCallback : BleCallback() {
    open fun onIndicateSuccess() {}
    open fun onIndicateFailure(exception: BleException?) {}
    open fun onCharacteristicChanged(data: ByteArray?) {}
}

abstract class BleMtuChangedCallback : BleCallback() {
    abstract fun onSetMTUFailure(exception: BleException)
    abstract fun onMtuChanged(mtu: Int)
}

abstract class BleNotifyCallback : BleCallback() {
    open fun onNotifySuccess() {}
    open fun onNotifyFailure(exception: BleException) {}
    open fun onCharacteristicChanged(data: ByteArray) {}
}

abstract class BleReadCallback : BleCallback() {
    open fun onReadSuccess(data: ByteArray) {}
    open fun onReadFailure(exception: BleException) {}
}

abstract class BleRssiCallback : BleCallback() {
    open fun onRssiFailure(exception: BleException) {}
    open fun onRssiSuccess(rssi: Int) {}

}


abstract class BleWriteCallback : BleCallback() {
    open fun onWriteSuccess(current: Int, total: Int, justWrite: ByteArray) {}
    open fun onWriteFailure(exception: BleException) {}
}