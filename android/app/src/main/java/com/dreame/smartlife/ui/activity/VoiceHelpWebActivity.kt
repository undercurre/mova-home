package com.dreame.smartlife.ui.activity

import android.content.Intent
import android.dreame.module.base.BaseActivity
import android.dreame.module.bean.AiSoundBean
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.util.AppUtils
import android.dreame.module.util.DarkThemeUtils
import android.dreame.module.util.StatusBarUtil
import android.dreame.module.util.SuperStatusUtil
import android.dreame.module.view.CommonTitleView
import android.graphics.Bitmap
import android.net.Uri
import android.os.Build
import android.view.View
import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.WebViewClient
import android.widget.TextView
import androidx.core.content.ContextCompat
import butterknife.BindView
import com.dreame.smartlife.R
import com.scwang.smartrefresh.layout.SmartRefreshLayout

class VoiceHelpWebActivity : BaseActivity() {

    @JvmField
    @BindView(R.id.titleView)
    var titleView: CommonTitleView? = null

    @JvmField
    @BindView(R.id.webView)
    var webView: WebView? = null

    @JvmField
    @BindView(R.id.tv_open_app)
    var tvOpenApp: TextView? = null

    @JvmField
    @BindView(R.id.srl_refresh)
    var srlRefresh: SmartRefreshLayout? = null

    private var soundBean: AiSoundBean? = null

    override fun setStatusBar() {
        SuperStatusUtil.hieStatusBarAndNavigationBar(window.decorView)
        val isDark = DarkThemeUtils.isDarkTheme(this);
        SuperStatusUtil.setStatusBar(
            this,
            true,
            isDark,
            ContextCompat.getColor(this, R.color.common_layoutBg)
        )
        val status = findViewById<View>(R.id.view_status_bar)
        status?.let {
            val lp = it.layoutParams
            lp.height = StatusBarUtil.getStatusBarHeight(this)
            it.layoutParams = lp
        }
    }

    override fun initView() {
        titleView?.setOnButtonClickListener(object : CommonTitleView.SimpleButtonClickListener() {
            override fun onLeftIconClick() {
                goBack()
            }
        })
        webView?.settings?.apply {
            cacheMode = WebSettings.LOAD_NO_CACHE
            domStorageEnabled = true
            javaScriptEnabled = true
            setSupportZoom(true)
            builtInZoomControls = true
            displayZoomControls = false
            useWideViewPort = true
            layoutAlgorithm = WebSettings.LayoutAlgorithm.TEXT_AUTOSIZING
            loadWithOverviewMode = true
        }
        webView?.webViewClient = object : WebViewClient() {
            override fun onPageStarted(view: WebView?, url: String?, favicon: Bitmap?) {
                super.onPageStarted(view, url, favicon)
            }

            override fun onPageFinished(view: WebView?, url: String?) {
                super.onPageFinished(view, url)
                srlRefresh?.finishRefresh()
            }

        }
        soundBean?.let {
            webView?.loadUrl(it.linkUrl)
        }
        soundBean?.let {
            titleView?.setTitle(it.name)
            tvOpenApp?.text = it.button
        }
        tvOpenApp?.setOnShakeProofClickListener() {
            soundBean?.android?.packageName?.let {
                val packageArray = it.split(",")
                var installApp = false
                packageArray.forEach { name ->
                    if (AppUtils.isInstallApp(this, name)) {
                        installApp = true
                        val intent = packageManager.getLaunchIntentForPackage(name)
                        intent?.flags =
                            Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED
                        startActivity(intent)
                        return@forEach
                    }
                }
                if (!installApp) {
                    try {
                        if (packageArray.size > 1) {
                            if (AppUtils.isForeignVersion()) {
                                startActivity(
                                    Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=${packageArray[1]}"))
                                )
                            } else {
                                if (Build.BRAND.equals("XIAOMI", ignoreCase = true) ||
                                    Build.BRAND.equals("REDMI", ignoreCase = true)
                                ) {
                                    if (soundBean?.android?.downloadUrl?.isNotEmpty() == true) {
                                        startActivity(
                                            Intent(Intent.ACTION_VIEW, Uri.parse(soundBean?.android?.downloadUrl))
                                        )
                                    }
                                } else {
                                    startActivity(
                                        Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=${packageArray[0]}"))
                                    )
                                }
                            }
                        } else {
                            startActivity(
                                Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=${soundBean?.android?.packageName}"))
                            )
                        }
                    } catch (e: Exception) {
                        if (soundBean?.android?.downloadUrl?.isNotEmpty() == true) {
                            startActivity(
                                Intent(Intent.ACTION_VIEW, Uri.parse(soundBean?.android?.downloadUrl))
                            )
                        }
                    }
                }
            }
        }
    }

    override fun initData() {
        soundBean = intent.getSerializableExtra("key_data") as? AiSoundBean
    }

    override fun initEvent() {
        srlRefresh?.setOnRefreshListener {
            soundBean?.let {
                webView?.loadUrl(it.linkUrl)
            }
        }
    }

    override fun onClick(v: View?) {
    }

    override fun getContentViewId(): Int = R.layout.activity_voice_help_web

    override fun initViewModel() {

    }

    override fun onBackPressed() {
        goBack()
    }

    private fun goBack() {
        if (webView?.canGoBack() == true) {
            webView?.goBack()
        } else {
            finish()
        }
    }
}