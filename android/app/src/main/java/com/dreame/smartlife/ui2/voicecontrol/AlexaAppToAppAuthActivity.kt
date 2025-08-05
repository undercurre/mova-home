package com.dreame.smartlife.ui2.voicecontrol

import android.content.Intent
import android.dreame.module.RoutPath
import android.dreame.module.data.Result
import android.dreame.module.data.entry.AlexaBindAuthReq
import android.dreame.module.util.LogUtil
import android.net.Uri
import android.os.Bundle
import androidx.activity.viewModels
import com.therouter.router.Route
import com.dreame.smartlife.databinding.ActivityAlexaApptoappAuthBinding
import com.dreame.smartlife.ui2.base.BaseActivity

/**
 * 在alexa app中绑定技能, 跳转到App,成功后跳转到alexa app
 */
@Route(path = RoutPath.VOICE_CONTROL_ALEXA_AUTH)
class AlexaAppToAppAuthActivity : BaseActivity<ActivityAlexaApptoappAuthBinding>() {

    private val TAG = "AlexaAppToAppBindActivity"

    private val viewModel by viewModels<VoiceControlViewModel>()

    // Constants
    private val QUERY_PARAMETER_KEY_CLIENT_ID = "client_id"
    private val QUERY_PARAMETER_KEY_RESPONSE_TYPE = "response_type"
    private val QUERY_PARAMETER_KEY_STATE = "state"
    private val QUERY_PARAMETER_KEY_SCOPE = "scope"
    private val QUERY_PARAMETER_KEY_REDIRECT_URI = "redirect_uri"

    // Incoming Query Parameters
    private var clientId: String? = null
    private var responseType: String? = null
    private var state: String? = null
    private var scope: String? = null
    private var redirectUri: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent?) {
        super.onNewIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent?) {
        if (intent == null) return
        val appLinkData: Uri? = intent.data ?: intent.getParcelableExtra<Uri?>("alexaUri")
        // Get values from App Link
        clientId = appLinkData?.getQueryParameter(QUERY_PARAMETER_KEY_CLIENT_ID)
        responseType = appLinkData?.getQueryParameter(QUERY_PARAMETER_KEY_RESPONSE_TYPE)
        state = appLinkData?.getQueryParameter(QUERY_PARAMETER_KEY_STATE)
        scope = appLinkData?.getQueryParameter(QUERY_PARAMETER_KEY_SCOPE)
        redirectUri = appLinkData?.getQueryParameter(QUERY_PARAMETER_KEY_REDIRECT_URI)

    }

    override fun initData() {


    }

    override fun initView() {
        binding.btnBind.setOnClickListener {
            // 绑定
            val req = AlexaBindAuthReq(clientId, redirectUri, scope, responseType, state)
            viewModel.skillAuthorizeCode(req)
        }
        binding.btnCancel.setOnClickListener {
            // 取消
            /// 跳转到alexa app
            val url = "$redirectUri#error=access_cancel&" +
                    "state=$state&" +
                    "error_description=cancel by user"
            openAlexaAppToAppUrl(url)

        }

    }

    override fun observe() {
        viewModel.authAlexaResult.observe(this) { result ->
            when (result) {
                is Result.Loading -> {
                    showLoading()
                }

                is Result.Success -> {
                    dismissLoading()
//                    ToastUtils.show(getString(R.string.operate_success))
                    /// 跳转到alexa app
                    val url = "$redirectUri?code=${result.data?.code}&state=$state&source=app"
                    openAlexaAppToAppUrl(url)
                }

                is Result.Error -> {
                    dismissLoading()
//                    ToastUtils.show(getString(R.string.operate_failed))
                    /// 跳转到alexa app
                    val url = "$redirectUri#error=access_denied&" +
                            "state=$state&" +
                            "error_description=${result.exception.message}"
                    openAlexaAppToAppUrl(url)
                }
            }
        }
    }

    private fun openAlexaAppToAppUrl(url: String?) {
        LogUtil.d(TAG, "openAlexaAppToAppUrl: $url")
        try {
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
            startActivity(intent)
        } catch (e: Exception) {
            LogUtil.e(TAG, "openAlexaAppToAppUrl error, url:$url ,error:$e")
        }
        finish()
    }

}