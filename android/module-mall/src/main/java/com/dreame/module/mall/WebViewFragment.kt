package com.dreame.module.mall


import android.dreame.module.RouteServiceProvider
import android.dreame.module.event.EventCode
import android.dreame.module.event.EventMessage
import android.dreame.module.util.LogUtil
import android.dreame.module.util.ScreenUtils
import android.dreame.module.util.StatusBarUtil
import android.os.Bundle
import android.util.Log
import android.view.View
import android.webkit.ConsoleMessage
import android.webkit.RenderProcessGoneDetail
import android.webkit.WebChromeClient
import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.lifecycle.lifecycleScope
import com.dreame.module.base.mvvm.fragment.BaseVbFragment
import com.dreame.module.mall.databinding.FragmentWebviewBinding
import com.dreame.module.mall.protocol.MallWebViewProtocolHelper
import com.dreame.module.mall.protocol.addMallJavascriptInterface
import com.dreame.module.mall.protocol.mallJavaScriptCallback
import com.dreame.module.mall.protocol.removeMallJavascriptInterface
import com.dreame.module.mall.service.DreameMallUIBean
import com.dreame.module.mall.uniapp.UniAppInfoCacheManager
import com.dreame.module.service.mall.IMallService
import kotlinx.coroutines.launch
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode


/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/07/31
 *     desc   :
 *     version: 1.0
 * </pre>
 */
class WebViewFragment() : BaseVbFragment<FragmentWebviewBinding>() {

    private var mallWebViewProtocolHelper: MallWebViewProtocolHelper? = null

    companion object {
        private const val SUB_PAGE_PAGE = "subPagePath"
        const val COMMUNITY_PAGE_PAGE = "/pages/contents/contents"

        @JvmStatic
        fun newInstance(pagePath: String? = null): WebViewFragment {
            val fragment = WebViewFragment()
            val args = Bundle()
            if (!pagePath.isNullOrEmpty()) {
                args.putString(SUB_PAGE_PAGE, pagePath)
                fragment.arguments = args
            }
            return fragment
        }
    }

