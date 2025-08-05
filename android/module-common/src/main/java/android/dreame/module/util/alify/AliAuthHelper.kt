package android.dreame.module.util.alify

import android.dreame.module.data.network.service.DreameService
import android.dreame.module.manager.AccountManager
import android.dreame.module.manager.AreaManager
import android.dreame.module.util.LogUtil
import com.aliyun.iot.aep.sdk.IoTSmart
import com.dreame.sdk.alify.AliFySdk
import com.dreame.sdk.alify.callback.IAliLoginCallback
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlinx.coroutines.withContext
import kotlin.coroutines.resumeWithException

typealias AliAuthSuccess = (needRestartApp: Boolean) -> Unit
typealias AliAuthFail = (code: Int?, error: String?) -> Unit

object AliAuthHelper : CoroutineScope by MainScope() {

    fun aliAuth(authSuccess: AliAuthSuccess? = null, authFail: AliAuthFail? = null) {
        launch {
            runCatching {
                aliFyAuth()
            }.onSuccess {
                authSuccess?.invoke(it)
            }.onFailure {
                authFail?.invoke(-1, it.message)
            }
        }
    }

    suspend fun aliFyAuth() = withContext(Dispatchers.IO) {
        AccountManager.getInstance().setAliAuthCode("")
        val result = DreameService.aliFyAuth()
        val domainAliFy = AreaManager.getCurrentCountry().domainAliFy
        authLogin(result.data, domainAliFy)
    }

    private suspend fun authLogin(authCode: String, domainAliFy: String) =
        suspendCancellableCoroutine {
            LogUtil.i("AliAuthHelper", "authLogin setCountry: $domainAliFy")
            IoTSmart.setCountry(domainAliFy) { needRestartApp ->
                AliFySdk.getInstance().authLogin(authCode, object : IAliLoginCallback {
                    override fun onLoginSuccess() {
                        AccountManager.getInstance().setAliAuthCode("$authCode-$domainAliFy")
                        it.resume(needRestartApp, null)
                    }

                    override fun onLoginFailed(code: Int, error: String?) {
                        it.resumeWithException(IllegalStateException("code=$code, error=$error"))
                    }
                })
            }
        }

}