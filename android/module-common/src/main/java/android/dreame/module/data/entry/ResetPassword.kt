package android.dreame.module.data.entry

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/08/24
 *     desc   :
 *     version: 1.0
 * </pre>
 */
data class SendSmsCodeReq(
    val phone: String, val phoneCode: String, val lang: String,
    val token: String,
    val sessionId: String,
    val sig: String,
)

data class SendEmailReq(val email: String, val lang: String)

data class ResetPasswordByPhoneReq(
    val codeKey: String,
    val confirmedPassword: String,
    val password: String,
    val phone: String,
    val phoneCode: String
)

data class ResetPasswordByEmailReq(
    val codeKey: String,
    val confirmedPassword: String,
    val email: String,
    val password: String
)
