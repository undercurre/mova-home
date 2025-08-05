package com.dreame.module.mall

import AndroidBug5497Workaround
import android.content.Intent
import android.content.pm.ActivityInfo
import android.content.res.Configuration
import android.dreame.module.RoutPath
import android.dreame.module.RouteServiceProvider
import android.dreame.module.base.permission.OnPermissionCallback2
import android.dreame.module.constant.Constants
import android.dreame.module.util.*
import android.dreame.module.util.permission.ShowPermissionDialog
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.view.View
import android.view.ViewGroup
import android.view.Window
import android.webkit.*
import androidx.lifecycle.lifecycleScope
import com.therouter.router.Route
import com.blankj.utilcode.util.BarUtils
import com.blankj.utilcode.util.KeyboardUtils
import com.blankj.utilcode.util.UriUtils
import com.dreame.module.base.mvi.BaseActivity
import com.dreame.module.mall.databinding.ActivityWebviewMallBinding
import com.dreame.module.mall.protocol.MallWebViewProtocolHelper
import com.dreame.module.mall.protocol.addMallJavascriptInterface
import com.dreame.module.mall.protocol.removeMallJavascriptInterface
import com.dreame.module.mall.service.DreameMallUIBean
import com.dreame.module.service.mall.IMallService
import com.hjq.permissions.Permission
import com.hjq.permissions.XXPermissions
import com.zhihu.matisse.Matisse
import com.zhihu.matisse.MimeType
import com.zhihu.matisse.internal.entity.CaptureStrategy
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import top.zibin.luban.Luban

@Route(path = RoutPath.MALL_WEBVIEW)
class MallWebViewActivity : BaseActivity<ActivityWebviewMallBinding>() {

    private var mallWebViewProtocolHelper: MallWebViewProtocolHelper? = null

    private var filePathValueCallback: ValueCallback<Array<Uri>>? = null

    private var url: String? = null
    private var hideTitle: Boolean = false

    private val CODE_SELECT_PICTURE = 10001
    private val CODE_SCAN_BAR = 10002

    private var lastUrlLoaded: String? = null

    private val ALIPAY_URL_PREFIX = "alipays://"
    private val WECHAT_URL_PREFIX = "weixin://"

