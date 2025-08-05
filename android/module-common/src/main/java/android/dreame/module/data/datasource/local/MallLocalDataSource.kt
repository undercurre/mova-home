package android.dreame.module.data.datasource.local

import android.dreame.module.data.entry.mall.MallLoginRes
import android.dreame.module.data.entry.mall.MallPersonInfoRes
import android.dreame.module.data.store.MallLoginStore


/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/08/20
 *     desc   :
 *     version: 1.0
 * </pre>
 */
class MallLocalDataSource {

    fun saveMallAccountInfo(data: MallLoginRes) {
        MallLoginStore.saveMallInfo(data)
    }
    fun clearMallAccountInfo() = MallLoginStore.clearMallInfo()

    fun saveMallPersonInfo(it: MallPersonInfoRes) {

    }


}