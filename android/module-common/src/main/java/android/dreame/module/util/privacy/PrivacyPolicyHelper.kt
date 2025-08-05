package android.dreame.module.util.privacy

import android.app.Activity
import android.dreame.module.R
import android.dreame.module.RoutPath
import android.dreame.module.constant.Constants
import android.dreame.module.data.Result
import android.dreame.module.data.entry.PrivacyListBean
import android.dreame.module.data.entry.PrivacyUpgradeBean
import android.dreame.module.data.network.service.DreameService
import android.dreame.module.ext.processApiResponse
import android.dreame.module.manager.AreaManager
import android.dreame.module.util.LogUtil
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.lifecycleScope
import com.therouter.TheRouter
import com.dreame.hacklibrary.HackJniHelper
import android.dreame.module.util.toast.ToastUtils
import com.tencent.mmkv.MMKV
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn
import kotlinx.coroutines.launch
import org.json.JSONObject

/**
 * 首页发现设备
 */

object PrivacyPolicyHelper {
    private val mmkv by lazy { MMKV.mmkvWithID("privacy_policy", MMKV.SINGLE_PROCESS_MODE, HackJniHelper.getCryptKey()) }
    private var agreementListBean: PrivacyListBean? = null
    private var privacyListBean: PrivacyListBean? = null

    private const val KEY_VERSION_AGREEMENT = "version_agreement"
    private const val KEY_VERSION_POLICY = "version_prolicy"

    private const val KEY_FEEDBACK_PROLICY = "key_feedback_prolicy"
    private const val KEY_FEEDBACK_AGREEMENT = "key_feedback_agreement"

    private const val KEY_URL_AGREEMENT = "url_feedback_agreement"
    private const val KEY_URL_PROLICY = "url_feedback_prolicy"

    fun clearPrivacyMMkv() {
        mmkv.remove(getAgreementVersionKey())
        mmkv.remove(getPolicyVersionKey())
        mmkv.remove(getAgreementUrlKey())
        mmkv.remove(getPolicyUrlKey())
        mmkv.remove(getFeedbackPolicyKey())
        mmkv.remove(getFeedbackAgreementKey())
    }

    /// 给flutter 使用
    fun getFlutterPrivacyMMkv(): String {
        val jsonObject = JSONObject()
        val agreementVersion = mmkv.decodeInt(getAgreementVersionKey())
        val agreementUrl = mmkv.decodeString(getAgreementUrlKey())
        val policyVersion = mmkv.decodeInt(getPolicyVersionKey())
        val policyUrl = mmkv.decodeString(getPolicyUrlKey())

        jsonObject.put("privacyUrl", policyUrl ?: "")
        jsonObject.put("privacyVersion", policyVersion)
        jsonObject.put("agreementUrl", agreementUrl ?: "")
        jsonObject.put("agreementVersion", agreementVersion)
        val region = AreaManager.getRegion()
        jsonObject.put("domain", region)
        return jsonObject.toString()
    }

    fun saveFlutterPrivacyMMkv(json: String) {
        val jsonObject = JSONObject(json)
        val privacyVersion = jsonObject.getInt("privacyVersion")
        val privacyUrl = jsonObject.getString("privacyUrl")
        val agreementVersion = jsonObject.getInt("agreementVersion")
        val agreementUrl = jsonObject.getString("agreementUrl")

        mmkv.encode(getPolicyUrlKey(), privacyUrl)
        mmkv.encode(getAgreementUrlKey(), agreementUrl)

        mmkv.encode(getPolicyVersionKey(), privacyVersion)
        mmkv.encode(getAgreementVersionKey(), agreementVersion)
    }

    private fun getAgreementVersionKey() = privacyPrefix() + KEY_VERSION_AGREEMENT
    private fun getPolicyVersionKey() = privacyPrefix() + KEY_VERSION_POLICY

    private fun getAgreementUrlKey() = privacyPrefix() + KEY_URL_AGREEMENT
    private fun getPolicyUrlKey() = privacyPrefix() + KEY_URL_PROLICY

    private fun getFeedbackPolicyKey() = privacyPrefix() + KEY_FEEDBACK_PROLICY
    private fun getFeedbackAgreementKey() = privacyPrefix() + KEY_FEEDBACK_PROLICY

    fun getVersionByType(type: Int) = mmkv.getInt(getVersionKeyByType(type), 0)
    fun getUrlByType(type: Int) = mmkv.getString(getUrlKeyByType(type), "")

