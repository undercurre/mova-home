package android.dreame.module.feature.connect.bluetooth.mower

import com.facebook.react.bridge.Callback

class BleOperatorRnCallback(val rnCallback: Callback) {
    // 是否有效
    @Volatile
    private var isValid = true
    fun onSuccess(obj: Any) {
        if (isValid) {
            isValid = false
//            LogUtil.d("--- BleOperatorRnCallback onSuccess ---- ${rnCallback.hashCode()}")
            rnCallback.invoke(obj)
        }
    }

    fun onFailed(code: Int, msg: String) {
        if (isValid) {
            isValid = false
//            LogUtil.d("--- BleOperatorRnCallback onFailed -1--- ${rnCallback.hashCode()}")
            rnCallback.invoke(false, "$code, $msg")
        }
    }

    fun onFailed(msg: String) {
        if (isValid) {
            isValid = false
//            LogUtil.d("--- BleOperatorRnCallback onFailed -2--- ${rnCallback.hashCode()}")
            rnCallback.invoke(false, msg)
        }
    }

    fun successWithArgs(vararg args: Any) {
        if (isValid) {
            isValid = false
            rnCallback.invoke(args)
        }
    }

    fun failedWithArgs(vararg args: Any) {
        if (isValid) {
            isValid = false
            rnCallback.invoke(args)
        }
    }

}