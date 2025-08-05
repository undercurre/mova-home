package android.dreame.module.feature.connect.bluetoothv2

import android.bluetooth.BluetoothDevice
import android.dreame.module.util.LogUtil

object MyBleConnectStateManager {
    private val btDeviceMap = HashMap<String, BluetoothDevice>()
    private val btManagerImplMap = HashMap<String, BleManagerImpl>()

    fun pushBtDevice(device: BluetoothDevice) {
        btDeviceMap[device.address] = device
    }

    fun removeBtDevice(mac: String) {
        btDeviceMap.remove(mac)
    }

    fun pushBleManager(mac: String, device: BleManagerImpl) {
        btManagerImplMap[mac] = device
    }

    fun removeBleManager(mac: String) {
        btManagerImplMap.remove(mac)
        removeBtDevice(mac)
    }

    fun getBleManager(mac: String) = btManagerImplMap.get(mac)


    fun disconnectAndCloseAll() {
        btManagerImplMap.values.onEach {
            LogUtil.d("------MyBleConnectStateManager disconnectAndCloseAll-----${it.bluetoothDevice?.address}")
            it.realDisconnectDevice(it.bluetoothDevice?.address ?: "", dispose = true)
        }
        btManagerImplMap.clear()
        btDeviceMap.clear()
    }
}
