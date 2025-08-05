package com.dreame.smartlife.ui.activity

import android.dreame.module.RoutPath
import android.dreame.module.constant.Constants
import android.dreame.module.manager.AreaManager.getRegion
import android.dreame.module.manager.LanguageManager
import android.dreame.module.util.LogUtil
import android.dreame.module.util.privacy.PrivacyPolicyConstants
import android.dreame.module.util.privacy.PrivacyPolicyHelper
import android.dreame.module.view.CommonTitleView
import com.therouter.router.Route
import com.dreame.smartlife.R
import com.dreame.smartlife.utils.rn.VideoLicenseUtil
import okhttp3.HttpUrl.Companion.toHttpUrlOrNull

@Route(path = RoutPath.WEBVIEW_POLICY)
class PrivacyPolicyWebView : WebViewActivity() {

    private var type: Int = 0
    private var url: String? = null

    // 只一键登录使用，其他不允许使用
    private val PROTOCOL_WEB_VIEW_URL = "url"
    private val PROTOCOL_WEB_VIEW_NAME = "name"

    override fun initData() {
        super.initData()
        val webUrl = intent.getStringExtra(PROTOCOL_WEB_VIEW_URL)
        val webName = intent.getStringExtra(PROTOCOL_WEB_VIEW_NAME)
        if (webUrl != null && webName != null) {
            type = PrivacyPolicyConstants.TYPE_ONEKEY_PRIVACY_POLICY
            url = webUrl
            webName.let { name ->
                val i: Int = name.indexOf("《")
                val i2: Int = name.indexOf("》")
                if (i != -1 && i2 != -1) {
                    binding.titleView.setTitle(name.substring(1, i2))
                } else {
                    binding.titleView.setTitle(name)
                }
            }
        } else {
            type = intent.getIntExtra(Constants.KEY_TYPE, PrivacyPolicyConstants.TYPE_AGREEMENT)
            url = intent.getStringExtra(Constants.KEY_WEB_URL)
            if (type == PrivacyPolicyConstants.TYPE_AGREEMENT || type == PrivacyPolicyConstants.TYPE_POLICY) {
                readPrivacyPolicyUrl()
                LogUtil.d("PolicyWebView: $url")
            }
        }
    }

    override fun initTitle() {
        loadPageTitle = false
        binding.titleView.setOnButtonClickListener(object :
            CommonTitleView.SimpleButtonClickListener() {
            override fun onLeftIconClick() {
                finish()
            }
        })
    }

    override fun loadUrl() {
        val finalUrl = url ?: ""
        when (type) {
            PrivacyPolicyConstants.TYPE_AGREEMENT -> {
                binding.titleView.setTitle(R.string.user_agreement)
                binding.webView.loadUrl(finalUrl)
            }
            PrivacyPolicyConstants.TYPE_POLICY -> {
                binding.titleView.setTitle(R.string.user_privacy)
                binding.webView.loadUrl(finalUrl)
            }
            PrivacyPolicyConstants.TYPE_VIDEO_POLICY -> {
                binding.titleView.setTitle(getString(R.string.video_policy_title_web))
                binding.webView.loadUrl(VideoLicenseUtil.getVideoPolicyUrl())
            }
            PrivacyPolicyConstants.TYPE_ONEKEY_PRIVACY_POLICY -> binding.webView.loadUrl(finalUrl)
            PrivacyPolicyConstants.TYPE_DEFAULT -> {
                val title = intent.getStringExtra(Constants.KEY_WEB_TITLE)
                binding.titleView.setTitle(title)
                binding.webView.loadUrl(finalUrl)
            }
            else -> {
                val title = intent.getStringExtra(Constants.KEY_WEB_TITLE)
                val data = intent.getStringExtra(Constants.KEY_DATA) ?: ""
                binding.titleView.setTitle(title)
                binding.webView.loadUrl(data)
            }
        }
    }

    override fun onBackPressed() {
        finish()
    }

    private fun readPrivacyPolicyUrl() {
        if (url == null) {
            url = PrivacyPolicyHelper.getUrlByType(type)
        }
        val version = PrivacyPolicyHelper.getVersionByType(type)
        val lang = LanguageManager.getInstance().getLangTag(this)
        url = composeNewUrl(url, lang, version.toString() + "")
    }

    /**
     * 重组Url
     *
     * @param url
     * @param lang
     * @param version
     */
    private fun composeNewUrl(
        url: String?,
        lang: String,
        version: String
    ): String? {
        val httpUrl = url?.toHttpUrlOrNull() ?: return url
        return httpUrl.newBuilder()
            .addQueryParameter("curLang", lang)
            .addQueryParameter("curRegion", getRegion())
            .build().toString()
    }

}