    override fun initView() {
        mallWebViewProtocolHelper = MallWebViewProtocolHelper(requireActivity(), binding.webView)

        binding.btnDownload.visibility = View.GONE
        binding.pb.visibility = View.GONE
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
        webSettings.apply {
            allowFileAccess = true
            allowContentAccess = true
            allowFileAccessFromFileURLs = true
        }

        //如果不设置WebViewClient，请求会跳转系统浏览器
        binding.webView.setWebViewClient(object : MyWebViewClient() {
            override fun onRenderProcessGone(view: WebView?, detail: RenderProcessGoneDetail?): Boolean {
                return super.onRenderProcessGone(view, detail)
            }
        })
        binding.webView.setWebChromeClient(object : MyWebChromeClient() {

            override fun onProgressChanged(view: WebView, newProgress: Int) {
            }

        })
        binding.webView.addMallJavascriptInterface(object : MallJavaScriptCallback {
            override fun openNewPage(type: String, path: String) {
                mallWebViewProtocolHelper?.openNewPage(requireContext(), type, path)
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

            override fun mapNavigation(event: String, date: String) {
                requireActivity().runOnUiThread {
                    mallWebViewProtocolHelper?.showMapNavigation(event, date)
                }
            }

        })
        loadUrl()
    }

    override fun initData(savedInstanceState: Bundle?) {
        observe()
    }

    private fun evaluateJavascript() {
        lifecycleScope.launch {
            LogUtil.i("UNIAPP", "evaluateJavascript: ----------start---------")
            val composeJson = RouteServiceProvider.getService<IMallService>()?.mallLoginSync() ?: ""
            LogUtil.i("UNIAPP", "evaluateJavascript: ----------end--------- $composeJson")
        }
    }

    private fun observe() {
        RouteServiceProvider.getService<IMallService>()?.mallInfoLiveData()?.observe(this) { bean ->
            val mallUIBean = bean as DreameMallUIBean
            LogUtil.d(": -------1----- mallViewModel.uiStates.observeState ${mallUIBean.sessionId} ${mallUIBean.userId}")
            if (mallUIBean.sessionId.isNotEmpty() && mallUIBean.userId.isNotEmpty()) {
                val composeJson = RouteServiceProvider.getService<IMallService>()?.composeJson()
                binding.webView.evaluateJavascript("javascript:onAppMessage(${composeJson})") {
                    Log.d("UNIAPP", "observe evaluateJavascript : $it")
                }
            }
        }
    }

    override fun onDestroyView() {
        mallJavaScriptCallback = null
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

        super.onDestroyView()
    }

    private fun loadUrl() {
        lifecycleScope.launch {
            runCatching {
                val currentH5Path = UniAppInfoCacheManager.getH5Path()
                RouteServiceProvider.getService<IMallService>()?.mallLoginSync()
                val loginInfo = RouteServiceProvider.getService<IMallService>()?.mallLoginInfo()
                val sessionId = loginInfo?.first
                val userId = loginInfo?.second
//                val newUrl = String.format("http://172.18.33.137:8080/index.html?sessid=%s&user_id=%s", sessionId, userId)
                val statusBarHeightPx = StatusBarUtil.getStatusBarHeight(requireContext())
                val statusBarHeight =
                    ScreenUtils.px2dp(requireContext(), statusBarHeightPx.toFloat()).toInt()
                val newUrl = String.format(
                    "file://$currentH5Path?sessid=%s&user_id=%s&statusBarHeight=%d",
                    sessionId,
                    userId,
                    statusBarHeight
                )
                val subPath = arguments?.getString(
                    SUB_PAGE_PAGE
                )
                LogUtil.i("UNIAPP", "loadUrl:  $newUrl     $subPath")
                if (subPath.isNullOrEmpty()) {
                    binding.webView.loadUrl(newUrl)
                } else {
                    binding.webView.loadUrl("$newUrl#$subPath")
                }
            }.onFailure {
                LogUtil.e("UNIAPP", "loadUrl error: $it")
            }
        }
    }

    private fun reloadUrl() {
        lifecycleScope.launch {
            runCatching {
                val currentH5Path = UniAppInfoCacheManager.getH5Path()
                LogUtil.d("UNIAPP", "reloadUrl : $currentH5Path")
                val loginInfo = RouteServiceProvider.getService<IMallService>()?.mallLoginInfo()
                val sessionId = loginInfo?.first ?: ""
                val userId = loginInfo?.second ?: ""
                val url = binding.webView.url ?: ""
                val statusBarHeightPx = StatusBarUtil.getStatusBarHeight(requireContext())
                val statusBarHeight =
                    ScreenUtils.px2dp(requireContext(), statusBarHeightPx.toFloat()).toInt()
                val newUrl = String.format(
                    "file://$currentH5Path?sessid=%s&user_id=%s&statusBarHeight=%d",
                    sessionId,
                    userId,
                    statusBarHeight
                )
                if (RouteServiceProvider.getService<IMallService>()
                        ?.needReloadNewMallUrl(url, newUrl) == true
                ) {
                    LogUtil.i("UNIAPP", "reloadUrl needReloadNewMallUrl:  $url    \n $newUrl")
                    val subPath = arguments?.getString(
                        SUB_PAGE_PAGE
                    )
                    if (subPath.isNullOrEmpty()) {
                        binding.webView.loadUrl(newUrl)
                    } else {
                        binding.webView.loadUrl("$newUrl#$subPath")
                    }
                }
            }.onFailure {
                LogUtil.e("UNIAPP", "reloadUrl error: $it")
            }
        }
    }

    override fun onResume() {
        super.onResume()
        reloadUrl()
    }

    override fun isRegisteredEventBus(): Boolean {
        return true
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    fun onEvent(event: EventMessage<*>) {
        when (event.code) {
            EventCode.REFRESH_MALL_SESSION -> {
                evaluateJavascript()
            }
        }
    }
}