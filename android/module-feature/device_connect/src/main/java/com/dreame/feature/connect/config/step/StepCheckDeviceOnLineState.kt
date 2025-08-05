package com.dreame.smartlife.config.step

import android.dreame.module.data.Result
import android.dreame.module.data.network.service.DreameService
import android.dreame.module.dto.IoTBaseReq
import android.dreame.module.dto.IoTPropertyReq
import android.dreame.module.dto.IoTPropertyReq.PropertyDTO
import android.dreame.module.ext.processApiResponse
import android.dreame.module.util.LogUtil
import android.os.Message
import android.os.SystemClock
import android.util.Log
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import java.util.*

/**
 * # 检查设备在线状态
 * 启动插件下载进程,检查设备在线状态,轮询10次,10s一次
 * 成功,失败:完成配网
 */
class StepCheckDeviceOnLineState : SmartStepConfig() {

    private var job: Job? = null

    // 一些需要sendcommand的设备
    private val listSomeModel = listOf("dreame.vacuum.r2312", "dreame.vacuum.r2312a", "dreame.vacuum.r2328")

    override fun stepName(): Step = Step.STEP_CHECK_DEVICE_ONLINE_STATE

    override fun handleMessage(msg: Message) {
    }


    override fun stepCreate() {
        super.stepCreate()
        LogUtil.i(TAG, "stepCreate: StepCheckDeviceOnLineState ${StepData.productModel}")
        // fix：后台APP 不允许创建service Fatal Exception: java.lang.IllegalStateException
        getHandler().sendMessage(Message.obtain().apply {
            obj = StepResult(StepName.STEP_CHECK, StepState.START)
        })

        //
        if (StepData.productModel.isNullOrBlank() || listSomeModel.contains(StepData.productModel)) {
            checkDeviceOnline()
        } else {
            getHandler().sendMessage(Message.obtain().apply {
                obj = StepResult(StepName.STEP_CHECK, StepState.SUCCESS)
            })
            finish(true)
        }
    }

    override fun stepDestroy() {
        job?.cancel()
    }

    private fun checkDeviceOnline() {
        job = launch {
            // 请求 sendcommand 接口结果
            val startTime = SystemClock.elapsedRealtime()
            var curTime = SystemClock.elapsedRealtime()

            while (curTime - startTime <= 10 * 10 * 1000) {
                val checkOnLine = checkOnLine()
                if (checkOnLine) {
                    return@launch
                }
                delay(1000)
                curTime = SystemClock.elapsedRealtime()
            }
            // check fail
            LogUtil.i(TAG, "checkDeviceOnline: fail")
            getHandler().sendMessage(Message.obtain().apply {
                obj = StepResult(StepName.STEP_CHECK, StepState.FAILED, reason = "check fail")
            })
            finish(true)
        }
    }

    private suspend fun checkOnLine(): Boolean {
        val requestId = Random().nextInt(500000) + 100
        val ioTReq = IoTBaseReq<IoTPropertyReq>().apply {
            id = requestId
            did = StepData.deviceId
        }
        val data = IoTPropertyReq().apply {
            id = requestId
            did = StepData.deviceId
            method = "get_properties"
        }
        val params: MutableList<PropertyDTO> = mutableListOf(
            PropertyDTO().apply {
                did = StepData.deviceId
                siid = 3
                piid = 1
            })
        data.params = params
        ioTReq.data = data
        val result = processApiResponse {
            DreameService.trySendCommand(
                StepData.targetDomain.split(".").toTypedArray()[0],
                ioTReq
            )
        }
        LogUtil.i(TAG, "checkDeviceOnline: response: $result")
        if (result is Result.Success) {
            getHandler().sendMessage(Message.obtain().apply {
                obj = StepResult(StepName.STEP_CHECK, StepState.SUCCESS)
            })
            finish(true)
            return true
        }
        return false
    }


}