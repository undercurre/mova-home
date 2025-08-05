package android.dreame.module.exception


/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/08/04
 *     desc   :
 *     version: 1.0
 * </pre>
 */
class DreameAuthException(val errCode: Int, val errMsg: String?) :
    DreameException(errCode, errMsg) {
    var maximum: String? = null
    var remains: String? = null
    var oauthSource:String? = null
    var uuid:String? = null
}