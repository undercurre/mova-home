package android.dreame.module.data.entry

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/08/13
 *     desc   :
 *     version: 1.0
 * </pre>
 */
data class SmsCodeReq(
    val phone: String,
    val phoneCode: String,
    val lang: String,

    val token: String,
    val sessionId: String,
    val sig: String,

    val socialUUid: String? = null,
    val source: String? = null,
    val type: String? = null
)

data class SmsCodeReqCover(
    val phone: String,
    val phoneCode: String,
    val lang: String,

    val token: String,
    val sessionId: String,
    val sig: String,
    // 新接口用
    val skipPhoneBoundVerify: Boolean? = null,
    val socialUUid: String? = null,
    val source: String? = null,
    val type: String? = null,
)


data class SmsCodeRes(
    val codeKey: String,
    val maxSends: Int,
    val resetIn: Int,
    val interval: Int,
    val expireIn: Int,
    val remains: Int,
    val unregistered: Boolean
)
