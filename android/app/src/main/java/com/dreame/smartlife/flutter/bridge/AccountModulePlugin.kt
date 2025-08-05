package com.dreame.smartlife.flutter.bridge

import android.content.Context
import android.dreame.module.GlobalMainScope
import android.dreame.module.LocalApplication
import android.dreame.module.RouteServiceProvider
import android.dreame.module.RouteServiceProvider.getService
import android.dreame.module.bean.OAuthBean
import android.dreame.module.bean.UserInfoBean
import android.dreame.module.data.store.AccountStore
import android.dreame.module.manager.AccountManager
import android.dreame.module.util.CacheUtil
import android.dreame.module.util.DeviceIdUtil
import android.dreame.module.util.GsonUtils
import android.dreame.module.util.LogUtil
import android.dreame.module.util.alify.AliAuthHelper
import android.dreame.module.util.privacy.PrivacyPolicyHelper
import com.dreame.module.service.app.ILogoutClearService
import com.dreame.module.service.app.flutter.IFlutterBridgeService
import com.dreame.smartlife.service.push.PushManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * 相关文档：https://wiki.dreame.tech/pages/viewpage.action?pageId=131991397
 */
class AccountModulePlugin(val context: Context) : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "invalidToken" -> {
                val account = AccountManager.getInstance().account
                account.access_token = "1234567890"
                AccountManager.getInstance().account = account
                result.success(null)
            }

            "getRefreshToken" -> {
                val account = AccountManager.getInstance().account
                result.success(account.refresh_token)
            }

            "getAuthBean" -> {
                result.success(GsonUtils.toJson(AccountManager.getInstance().account))
            }

            "getTenantId" -> {
                result.success(LocalApplication.getInstance().tenantId)
            }

            "refreshAuthBean" -> {
                val authJson = call.argument<String>("authBean") ?: ""
                AccountManager.getInstance().account =
                    GsonUtils.fromJson(authJson, OAuthBean::class.java)
                result.success(true)
            }

            "lastRefreshTime" -> {
                val lastRefreshTime = AccountManager.getInstance().lastRefreshTime
                result.success(lastRefreshTime)
            }

            "accountClear" -> {
                // refresh_token失效,退出登录
                AccountManager.getInstance().clear()
                result.success(true)
            }

            "prepareLogout" -> {
                // refresh_token失效,退出登录
                GlobalMainScope.launch {
                    try {
                        RouteServiceProvider.getService<ILogoutClearService>()?.prepareLogout()
                    } finally {
                        result.success(true)
                    }
                }
            }

            "saveUserInfo" -> {
                val authJson = call.argument<String>("params") ?: ""
                AccountManager.getInstance().userInfo =
                    GsonUtils.fromJson(authJson, UserInfoBean::class.java)
                result.success(true)
            }

            "getUserInfo" -> {
                val userInfo = AccountManager.getInstance().userInfo
                result.success(GsonUtils.toJson(userInfo))
            }

            "isAgreedProtocol" -> {
                val isFirstLogin = AccountManager.getInstance().isFirstLogin
                // 注意:isFirstLogin默认为true，因为已同意隐私为!isFirstLogin
                result.success(!isFirstLogin)
            }

            "agreeProtocol" -> {
                AccountManager.getInstance().putIsFirstLogin()
                result.success(true)
            }

            "savePasswordAccount" -> {
                val params = call.argument<String>("params") ?: ""
                AccountStore.loginAccount = params
                result.success(true)
            }

            "getPasswordAccount" -> {
                val loginAccount = AccountStore.loginAccount
                result.success(loginAccount)
            }

            "saveMobileAccount" -> {
                val params = call.argument<String>("params") ?: ""
                AccountStore.loginMobile = params
                result.success(true)
            }

            "getMobileAccount" -> {
                val loginMobile = AccountStore.loginMobile
                result.success(loginMobile)
            }

            "savePrivacyInfo" -> {
                val params = call.argument<String>("params") ?: ""
                PrivacyPolicyHelper.saveFlutterPrivacyMMkv(params)
                result.success(true)
            }

            "getPrivacyInfo" -> {
                val json = PrivacyPolicyHelper.getFlutterPrivacyMMkv()
                result.success(json)
            }

            "getPushToken" -> {
                PushManager.getDevicePushToken(LocalApplication.getInstance()) { token ->
                    LogUtil.i("AccountModulePlugin", "getPushToken: $token")
                    try {
                        val resultMap = mutableMapOf(
                            Pair("token", token?.token ?: ""),
                            Pair("tokenType", token?.tokenType ?: ""),
                            "deviceUUID" to DeviceIdUtil.getDeviceId(LocalApplication.getInstance())
                        )
                        val service = getService(IFlutterBridgeService::class.java)
                        if (service is IFlutterBridgeService) {
                            service.refreshPushToken(resultMap)
                        } else {
                            LogUtil.e("AccountModulePlugin", "getPushToken error: service is not IFlutterBridgeService")
                        }
                    } catch (e: Exception) {
                        LogUtil.e("AccountModulePlugin", "getPushToken error: $e")
                    }
                }
                result.success(emptyMap<String, String>())
            }

            "getLocalCacheSize" -> {
                result.success(CacheUtil.getAppCacheSize(context))
            }

            "doAlifyAuth" -> {
                AliAuthHelper.aliAuth({ needRestartApp ->
                    LogUtil.i("AccountModulePlugin", "auth success needRestartApp $needRestartApp")
                }) { code, error ->
                    LogUtil.i("AccountModulePlugin", "auth fail: $error -- $code")
                }
                result.success(null)
            }

            else -> {
                LogUtil.e("flutter method isnt implement: ${call.method}")
                if (call.method.startsWith("get")) {
                    result.success("")
                } else {
                    result.success(true)
                }
            }
        }
    }
}