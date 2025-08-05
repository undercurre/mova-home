package com.dreame.module.mall.service

import android.content.Context
import android.dreame.module.GlobalMainScope
import android.dreame.module.LocalApplication
import android.dreame.module.RoutPath
import android.dreame.module.constant.Constants
import android.dreame.module.util.LogUtil
import android.dreame.module.util.ScreenUtils
import android.dreame.module.util.StatusBarUtil
import android.util.Log
import androidx.lifecycle.LiveData
import com.therouter.router.Route
import com.therouter.TheRouter
import com.dreame.module.mall.uniapp.UniAppInfoCacheManager
import com.dreame.module.mall.uniapp.UniAppUpgradeManager
import com.dreame.module.service.app.flutter.IFlutterBridgeService
import com.dreame.module.service.mall.IMallService
import com.dreame.module.service.mall.MallServiceExport
import com.google.gson.JsonElement
import com.google.gson.JsonObject
import com.google.gson.JsonParser

@Route(path = RoutPath.MALL_SERVICE)
class MallServiceImpl : IMallService {

    private val TAG = MallServiceImpl::class.java.simpleName
    private val helper by lazy { MallServiceHelper() }

    override fun openShopPage(path: String, params: String?, event: String?, force: Boolean) {
        val pair = mallLoginInfo()
        val sessionId = pair.first
        val userId = pair.second
        LogUtil.d(
            "UNIAPP",
            "openShopPage: $path, params: $params ,sessionId: $sessionId ,userId: $userId"
        )
        if (event != null && event.equals(MallServiceExport.H5_EVENT_OPEN_WX_WEBVIEW)) {
            TheRouter.build(RoutPath.MALL_PAY_WEBVIEW)
                .withString("event", event)
                .withString(Constants.KEY_WEB_URL, path)
                .withBoolean(Constants.KEY_WEB_HIDE_TITLE, true)
                .navigation()
        } else if (event != null && event.equals(MallServiceExport.H5_EVENT_OPEN_OUTER_WEBVIEW)) {
            TheRouter.build(RoutPath.MAIN_WEBVIEW)
                .withString("event", event)
                .withString(Constants.KEY_WEB_URL, path)
                .withBoolean(Constants.KEY_WEB_HIDE_TITLE, false)
                .navigation()
        } else {
            GlobalMainScope.launch {
                if(path.startsWith("http")){
                    startFlutterWebView(path, sessionId, userId, params, path, event)
                }else{
                    (TheRouter.build(RoutPath.APP_FLUTTER_BRIDGE_SERVICE)
                        .navigation() as IFlutterBridgeService).getCommonPlugin(
                        "mall"
                    ) {
                        startFlutterWebView(it, sessionId, userId, params, path, event)
                    }
                }
            }
        }
    }

    private fun startFlutterWebView(
        it: String,
        sessionId: String,
        userId: String,
        params: String?,
        path: String,
        event: String?
    ) {
        val statusBarHeightPx =
            StatusBarUtil.getStatusBarHeight(LocalApplication.getInstance())
        val statusBarHeight = ScreenUtils.px2dp(
            LocalApplication.getInstance(),
            statusBarHeightPx.toFloat()
        ).toInt()
        val h5Path = it
        val stringBuffer = StringBuffer(h5Path)
        if(h5Path.contains("dreame.tech") || !h5Path.startsWith("http")){
            stringBuffer.append("?sessid=")
                .append(sessionId)
                .append("&user_id=")
                .append(userId)
                .append("&statusBarHeight=")
                .append(statusBarHeight)
        }
        params?.let {
            val element = JsonParser.parseString(params)
            val map = parseParams(element)
            map.entries.forEach { entry ->
                stringBuffer.append("&${entry.key}=${entry.value}")
            }
        }
        stringBuffer.append("#$path")
        val newUrl = stringBuffer.toString()
        TheRouter.build(RoutPath.MALL_WEBVIEW)
            .withString("event", event)
            .withString(Constants.KEY_WEB_URL, newUrl)
            .withBoolean(Constants.KEY_WEB_HIDE_TITLE, true)
            .navigation()
    }

    override suspend fun mallLoginSync(): String {
        return helper.mallLoginSync()
    }

    override fun mallInfoLiveData(): LiveData<*> {
        return helper.liveData
    }

    override fun mallPersonInfo() {
        helper.mallPersonInfo()
    }

    override suspend fun queryMallPersonInfo(): Map<String, String> {
        return helper.queryMallPersonInfo()
    }

    override fun composeJson(): String {
        return helper.composeJson()
    }

    override fun mallLoginInfo(): Pair<String, String> {
        return helper.liveData.value?.let {
            it.sessionId to it.userId
        } ?: ("" to "")
    }

    override fun needReloadNewMallUrl(url: String, newUrl: String): Boolean {
        return url.substring(0, url.indexOf("?")) != newUrl.substring(0, newUrl.indexOf("?"))
    }

    override fun init(context: Context?) {
        Log.d(TAG, "init MallService: $context")
    }


    override fun clearUniappCache() {
        try {
            UniAppInfoCacheManager.clearAll()
            UniAppInfoCacheManager.clearMallInfo()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    override fun checkUniappUpgrade() {
        try {
            UniAppUpgradeManager.getUniPlugin()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    override fun logoutClear() {
        LogUtil.i(TAG, "mallserviceimpl logoutClear: ")
        helper.logoutClear()
    }

    private fun parseParams(element: JsonElement): Map<String, String> {
        val map = mutableMapOf<String, String>()
        if (element is JsonObject) {
            for (mutableEntry in element.entrySet()) {
                if (mutableEntry.value.isJsonObject) {
                    map.putAll(parseParams(element))
                } else {
                    map.put(mutableEntry.key, mutableEntry.value.asString)
                }
            }
        }
        return map
    }

}