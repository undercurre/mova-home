package com.dreame.smartlife.flutter.bridge

import android.content.res.Configuration
import android.dreame.module.GlobalMainScope
import android.dreame.module.LocalApplication
import android.dreame.module.RouteServiceProvider
import android.dreame.module.bean.CountryBean
import android.dreame.module.bean.LanguageBean
import android.dreame.module.manager.AreaManager
import android.dreame.module.manager.LanguageManager
import android.dreame.module.util.DarkThemeUtils
import android.dreame.module.util.GsonUtils
import com.dreame.module.service.app.flutter.IFlutterBridgeService
import com.dreame.module.service.reactnative.RnPluginService
import com.dreame.movahome.flutter.FlutterPluginActivity
import com.dreame.smartlife.help.CustomerServiceManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.TimeZone

/**
 * 相关文档：https://wiki.dreame.tech/pages/viewpage.action?pageId=131991397
 */
class LocalModulePlugin(val context: FlutterPluginActivity) : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getLangTagCode" -> {
                val pair = LanguageManager.getInstance().getLangTagWithCountyCode(context)
                val resultMap: MutableMap<String, String> = HashMap()
                resultMap["languageCode"] = pair.first
                resultMap["countryCode"] = pair.second
                result.success(resultMap)
            }

            "getLangTag" -> {
                val langTag = LanguageManager.getInstance().getLangTag(context)
                result.success(langTag)
            }

            "setLangTag" -> {
                val language = call.arguments as HashMap<*, *>
                val json = GsonUtils.toJson(language)
                val languageBean = GsonUtils.fromJson<LanguageBean>(json, LanguageBean::class.java)
                if (languageBean.langTag == "zh-TW" || languageBean.langTag == "zh-HK") {
                    languageBean.langTag = "zh"
                }
                LanguageManager.getInstance().setLanguage(languageBean)
                result.success(true)
            }

            "getCurrentCountry" -> {
                val currentCountry = AreaManager.getCurrentCountry()
                result.success(GsonUtils.toJson(currentCountry))
            }

            "setCurrentCountry" -> {
                val jsonMap = call.arguments as Map<*, *>
                val jsonStr = GsonUtils.toJson(jsonMap)
                val bean = GsonUtils.fromJson<CountryBean>(jsonStr, CountryBean::class.java)
                AreaManager.setCurrentCountry(bean)
                result.success(true)
            }

            "getTimeZone" -> {
                val timeZone = TimeZone.getDefault().id
                result.success(timeZone)
            }

            "setAppTheme" -> {
                val darkTheme = call.arguments<String>()
                val model = when (darkTheme) {
                    "system" -> 0
                    "light" -> Configuration.UI_MODE_NIGHT_NO
                    "dark" -> Configuration.UI_MODE_NIGHT_YES
                    else -> -Configuration.UI_MODE_NIGHT_NO
                }
                DarkThemeUtils.setApplicationDarkThemeStyle(model)
                /// 清理缓存中的RN bundle
                RouteServiceProvider.getService<RnPluginService>()?.clearAllRnCache()
                result.success(true)
            }

            else -> {
                result.success(true)
            }
        }
    }

}