    private fun getVersionKeyByType(type: Int) =
        when (type) {
            PrivacyPolicyConstants.TYPE_POLICY -> {
                getPolicyVersionKey()
            }

            PrivacyPolicyConstants.TYPE_AGREEMENT -> {
                getAgreementVersionKey()
            }

            else -> {
                ""
            }
        }

    private fun getUrlKeyByType(type: Int) =
        when (type) {
            PrivacyPolicyConstants.TYPE_POLICY -> {
                getPolicyUrlKey()
            }

            PrivacyPolicyConstants.TYPE_AGREEMENT -> {
                getAgreementUrlKey()
            }

            else -> {
                ""
            }
        }

    fun getFeedbackKeyByType(type: Int) =
        when (type) {
            PrivacyPolicyConstants.TYPE_POLICY -> {
                getFeedbackPolicyKey()
            }

            PrivacyPolicyConstants.TYPE_AGREEMENT -> {
                getFeedbackAgreementKey()
            }

            else -> {
                ""
            }
        }

    fun isPrivacyPolicyValid(): Boolean {
        return agreementListBean != null && privacyListBean != null
    }

    fun getPrivacyPolicyUrl(): String {
        return privacyListBean?.url ?: ""
    }

    fun getAgreementUrl(): String {
        return agreementListBean?.url ?: ""
    }


    private suspend fun queryPrivacyPolicy(): Pair<Int, String> {
        val processApiResponse = processApiResponse {
            DreameService.getPrivacy("")
        }
        if (processApiResponse is Result.Success) {
            val data = processApiResponse.data
            data?.let { handleResult(it) }
            return 0 to ""
        } else if (processApiResponse is Result.Error) {
            return -1 to (processApiResponse.exception.message ?: "")
        }
        return -1 to ""
    }

    private fun handleResult(data: PrivacyUpgradeBean) {
        val list = data.privacyList.sortedBy {
            it.type
        }.toMutableList()
        list.onEach {
            when (it.type) {
                PrivacyPolicyConstants.TYPE_AGREEMENT.toString() -> {
                    agreementListBean = it
                }

                PrivacyPolicyConstants.TYPE_POLICY.toString() -> {
                    privacyListBean = it

                }
            }
        }

        //
        LogUtil.i("---------------------- 隐私 ----------------------------")
        LogUtil.i("--- url: " + mmkv.getString(getAgreementUrlKey(), ""))
        LogUtil.i("--- url: " + mmkv.getString(getPolicyUrlKey(), ""))

        LogUtil.i("--- feedback: " + mmkv.getInt(getFeedbackPolicyKey(), 0))
        LogUtil.i("--- feedback: " + mmkv.getInt(getFeedbackAgreementKey(), 0))

        LogUtil.i("--- version:  " + mmkv.getInt(getPolicyVersionKey(), 0))
        LogUtil.i("--- version: " + mmkv.getInt(getAgreementVersionKey(), 0))

        LogUtil.i("---------------------- 隐私  ---------------------------")

    }

    fun queryPrivacyPolicyUpgradeFlow(version: Int = 0, force: Boolean = false) = flow {
        val processApiResponse = processApiResponse {
            DreameService.getPrivacy(if (version <= 0) "" else version.toString())
        }
        if (processApiResponse is Result.Success) {
            // 判断隐私是否有更新
            val data = processApiResponse.data
            data?.let {
                handleResult(data)
                val showDialog = privacyListBean?.let { checkListData(it) } ?: false
                agreementListBean?.let { checkListData(it) }
                if (showDialog || force) {
                    emit(null to privacyListBean)
                }
            }
        }
    }.flowOn(Dispatchers.IO)

    private fun checkListData(privacyListBean: PrivacyListBean): Boolean {
        var showDialog = false
        when (privacyListBean.type) {
            PrivacyPolicyConstants.TYPE_AGREEMENT.toString() -> {
                // 用户协议
                val versionLocal = mmkv.decodeInt(getAgreementVersionKey())
                val version = privacyListBean.version
                if (version > versionLocal) {
                    // 弹框提示
                    showDialog = true
                    mmkv.encode(getAgreementUrlKey(), privacyListBean.url)
                } else {
                    val decodeString = mmkv.decodeString(getAgreementUrlKey(), "")
                    val url = privacyListBean.url
                    if (url != decodeString) {
                        mmkv.encode(getAgreementUrlKey(), url)
                    }
                }
            }

            PrivacyPolicyConstants.TYPE_POLICY.toString() -> {
                // 隐私政策
                val versionLocal = mmkv.decodeInt(getPolicyVersionKey())
                val version = privacyListBean.version
                if (version > versionLocal) {
                    // 弹框提示
                    showDialog = true
                    mmkv.encode(getPolicyUrlKey(), privacyListBean.url)
                } else {
                    val decodeString = mmkv.decodeString(getPolicyUrlKey(), "")
                    val url = privacyListBean.url
                    if (url != decodeString) {
                        mmkv.encode(getPolicyUrlKey(), privacyListBean.url)
                    }
                }
            }
        }
        return showDialog
    }

