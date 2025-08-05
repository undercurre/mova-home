package com.dreame.smartlife.ui.activity

import android.annotation.SuppressLint
import android.content.Intent
import android.dreame.module.RoutPath
import android.dreame.module.constant.Constants
import android.dreame.module.util.DarkThemeUtils
import android.dreame.module.util.LogUtil
import android.dreame.module.view.CommonTitleView
import android.net.Uri
import android.text.TextUtils
import android.util.Log
import android.view.KeyEvent
import android.view.View
import android.view.ViewGroup
import android.webkit.*
import androidx.core.content.ContextCompat
import com.therouter.router.Route
import com.dreame.module.base.mvi.BaseActivity
import com.dreame.smartlife.R
import com.dreame.smartlife.databinding.ActivityWebviewBinding
import android.dreame.module.util.toast.ToastUtils

@Route(path = RoutPath.MAIN_WEBVIEW)
open class WebViewActivity : BaseActivity<ActivityWebviewBinding>() {

    private var webTitle: String = ""
    private var webUrl: String = ""
    private val ALIPAY_URL_PREFIX = "alipays://"
    private val WECHAT_URL_PREFIX = "weixin://"

    /**
     * 控制是否加载webview的title
     */
    protected var loadPageTitle = true
    override fun initData() {
        webTitle = intent.getStringExtra(Constants.KEY_WEB_TITLE) ?: ""
        webUrl = intent.getStringExtra(Constants.KEY_WEB_URL) ?: ""
        val hideTitle = intent.getBooleanExtra(Constants.KEY_WEB_HIDE_TITLE, false)
        if (hideTitle) {
            binding.titleView.visibility = View.GONE
        }
    }

    override fun initView() {
        val bgColor = intent.getIntExtra(Constants.KEY_WEB_BG_COLOR, -1)
        if (bgColor != -1) {
            binding.llRoot.setBackgroundColor(ContextCompat.getColor(this, bgColor))
        }
        initWebView()
        initTitle()
        loadUrl()
    }

    override fun observe() {
    }

    override fun onBackPressed() {
        if (binding.webView.canGoBack()) {
            binding.webView.goBack()
        } else {
            finish()
        }
    }

    open fun initTitle() {
        binding.titleView.setOnButtonClickListener(object :
            CommonTitleView.SimpleButtonClickListener() {
            override fun onLeftIconClick() {
                onBackPressed()
            }
        })
        binding.titleView.setTitle(webTitle)
    }

    open fun loadUrl() {
        val index = webUrl.indexOf("themeMode=")
        if (index != -1) {
            val themeMode = DarkThemeUtils.getThemeSettingString(this)
            webUrl = webUrl.substring(0, index) + "themeMode=${themeMode}"
        } else {
            // 添加themeMode参数
        }
        binding.webView.loadUrl(webUrl)
    }

