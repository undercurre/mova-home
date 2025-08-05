package android.dreame.module.data.datasource.remote

import android.dreame.module.data.entry.AlexaApp2AppReq
import android.dreame.module.data.entry.AlexaBindAuthReq
import android.dreame.module.data.entry.AlexaLinkAuthReq
import android.dreame.module.data.network.service.DreameService
import android.dreame.module.ext.processApiResponse

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2022/02/28
 *     desc   :
 *     version: 1.0
 * </pre>
 */
class VoiceControlDataSource {

    suspend fun getAlexaApp2AppUrl(os: String) = processApiResponse {
        DreameService.getAlexaApp2AppUrl(AlexaApp2AppReq(os))
    }

    suspend fun alexaSkillAccountLink(
        awsCode: String,
        redirectUrl: String
    ) = processApiResponse {
        DreameService.alexaSkillAccountLink(
            AlexaLinkAuthReq(
                awsCode,
                redirectUrl
            )
        )
    }

    suspend fun unbindAlexaAccountLink() = processApiResponse {
        DreameService.unbindAlexaAccountLink()
    }

    suspend fun skillAuthorizeCode(req: AlexaBindAuthReq) = processApiResponse {
        DreameService.skillAuthorizeCode(req)
    }

    suspend fun getVoiceProductList(lang: String, version: String, os: String) = processApiResponse {
        DreameService.getVoiceProductList(lang, version, os)
    }

}