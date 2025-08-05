package android.dreame.module.data.network.api

import android.dreame.module.data.entry.mall.MallLoginRes
import android.dreame.module.data.entry.mall.MallPersonInfoRes
import android.dreame.module.data.network.HttpResult
import android.dreame.module.data.network.MallHttpResult
import retrofit2.http.*

/**
 * 商城API
 */
interface DreameMallApiService {

    @POST("/main/login/app-login")
    @FormUrlEncoded
    suspend fun mallLogin(@FieldMap req: Map<String, String>): HttpResult<MallLoginRes>

    @FormUrlEncoded
    @POST("/main/my/info")
    suspend fun mallPersonInfo(@FieldMap req: Map<String, String>): MallHttpResult<MallPersonInfoRes>

}