    @SuppressLint("SetJavaScriptEnabled")
    private fun initWebView() {
        binding.webView.settings.apply {
            // 缓存
            cacheMode = WebSettings.LOAD_DEFAULT
            domStorageEnabled = true
            // 支持javascript
            javaScriptEnabled = true
            // 设置可以支持缩放
            setSupportZoom(true)
            // 设置出现缩放工具
            builtInZoomControls = true
            // 设置缩放控件隐藏
            displayZoomControls = false
            // 扩大比例的缩放
            useWideViewPort = true
            // 自适应屏幕
            layoutAlgorithm = WebSettings.LayoutAlgorithm.TEXT_AUTOSIZING
            loadWithOverviewMode = true
            mixedContentMode = WebSettings.MIXED_CONTENT_ALWAYS_ALLOW

            allowFileAccess = true
            allowContentAccess = true
            allowFileAccessFromFileURLs = true
        }
        // 如果不设置WebViewClient，请求会跳转系统浏览器
        binding.webView.webViewClient = object : WebViewClient() {
            override fun shouldInterceptRequest(
                view: WebView,
                request: WebResourceRequest
            ): WebResourceResponse? {
                // 步骤1:判断拦截资源的条件，即判断url里的图片资源的文件名
                return super.shouldInterceptRequest(view, request)
            }

            @Deprecated("Deprecated in Java")
            override fun shouldOverrideUrlLoading(view: WebView, url: String): Boolean {
                // 该方法在Build.VERSION_CODES.LOLLIPOP以前有效，从Build.VERSION_CODES.LOLLIPOP起，建议使用shouldOverrideUrlLoading(WebView, WebResourceRequest)} instead
                // 返回false，意味着请求过程里，不管有多少次的跳转请求（即新的请求地址），均交给webView自己处理，这也是此方法的默认处理
                // 返回true，说明你自己想根据url，做新的跳转，比如在判断url符合条件的情况下，我想让webView加载http://ask.csdn.net/questions/178242
                if (url.startsWith("http:") || url.startsWith("https:")) {
                    if (url.contains("https://wx.tenpay.com")) {
                        view.loadUrl(url, mapOf("Referer" to "https://www.mova-tech.com"))
                        return true
                    }
                } else {
                    if (url.startsWith(WebView.SCHEME_MAILTO)) {
                        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
                        gotoWithCheckInstall(
                            Intent.createChooser(
                                intent,
                                getString(R.string.title_chooose_email)
                            )
                        )
                        return true
                    } else if (url.startsWith(WebView.SCHEME_TEL)) {
                        val intent = Intent(Intent.ACTION_DIAL, Uri.parse(url))
                        if (intent.resolveActivity(packageManager) != null) {
                            startActivity(intent)
                        }
                        return true
                    } else if (url.startsWith(WECHAT_URL_PREFIX)) {
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
                    } else {
                        try {
                            val intent = Intent()
                            intent.action = Intent.ACTION_VIEW
                            intent.data = Uri.parse(url)
                            startActivity(intent)
                            return true
                        } catch (e: Exception) {
                            LogUtil.e(Log.getStackTraceString(e))
                        }
                    }
                }
                return super.shouldOverrideUrlLoading(view, url)
            }

            override fun shouldOverrideUrlLoading(
                view: WebView,
                request: WebResourceRequest
            ): Boolean {
                return super.shouldOverrideUrlLoading(view, request)
            }

            override fun onPageFinished(view: WebView, url: String) {
                super.onPageFinished(view, url)

            }

            override fun onUnhandledKeyEvent(view: WebView, event: KeyEvent) {
                super.onUnhandledKeyEvent(view, event)
            }

            override fun shouldOverrideKeyEvent(view: WebView, event: KeyEvent): Boolean {
                return super.shouldOverrideKeyEvent(view, event)
            }
        }
        binding.webView.webChromeClient = object : WebChromeClient() {
            override fun onProgressChanged(view: WebView, newProgress: Int) {
                binding.pbLoad.apply {
                    progress = newProgress
                    visibility = if (newProgress == 100) View.INVISIBLE else View.VISIBLE
                }
            }

            override fun onReceivedTitle(view: WebView, title: String) {
                super.onReceivedTitle(view, title)
                if (TextUtils.isEmpty(webTitle) && loadPageTitle) {
                    LogUtil.d("onReceivedTitle: ${view.title}")
                    binding.titleView.setTitle(view.title)
                }
            }

            override fun onPermissionRequest(request: PermissionRequest?) {
                super.onPermissionRequest(request)
            }
        }

        binding.webView.isVerticalScrollBarEnabled = true
        binding.webView.scrollBarStyle = View.SCROLLBARS_INSIDE_OVERLAY

    }

    private fun gotoWithCheckInstall(intent: Intent) {
        if (intent.resolveActivity(packageManager) != null) {
            startActivity(intent)
        } else {
            ToastUtils.show(getString(R.string.Help_CustomerCare_NoEmailClient_Toast))
        }
    }

    override fun onDestroy() {
        (binding.webView.parent as ViewGroup).removeView(binding.webView)
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
}