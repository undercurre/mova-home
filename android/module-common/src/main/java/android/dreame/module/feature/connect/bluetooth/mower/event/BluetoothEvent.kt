package android.dreame.module.feature.connect.bluetooth.mower.event

/**
 * [https://github.com/MiEcosystem/miot-plugin-sdk/blob/master/miot-sdk/device/bluetooth/BluetoothDevice.js]
 */
object BluetoothEvent {
    const val BLUETOOTH_CONNECTION_STOP_SCAN = "bluetoothStopScan"
    const val BLUETOOTH_CONNECTION_STATUS_CHANGED = "bluetoothConnectionStatusChanged"

    const val BLUETOOTH_DEVICE_DISCOVERED = "bluetoothDeviceDiscovered"
    const val BLUETOOTH_DEVICE_DISCOVER_FAILED = "bluetoothDeviceDiscoverFailed"

    const val BLUETOOTH_SEVICE_DISCOVERED = "bluetoothSeviceDiscovered"
    const val BLUETOOTH_SEVICE_DISCOVER_FAILED = "bluetoothSeviceDiscoverFailed"

    const val BLUETOOTH_CHARACTERISTIC_DISCOVERED = "bluetoothCharacteristicDiscovered"
    const val BLUETOOTH_CHARACTERISTIC_DISCOVER_FAILED = "bluetoothCharacteristicDiscoverFailed"
    const val BLUETOOTH_CHARACTERISTIC_VALUE_CHANGED = "bluetoothCharacteristicValueChanged"

    const val BLUETOOTH_STATUS_CHANGED = "bluetoothStatusChanged"
}

object ErrorType {
    // 成功
    const val CONNECT_SUCCESS = 0

    // 请求失败
    const val CONNECT_ERROR = -1

    // 请求取消
    const val CONNECT_CANCEL = -2

    // 参数异常
    const val CONNECT_PARAM_ERROR = -3

    // 蓝牙不支持
    const val CONNECT_BLE_NOT_SUPPORT = -4

    // 蓝牙已关闭
    const val CONNECT_BLE_CLOSE = -5

    // 连接不可用
    const val CONNECT_UNAVAILABLE = -6

    // 超时
    const val CONNECT_TIMEOUT = -7

    // token失效
    const val CONNECT_TOKEN_INVILID = -10

    // 请求过于频繁
    const val CONNECT_REQUEST_TOO_FREQUENT = -11

    // 配置未准备
    const val CONNECT_CONFIGURATION_NOT_READY = -12

    // 请求中
    const val CONNECT_REQUEST_ING = -13

    // 请求被拒绝
    const val CONNECT_REQUEST_DENIED = -14

    // 未知异常
    const val CONNECT_UNKNOWN = -15

}