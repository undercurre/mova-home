package android.dreame.module.data.datasource.remote

import android.dreame.module.data.entry.ModifyPassword
import android.dreame.module.data.entry.SettingPassword
import android.dreame.module.data.network.service.DreameService
import android.dreame.module.ext.processApiResponse

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/08/20
 *     desc   :
 *     version: 1.0
 * </pre>
 */
class PasswordRemoteDataSource {

    /**
     * 设置密码
     */
    suspend fun settingPassword(params: SettingPassword) = processApiResponse {
        DreameService.settingPassword(params)
    }


    /**
     * 设置密码
     */
    suspend fun modifyPassword(params: ModifyPassword) = processApiResponse {
        DreameService.modifyPassword(params)
    }
}