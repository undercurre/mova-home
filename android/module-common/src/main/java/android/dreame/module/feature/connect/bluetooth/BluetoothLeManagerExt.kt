package android.dreame.module.feature.connect.bluetooth

import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattService
import android.dreame.module.feature.connect.bluetooth.BleOperateHelper
import android.dreame.module.feature.connect.bluetooth.callback.deviceGattMap
import java.util.UUID

/**
 * 非必要不使用
 */
object BluetoothLeManagerExt {
    fun getBluetoothGatt(mac: String): BluetoothGatt? {
        return deviceGattMap[mac]
    }

    fun getBluetoothGattService(mac: String, serviceUUID: String): BluetoothGattService? {
        return getBluetoothGatt(mac)?.getService(UUID.fromString(serviceUUID))
    }

    fun getBluetoothGattServices(mac: String): List<BluetoothGattService> {
        return getBluetoothGatt(mac)?.services ?: emptyList()
    }

    fun getBluetoothGattServices(mac: String, serviceUUIDs: Array<String>): List<BluetoothGattService> {
        return getBluetoothGattServices(mac).filter {
            serviceUUIDs.contains(it.uuid.toString())
        }
    }

    fun getBluetoothGatt(mac: String, serviceUUID: String, characteristicUUID: String): BluetoothGattCharacteristic? {
        return getBluetoothGattService(mac, serviceUUID)?.getCharacteristic(UUID.fromString(characteristicUUID))
    }

    fun getCharacteristics(mac: String, serviceUUID: String, characteristicUUID: Array<String>): List<BluetoothGattCharacteristic> {
        return getBluetoothGattService(mac, serviceUUID)?.characteristics?.filter {
            characteristicUUID.isEmpty() || characteristicUUID.contains(it.uuid.toString())
        } ?: emptyList()
    }

}