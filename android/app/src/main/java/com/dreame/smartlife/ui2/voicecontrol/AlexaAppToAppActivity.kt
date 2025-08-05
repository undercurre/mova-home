package com.dreame.smartlife.ui2.voicecontrol

import android.content.Intent
import android.dreame.module.RoutPath
import android.dreame.module.data.Result
import android.dreame.module.util.DarkThemeUtils
import android.dreame.module.util.LogUtil
import android.dreame.module.util.toast.ToastUtils
import android.dreame.module.view.CommonTitleView
import android.net.Uri
import android.os.Bundle
import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.activity.viewModels
import com.blankj.utilcode.util.EncodeUtils
import com.dreame.module.res.BottomConfirmDialog
import com.dreame.smartlife.R
import com.dreame.smartlife.databinding.ActivityAlexaApptoappBinding
import com.dreame.smartlife.ui2.base.BaseActivity
import com.dreame.smartlife.utils.AlexaAppUtil
import com.therouter.TheRouter
import com.therouter.router.Autowired
import com.therouter.router.Route


/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2022/02/28
 *     desc   :
 *     version: 1.0
 * </pre>
 */
@Route(path = RoutPath.VOICE_CONTROL_ALEXA)
class AlexaAppToAppActivity : BaseActivity<ActivityAlexaApptoappBinding>() {

    private val TAG = "AlexaAppToAppActivity"

    private val viewModel by viewModels<VoiceControlViewModel>()
    private var applinkUrl: String? = null
    private var lwaUrl: String? = null
    private var alreadyBind = false

    @JvmField
    @Autowired(name = "link")
    var link: String? = null
    @JvmField
    @Autowired(name = "name")
    var name: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        TheRouter.inject(this)
        link = String(EncodeUtils.base64Decode(link))
        super.onCreate(savedInstanceState)
        handleIntent(intent)
    }


    private fun handleIntent(intent: Intent?) {
        intent?.let {
            val appLinkAction = it.action
            val appLinkData: Uri? = it.data ?: it.getParcelableExtra<Uri?>("alexaUri")
            if (Intent.ACTION_VIEW == appLinkAction) {
                val code = appLinkData?.getQueryParameter("code")
                val state = appLinkData?.getQueryParameter("state")
                if (code.isNullOrEmpty()) {
//                    ToastUtils.show(getString(R.string.cancel))
                } else {
                    var url = "${appLinkData?.scheme}://${appLinkData?.authority}"
                    if (url.startsWith("mova://")) {
                        url = "https://app.mova-tech.com"
                    }
                    LogUtil.d(TAG, "onNewIntent: $code,$state, $url")
                    viewModel.alexaSkillAccountLink(code ?: "", url)
                }
            }
        }
    }

    override fun initData() {
    }

    override fun initView() {
        binding.titleView.setTitle("Alexa")
        binding.llBind.setOnClickListener {
            if (alreadyBind) {
                showUnbindDialog()
            } else {
                if (AlexaAppUtil.isAlexaAppSupportAppLink(this@AlexaAppToAppActivity)) {
                    applinkUrl?.let {
                        openAlexaAppToAppUrl(applinkUrl)
                    }
                } else {
                    lwaUrl?.let {
                        openAlexaAppToAppUrl(lwaUrl)
                    }
                }
            }
        }
        binding.titleView.setOnButtonClickListener(object :
            CommonTitleView.SimpleButtonClickListener() {
            override fun onLeftIconClick() {
                goBack()
            }
        })
        binding.webView.settings.apply {
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
        binding.webView.webViewClient = object : WebViewClient() {
            override fun onPageFinished(view: WebView?, url: String?) {
                super.onPageFinished(view, url)
                binding.srlRefresh.finishRefresh()
            }
        }
        link?.let {
            val index = it.indexOf("themeMode=")
            val themeMode = DarkThemeUtils.getThemeSettingString(this)
            val newUrl = if (index != -1) {
                it.substring(0, index) + "themeMode=${themeMode}"
            } else {
                val index = it.indexOf("?")
                if (index < 0) {
                    it + "?themeMode=${themeMode}"
                } else {
                    it + "&themeMode=${themeMode}"
                }
            }
            binding.webView.loadUrl(newUrl)

        }

        binding.srlRefresh.setOnRefreshListener {
            link?.let {
                val index = it.indexOf("themeMode=")
                val themeMode = DarkThemeUtils.getThemeSettingString(this)
                val newUrl = if (index != -1) {
                    it.substring(0, index) + "themeMode=${themeMode}"
                } else {
                    val index = it.indexOf("?")
                    if (index < 0) {
                        it + "?themeMode=${themeMode}"
                    } else {
                        it + "&themeMode=${themeMode}"
                    }
                }
                binding.webView.loadUrl(newUrl)
            }
        }
    }

    private fun showUnbindDialog() {
        val dialog = BottomConfirmDialog(this)
        dialog.show(
            getString(R.string.text_alexa_unbind_confirm),
            getString(R.string.confirm_unbind),
            getString(R.string.cancel),
            {
                viewModel.unbindAlexaAccountLink()
                it.dismiss()
            },
            {
                it.dismiss()
            }
        )
    }

    override fun observe() {
        viewModel.alexaApp2AppRes.observe(this) { result ->
            when (result) {
                is Result.Loading -> {
                    LogUtil.i(TAG, "alexaApp2AppRes loading")
                    showLoading()
                }

                is Result.Success -> {
                    dismissLoading()
                    if (result.data?.alreadyBind == true) {
                        alreadyBind = true
                        binding.llBind.setContent(getString(R.string.alexa_already_bind))
                    } else {
                        alreadyBind = false
                        binding.llBind.setContent(getString(R.string.alexa_not_bind))
                    }

                    applinkUrl = result.data?.applinkUrl
                    lwaUrl = result.data?.lwaUrl
                }

                is Result.Error -> {
                    dismissLoading()
                }
            }
        }
        viewModel.alexaSkillAccountLink.observe(this) { result ->
            when (result) {
                is Result.Loading -> {
                    showLoading()
                }

                is Result.Success -> {
                    dismissLoading()
                    ToastUtils.show(getString(R.string.bind_success))
                    viewModel.getAlexaApp2AppUrl()
                }

                is Result.Error -> {
                    dismissLoading()
                    ToastUtils.show(getString(R.string.bind_failure))
                }
            }
        }
        viewModel.unbindAlexaResult.observe(this) { result ->
            when (result) {
                is Result.Loading -> {
                    showLoading()
                }

                is Result.Success -> {
                    dismissLoading()
                    ToastUtils.show(getString(R.string.unbind_success))
                    alreadyBind = false
                    binding.llBind.setContent(getString(R.string.alexa_not_bind))
                }

                is Result.Error -> {
                    dismissLoading()
                    ToastUtils.show(getString(R.string.unbind_failed))
                }
            }
        }
        viewModel.getAlexaApp2AppUrl()
    }

    private fun openAlexaAppToAppUrl(url: String?) {
        LogUtil.d(TAG, "openAlexaAppToAppUrl: $url")
        try {
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
            startActivity(intent)
        } catch (e: Exception) {
            LogUtil.e(TAG, "openAlexaAppToAppUrl error, url:$url ,error:$e")
        }
    }

    override fun onNewIntent(intent: Intent?) {
        super.onNewIntent(intent)
        LogUtil.d(TAG, "onNewIntent: " + intent?.data)
        handleIntent(intent)
    }

    override fun onBackPressed() {
        goBack()
    }

    private fun goBack() {
        if (binding.webView.canGoBack()) {
            binding.webView.goBack()
        } else {
            finish()
        }
    }
}