package com.dreame.smartlife.flutter.bridge

import android.content.Context
import android.dreame.module.LocalApplication
import android.dreame.module.constant.Constants
import android.dreame.module.rn.utils.Host
import android.dreame.module.task.RetrofitInitTask
import android.dreame.module.util.AppUtils
import android.dreame.module.util.CheckRootUtil
import com.blankj.utilcode.util.NetworkUtils
import com.dreame.hacklibrary.HackJniHelper
import com.tencent.mm.opensdk.openapi.IWXAPI
import com.tencent.mm.opensdk.openapi.WXAPIFactory
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

/**
 * 相关文档：https://wiki.dreame.tech/pages/viewpage.action?pageId=131991397
 */
class InfoModulePlugin(val context: Context) : MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "signPassword" -> {
                val content = call.argument<String>("content") ?: ""
                result.success(HackJniHelper.signPassword(content))
            }

            "envType" -> {
                result.success(Host.getEnv())
            }

            "getCurrentHost" -> {
                result.success(RetrofitInitTask.getBaseUrl())
            }

            "getWebHost" -> {
                result.success(RetrofitInitTask.getAppPrivacyBaseUrl())
            }

            "isGpVersion" -> {
                result.success(LocalApplication.getInstance().isGpVersion)
            }

            "installApk" -> {
                val apkPath = call.argument<String>("apkPath") ?: ""
                result.success(AppUtils.installApk(context, apkPath))
            }

            "isWifiConnected" -> {
                result.success(NetworkUtils.isWifiConnected())
            }

            "isRooted" -> {
                result.success(CheckRootUtil.isRooted(context))
            }

            "isAppInstalled" -> {
                val packageName = call.arguments as String? ?: ""
                if (packageName == "wechat") {
                    val api: IWXAPI = WXAPIFactory.createWXAPI(context, Constants.WECHAT_APP_ID)
                    result.success(api.isWXAppInstalled)
                }
                result.success(false)
            }

            else -> {
                result.success(true)
            }
        }
    }
}