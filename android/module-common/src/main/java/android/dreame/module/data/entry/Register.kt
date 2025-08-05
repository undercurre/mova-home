package android.dreame.module.data.entry

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/08/20
 *     desc   :
 *     version: 1.0
 * </pre>
 */
data class EmailRegisterReq(
    val email: String,
    val password: String,
    val confirmedPassword: String,
    val country: String,
    val lang: String,
    val socialUUid:String? = null,
    val source:String? = null
)