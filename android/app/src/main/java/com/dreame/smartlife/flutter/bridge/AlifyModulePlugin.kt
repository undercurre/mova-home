package com.dreame.smartlife.flutter.bridge

import android.content.Context
import android.dreame.module.bean.DeviceListBean
import android.dreame.module.util.GsonUtils
import android.dreame.module.util.LogUtil
import android.dreame.module.util.alify.BindAliHelper
import android.text.TextUtils
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class AlifyModulePlugin(val context: Context) : MethodCallHandler {
    private val TAG = "AlifyModulePlugin"

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "checkAliDevice" -> {
                if (call.hasArgument("device")) {
                    val json = call.argument<String>("device")
                    val currentDevice = GsonUtils.fromJson<DeviceListBean.Device>(
                        json,
                        DeviceListBean.Device::class.java
                    )
                    if (currentDevice != null) {
                        if (TextUtils.isEmpty(currentDevice.iotId)) {
                            BindAliHelper.bindDevice(currentDevice,
                                { iotId ->
                                    result.success(mutableMapOf("code" to 0, "iotId" to iotId))
                                },
                                { err ->
                                    LogUtil.i(TAG, "flutter bindDevice fail $err")
                                    result.success(
                                        mutableMapOf(
                                            "code" to 102,
                                            "message" to "flutter bindDevice error: $err"
                                        )
                                    )
                                })
                        } else {
                            BindAliHelper.checkAliDeviceInfo(currentDevice, { iotId ->
                                result.success(mutableMapOf("code" to 0, "iotId" to iotId))
                            }, { err ->
                                LogUtil.i(TAG, "flutter checkAliDeviceInfo fail $err")
                                result.success(
                                    mutableMapOf(
                                        "code" to 103,
                                        "message" to "flutter checkAliDeviceInfo fail, message: $err"
                                    )
                                )
                            })
                        }
                    }
                } else {
                    result.success(mutableMapOf("code" to 101, "message" to "device is null"))
                }
            }

            else -> {
                result.success(true)
            }
        }
    }
}