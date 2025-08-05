package android.dreame.module.data.datasource.remote

import android.dreame.module.data.network.service.DreameService
import android.dreame.module.data.network.service.OtherOriginService
import android.dreame.module.ext.processApiResponse

/**
 * 设备相关查询
 */
class ProductRemoteDataSource {

    suspend fun queryProductCategoryList() = processApiResponse {
        DreameService.queryProductCategoryList()
    }

    suspend fun checkModel(model: String) = processApiResponse {
        DreameService.checkModel(model)
    }

    @Deprecated(message = "Deprecated")
    suspend fun getProductsByModels(models: String, language: String) = processApiResponse {
        DreameService.getProductsByModels(models, language)
    }

    @Deprecated(message = "Deprecated")
    suspend fun getProductsByPids(pids: String) = processApiResponse {
        DreameService.getProductsByPids(pids)
    }

    suspend fun getProductsCategoryByModels(models: String) = processApiResponse {
        DreameService.getProductsCategoryByModels(models)
    }

    suspend fun getProductsCategoryByPids(pids: String) = processApiResponse {
        DreameService.getProductsCategoryByPids(pids)
    }

    suspend fun getDomain(region: String) = processApiResponse {
        DreameService.getDomain(region)
    }

    suspend fun getMqttDomainV2(region: String, qrCodePair: Boolean) = processApiResponse {
        DreameService.getMqttDomainV2(region, qrCodePair)
    }

    suspend fun getProductConnectIns(productId: String, language: String, tenantId: String) = processApiResponse {
        DreameService.getProductConnectIns(productId, language, tenantId)
    }

    suspend fun getOpenDeviceInfo(productId: String, dictKey: String) = processApiResponse {
        DreameService.getOpenDeviceInfo(productId, dictKey)
    }

    suspend fun getProductInfo(productModel: String) = processApiResponse {
        OtherOriginService.getProductInfo(productModel)
    }

    suspend fun getUrlRedirect(urlRedirect: String) = processApiResponse {
        DreameService.getUrlRedirect(urlRedirect)
    }

}