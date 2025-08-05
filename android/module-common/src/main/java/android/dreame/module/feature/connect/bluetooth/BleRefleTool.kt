package android.dreame.module.feature.connect.bluetooth

import android.annotation.SuppressLint
import android.bluetooth.BluetoothGatt
import android.dreame.module.util.LogUtil
import android.dreame.module.feature.connect.bluetooth.callback.deviceGattMap
import io.reactivex.annotations.Experimental
import java.lang.reflect.Field

/**
 * 蓝牙反射工具
 */
object BleReflectTool {

    @Synchronized
    fun refreshDeviceCache(mac: String) {
        deviceGattMap[mac]?.let { gatt ->
            refreshDeviceCache(gatt)
        }
    }

    @Synchronized
    fun refreshDeviceCache(gatt: BluetoothGatt) {
        try {
            val refresh = BluetoothGatt::class.java.getMethod("refresh")
            if (refresh != null) {
                refresh.isAccessible = true
                val success = refresh.invoke(gatt) as Boolean
                refresh.isAccessible = false
                LogUtil.i(BleRealConnectHelper.TAG, "refreshDeviceCache, is success:  $success")
            }
        } catch (e: Exception) {
            LogUtil.e(BleRealConnectHelper.TAG, "exception occur while refreshing device: " + e.message)
            e.printStackTrace()
        }
    }

    /**
     * 获取 mDeviceBusy 属性的值
     * 此方法需配合[反射调试神器](https://github.com/tiann/FreeReflection), 且仅仅适用于调试阶段，线上不要用
     * @param bluetoothGatt [android.bluetooth.BluetoothGatt]
     */
    @Experimental
    @SuppressLint("SoonBlockedPrivateApi")
    private fun getDeviceBusyState(bluetoothGatt: BluetoothGatt): Boolean? {
        try {
            val field: Field = BluetoothGatt::class.java.getDeclaredField("mDeviceBusy")
            field.isAccessible = true
            val xxx = field.get(bluetoothGatt)
            if (xxx is Boolean) {
                return xxx
            }
            return null
        } catch (e: Exception) {
            e.printStackTrace()
            return null
        }
    }
}