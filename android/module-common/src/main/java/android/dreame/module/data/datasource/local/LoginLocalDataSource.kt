package android.dreame.module.data.datasource.local

import android.dreame.module.data.entry.OAuthRes
import android.dreame.module.data.entry.UserInfo
import android.dreame.module.data.store.AccountStore
import android.dreame.module.manager.AccountManager

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/08/20
 *     desc   :
 *     version: 1.0
 * </pre>
 */
class LoginLocalDataSource {
    fun saveAccount(auth: OAuthRes) {
        AccountStore.auth = auth
    }

    fun getAccount(): OAuthRes? = AccountStore.auth

    fun saveUserInfo(userInfo: UserInfo?){
        AccountStore.userInfo = userInfo
    }
}