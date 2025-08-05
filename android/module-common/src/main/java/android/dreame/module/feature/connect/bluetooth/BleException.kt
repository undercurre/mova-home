package android.dreame.module.feature.connect.bluetooth


internal const val ERROR_CODE_TIMEOUT = 1000
internal const val ERROR_CODE_GATT = 1001
internal const val ERROR_CODE_OTHER = 1002
internal const val ERROR_CODE_CONNECT = 1003

/**
 * 异常类
 */
open class BleException(val code: Int, val description: String)
class BleConnectException(status: Int = ERROR_CODE_CONNECT, description: String = "GATT connect exception occurred!") :
    BleException(status, description)

class BleOtherException(status: Int = ERROR_CODE_OTHER, description: String) : BleException(status, description)
class BleTimeoutException(description: String = "Timeout Exception Occurred!") : BleException(ERROR_CODE_TIMEOUT, description)
class BleGattException(val gattStatus: Int = ERROR_CODE_GATT, description: String = "GATT operator exception Occurred!") :
    BleException(gattStatus, description)

/**
 * 状态参数类
 */
internal data class BleStateParameter(val mac: String, val status: Int)

/**
 * 连接状态
 */
internal enum class LastState {
    CONNECT_IDLE, CONNECT_CONNECTING, CONNECT_CONNECTED, CONNECT_FAILURE, CONNECT_DISCONNECT,
    DISCOVER_SERVICE_IDLE, DISCOVER_SERVICE_ING, DISCOVER_SERVICE_SUCCESS, DISCOVER_SERVICE_FAILURE,
}