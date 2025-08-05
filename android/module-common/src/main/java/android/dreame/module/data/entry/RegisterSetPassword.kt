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
data class RegisterByPhoneReq(
    val phone: String,
    val phoneCode: String,
    val password: String,
    val confirmedPassword: String,
    val country: String,
    val lang: String,
    val codeKey: String
)

data class RegisterByPhoneAndPasswordReq(
    val phone: String,
    val phoneCode: String,
    val password: String,
    val country: String,
    val lang: String,
    val codeKey: String,
    val codeValue:String
)