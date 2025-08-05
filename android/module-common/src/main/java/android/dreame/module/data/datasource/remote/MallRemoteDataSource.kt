package android.dreame.module.data.datasource.remote

import android.dreame.module.data.network.service.DreameMallLoginService
import android.dreame.module.ext.processApiResponse
import android.dreame.module.ext.processMallApiResponse

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/08/20
 *     desc   :
 *     version: 1.0
 * </pre>
 */
class MallRemoteDataSource {

    suspend fun mallLogin(req: Map<String, String>) = processApiResponse {
        DreameMallLoginService.mallLogin(req)
    }

    suspend fun mallPersonInfo(req: Map<String, String>) = processMallApiResponse {
        DreameMallLoginService.mallPersonInfo(req)
    }


}