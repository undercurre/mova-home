package android.dreame.module.data.entry

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/07/30
 *     desc   :
 *     version: 1.0
 * </pre>
 */
data class UserInfo(
    val account: String,
    val uid: String,
    val name: String,
    val avatar: String,
    val email: String,
    val phone: String,
    val phoneCode: String,
    val country: String,
    val lang: String,
    val hasPass: Boolean,
    val devOption: String,
    val sources: List<String>
)