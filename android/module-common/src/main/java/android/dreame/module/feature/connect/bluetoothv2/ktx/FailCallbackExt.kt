package android.dreame.module.feature.connect.bluetoothv2.ktx

import no.nordicsemi.android.ble.callback.FailCallback

object FailCallbackStatus {

    fun failException2String(status: Int): String {
        return when (status) {
            FailCallback.REASON_DEVICE_DISCONNECTED
                -> "device disconnected"

            FailCallback.REASON_DEVICE_NOT_SUPPORTED
                -> "Device not supported"

            FailCallback.REASON_NULL_ATTRIBUTE
                -> "null attribute"

            FailCallback.REASON_REQUEST_FAILED
                -> "Request failed"

            FailCallback.REASON_TIMEOUT
                -> "timeout"

            FailCallback.REASON_VALIDATION

                -> "validation"

            FailCallback.REASON_CANCELLED
                -> "cancelled"

            FailCallback.REASON_NOT_ENABLED
                -> "not enabled"

            FailCallback.REASON_BLUETOOTH_DISABLED
                -> "bluetooth disabled"

            else -> "other status: $status"
        }
    }

    fun failException(status: Int): Exception {
        return when (status) {
            FailCallback.REASON_DEVICE_DISCONNECTED
                -> Exception("Device disconnected")

            FailCallback.REASON_DEVICE_NOT_SUPPORTED
                -> Exception("Device not supported")

            FailCallback.REASON_NULL_ATTRIBUTE
                -> Exception("null attribute")

            FailCallback.REASON_REQUEST_FAILED
                -> Exception("Request failed")

            FailCallback.REASON_TIMEOUT
                -> Exception("timeout")

            FailCallback.REASON_VALIDATION

                -> Exception("validation")

            FailCallback.REASON_CANCELLED
                -> Exception("cancelled")

            FailCallback.REASON_NOT_ENABLED
                -> Exception("not enabled")

            FailCallback.REASON_BLUETOOTH_DISABLED
                -> Exception("bluetooth disabled")

            else -> Exception("other $status")
        }
    }
}
