package com.dreame.smartlife.flutter.bridge

import android.app.Activity
import android.dreame.module.LocalApplication
import android.dreame.module.constant.Constants
import android.dreame.module.manager.AccountManager
import android.dreame.module.manager.LanguageManager
import android.dreame.module.util.DarkThemeUtils
import android.dreame.module.util.DeviceIdUtil
import android.dreame.module.util.LogUtil
import android.dreame.module.util.SPUtil
import android.os.Build
import com.blankj.utilcode.util.EncodeUtils
import com.blankj.utilcode.util.EncryptUtils
import com.dreame.smartlife.service.push.PushManager
import com.google.firebase.analytics.FirebaseAnalytics
import com.tencent.bugly.crashreport.CrashReport
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * 相关文档：https://wiki.dreame.tech/pages/viewpage.action?pageId=131991397
 */
class FeatureModulePlugin(val activity: Activity) : MethodChannel.MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "initSomeSdkAfterAgreePrivacy" -> {
                //初始化 sdk
                LocalApplication.getInstance().initSomeSdkAfterAgreePrivacy()
                PushManager.initPush(activity, emptyMap())
                result.success(true)
            }

            "updateWorkStatusPath" -> {
                //vacuum
                //hold
                val model = call.argument<String>("model") ?: ""
                val filePath = call.argument<String>("filePath") ?: ""
                SPUtil.put(activity, "status_path", model, filePath)
                result.success(true)
            }

            "initHomeConfig" -> {
                initCrashSDKConfig()
                /**
                 *  该方法是推送平台多维度推送决策必调用的方法，请务必调用
                 *  需在用户同意隐私政策协议之后调用，否则会出现合规问题
                 */
                PushManager.onPageStart(activity, emptyMap())
                result.success(true)
            }

            "getThemeMode" -> {
                val context = LanguageManager.getInstance().setLocal(activity)
                val settingString = DarkThemeUtils.getThemeSettingString(context)
                LogUtil.i("sunzhibin getThemeMode: $settingString")
                result.success(settingString)
            }

            else -> {
                result.success(true)
            }
        }
    }

    /**
     * 初始化bugly、firebase sdk用户信息
     */
    private fun initCrashSDKConfig() {
        val uid = AccountManager.getInstance().account.uid ?: ""
        val encryptUid =
            EncodeUtils.base64Encode2String("${uid}_${Constants.UID_ENCRYPT_KEY}".toByteArray())
        CrashReport.setUserId(activity, encryptUid)
        CrashReport.setDeviceModel(activity, Build.MODEL + "_" + Build.BRAND)
        CrashReport.setDeviceId(
            activity,
            EncryptUtils.encryptMD5ToString(DeviceIdUtil.getDeviceId(activity))
        )
        if (LocalApplication.getInstance().isGpVersion) {
            FirebaseAnalytics.getInstance(activity).setUserId(encryptUid)
        }
    }

}