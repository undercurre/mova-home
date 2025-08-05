package android.dreame.module.data.repostitory

import android.dreame.module.data.datasource.remote.VoiceControlDataSource
import android.dreame.module.data.entry.AlexaBindAuthReq
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2022/02/28
 *     desc   :
 *     version: 1.0
 * </pre>
 */
class VoiceControlRepository(
    private val voiceControlDataSource: VoiceControlDataSource,
    private val ioDispatcher: CoroutineDispatcher = Dispatchers.IO
) {
    suspend fun getAlexaApp2AppUrl(os: String) = flow {
        val result = voiceControlDataSource.getAlexaApp2AppUrl(os)
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun alexaSkillAccountLink(
        awsCode: String,
        redirectUrl: String
    ) = flow {
        val result = voiceControlDataSource.alexaSkillAccountLink(awsCode, redirectUrl)
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun unbindAlexaAccountLink() = flow {
        emit(voiceControlDataSource.unbindAlexaAccountLink())
    }.flowOn(ioDispatcher)

    suspend fun skillAuthorizeCode(req: AlexaBindAuthReq) = flow {
        emit(voiceControlDataSource.skillAuthorizeCode(req))
    }.flowOn(ioDispatcher)

    suspend fun getVoiceProductList(lang: String, version: String, os: String) = flow {
        emit(voiceControlDataSource.getVoiceProductList(lang, version, os))
    }.flowOn(ioDispatcher)


}