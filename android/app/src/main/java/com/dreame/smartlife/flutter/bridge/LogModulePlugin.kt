package com.dreame.smartlife.flutter.bridge

import android.content.Context
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.util.LogUtil
import android.dreame.module.util.log.LogUploadServer
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/**
 * 相关文档：https://wiki.dreame.tech/pages/viewpage.action?pageId=131991397
 */
class LogModulePlugin(val context: Context) : MethodChannel.MethodCallHandler {
    val TAG = "Flutter"
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "log" -> {
                val level = call.argument<String>("level") ?: ""
                val message = call.argument<String>("message") ?: ""
                val stackTrace = call.argument<String>("stackTrace") ?: ""
                when (level) {
                    "info" -> {
                        LogUtil.i(TAG, "message: $message, stackTrace: $stackTrace")
                    }

                    "error" -> {
                        LogUtil.e(TAG, "message: $message, stackTrace: $stackTrace")
                    }

                    "verbose" -> {
                        LogUtil.v(TAG, "message: $message, stackTrace: $stackTrace")
                    }

                    "debug" -> {
                        LogUtil.d(TAG, "message: $message, stackTrace: $stackTrace")
                    }

                    "warn" -> {
                        LogUtil.w(TAG, "message: $message, stackTrace: $stackTrace")
                    }

                    "wtf" -> {
                        LogUtil.wtf(TAG, "message: $message, stackTrace: $stackTrace")
                    }

                    else -> {
                        LogUtil.d(TAG, "message: $message, stackTrace: $stackTrace")
                    }
                }
                result.success(null)
            }

            "close" -> {
                LogUtil.close()
                result.success(null)
            }

            "uploadLog" -> {
                MainScope().launch {
                    runCatching {
                        val msgId = call.argument<String>("msgId") ?: ""
                        withContext(Dispatchers.IO) {
                            LogUploadServer.uploadAppLocalLog("0", msgId)
                        }
                    }.onFailure {
                        LogUtil.e(TAG, "uploadLog error: ${it.message}")
                    }
                }
                result.success(true)
            }
            else -> result.success(false)
        }
    }

}