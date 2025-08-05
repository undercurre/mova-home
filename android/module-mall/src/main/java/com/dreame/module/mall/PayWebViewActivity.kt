package com.dreame.module.mall

import android.content.Intent
import android.dreame.module.RoutPath
import android.dreame.module.constant.Constants
import android.dreame.module.util.LogUtil
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.view.ViewGroup
import android.view.WindowManager
import android.webkit.WebChromeClient
import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.lifecycle.lifecycleScope
import com.therouter.router.Route
import com.dreame.module.base.mvi.BaseActivity
import com.dreame.module.mall.databinding.ActivityWebviewMallBinding
import com.dreame.module.mall.protocol.removeMallJavascriptInterface
import com.dreame.module.service.mall.MallServiceExport
import android.dreame.module.util.toast.ToastUtils
import kotlinx.coroutines.launch

@Route(path = RoutPath.MALL_PAY_WEBVIEW)
class PayWebViewActivity : BaseActivity<ActivityWebviewMallBinding>() {

    private var url: String? = null
    private var event: String? = null
    private var hideTitle: Boolean = false

    private val ALIPAY_URL_PREFIX = "alipays://"
    private val WECHAT_URL_PREFIX = "weixin://"

    companion object {
        @JvmStatic
        fun newInstance(): WebViewFragment {
            return WebViewFragment()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT));
        // 把 DecorView 的默认 padding 取消，同时 DecorView 的默认大小也会取消
        window.getDecorView().setPadding(0, 0, 0, 0)
        val layoutParams: WindowManager.LayoutParams = window.getAttributes()
        // 设置宽度
        layoutParams.width = 1
        layoutParams.height = 1
        window.setAttributes(layoutParams)
        // 给 DecorView 设置背景颜色，很重要，不然导致 Dialog 内容显示不全，有一部分内容会充当 padding，上面例子有举出
        window.getDecorView().setBackgroundColor(Color.TRANSPARENT);

    }
    override fun initView() {
        url = intent.getStringExtra(Constants.KEY_WEB_URL)
        event = intent.getStringExtra("event")
        hideTitle = intent.getBooleanExtra(Constants.KEY_WEB_HIDE_TITLE, false)
        val webSettings: WebSettings = binding.webView.getSettings()
        //缓存
        webSettings.cacheMode = WebSettings.LOAD_DEFAULT

        webSettings.domStorageEnabled = true
        //支持javascript
        //支持javascript
        webSettings.javaScriptEnabled = true
        // 设置可以支持缩放
        webSettings.setSupportZoom(true)
        // 设置出现缩放工具
        webSettings.builtInZoomControls = true
        // 设置缩放控件隐藏
        webSettings.displayZoomControls = false
        //扩大比例的缩放
        webSettings.useWideViewPort = true
        //自适应屏幕
        webSettings.layoutAlgorithm = WebSettings.LayoutAlgorithm.TEXT_AUTOSIZING
        webSettings.loadWithOverviewMode = true

//        webSettings.cacheMode = WebSettings.LOAD_CACHE_ELSE_NETWORK
        webSettings.apply {
            allowFileAccess = true
            allowContentAccess = true
            allowFileAccessFromFileURLs = true
        }

        //如果不设置WebViewClient，请求会跳转系统浏览器
        binding.webView.setWebViewClient(object : WebViewClient() {
            override fun shouldOverrideUrlLoading(view: WebView, url: String): Boolean {
                //该方法在Build.VERSION_CODES.LOLLIPOP以前有效，从Build.VERSION_CODES.LOLLIPOP起，建议使用shouldOverrideUrlLoading(WebView, WebResourceRequest)} instead
                //返回false，意味着请求过程里，不管有多少次的跳转请求（即新的请求地址），均交给webView自己处理，这也是此方法的默认处理
                //返回true，说明你自己想根据url，做新的跳转，比如在判断url符合条件的情况下，我想让webView加载http://ask.csdn.net/questions/178242
                LogUtil.d("shouldOverrideUrlLoading: $url")
                if (url.startsWith(WECHAT_URL_PREFIX)) {
                    try {
                        val intent = Intent()
                        intent.action = Intent.ACTION_VIEW
                        intent.data = Uri.parse(url)
                        if (intent.resolveActivity(packageManager) != null) {
                            startActivity(intent)
                            finish()
                            return true
                        } else {
                            finish()
                            ToastUtils.show(getString(R.string.text_wechat_uninstall_operate_failed))
                        }
                        return false
                    } catch (e: Exception) {
                        LogUtil.e(Log.getStackTraceString(e))
                    }
                } else if (url.startsWith(ALIPAY_URL_PREFIX)) {
                    try {
                        val intent = Intent()
                        intent.action = Intent.ACTION_VIEW
                        intent.data = Uri.parse(url)
                        if (intent.resolveActivity(packageManager) != null) {
                            startActivity(intent)
                            return true
                        }
                        return false
                    } catch (e: Exception) {
                        LogUtil.e(Log.getStackTraceString(e))
                    }
                }
                return super.shouldOverrideUrlLoading(view, url)
            }

        })
        binding.webView.setWebChromeClient(
            object : WebChromeClient() {
            })
        loadUrl()

    }

    override fun initData() {
    }

    override fun observe() {

    }

    override fun onDestroy() {

        (binding.webView.parent as ViewGroup).removeView(binding.webView)
        binding.webView.removeMallJavascriptInterface()
        binding.webView.apply {
            stopLoading()
            settings.javaScriptEnabled = false
            clearHistory()
            clearCache(true)
            removeAllViews()
            webChromeClient = null
            destroy()
        }

        super.onDestroy()

    }

    private fun loadUrl() {
        lifecycleScope.launch {
            runCatching {
                if (event != null && event.equals(MallServiceExport.H5_EVENT_OPEN_WX_WEBVIEW)) {
                    binding.webView.loadUrl(url ?: "", mapOf("Referer" to "https://www.dreame.tech"))
                } else {
                    binding.webView.loadUrl(url ?: "")
                }
            }.onFailure {
                LogUtil.e("UNIAPP", "loadUrl error: $it")
            }
        }
    }

    override fun onBackPressed() {
        if (binding.webView.canGoBack()) {
            binding.webView.goBack()
        } else {
            super.onBackPressed()
        }
    }

    override fun onResume() {
        super.onResume()
        binding.webView.onResume()
    }

    override fun onPause() {
        super.onPause()
        LogUtil.d("onPause: ")
        binding.webView.stopLoading()
        binding.webView.onPause()
    }
}