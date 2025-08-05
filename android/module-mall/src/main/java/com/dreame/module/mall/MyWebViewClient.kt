package com.dreame.module.mall

import android.dreame.module.util.LogUtil
import android.net.http.SslError
import android.webkit.RenderProcessGoneDetail
import android.webkit.SslErrorHandler
import android.webkit.WebResourceError
import android.webkit.WebResourceRequest
import android.webkit.WebResourceResponse
import android.webkit.WebView
import android.webkit.WebViewClient

open class MyWebViewClient : WebViewClient() {
    override fun onRenderProcessGone(view: WebView?, detail: RenderProcessGoneDetail?): Boolean {
        return super.onRenderProcessGone(view, detail)
    }
    override fun onReceivedError(view: WebView?, request: WebResourceRequest?, error: WebResourceError?) {
        super.onReceivedError(view, request, error)
        LogUtil.e(
            "onReceivedError", "error: ${error?.errorCode}  ${error?.description} ,request: ${request?.url}"
        )
    }

    override fun onReceivedHttpError(view: WebView?, request: WebResourceRequest?, errorResponse: WebResourceResponse?) {
        super.onReceivedHttpError(view, request, errorResponse)
        LogUtil.e(
            "onReceivedHttpError", "errorResponse: ${errorResponse?.statusCode} ${errorResponse?.reasonPhrase}"
        )
    }

    override fun onReceivedSslError(view: WebView?, handler: SslErrorHandler?, error: SslError?) {
        super.onReceivedSslError(view, handler, error)
        LogUtil.e("onReceivedSslError", "error: ${error.toString()}")
    }

}