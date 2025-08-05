package android.dreame.module.data.datasource.local

import android.dreame.module.data.entry.UserInfo
import android.dreame.module.data.store.AccountStore

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/08/20
 *     desc   :
 *     version: 1.0
 * </pre>
 */
class MineLocalDataSource {
    suspend fun saveUserInfo(userInfo: UserInfo) {
        AccountStore.userInfo = userInfo
    }

    suspend fun getLocalUserInfo(): UserInfo? {
        return AccountStore.userInfo

    }
}