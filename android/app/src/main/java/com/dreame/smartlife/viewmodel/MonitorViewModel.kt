package com.dreame.smartlife.viewmodel

import android.dreame.module.bean.DeviceListBean
import android.dreame.module.bean.DeviceListBean.Device
import android.dreame.module.data.Result
import android.dreame.module.data.network.service.DreameService
import android.dreame.module.dto.IoTActionReq
import android.dreame.module.dto.IoTBaseReq
import android.dreame.module.ext.processApiResponse
import android.dreame.module.util.ActivityUtil
import android.dreame.module.util.LogUtil
import android.dreame.module.util.alify.AliAuthHelper
import android.dreame.module.util.alify.BindAliHelper
import android.text.TextUtils
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.dreame.smartlife.ui2.home.call.VideoCallActivity
import kotlinx.coroutines.launch
import java.util.*


class MonitorViewModel : ViewModel() {

    private val TAG = "MonitorViewModel"

    private var _isCheckingCallStatus = false
        @Synchronized
        set
    val isCheckingCallStatus = _isCheckingCallStatus
    val isShowingCall: Boolean
        get() {
           return ActivityUtil.getInstance().topActivity is VideoCallActivity
        }

    fun sendStopAction(
        targetDomain: String,
        deviceId: String,
        successBlock: () -> Unit,
        failBlock: () -> Unit
    ) {
        viewModelScope.launch {
            runCatching {
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
                    siid = 4
                    aiid = 2
                }
                data.params = params
                ioTReq.data = data
                processApiResponse {
                    DreameService.sendAction(targetDomain.split(".").toTypedArray()[0], ioTReq)
                }
            }.onSuccess {
                if (it is Result.Success) {
                    successBlock.invoke()
                } else {
                    failBlock.invoke()
                }
            }.onFailure {
                failBlock.invoke()
            }
        }
    }

    fun checkAliDeviceInfo(
        device: DeviceListBean.Device,
        successBlock: (iotId: String) -> Unit,
        failBlock: (error: String?) -> Unit,
        loadingCallback: ((show: Boolean) -> Unit)? = null
    ) {
        BindAliHelper.checkAliDeviceInfo(device, successBlock, failBlock, loadingCallback)
    }

    fun aliSDKAuth() {
        AliAuthHelper.aliAuth({ needRestartApp ->
            LogUtil.i("MonitorViewModel", "auth success needRestartApp $needRestartApp")
        }) { code, error ->
            LogUtil.i("MonitorViewModel", "auth fail: $error -- $code")
        }
    }

    fun checkVideoCallState(
        targetDomain: String,
        deviceId: String,
        successBlock: (state: String) -> Unit,
        failBlock: () -> Unit
    ) {
        viewModelScope.launch {
            runCatching {
                _isCheckingCallStatus = true
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
                    siid = 10001
                    aiid = 6
                    `in` = mutableListOf(IoTActionReq.ParamsDTO.InDTO().apply {
                        piid = 201
                        value = "check"
                    })
                }
                data.params = params
                ioTReq.data = data
                processApiResponse {
                    DreameService.sendAction(
                        targetDomain.split(".").toTypedArray()[0],
                        ioTReq
                    )
                }
            }.onSuccess {
                _isCheckingCallStatus = false
                if (it is Result.Success) {
                    val actionResult = it.data
                    actionResult?.let { result ->
                        val resultDTO = result.result
                        if (resultDTO.code == 0 && resultDTO.out.isNotEmpty()) {
                            val value = resultDTO.out[0].value
                            LogUtil.i(TAG, "checkVideoCallState: success value is: $value")
                            if (!TextUtils.isEmpty(value)) {
                                successBlock.invoke(value)
                            }
                        }
                    }
                } else {
                    failBlock.invoke()
                }
            }.onFailure {
                _isCheckingCallStatus = false
                failBlock.invoke()
            }
        }
    }

    fun acceptOrRejectCall(
        accept: Boolean,
        device: Device,
        successBlock: (() -> Unit)? = null,
        failBlock: (() -> Unit)? = null
    ) {
        viewModelScope.launch {
            runCatching {
                val requestId = Random().nextInt(500000) + 100
                val ioTReq = IoTBaseReq<IoTActionReq>().apply {
                    id = requestId
                    did = device.did
                }
                val data = IoTActionReq().apply {
                    id = requestId
                    method = "action"
                }
                val params = IoTActionReq.ParamsDTO().apply {
                    did = device.did
                    siid = 10001
                    aiid = 6
                    `in` = mutableListOf(IoTActionReq.ParamsDTO.InDTO().apply {
                        piid = 201
                        value = if (accept) "accept" else "reject"
                    })
                }
                data.params = params
                ioTReq.data = data
                processApiResponse {
                    DreameService.sendAction(
                        device.bindDomain.split(".").toTypedArray()[0],
                        ioTReq
                    )
                }
            }.onSuccess {
                if (it is Result.Success) {
                    successBlock?.invoke()
                } else {
                    failBlock?.invoke()
                }
            }.onFailure {
                failBlock?.invoke()
            }
        }
    }

    fun showCallView(showCall: () -> Unit) {
        ActivityUtil.getInstance().topActivity?.let {
            if (it !is VideoCallActivity) {
                showCall.invoke()
            }
        }
    }

}