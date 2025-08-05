package android.mova.module.ui

import android.content.Intent
import android.dreame.module.R
import android.dreame.module.RoutPath
import android.dreame.module.RouteServiceProvider
import android.dreame.module.manager.AccountManager
import android.dreame.module.util.EscapeUtil
import android.dreame.module.util.GsonUtils
import android.dreame.module.util.LogUtil
import android.net.Uri
import android.os.Bundle
import android.util.Base64
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import com.therouter.TheRouter
import com.dreame.module.service.app.flutter.IFlutterBridgeService
import org.json.JSONObject

/**
 * 页面跳转 Scheme 类型枚举
 */
enum class SchemeType(val value: String) {
    DEVICE("DEVICE"),
    WEB("WEB"),
    WEB_EXTERNAL("WEB_EXTERNAL"),
    MALL("MALL"),
    VIP("VIP"),
    WX_APPLET("WX_APPLET"),
    APP("APP"),
    HOME_TAB("HOME_TAB"),
    APP_LOGIN("APP_LOGIN"),
    ALEXA_AUTH("ALEXA_AUTH"),
    SPLASH_AD("SPLASH_AD"),
    COMMUNITY("COMMUNITY"),
    NFC("NFC");
}


/**
 * 路由处理页面
 * 文档 https://wiki.dreame.tech/pages/viewpage.action?pageId=88556360
 * 1. 账号有效 path
 * 1) open 跳转首页-首页打开对应页面
 * 2) auth 授权
 * 3）其他 直接打开路由页面
 * 2. 账号无效 登录页
 */
class SchemeHandleActivity : AppCompatActivity() {

