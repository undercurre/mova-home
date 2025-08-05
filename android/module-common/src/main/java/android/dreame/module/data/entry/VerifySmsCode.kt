package android.dreame.module.data.entry

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/08/19
 *     desc   :
 *     version: 1.0
 * </pre>
 */
data class VerifySmsCodeReq(
    val phone: String,
    val codeValue: String,
    val codeKey: String,
    val phoneCode: String
)

data class VerifyEmailCodeReq(
    val codeKey: String,
    val codeValue: String,
    val email: String
)

data class UnbindCodeReq(
    val codeKey: String,
)
data class UnbindEmailReq(
    val password: String,
)