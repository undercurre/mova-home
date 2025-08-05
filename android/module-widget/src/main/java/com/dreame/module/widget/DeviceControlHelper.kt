package com.dreame.module.widget

import android.dreame.module.bean.IoTActionResult
import android.dreame.module.data.Result
import android.dreame.module.data.datasource.local.DeviceLocalDataSource
import android.dreame.module.data.datasource.remote.DeviceRemoteDataSource
import android.dreame.module.data.network.service.DreameService
import android.dreame.module.data.repostitory.DeviceRepository
import android.dreame.module.dto.IoTActionReq
import android.dreame.module.dto.IoTBaseReq
import android.dreame.module.dto.IoTPropertyReq
import android.dreame.module.ext.processApiResponse
import android.dreame.module.trace.AppWidgetEventCode
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ModuleCode
import android.dreame.module.util.GsonUtils
import android.dreame.module.util.LogUtil
import android.dreame.module.util.mqtt.MqttMessageBean
import com.dreame.module.widget.constant.STATUS_APPWIDGET_DEVICE_CLEAN_AREA
import com.dreame.module.widget.constant.STATUS_APPWIDGET_DEVICE_CLEAN_TIME
import com.dreame.module.widget.constant.STATUS_APPWIDGET_DEVICE_POWER
import com.dreame.module.widget.constant.STATUS_APPWIDGET_DEVICE_STATUS
import com.dreame.module.widget.constant.STATUS_APPWIDGET_FAST_COMMAND_LIST
import com.dreame.module.widget.constant.STATUS_APPWIDGET_MSG
import com.dreame.module.widget.constant.STATUS_APPWIDGET_RET
import com.dreame.module.widget.constant.STATUS_APPWIDGET_SUPPORT_VIDEO
import com.google.gson.JsonObject
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.flow
import java.util.Random

class DeviceControlHelper {
    private val repository = DeviceRepository(DeviceRemoteDataSource(), DeviceLocalDataSource())

    /**
     * 开启或中断快捷指令
     */
    suspend fun startOrStopFastCommand(
        latestStatus: Int, host: String,
        did: String, model: String, fastCommandId: Long,
        executingFastCommand: Pair<Long, String>,
        block: (suspend (ret: Int, msg: String) -> Unit)?
    ) {
        if (latestStatus == 16) {
            LogUtil.i("DeviceControlHelper", "srartOrStopFastCommand : latestStatus = 16")
            block?.invoke(0, "")
            return
        }

        if (executingFastCommand.first < 0) {
            val taskState = setOf(1, 3, 4, 5, 7, 9, 10, 11, 12, 15, 17, 18, 20, 21, 25, 27, 97, 98, 99)
            if (latestStatus in taskState) {
                LogUtil.i("DeviceControlHelper", "executingFastCommand.first < 0 $latestStatus")
                interceptCurrentTask(host, did, true) { ret, msg ->
                    executeCommand(host, did, fastCommandId, block)
                }
            } else {
                LogUtil.i("DeviceControlHelper", "executingFastCommand.first < 0  executeCommand ------------ $latestStatus")
                executeCommand(host, did, fastCommandId, block)
            }
        } else {
            if (executingFastCommand.first == fastCommandId) {
                if (executingFastCommand.second == "1") {
                    LogUtil.i("DeviceControlHelper", "executingFastCommand.first < 0  ------------ executingFastCommand.second ==1 startOrStopClean 2")
                    startOrStopClean(host, did, model, 2, block)
                } else if (executingFastCommand.second == "0") {
                    LogUtil.i("DeviceControlHelper", "executingFastCommand.first < 0  ------------ executingFastCommand.second ==1 startOrStopClean 1")
                    startOrStopClean(host, did, model, 1, block)
                } else {
                    LogUtil.i("DeviceControlHelper", "executingFastCommand.first < 0  ------------ executeCommand")
                    executeCommand(host, did, fastCommandId, block)
                }
            } else {
                //其他快捷指令正在执行或者暂停状态
                if (executingFastCommand.second == "1" || executingFastCommand.second == "0") {
                    LogUtil.i("DeviceControlHelper", "executingFastCommand.first != fastCommandId  ------------ interceptCurrentTask")
                    interceptCurrentTask(host, did, true) { ret, msg ->
                        LogUtil.i(
                            "DeviceControlHelper",
                            "executingFastCommand.first != fastCommandId  ------------ interceptCurrentTask executeCommand $fastCommandId"
                        )
                        executeCommand(host, did, fastCommandId, block)
                    }
                } else {
                    LogUtil.i("DeviceControlHelper", "executingFastCommand.first != fastCommandId  executingFastCommand $fastCommandId")
                    executeCommand(host, did, fastCommandId, block)
                }
            }
        }
    }