    companion object {
        @JvmStatic
        fun newInstance(): WebViewFragment {
            return WebViewFragment()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        supportRequestWindowFeature(Window.FEATURE_NO_TITLE);
        super.onCreate(savedInstanceState)
        AndroidBug5497Workaround.assistActivity(this)
        BarUtils.setNavBarVisibility(window, true)
    }

    override fun initView() {
        url = intent.getStringExtra(Constants.KEY_WEB_URL)
        hideTitle = intent.getBooleanExtra(Constants.KEY_WEB_HIDE_TITLE, false)
        mallWebViewProtocolHelper = MallWebViewProtocolHelper(this, binding.webView)
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
        binding.webView.setWebViewClient(object : MyWebViewClient() {
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
            object : MyWebChromeClient() {
                private var mCustomView: View? = null
                private var mCustomCallback: CustomViewCallback? = null

                override fun onProgressChanged(view: WebView, newProgress: Int) {
                }

                override fun onShowCustomView(view: View?, callback: CustomViewCallback?) {
                    super.onShowCustomView(view, callback)
                    LogUtil.d("onShowCustomView: $view")
                    if (mCustomView != null) {
                        callback?.onCustomViewHidden()
                        return
                    }
                    mCustomView = view
                    mCustomView?.visibility = View.VISIBLE
                    mCustomCallback = callback
                    binding.flVideo.addView(mCustomView)
                    binding.flVideo.bringToFront()
                    requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
                }

                override fun onHideCustomView() {
                    super.onHideCustomView()
                    if (mCustomView == null) {
                        return
                    }
                    mCustomView?.visibility = View.GONE
                    binding.flVideo.removeView(mCustomView)
                    mCustomView = null
                    try {
                        mCustomCallback?.onCustomViewHidden()
                    } catch (e: Exception) {

                    }
                    requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT

                }

                override fun onShowFileChooser(
                    webView: WebView,
                    filePathCallback: ValueCallback<Array<Uri>>,
                    fileChooserParams: FileChooserParams,
                ): Boolean {
                    filePathValueCallback = filePathCallback
                    val acceptTypes = fileChooserParams.acceptTypes
                    val allowMultiple =
                        fileChooserParams.mode == FileChooserParams.MODE_OPEN_MULTIPLE
                    val intent = fileChooserParams.createIntent()
                    if (XXPermissions.isGranted(
                            this@MallWebViewActivity,
                            Permission.CAMERA,
                            Permission.READ_MEDIA_IMAGES
                        )
                    ) {
                        gotoPickPickture(allowMultiple, true)
                    } else {
                        showPermissionDialog { camera, gralery ->
                            if (!camera && !gralery) {
                                filePathValueCallback?.onReceiveValue(null)
                                filePathValueCallback = null
                            } else {
                                gotoPickPickture(allowMultiple, camera)
                            }
                        }
                    }
                    return true
                }
            })

        binding.webView.addMallJavascriptInterface(
            object : MallJavaScriptCallback {
                override fun openNewPage(type: String, path: String) {
                    mallWebViewProtocolHelper?.openNewPage(this@MallWebViewActivity, type, path)
                }

                override fun openPayPage(type: String, path: String) {
                    mallWebViewProtocolHelper?.openNewPage(this@MallWebViewActivity, type, path)
                }

                override fun closePage(type: String, path: String) {
                    finish()
                }

                override fun share(type: String, content: String) {
                    mallWebViewProtocolHelper?.doShare(type, content)
                }

                override fun navigation(type: String, content: String) {
                    mallWebViewProtocolHelper?.doNavigation(type, content)
                }

                override fun refreshSession(type: String) {
                    evaluateJavascript()
                }

                override fun mapNavigation(type: String, date: String) {
                    runOnUiThread {
                        mallWebViewProtocolHelper?.showMapNavigation(type, date)
                    }
                }
            })
        loadUrl()

    }

    private fun gotoPickPickture(allowMultiple: Boolean, camera: Boolean = false) {
        Matisse.from(this)
            .choose(MimeType.of(MimeType.WEBP, MimeType.BMP, MimeType.JPEG, MimeType.PNG))
            .capture(camera) // 使用相机，和 captureStrategy 一起使用
            .captureStrategy(CaptureStrategy(false, this.packageName + ".fileprovider"))
            .theme(R.style.Matisse_Dracula)
            .countable(true)
            .showSingleMediaType(!allowMultiple)
            .maxSelectable(1)
            .restrictOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT)
            .imageEngine(GlideLoadEngine())
            .forResult(CODE_SELECT_PICTURE)
    }

    override fun initData() {
    }

    private fun evaluateJavascript() {
        lifecycleScope.launch {
            LogUtil.i("UNIAPP", "evaluateJavascript: ----------start---------")
            val composeJson = RouteServiceProvider.getService<IMallService>()?.mallLoginSync() ?: ""
            LogUtil.i("UNIAPP", "evaluateJavascript: ----------end--------- $composeJson")
        }
    }

    override fun observe() {
        RouteServiceProvider.getService<IMallService>()?.mallInfoLiveData()?.observe(this) { bean ->
            val mallUIBean = bean as DreameMallUIBean
            LogUtil.d(": -------1----- mallViewModel.uiStates.observeState ${mallUIBean.sessionId} ${mallUIBean.userId}")
            if (mallUIBean.sessionId.isNotEmpty() && mallUIBean.userId.isNotEmpty()) {
                if (url?.contains(mallUIBean.sessionId) == true && url?.contains(mallUIBean.userId) == true) {
                    return@observe
                }
                val composeJson = RouteServiceProvider.getService<IMallService>()?.composeJson()
                binding.webView.evaluateJavascript("javascript:onAppMessage(${composeJson})") {
                    Log.d("UNIAPP", "observe evaluateJavascript : $it")
                }
            }
        }
    }

    override fun onDestroy() {
        //兜底策略
        filePathValueCallback?.onReceiveValue(null)

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
                binding.webView.loadUrl(url ?: "")
            }.onFailure {
                LogUtil.e("UNIAPP", "loadUrl error: $it")
            }
        }
    }

    private fun showPermissionDialog(block: (camera: Boolean, gralery: Boolean) -> Unit) {
        ShowPermissionDialog.showPermissionDialog(
            this,
            R.string.Toast_SystemServicePermission_CameraPhoto,
            {
                filePathValueCallback?.onReceiveValue(null)
                filePathValueCallback = null
            }
        ) {
            XXPermissions.with(this)
                .permission(Permission.CAMERA, Permission.READ_MEDIA_IMAGES)
                .request(object : OnPermissionCallback2 {
                    override fun onGranted(permissions1: MutableList<String>, all: Boolean) {
                        if (all) {
                            block(true, true)
                        } else {
                            if (permissions1.isEmpty()) {
                                block(false, false)
                            }
                            if (permissions1.contains(Permission.CAMERA)) {
                                block(true, false)
                            } else if (permissions1.contains(Permission.READ_MEDIA_IMAGES)) {
                                block(false, true)
                            }
                        }
                    }

                    override fun onDenied2(
                        permissions: MutableList<String>?,
                        never: Boolean,
                    ): Boolean {
                        filePathValueCallback?.onReceiveValue(null)
                        filePathValueCallback = null
                        return super.onDenied2(permissions, never)
                    }
                })
        }
    }

    override fun onBackPressed() {
        if (binding.webView.canGoBack()) {
            binding.webView.goBack()
        } else {
            super.onBackPressed()
        }
    }

    @Deprecated("Deprecated in Java")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == CODE_SELECT_PICTURE) {
            if (resultCode == RESULT_OK) {
                val uri = Matisse.obtainResult(data)
                val path = Matisse.obtainPathResult(data)
                // 如果图片大于2M, 则压缩图片
                compressorPicture(uri[0], path[0])
            } else {
                filePathValueCallback?.onReceiveValue(null)
                filePathValueCallback = null
            }
        } else if (requestCode == CODE_SCAN_BAR) {
            if (resultCode == RESULT_OK) {
                val result = data?.getStringExtra(Constants.EXTRA_RESULT) ?: ""
                mallWebViewProtocolHelper?.onBarCodeScan("", 0, result)
            } else {
                mallWebViewProtocolHelper?.onBarCodeScan("", -1, "")
            }
        }
    }

    private fun compressorPicture(uri: Uri, path: String) {
        lifecycleScope.launch(Dispatchers.IO) {
            val files = Luban.with(this@MallWebViewActivity)
                .load(path)
                .setTargetDir(
                    AndroidFileUtils.getCacheFileDir(AndroidFileUtils.IMAGE).getAbsolutePath()
                )
                .ignoreBy(2 * 1024)
                .get()
            val file2Uri = UriUtils.file2Uri(files[0])
            filePathValueCallback?.onReceiveValue(arrayOf(file2Uri))
            filePathValueCallback = null
            LogUtil.i("onActivityResult: ${file2Uri}")
        }

    }

    override fun onStart() {
        super.onStart()

    }


    override fun onResume() {
        super.onResume()
        binding.webView.onResume()
        LogUtil.d("onResume: $lastUrlLoaded")
    }

    override fun onPause() {
        super.onPause()
        LogUtil.d("onPause: ")
        binding.webView.stopLoading()
        binding.webView.onPause()

        KeyboardUtils.unregisterSoftInputChangedListener(this.window)
    }

    override fun onConfigurationChanged(config: Configuration) {
        super.onConfigurationChanged(config)
        when (config.orientation) {
            Configuration.ORIENTATION_LANDSCAPE -> {
                BarUtils.setNavBarVisibility(window, false)
            }

            Configuration.ORIENTATION_PORTRAIT -> {
                BarUtils.setNavBarVisibility(window, true)
            }
        }
    }
}