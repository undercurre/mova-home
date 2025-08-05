package android.dreame.module.rn.bridge.system

import android.dreame.module.R
import android.os.Handler
import android.os.Looper
import androidx.appcompat.app.AppCompatActivity
import com.dreame.sdk.biometric.BIO_CODE_UNSUPPORTED
import com.dreame.sdk.biometric.BiometricConfig
import com.dreame.sdk.biometric.BiometricSdk
import com.facebook.react.bridge.Callback
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap

class SecretModule(val context: ReactApplicationContext) : ReactContextBaseJavaModule(context) {
    private val uiHandler = Handler(Looper.getMainLooper())

    override fun getName(): String = "Secret"

    @ReactMethod
    fun isBiometricSupported(promise: Promise) {
        promise.resolve(BiometricSdk.isSupportBiometric(context))
    }

    @ReactMethod
    fun disableBiometric(key: String, promise: Promise) {
        promise.resolve(BiometricSdk.disableBiometric(context, key))
    }

    @ReactMethod
    fun isEnableBiometric(key: String, promise: Promise) {
        promise.resolve(BiometricSdk.isEnableBiometric(context, key))
    }

    @ReactMethod
    fun encryptDataWithBiometric(
        key: String,
        value: String,
        config: ReadableMap,
        callback: Callback
    ) {
        if (currentActivity == null) {
            callback.invoke(false, BIO_CODE_UNSUPPORTED)
        } else {
            uiHandler.post {
                BiometricSdk.enableBiometric(
                    currentActivity as AppCompatActivity,
                    key,
                    value,
                    BiometricConfig(
                        config.getString("title") ?: " MOVAhome",
                        config.getString("negativeButtonText")
                            ?: (currentActivity as AppCompatActivity).getString(R.string.cancel),
                        if (config.hasKey("confirmationRequired")) config.getBoolean("confirmationRequired") else false,
                        if (config.hasKey("subtitle")) config.getString("subtitle") ?: "" else "",
                        if (config.hasKey("description")) config.getString("description")
                            ?: "" else ""
                    ), { callback.invoke(true) }, { callback.invoke(false, it) }
                )
            }
        }
    }

    @ReactMethod
    fun decryptDataWithBiometric(key: String, config: ReadableMap, callback: Callback) {
        if (currentActivity == null) {
            callback.invoke(false, BIO_CODE_UNSUPPORTED)
        } else {
            uiHandler.post {
                BiometricSdk.checkBiometric(currentActivity as AppCompatActivity, key,
                    BiometricConfig(
                        config.getString("title") ?: " MOVAhome",
                        config.getString("negativeButtonText")
                            ?: (currentActivity as AppCompatActivity).getString(R.string.cancel),
                        if (config.hasKey("confirmationRequired")) config.getBoolean("confirmationRequired") else false,
                        if (config.hasKey("subtitle")) config.getString("subtitle") ?: "" else "",
                        if (config.hasKey("description")) config.getString("description")
                            ?: "" else ""
                    ), { callback.invoke(true) }, { callback.invoke(false, it) })
            }
        }
    }

}