    /**
     * 点击清扫机器
     */
    suspend fun deviceActionCleanBG(
        latestStatus: Int,
        host: String,
        did: String,
        model: String,
        supportVideoMultitask: Boolean,
        executingFastCommand: Pair<Long, String>? = null,
        block: (suspend (ret: Int, msg: String) -> Unit)? = null
    ) {
        // 中断快捷指令，下发回充
        if (executingFastCommand != null && executingFastCommand.first > 0) {
            interceptCurrentTask(host, did) { ret, msg ->
                startOrStopClean(host, did, model, 1, block)
            }
            return
        }
        // 有视频任务, 终止当前任务, 下发回充
        if (supportVideoMultitask && (latestStatus == 98 || latestStatus == 99)) {
            interceptCurrentTask(host, did) { ret, msg ->
                if (ret == 0) {
                    startOrStopClean(host, did, model, 1, block)
                } else {
                    block?.invoke(ret, msg)
                }
            }
            return
        }
        // 回充或暂停
        val canStop = arrayListOf(1, 7, 9, 10, 11, 12, 15, 16, 17, 18, 20, 22, 23, 25, 26, 27, 97, 98)
        if (canStop.contains(latestStatus)) {
            EventCommonHelper.eventCommonPageInsert(ModuleCode.AppWidget.code, AppWidgetEventCode.Clean.code, 0)
            startOrStopClean(host, did, model, 2, block)
        } else {
            EventCommonHelper.eventCommonPageInsert(ModuleCode.AppWidget.code, AppWidgetEventCode.Pause.code, 0)
            startOrStopClean(host, did, model, 1, block)
        }
    }

    /**
     * 点击回充机器
     */
    suspend fun deviceActionChargingBG(
        latestStatus: Int,
        host: String,
        did: String,
        model: String,
        supportVideoMultitask: Boolean,
        executingFastCommand: Pair<Long, String>? = null,
        block: (suspend (ret: Int, msg: String) -> Unit)? = null
    ) {
        // 中断快捷指令，下发回充
        if (executingFastCommand != null && executingFastCommand.first > 0) {
            interceptCurrentTask(host, did) { ret, msg ->
                chargeOrPause(latestStatus, host, did, model, block)
            }
            return
        }
        // 有视频任务, 终止当前任务, 下发回充
        if (supportVideoMultitask && (latestStatus == 98 || latestStatus == 99)) {
            interceptCurrentTask(host, did) { ret, msg ->
                if (ret == 0) {
                    chargeOrPause(latestStatus, host, did, model, block)
                } else {
                    block?.invoke(ret, msg)
                }
            }
            return
        }
        // 回充或暂停
        chargeOrPause(latestStatus, host, did, model, block)
    }


