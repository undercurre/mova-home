package com.dreame.feature.connect.scan

import android.dreame.module.LocalApplication
import android.dreame.module.bean.ProductListContent
import android.dreame.module.data.Result
import android.dreame.module.data.entry.ProductListBean
import android.dreame.module.data.network.service.DreameService
import android.dreame.module.ext.processApiResponse
import android.dreame.module.manager.LanguageManager
import android.dreame.module.util.LogUtil
import android.util.ArrayMap
import androidx.core.text.isDigitsOnly
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOf

/**
 * 查询扫描到的设备
 */
class DeviceScanQuery {
    private val TAG = "QueryScanDevice"

    fun queryDeviceModel(arrayMap: ArrayMap<String, Boolean>) = flow {
        val parameters = combiningRequestParameters(arrayMap)
        val models = parameters.first
        val productIds = parameters.second
        LogUtil.d(TAG, "queryDeviceModel:  $models  -----  $productIds")
        val list = if (models.isNotEmpty()) {
            queryDeviceByModel(models)
        } else {
            emptyList()
        }
        val list1 = if (productIds.isNotEmpty()) {
            queryDeviceByProductId(productIds)
        } else {
            emptyList()
        }
        emit(list + list1)
    }

    /**
     * 组合请求参数
     */
    private fun combiningRequestParameters(arrayMap: ArrayMap<String, Boolean>): Pair<String, String> {
        val modelSb = StringBuilder()
        val productIdSb = StringBuilder()
        for (entity in arrayMap) {
            val model = entity.key
            val value = entity.value
            if (!value) {
                if (model.isDigitsOnly()) {
                    if (productIdSb.isNotEmpty()) {
                        productIdSb.append(",")
                    }
                    productIdSb.append(model)
                } else {
                    if (modelSb.isNotEmpty()) {
                        modelSb.append(",")
                    }
                    modelSb.append(model)
                }
            }
        }
        if (modelSb.isEmpty() && productIdSb.isEmpty()) {
            return "" to ""
        }
        return modelSb.toString() to productIdSb.toString()
    }

    private suspend fun queryDeviceByModel(params: String): List<ProductListBean> {
        // 组参数
        val result = processApiResponse {
            DreameService.getProductsCategoryByModels(params)
        }
        if (result is Result.Success) {
            // 处理数据
            val data = result.data
            return data ?: emptyList()
        }
        return emptyList()

    }

    private suspend fun queryDeviceByProductId(params: String): List<ProductListBean> {
        val result = processApiResponse {
            DreameService.getProductsCategoryByPids(params)
        }
        if (result is Result.Success) {
            // 处理数据
            val data = result.data
            return data ?: emptyList()
        }
        return emptyList()
    }

}
