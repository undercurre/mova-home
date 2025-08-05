package com.dreame.smartlife.config.step

import android.dreame.module.data.Result
import android.dreame.module.data.datasource.local.ProductLocalDataSource
import android.dreame.module.data.datasource.remote.ProductRemoteDataSource
import android.dreame.module.data.entry.device.DevicePairReq
import android.dreame.module.data.network.service.DreameService
import android.dreame.module.data.repostitory.ProductRepository
import android.dreame.module.ext.processApiResponse
import android.dreame.module.rn.load.RnCacheManager
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ExceptionStatisticsEventCode
import android.dreame.module.trace.ModuleCode
import android.dreame.module.trace.PairNetEventCode
import android.dreame.module.util.LocationUtils
import android.dreame.module.util.LogUtil
import android.os.Message
import android.os.SystemClock
import android.text.TextUtils
import com.dreame.feature.connect.trace.BuriedConnectHelper
import com.dreame.feature.connect.trace.EventConnectPageHelper
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

/**
 * # 检查设备pair状态
 * 断开设备热点,检查设备pair状态,轮询10次,10s一次
 * 成功:检查设备在线状态 [StepCheckDeviceOnLineState]
 * 失败:结束配网,显示重试按钮
 */
class StepCheckDevicePairState : SmartStepConfig() {
    private var errorMsg = ""
    private var errorCode = -1
    private var job: Job? = null
    override fun stepName(): Step = Step.STEP_CHECK_DEVICE_PAIR_STATE

    override fun handleMessage(msg: Message) {
    }

    override fun stepCreate() {
        super.stepCreate()
        LogUtil.i(TAG, "stepCreate: StepCheckDevicePairState")
        getHandler().sendMessage(Message.obtain().apply {
            obj = StepResult(StepName.STEP_PAIR, StepState.START)
        })
        launch {
            val index = StepData.deviceApName.indexOf("_miap")
            val model = if (index != -1) {
                StepData.deviceApName.replace("-", ".").substring(0, index)
            } else ""
            val isCnLimit = checkoutModelInfo(model)
            LogUtil.i(TAG, "requestLocation isCnLimit: $isCnLimit")
            val int3 = if (LocationUtils.lastLocation == null && LocationUtils.lastAddress == null) {
                0
            } else if (LocationUtils.lastLocation != null && LocationUtils.lastAddress != null) {
                1
            } else {
                2
            }

            if (isCnLimit) {
                EventCommonHelper.eventCommonPageInsert(
                    ModuleCode.ExceptionStatistics.code,
                    ExceptionStatisticsEventCode.GPS_LOCK.code,
                    0,
                    StepData.deviceId,
                    model = model,
                    int1 = if (LocationUtils.lastAreaCode.isNullOrBlank()) 2 else 1,
                    int2 = if (LocationUtils.lastAddress == null) 0 else if (isCnLimit) 1 else 2,
                    int3 = int3,
                    str1 = LocationUtils.lastAddress?.countryName ?: LocationUtils.lastAddress?.countryCode ?: "",
                    str2 = LocationUtils.lastAddress?.locality ?: LocationUtils.lastAddress?.adminArea ?: "",
                    str3 = "",
                    rawStr = LocationUtils.lastAddress?.toString() ?: ""
                )
                // 跳转配网失败
                finish(false)
                getHandler().sendMessage(Message.obtain().apply {
                    obj = StepResult(StepName.STEP_PAIR, StepState.FAILED, reason = "pair fail")
                })
            } else {
                EventCommonHelper.eventCommonPageInsert(
                    ModuleCode.ExceptionStatistics.code,
                    ExceptionStatisticsEventCode.GPS_LOCK.code,
                    0,
                    StepData.deviceId,
                    model = model,
                    int1 = if (LocationUtils.lastAreaCode.isNullOrBlank()) 2 else 1,
                    int2 = 0,
                    int3 = int3,
                    str1 = LocationUtils.lastAddress?.countryName ?: LocationUtils.lastAddress?.countryCode ?: "",
                    str2 = LocationUtils.lastAddress?.locality ?: LocationUtils.lastAddress?.adminArea ?: "",
                    str3 = "",
                    rawStr = LocationUtils.lastAddress?.toString() ?: ""
                )
                checkDevicePairResult()
            }
        }
    }

    override fun stepDestroy() {
        job?.cancel()
    }

