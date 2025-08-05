package android.dreame.module.data.store

import android.dreame.module.LocalApplication
import android.dreame.module.data.entry.OAuthRes
import android.dreame.module.data.entry.UserInfo
import android.dreame.module.util.SPUtil

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/07/30
 *     desc   :
 *     version: 1.0
 * </pre>
 */
object AccountStore {
    private val mmkv = SPUtil.createPreference(LocalApplication.getInstance(), "sp_account")
    private val androidSp = SPUtil.createAndroidSp(LocalApplication.getInstance(), "sp_account")

    var auth: OAuthRes? by JsonSpDelegate(mmkv, androidSp, "account", OAuthRes::class.java)

    var userInfo: UserInfo? by JsonSpDelegate(mmkv, androidSp, "userInfo", UserInfo::class.java)

    var loginAccount: String by SpDelegate(androidSp, "loginAccount", "")

    var loginMobile: String by SpDelegate(androidSp, "loginMobile", "")
}