package android.dreame.module.data.repostitory

import android.dreame.module.data.Result
import android.dreame.module.data.datasource.local.MallLocalDataSource
import android.dreame.module.data.datasource.remote.MallRemoteDataSource
import android.dreame.module.data.entry.mall.*
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn

class MallRepository(
    private val localDataSource: MallLocalDataSource,
    private val remoteDataSource: MallRemoteDataSource,
    private val ioDispatcher: CoroutineDispatcher = Dispatchers.IO
) {

    suspend fun mallLogin(req: MallLoginReq) = flow {
        val result = mallLoginSync(req)
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun mallLoginSync(req: MallLoginReq): Result<MallLoginRes> {
        val result = remoteDataSource.mallLogin(req.toMap())
        if (result is Result.Success) {
            result.data?.let {
                localDataSource.saveMallAccountInfo(it)
            }
        }
        return result;
    }

    suspend fun mallPersonInfo(sessionId: String, userId: String) = flow {
        val req = MallPersonInfoReq(userId, sessionId)
        var result = remoteDataSource.mallPersonInfo(req.toMap())
        if (result is Result.Success) {

        } else if (result is Result.Error) {

        }
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun mallPersonInfoSync(sessionId: String, userId: String): Result<MallPersonInfoRes> {
        val req = MallPersonInfoReq(userId, sessionId)
        var result = remoteDataSource.mallPersonInfo(req.toMap())
        if (result is Result.Success) {

        } else if (result is Result.Error) {

        }
        return result;
    }

}