    private suspend fun checkoutModelInfo(model: String): Boolean {
        /// 判断缓存的设备是否已经有了model info , 没有的话就查询一下
        val dreameWifiDeviceBean = StepData.scanDeviceList.firstOrNull {
            it.product_model == model || it.deviceProduct?.quickConnects?.values?.contains(model) == true
        }
        val extendScType = if (dreameWifiDeviceBean == null && StepData.productModel != model && !StepData.productModels.contains(model)) {
            LogUtil.i(TAG, "checkoutModelInfo queryDeviceByModel $model")
            queryDeviceExtendScTypeByModel(model)
        } else {
            if (dreameWifiDeviceBean != null) {
                dreameWifiDeviceBean.extendScType ?: listOf()
            } else {
                StepData.extendScType
            }
        }
        LogUtil.i(
            TAG,
            "checkoutModelInfo queryDeviceByModel model: $model ,countrycode:${LocationUtils.lastAreaCode} ,extendScType: ${extendScType?.joinToString()}"
        )
        if (extendScType?.contains(ExtendScType.GPS_LOCK) == true) {
            /// 锁区校验
            // 查询model信息
            return if (LocationUtils.lastAreaCode.isNullOrBlank()) {
                val pair = LocationUtils.getCurrentLocationAreaCode()
                return LocationUtils.isGpsLock(pair.second ?: "")
            } else {
                LocationUtils.isGpsLock(LocationUtils.lastAreaCode ?: "")
            }
        }
        return false
    }

    private suspend fun queryDeviceExtendScTypeByModel(model: String): List<String>? {
        // 组参数
        val startTime = SystemClock.elapsedRealtime()
        var curTime = SystemClock.elapsedRealtime()

        // 请求 pair 接口结果
        delay(3 * 1000)
        while (curTime - startTime <= 10 * 10 * 1000) {
            val extendScType = queryModelExtendScType(model)
            if (extendScType != null) {
                return extendScType
            }
            delay(1000)
            curTime = SystemClock.elapsedRealtime()
        }
        return null
    }

    private fun checkDevicePairResult() {
        job = launch {
            val startTime = SystemClock.elapsedRealtime()
            var curTime = SystemClock.elapsedRealtime()
            var pairResult = false
            // 请求 pair 接口结果
            delay(3 * 1000)
            while (curTime - startTime <= 10 * 10 * 1000) {
                val devicePair = getDevicePair()
                if (devicePair) {
                    pairResult = true
                    return@launch
                }
                delay(1000)
                curTime = SystemClock.elapsedRealtime()
            }

            if (errorCode != -1) {
                EventConnectPageHelper.insertStepErrorEntity(errorCode, 0, "", errorMsg)
            }
            /// 配网耗时
            trackPairResult(0)
            // pair fail
            LogUtil.i(TAG, "checkDevicePairResult: fail")
            finish(false)
            getHandler().sendMessage(Message.obtain().apply {
                obj = StepResult(StepName.STEP_PAIR, StepState.FAILED, reason = "pair fail")
            })
        }
    }

    private fun trackPairResult(result: Int) {
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code,
            PairNetEventCode.PageCostTime.code, 0,
            StepData.deviceId,
            StepData.deviceModel(),
            int1 = result,
            int2 = BuriedConnectHelper.currentEnterType(),
            int3 = StepData.pairNetMethod /*获取配网方式*/,
            int5 = StepData.calculateConnectCostTime(),
            str1 = BuriedConnectHelper.currentSessionID(),
            rawStr = StepData.capabilities ?: ""
        )
    }

    private fun aliDevice() = run {
        !TextUtils.isEmpty(StepData.feature) && StepData.feature.contains("video_ali")
    }

    suspend fun getDevicePair(): Boolean {
        val result = processApiResponse {
            DreameService.getDevicePair(DevicePairReq(StepData.deviceId))
        }
        LogUtil.i(TAG, "checkDevicePairResult: response json is: $result")
        if (result is Result.Success && result.data == true) {
            errorCode = -1
            errorMsg = ""
            LogUtil.i(TAG, "checkDevicePairResult: success to next step ${StepData.deviceId}")
            getHandler().sendMessage(Message.obtain().apply {
                obj = StepResult(StepName.STEP_PAIR, StepState.SUCCESS)
            })
            if (aliDevice()) {
                nextStep(Step.STEP_BIND_ALI_DEVICE)
            } else {
                nextStep(Step.STEP_CHECK_DEVICE_ONLINE_STATE)
            }
            trackPairResult(1)
            // 清除缓存
            RnCacheManager.clearCacheByDid(StepData.deviceId)
            return true
        } else {
            if (result is Result.Success) {
                errorCode = 5
                errorMsg = ""

            } else if (result is Result.Error) {
                errorCode = 6
                errorMsg = "${result.exception}"
            }
            return false
        }
    }

    private suspend fun queryModelExtendScType(model: String): List<String>? {
        val result = processApiResponse {
            DreameService.getProductsCategoryByModels(model)
        }
        if (result is Result.Success) {
            // 处理数据
            val data = result.data
            if (data?.isNotEmpty() == true) {
                return data[0].extendScType ?: listOf()
            } else {
                return listOf()
            }
        } else if (result is Result.Error) {
            LogUtil.e(TAG, "queryDeviceByModel: ${result.exception}")
            if (result.exception.code == -1) {
                // 继续
            } else {
                return null
            }
        }
        return null
    }

}