    suspend fun deviceActionStatusBG(
        host: String,
        deviceId: String, enableFeatCode: Boolean = false
    ) = flow {
        val params: MutableList<IoTPropertyReq.PropertyDTO> = mutableListOf(
            IoTPropertyReq.PropertyDTO().apply {
                did = deviceId
                siid = 2
                piid = 1
            },
            IoTPropertyReq.PropertyDTO().apply {
                did = deviceId
                siid = 3
                piid = 1
            },

            //清扫面积
            IoTPropertyReq.PropertyDTO().apply {
                did = deviceId
                siid = 4
                piid = 3
            },

            //清扫时间
            IoTPropertyReq.PropertyDTO().apply {
                did = deviceId
                siid = 4
                piid = 2
            },
            // 当前是否有快捷指令在执行
            IoTPropertyReq.PropertyDTO().apply {
                did = deviceId
                siid = 4
                piid = 48
            }
        )

        if (enableFeatCode) {
            params.addAll(
                mutableListOf(
                    // 支持视频监控，快捷指令 新特性
                    IoTPropertyReq.PropertyDTO().apply {
                        did = deviceId
                        siid = 4
                        piid = 38
                    },
                    IoTPropertyReq.PropertyDTO().apply {
                        did = deviceId
                        siid = 4
                        piid = 83
                    },
                )
            )
        }
        val requestId = Random().nextInt(500000) + 100
        val req = IoTBaseReq<IoTPropertyReq>().apply {
            id = requestId
            did = deviceId
        }
        val data = IoTPropertyReq().apply {
            id = requestId
            did = deviceId
            method = "get_properties"
        }
        data.params = params
        req.data = data
        repository.trySendCommand(host, req).collect {
            if (it is Result.Success) {
                var data: JsonObject? = null
                try {
                    data = it.data as JsonObject
                } catch (e: Exception) {
                    LogUtil.i("trySendCommand json parse error:${e.message}")
                }
                val result = data?.getAsJsonArray("result")
                result?.let {
                    val paramsDTOS = GsonUtils.parseLists(
                        result.toString(),
                        MqttMessageBean.DataDTO.ParamsDTO::class.java
                    )
                    var deviceStatus = -1
                    var battary = 100

                    var featureCode = -1
                    var featureCode2 = -1
                    var fastCommand: String? = null
                    var cleanArea = -1f
                    var cleanTime = -1

                    if (paramsDTOS.size > 0) {
                        paramsDTOS.onEach {
                            when (it.siid) {
                                2 -> {
                                    when (it.piid) {
                                        1 -> {
                                            // 机器当前状态
                                            if (it.code == 0 || it.code == null) {
                                                deviceStatus = (it.value ?: "0").toInt()
                                            }
                                        }
                                    }
                                }

                                3 -> {
                                    when (it.piid) {
                                        1 -> {
                                            // 机器当前状态
                                            if (it.code == 0 || it.code == null) {
                                                battary = (it.value ?: "0").toInt()
                                            }
                                        }
                                    }
                                }

                                4 -> {
                                    when (it.piid) {
                                        3 -> {
                                            if (it.code == 0 || it.code == null) {
                                                cleanArea = (it.value ?: "-1").toFloat()
                                            }
                                        }

                                        2 -> {
                                            if (it.code == 0 || it.code == null) {
                                                cleanTime = (it.value ?: "-1").toInt()
                                            }
                                        }

                                        38 -> {
                                            if (it.code == 0 || it.code == null) {
                                                featureCode = (it.value ?: "0").toInt()
                                            }
                                        }

                                        83 -> {
                                            if (it.code == 0 || it.code == null) {
                                                featureCode2 = (it.value ?: "0").toInt()
                                            }
                                        }

                                        48 -> {
                                            if (it.code == 0 || it.code == null) {
                                                fastCommand = it.value ?: ""
                                            }
                                        }
                                    }
                                }

                            }
                        }
                        val map = mutableMapOf<String, Any>()
                        map[STATUS_APPWIDGET_RET] = 0
                        map[STATUS_APPWIDGET_DEVICE_STATUS] = deviceStatus
                        map[STATUS_APPWIDGET_DEVICE_POWER] = battary
                        if (fastCommand != null) {
                            map[STATUS_APPWIDGET_FAST_COMMAND_LIST] = fastCommand ?: ""
                        }
                        if (cleanArea != -1f) {
                            map[STATUS_APPWIDGET_DEVICE_CLEAN_AREA] = cleanArea
                        }
                        if (cleanTime != -1) {
                            map[STATUS_APPWIDGET_DEVICE_CLEAN_TIME] = cleanTime
                        }
                        if (enableFeatCode) {
                            val featCode = if (featureCode == -1) 0 else featureCode
                            val featCode2 = if (featureCode2 == -1) 0 else featureCode2
                            map[STATUS_APPWIDGET_SUPPORT_VIDEO] = isShowVideo(featCode, featCode2)
                            map["featureCode"] = featCode
                            map["featureCode2"] = featCode2
                        }
                        LogUtil.d(
                            "sunzhibin",
                            "++++++++deviceActionStatusBG ++++++++++ : $featureCode $featureCode2 ${
                                isShowVideo(
                                    featureCode,
                                    featureCode2
                                )
                            }"
                        )

                        emit(map)
                    }
                }
            } else if (it is Result.Error) {
                val map = mutableMapOf<String, Any>()
                map[STATUS_APPWIDGET_RET] = it.exception.code
                map[STATUS_APPWIDGET_MSG] = it.exception.message ?: ""
                emit(emptyMap())
            }

        }

    }

    /**
     * 同时支持清扫与视频
     */
    fun isShowVideo(featureCode: Int, featureCode2: Int): Boolean {
        val featCode = if (featureCode < 0) 0 else featureCode
        val featCode2 = if (featureCode2 < 0) 0 else featureCode2
        val value = featCode or featCode2
        return value and 1 != 0
    }

    private suspend fun chargeOrPause(latestStatus: Int, host: String, did: String, model: String, block: (suspend (ret: Int, msg: String) -> Unit)? = null) {
        if (latestStatus != 5 && latestStatus != 6) {
            //  startCharge
            EventCommonHelper.eventCommonPageInsert(ModuleCode.AppWidget.code, AppWidgetEventCode.Charge.code, 0)
            startCharge(host, did, block)
        } else {
            EventCommonHelper.eventCommonPageInsert(ModuleCode.AppWidget.code, AppWidgetEventCode.Pause.code, 0)
            startOrStopClean(host, did, model, 2, block)
        }
    }

    private suspend fun startCharge(host: String, did: String, block: (suspend (ret: Int, msg: String) -> Unit)? = null) {
        val inDTOList = mutableListOf<IoTActionReq.ParamsDTO.InDTO>()
        val inDTO3 = IoTActionReq.ParamsDTO.InDTO().apply {
            this.piid = 100
            this.value = "3,{\"app_charge\":1}"
        }
        inDTOList.add(inDTO3)
        sendActionCommand(host, 3, 1, did, inDTOList, block)
    }

    private suspend fun startOrStopClean(host: String, did: String, model: String, aiid: Int, block: (suspend (ret: Int, msg: String) -> Unit)? = null) {
        val oldFramwork = model == "dreame.vacuum.p2029"
        val extraCmd = if (aiid == 1) {
            "2,1,{\"app_auto_clean\":1}"
        } else if (aiid == 2) {
            "1,{\"app_pause\":1}"
        } else {
            null
        }
        val inDTOList = mutableListOf<IoTActionReq.ParamsDTO.InDTO>()
        val inDTO3 = IoTActionReq.ParamsDTO.InDTO().apply {
            this.piid = 100
            this.value = extraCmd
        }
        if (!oldFramwork) {
            inDTOList.add(inDTO3)
        }
        sendActionCommand(host, 2, aiid, did, inDTOList, block)
    }

    private suspend fun sendAction(
        host: String,
        did: String,
        siid: Int,
        aiid: Int,
        block: (suspend (ret: Int, msg: String) -> Unit)? = null
    ) {
        val req: IoTBaseReq<IoTActionReq> = IoTBaseReq<IoTActionReq>().apply {
            val random = Random()
            val id = random.nextInt(10000) + 10000
            this.id = id
            this.did = did

            val data = IoTActionReq()
            data.id = id
            data.method = "action"

            val params = IoTActionReq.ParamsDTO().apply {
                this.did = did
                this.siid = siid
                this.aiid = aiid
            }
            data.params = params
            this.data = data
        }
        repository.sendAction(host, req)
            .collect {
                handleDeviceActionResult(it, block)
            }
    }

    private suspend fun interceptCurrentTask(
        host: String,
        did: String,
        executeCommand: Boolean = true,
        block: (suspend (ret: Int, msg: String) -> Unit)? = null
    ) {
        val req: IoTBaseReq<IoTActionReq> = IoTBaseReq()
        val random = Random()
        val id = random.nextInt(10000) + 10000
        req.id = id
        req.did = did
        val data = IoTActionReq()
        data.id = id
        data.method = "action"
        val params = IoTActionReq.ParamsDTO()
        params.did = did
        params.siid = 4
        params.aiid = 2
        data.params = params
        req.setData(data)
        repository.trySendActionCommand(host, req)
            .collect { result ->
                if (result is Result.Success) {
                    block?.run {
                        if (executeCommand) {
                            delay(800)
                        }
                        block(0, "")
                    }
                } else if (result is Result.Error) {
                    block?.invoke(result.exception.code, result.exception.message ?: "")
                }
            }
    }

    private suspend fun executeCommand(
        host: String,
        deviceId: String,
        fastCommandId: Long,
        block: (suspend (ret: Int, msg: String) -> Unit)?
    ) {
        val inDTOList = mutableListOf<IoTActionReq.ParamsDTO.InDTO>()
        val inDTO = IoTActionReq.ParamsDTO.InDTO().apply {
            this.piid = 1
            this.value = 25
        }
        inDTOList.add(inDTO)

        val inDTO2 = IoTActionReq.ParamsDTO.InDTO().apply {
            this.piid = 10
            this.value = "$fastCommandId"
        }
        inDTOList.add(inDTO2)

        val inDTO3 = IoTActionReq.ParamsDTO.InDTO().apply {
            this.piid = 100
            this.value = "25,{\"task_id\":$fastCommandId}"
        }
        inDTOList.add(inDTO3)
        sendActionCommand(host, 4, 1, deviceId, inDTOList, block)
    }

    private suspend fun sendActionCommand(
        host: String,
        siid: Int,
        aiid: Int,
        deviceId: String,
        inDTOList: MutableList<IoTActionReq.ParamsDTO.InDTO>?,
        block: (suspend (ret: Int, msg: String) -> Unit)? = null
    ) {
        val requestId = Random().nextInt(500000) + 100
        val ioTReq = IoTBaseReq<IoTActionReq>().apply {
            id = requestId
            did = deviceId
        }
        val data = IoTActionReq().apply {
            id = requestId
            method = "action"
        }
        val params = IoTActionReq.ParamsDTO().apply {
            did = deviceId
            this.siid = siid
            this.aiid = aiid
            inDTOList?.let {
                `in` = inDTOList
            }
        }
        data.params = params
        ioTReq.data = data
        runCatching {
            val result = processApiResponse {
                DreameService.trySendActionCommand(host, ioTReq)
            }
            if (result is Result.Success) {
                val data = result.data
                val ret = data?.result
                ret?.let {
                    if (it.code == null || it.code == 0) {
                        block?.invoke(0, "")
                    } else {
                        block?.invoke(it.code, "")
                    }
                }
            }
        }.onFailure {
            it.printStackTrace()
            block?.invoke(-1, it.message ?: "")
        }
    }

    private suspend fun handleDeviceActionResult(result: Result<IoTActionResult>, block: (suspend (ret: Int, msg: String) -> Unit)? = null) {
        if (result is Result.Success) {
            block?.invoke(0, "")
        } else if (result is Result.Error) {
            block?.invoke(result.exception.code, result.exception.message ?: "")
        }
    }


    suspend fun getUserFeatures(did: String, shareUid: String, block: (suspend (ret: Int, result: Boolean, msg: String) -> Unit)?) {
        repository.getUserFeatures(did, shareUid)
            .collect {
                when (it) {
                    is Result.Success -> {
                        val list = it.data?.split(",") ?: emptyList()
                        val hasVideoPermission = list.find { "video".equals(it, true) } != null
                        block?.invoke(0, hasVideoPermission, "")
                    }

                    is Result.Error -> {
                        block?.invoke(it.exception.code, false, it.exception.message ?: "error")
                    }

                    else -> {

                    }
                }
            }
    }
}