package android.dreame.module.bean.device

import android.bluetooth.BluetoothDevice

/**
 * BluetoothDevice包装类
 */
data class BluetoothDeviceWrapper(
    val result: String,
    var device: BluetoothDevice,
    var scanRecord: ByteArray,
    var rssi: Int,
    var timestamp: Long,
    var isActive: Boolean = false
) {
    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as BluetoothDeviceWrapper

        if (device != other.device) return false
        if (!scanRecord.contentEquals(other.scanRecord)) return false

        return true
    }

    override fun hashCode(): Int {
        var result = device.hashCode()
        result = 31 * result + scanRecord.contentHashCode()
        return result
    }
}