    fun savePrivacyPolicyInfo(): Boolean {
        if (agreementListBean == null && privacyListBean == null) {
            LogUtil.e("savePrivacyPolicyInfo: ")
            return false;
        }

        mmkv.encode(getPolicyUrlKey(), privacyListBean?.url)
        mmkv.encode(getAgreementUrlKey(), agreementListBean?.url)

        mmkv.encode(getPolicyVersionKey(), privacyListBean?.version ?: 0)
        mmkv.encode(getAgreementVersionKey(), agreementListBean?.version ?: 0)

        return true
    }

    suspend fun feedbackDefault() {
        val versionFeedback = mmkv.decodeInt(getFeedbackPolicyKey(), 0)
        val versionLocal = mmkv.decodeInt(getPolicyVersionKey(), 0)
        if (versionFeedback != versionLocal) {
            val processApiResponse = processApiResponse {
                DreameService.agreePrivacy(versionLocal)
            }
            if (processApiResponse is Result.Success) {
                // 判断隐私是否有更新
                mmkv.encode(getFeedbackPolicyKey(), versionLocal)
            }
        }
    }


    suspend fun feedback(version: Int) {
        val processApiResponse = processApiResponse {
            DreameService.agreePrivacy(version)
        }
        if (processApiResponse is Result.Success) {
            // 判断隐私是否有更新
            mmkv.encode(getFeedbackPolicyKey(), version)
        }
    }


    fun Activity.gotoPrivacyUrl(type: Int = PrivacyPolicyConstants.TYPE_DEFAULT) {
        if (isPrivacyPolicyValid()) {
            gotoUrlShow(type)
            return
        }
        runWithScope {
            val ret = queryPrivacyPolicy()
            if (ret.first == 0) {
                gotoUrlShow(type)
            } else {
                if (type != PrivacyPolicyConstants.TYPE_DEFAULT) {
                    ToastUtils.show(if (ret.second.isBlank()) getString(R.string.operate_failed) else ret.second)
                }
            }
        }
    }

    private fun gotoUrlShow(type: Int) {
        if (!isPrivacyPolicyValid()) {
            // throw exception
            return
        }
        savePrivacyPolicyInfo()
        if (type == PrivacyPolicyConstants.TYPE_DEFAULT) {
            return
        }
        val webType = if (type == PrivacyPolicyConstants.TYPE_POLICY) PrivacyPolicyConstants.TYPE_POLICY else PrivacyPolicyConstants.TYPE_AGREEMENT
        val url = if (type == PrivacyPolicyConstants.TYPE_POLICY) getPrivacyPolicyUrl() else getAgreementUrl()

        TheRouter.build(RoutPath.WEBVIEW_POLICY)
            .withInt(Constants.KEY_TYPE, webType)
            .withString(Constants.KEY_WEB_URL, url)
            .navigation()
    }

    private fun Activity.runWithScope(block: suspend CoroutineScope.() -> Unit) {
        (this as LifecycleOwner).lifecycleScope.launch {
            block()
        }
    }

    private fun privacyPrefix(): String {
        val region = AreaManager.getRegion()
        return if (region == "cn") {
            "cn_"
        } else {
            // 海外
            "abroad_"
        }

    }

    fun handleResultAndSaveInfo(data: PrivacyUpgradeBean) {
        val list = data.privacyList.sortedBy {
            it.type
        }.toMutableList()
        list.onEach {
            when (it.type) {
                PrivacyPolicyConstants.TYPE_AGREEMENT.toString() -> {
                    mmkv.encode(getAgreementUrlKey(), it.url)
                    mmkv.encode(getAgreementVersionKey(), it.version)
                }

                PrivacyPolicyConstants.TYPE_POLICY.toString() -> {
                    mmkv.encode(getPolicyUrlKey(), it.url)
                    mmkv.encode(getPolicyVersionKey(), it.version)

                }
            }
        }
    }

    /**
     * 清除内存缓存
     */
    fun resetPrivacyPolicyInfo() {
        agreementListBean = null
        privacyListBean = null
    }
}