package android.dreame.module.rn.bridge.video

import android.dreame.module.rn.load.RnLoaderCache
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.util.LogUtil
import android.dreame.module.util.alify.BindAliHelper
import android.text.TextUtils
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod

class AliCheckModule(val context: ReactApplicationContext) : ReactContextBaseJavaModule(context) {

    val TAG = "AliCheckModule"

    override fun getName() = "AliCheckModule"

    @ReactMethod
    fun checkAliDevice(promise: Promise) {
        val currentDevice = RnLoaderCache.getCurrentDevice(context)
        if (currentDevice != null) {
            if (TextUtils.isEmpty(currentDevice.iotId)) {
                BindAliHelper.bindDevice(currentDevice,
                    { iotId ->
                        LogUtil.i(TAG, "plugin bindDevice success $iotId")
                        currentDevice.iotId = iotId
                        promise.resolve(packageParams(iotId))
                    },
                    { err ->
                        LogUtil.i(TAG, "plugin bindDevice error: $err")
                        EventCommonHelper.eventCommonPageInsert(
                            102,
                            4,
                            0,
                            "", "",
                            str1 = "plugin bindDevice error: $err"
                        )
                        promise.reject(Exception("plugin bindDevice error: $err"))
                    })
            } else {
                BindAliHelper.checkAliDeviceInfo(currentDevice, { iotId ->
                    currentDevice.iotId = iotId
                    promise.resolve(packageParams(iotId))
                }, { err ->
                    LogUtil.i(TAG, "plugin checkAliDeviceInfo error $err")
                    EventCommonHelper.eventCommonPageInsert(
                        102,
                        4,
                        0,
                        "", "",
                        str1 = "plugin checkAliDeviceInfo error $err"
                    )
                    promise.reject(Exception("plugin checkAliDeviceInfo error: $err"))
                })
            }
        } else {
            promise.resolve(packageParams(""))
        }
    }

    private fun packageParams(iotId: String) = Arguments.createMap().apply {
        putString("iotId", iotId)
    }

}