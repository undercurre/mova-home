package com.dreame.module.mall.protocol

import android.dreame.module.globalMainHandler
import android.dreame.module.util.LogUtil
import android.webkit.JavascriptInterface
import android.webkit.WebView
import com.dreame.module.mall.MallJavaScriptCallback
import com.dreame.module.service.mall.MallServiceExport
import org.json.JSONObject

@Deprecated(message = "callback")
var mallJavaScriptCallback: MallJavaScriptCallback? = null

fun WebView.addMallJavascriptInterface(callback: MallJavaScriptCallback? = null) {
    LogUtil.i("addMallJavascriptInterface: jsBridge $this")
    addJavascriptInterface(MallJsBridge(callback), "jsBridge")
}

fun WebView.removeMallJavascriptInterface() {
    LogUtil.i("removeMallJavascriptInterface: jsBridge $this")
    removeJavascriptInterface("jsBridge")
}

fun WebView.evaluateMallOnAppMessage(json: String, block: ((ret: String) -> Unit)? = null) {
    LogUtil.d("evaluateMallJavascript: $this")
    globalMainHandler.post {
        evaluateJavascript("javascript:onAppMessage($json)") { ret ->
            block?.invoke(ret)
        }
    }
}

fun WebView.evaluateMallOnBarCodeScan(json: JSONObject, block: ((ret: String) -> Unit)? = null) {
    LogUtil.d("evaluateMallJavascript: $this")
    globalMainHandler.post {
        evaluateJavascript("javascript:onBarCodeScan($json)") { ret ->
            block?.invoke(ret)
        }
    }
}


class MallJsBridge(val callback: MallJavaScriptCallback? = null) {
    @JavascriptInterface
    fun messageChannel(msg: String) {
        LogUtil.i("UNIAPP", "messageChannel: $msg")
        val jsonObject = JSONObject(msg)
        val type = jsonObject.optString("type")
        val data = jsonObject.optString("data")
        handleH5Message(type, data)
    }

    private fun handleH5Message(event: String, data: String) {
        when (event) {
            MallServiceExport.H5_EVENT_OPEN_PLUGIN,
            MallServiceExport.H5_EVENT_OPEN_WEBVIEW -> {
                mallJavaScriptCallback?.openNewPage(event, data)
                callback?.openNewPage(event, data)
            }

            MallServiceExport.H5_EVENT_OPEN_OUTER_WEBVIEW -> {
                mallJavaScriptCallback?.openNewPage(event, data)
                callback?.openNewPage(event, data)
            }

            MallServiceExport.H5_EVENT_OPEN_WX_WEBVIEW -> {
                mallJavaScriptCallback?.openPayPage(event, data)
                callback?.openPayPage(event, data)
            }

            MallServiceExport.H5_EVENT_CLOSE_WEBVIEW -> {
                mallJavaScriptCallback?.closePage(event, data)
                callback?.closePage(event, data)
            }

            MallServiceExport.H5_EVENT_GALLERY -> {
                mallJavaScriptCallback?.openGallery(event, data)
                callback?.openGallery(event, data)
            }

            MallServiceExport.H5_EVENT_REFRESH_SESSION,
            MallServiceExport.UNIAPP_EVENT_REFRESH_TOKEN,
            MallServiceExport.H5_EVENT_REFRESH_SESSION2 -> {
                mallJavaScriptCallback?.refreshSession(event)
                callback?.refreshSession(event)
            }

            MallServiceExport.UNIAPP_EVENT_NAVIGATION -> {
                mallJavaScriptCallback?.navigation(event, data)
                callback?.navigation(event, data)
            }

            MallServiceExport.UNIAPP_EVENT_SHARE -> {
                mallJavaScriptCallback?.share(event, data)
                callback?.share(event, data)
            }

            MallServiceExport.UNIAPP_EVENT_MAP_NAVIGATION -> {
                mallJavaScriptCallback?.mapNavigation(event, data)
                callback?.mapNavigation(event, data)
            }
        }
    }

}



