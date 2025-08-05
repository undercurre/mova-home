package android.dreame.module.event

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/12/01
 *     desc   :
 *     version: 1.0
 * </pre>
 */
data class WechatAuthStatus(
    val authCode: String?,
    val errorCode: Int?
)