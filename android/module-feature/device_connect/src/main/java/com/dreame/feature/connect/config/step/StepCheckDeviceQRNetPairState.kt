package com.dreame.smartlife.config.step

import android.content.Intent
import android.dreame.module.LocalApplication
import android.dreame.module.data.Result
import android.dreame.module.data.entry.device.DeviceQRNetPairReq
import android.dreame.module.data.entry.device.DeviceQRNetPairRes
import android.dreame.module.data.network.service.DreameService
import android.dreame.module.ext.processApiResponse
import android.dreame.module.rn.load.RnCacheManager
import android.dreame.module.util.LogUtil
import android.os.Message
import android.os.SystemClock
import android.text.TextUtils
import android.util.Log
import com.dreame.feature.connect.trace.EventConnectPageHelper
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

/**
 * 检查二维码配网设备pair状态
 */
class StepCheckDeviceQRNetPairState : SmartStepConfig() {

    private var errorMsg = ""
    private var errorCode = -1
    private var job: Job? = null
    override fun stepName(): Step = Step.STEP_QR_NET_PAIR

    override fun handleMessage(msg: Message) {
    }

    override fun stepCreate() {
        super.stepCreate()
        Log.d(TAG, "stepCreate: StepCheckDevicePairState")
        getHandler().sendMessage(Message.obtain().apply {
            obj = StepResult(StepName.STEP_QR_NET_PAIR, StepState.START)
        })
        if (StepData.deviceId.isNotBlank()) {
            // 下一步
            pairOperationSuccess()
        } else if (StepData.pairQRKey.isNullOrBlank()) {
            getHandler().sendMessage(Message.obtain().apply {
                obj = StepResult(StepName.STEP_QR_NET_PAIR, StepState.FAILED)
            })
        } else {
            checkDevicePairResult()
        }

    }

    override fun stepDestroy() {
        job?.cancel()
    }


    private fun checkDevicePairResult() {
        job = launch {
            val startTime = SystemClock.elapsedRealtime()
            var curTime = SystemClock.elapsedRealtime()

            // 请求 pair 接口结果
            delay(3 * 1000)
            while (curTime - startTime <= 10 * 10 * 1000) {
                val devicePair = geQRNetPaiQRr()
                if (devicePair) {
                    return@launch
                }
                delay(1000)
                curTime = SystemClock.elapsedRealtime()
            }

            if (errorCode != -1) {
                EventConnectPageHelper.insertStepErrorEntity(errorCode, 0, "", errorMsg)
            }
            // pair fail
            LogUtil.i(TAG, "checkDevicePairResult: fail")
            finish(false)
            getHandler().sendMessage(Message.obtain().apply {
                obj = StepResult(StepName.STEP_QR_NET_PAIR, StepState.FAILED, reason = "pair fail")
            })
        }
    }

    private fun aliDevice() = run {
        !TextUtils.isEmpty(StepData.feature) && StepData.feature.contains("video_ali")
    }

    private suspend fun geQRNetPaiQRr(): Boolean {
        val result = processApiResponse {
            DreameService.getDeviceQRNetPairResult(DeviceQRNetPairReq(StepData.pairQRKey ?: ""))
        }
        LogUtil.i(TAG, "checkDevicePairResult: response json is: ${StepData.pairQRKey}  $result")
        if (result is Result.Success && result.data?.success == true) {
            errorCode = -1
            errorMsg = ""
            LogUtil.i(TAG, "checkDevicePairResult: success to next step ${StepData.deviceId}")
            StepData.deviceId = result.data?.did ?: ""
            pairOperationSuccess()
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

    private fun pairOperationSuccess() {
        if (aliDevice() && StepData.deviceId.isNotBlank()) {
            nextStep(Step.STEP_BIND_ALI_DEVICE)
        } else {
            getHandler().sendMessage(Message.obtain().apply {
                obj = StepResult(StepName.STEP_QR_NET_PAIR, StepState.SUCCESS)
            })
            finish(true)
        }
        //清除缓存
        RnCacheManager.clearCacheByDid(StepData.deviceId)
    }

}