    private val TAG = "SchemeHandleActivity"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.i(TAG, "onCreate: ")
        handleSchemeEvent()
    }

    override fun onNewIntent(intent: Intent?) {
        Log.i(TAG, "onNewIntent: ")
        super.onNewIntent(intent)
    }

    private fun handleSchemeEvent() {
        if (handleAlexaScheme()) {
            finish()
            return
        }
        if (handlePairNetScheme()) {
            finish()
            return
        }
        intent.data?.let { uri ->
            LogUtil.i(TAG, "handleSchemeEvent: $uri")
            val ext = uri.getQueryParameter("ext")
            val path = uri.lastPathSegment
            val msgCategory = intent.getStringExtra("msg_category")
            LogUtil.d(TAG, "handleSchemeEvent ext : $ext,path:$path")
            var extObj: JSONObject? = null
            var realExt = ""
            try {
                val unescapeExt = EscapeUtil.safeUnescape(ext)
                LogUtil.d(TAG, "handleSchemeEvent unescapeScheme: $unescapeExt")
                realExt = String(Base64.decode(unescapeExt, Base64.DEFAULT))
                LogUtil.i(TAG, "handleSchemeEvent realExt: $realExt")
                extObj = JSONObject(realExt)
            } catch (e: Exception) {
                LogUtil.e("handleSchemeEvent parse error: $e")
                e.printStackTrace()
            }
            if (AccountManager.getInstance().isAccountValid) {
                val intent = RouteServiceProvider.getService<IFlutterBridgeService>()
                    ?.openMainFlutter(
                        this,
                        "/root",
                        mutableMapOf("schemeType" to (path ?: ""), "ext" to realExt)
                    )
                Log.i(TAG, "handleSchemeEvent:  startActivity")
                startActivity(intent)
                RouteServiceProvider.getService<IFlutterBridgeService>()
                    ?.sendSchemeEvent(path ?: "", realExt)
            } else {
                TheRouter.build(RoutPath.SPLASH_PAGE)
                    .withFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                    .navigation()
            }
        }
        overridePendingTransition(R.anim.fade_in, R.anim.fade_out)
        finish()
    }

    private fun handlePairNetScheme(): Boolean {
        intent?.let {
            val appLinkData: Uri? = it.data
            val code = appLinkData?.getQueryParameter("m")
            val state = appLinkData?.getQueryParameter("model")
            if (code?.isNotBlank() == true && state?.isNotBlank() == true) {
                LogUtil.d(TAG, "onNewIntent: $code,$state")
                /// 跳转 alexa
                TheRouter.build(RoutPath.SPLASH_PAGE).navigation()
                return true
            }
        }
        return false
    }

    // alexa授权
    // https://app.mova-tech.com/?client_id=alexa_mova&response_type=code&scope=open&redirect_uri=https://pitangui.amazon.com/api/skill/link/M2KCHL8Q16NVQ5&state=AmaseyJ2YWxpZGF0aW9uQ29kZSI6IjRjVnNRK3lRNkRJUXk3Y2pvV0RiRzMraThhVVp1TDYvMXRDT0ZUaVIxdWc9IiwiZGlyZWN0ZWRJZCI6ImFtem4xLmFjY291bnQuQUhRM0wyQUg0V1ozN00yUkRSWE5WVFIzM0JYQSIsInBhcnRuZXJJZCI6IkExazlkU0cxTWQ0S015Tk9TdWlCZFJBakYiLCJhcHBsaWNhdGlvbkRvbWFpbiI6IkFMRVhBX1NLSUxMUyIsImFwcGxpY2F0aW9uRG9tYWlucyI6WyJBTEVYQV9TS0lMTFMiLCJBTEVYQV9DT0hPIl0sImV4cGlyYXRpb25UaW1lSW5NaWxsaXMiOjE3MzIwNzQ4MDE2MTMsInVzZXJTdGF0ZSI6W3siayI6InJlcXVlc3RSZWFsbSIsInYiOiJ1cy1lYXN0LTEifSx7ImsiOiJza2lsbElkIiwidiI6ImFtem4xLmFzay5za2lsbC5kNzNiMmZiNi02NTRhLTQ4ZTMtYWViMS1iYjJmMDZmMzE4OWUifSx7ImsiOiJjc3JmVG9rZW4iLCJ2IjoiMTY3NTA0NjM0MiJ9LHsiayI6InJlcXVlc3RJbmdyZXNzIiwidiI6ImRwIn0seyJrIjoiY3VzdG9tZXJJZCIsInYiOiJBMkJMM0hISEo2MVJOUSJ9LHsiayI6InJlcXVlc3REZXZpY2VGYW1pbHkiLCJ2IjoiQ29tcEFwcEFuZHJvaWQifSx7ImsiOiJyZXF1ZXN0U3RhZ2UiLCJ2IjoicHJvZCJ9LHsiayI6InNraWxsU3RhZ2UiLCJ2IjoiZGV2ZWxvcG1lbnQifSx7ImsiOiJyZXF1ZXN0U3RhcnRUaW1lIiwidiI6IjE3MzIwNzEyMDE1OTAifV0sImRpcmVjdGVkSWRUeXBlIjoiT0JGVVNDQVRFRF9DVVNUT01FUl9JRCIsImdyYW50ZWRTY29wZXNJbmNsdWRlZCI6ZmFsc2V9BBBBBBBBAAAAAAAAAAD2MWALFweHYTPhkbWEHleAIQAAAAAAAACIs7uSrHwKCk5gsOCWNCG1XgjuKLWobFk2U65s74Hc7bI=
    private fun handleAlexaScheme(): Boolean {
        intent?.let {
            val appLinkAction = it.action
            val appLinkData: Uri? = it.data
            if (Intent.ACTION_VIEW == appLinkAction) {
                val code = appLinkData?.getQueryParameter("code")
                val state = appLinkData?.getQueryParameter("state")
                // 绑定技能
                if (code?.isNotBlank() == true && state?.isNotBlank() == true) {
                    LogUtil.d(TAG, "onNewIntent: $code,$state")
                    /// 跳转 alexa
                    val newIntent = TheRouter.build(RoutPath.VOICE_CONTROL_ALEXA)
                        .withParcelable("alexaUri", appLinkData)
                        .createIntent(this)
                    newIntent.action = it.action
                    startActivity(newIntent)
                    return true
                }

                // 授权

                val clientId = appLinkData?.getQueryParameter("client_id")
                val responseType = appLinkData?.getQueryParameter("response_type")
//                val state = appLinkData?.getQueryParameter("state")
                val scope = appLinkData?.getQueryParameter("scope")
                val redirectUri = appLinkData?.getQueryParameter("redirect_uri")
                if (clientId?.isNotBlank() == true && responseType?.isNotBlank() == true && state?.isNotBlank() == true) {
                    LogUtil.i(TAG, "onNewIntent: $clientId,$responseType,$state,$scope,$redirectUri")
                    val schemeType = "ALEXA_AUTH"
                    val extra = GsonUtils.toJson(
                        mapOf(
                            "client_id" to clientId,
                            "response_type" to responseType,
                            "state" to state,
                            "scope" to scope,
                            "redirect_uri" to redirectUri
                        )
                    )
                    // 启动进程
                    val intent = RouteServiceProvider.getService<IFlutterBridgeService>()
                        ?.openMainFlutter(
                            this,
                            "/root",
                            mutableMapOf("schemeType" to schemeType, "ext" to extra)
                        )
                    startActivity(intent)
                    // 跳转 alexa
                    RouteServiceProvider.getService<IFlutterBridgeService>()
                        ?.sendSchemeEvent(
                            schemeType,
                            extra
                        )
                    return true
                }
            }
        }
        return false
    }
}