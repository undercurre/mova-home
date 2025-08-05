package android.dreame.module.data.repostitory

import android.dreame.module.LocalApplication
import android.dreame.module.data.Result
import android.dreame.module.data.datasource.local.ProductLocalDataSource
import android.dreame.module.data.datasource.remote.ProductRemoteDataSource
import android.dreame.module.data.network.service.DreameService
import android.dreame.module.ext.processApiResponse
import android.dreame.module.manager.LanguageManager
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn

class ProductRepository(
    private val remoteDataSource: ProductRemoteDataSource,
    private val localDataSource: ProductLocalDataSource,
    private val ioDispatcher: CoroutineDispatcher = Dispatchers.IO
) {

    suspend fun queryProductCategoryList() = flow {
        val result = remoteDataSource.queryProductCategoryList()
        when (result) {
            is Result.Success -> {
            }

            else -> {}
        }
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun checkModel(model: String) = flow {
        val result = remoteDataSource.checkModel(model)
        emit(result)
    }

    suspend fun getProductsCategoryByPids(pids: String) = flow {
        val result = remoteDataSource.getProductsCategoryByPids(pids)
        emit(result)
    }

    suspend fun getProductsCategoryByModels(models: String, language: String) = flow {
        val result = remoteDataSource.getProductsCategoryByModels(models)
        emit(result)
    }

    suspend fun getDomain(region: String) = flow {
        val result = remoteDataSource.getDomain(region)
        emit(result)
    }

    suspend fun getMqttDomainV2(region: String, qrCodePair: Boolean) = flow {
        val result = remoteDataSource.getMqttDomainV2(region, qrCodePair)
        emit(result)
    }

    suspend fun getProductConnectIns(productId: String, language: String) = flow {
        val tenantId = LocalApplication.getInstance().tenantId
        val result = remoteDataSource.getProductConnectIns(productId, language, tenantId)
        emit(result)
    }

    suspend fun getOpenDeviceInfo(productId: String, dictKey: String) = flow {
        val result = remoteDataSource.getOpenDeviceInfo(productId,dictKey)
        emit(result)
    }

    suspend fun getProductInfo(productModel: String) = flow {
        val result = remoteDataSource.getProductInfo(productModel)
        emit(result)
    }
    suspend fun getUrlRedirect(urlRedirect: String) = flow {
        val result = remoteDataSource.getUrlRedirect(urlRedirect)
        emit(result)
    }


}