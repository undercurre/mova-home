package com.dreame.smartlife.config.step

import android.Manifest
import android.content.pm.PackageManager
import android.dreame.module.ext.decodeQuotedSSID
import android.dreame.module.util.LogUtil
import android.net.*
import android.net.wifi.SupplicantState
import android.net.wifi.WifiConfiguration
import android.os.Build
import android.os.Message
import android.text.TextUtils
import androidx.core.app.ActivityCompat
import com.dreame.smartlife.config.event.StepId
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlin.coroutines.cancellation.CancellationException

/**
 * # 连接状态二次确认
 * 检查连接状态
 * 成功:发送数据到设备 [StepSendDataWifi]
 * 失败:
 *  1)可以重试:wifi扫描 [StepWifiScan]
 *  2)重试失败:手动连接 [StepManualConnect]
 */
class StepConnectCheck : SmartStepConfig() {

    override fun stepName(): Step = Step.STEP_CONNECT_CHECK

    override fun maxRetryCount(): Int = 1

    companion object {
        private const val COUNT_RETRY = 1 + 5

        private const val MSG_CODE_CHECK_CONNECT = 40001
        private const val MSG_CODE_CHECK_CONNECT_RETRY = 40002
    }

    private lateinit var launch: Job

    private var isChecking = false;

    override fun handleMessage(msg: Message) {
        when (msg.what) {
            MSG_CODE_CHECK_CONNECT -> {
                if (!isChecking) {
                    isChecking = true
                    checkConnect(msg.arg1 == COUNT_RETRY - 1)
                    isChecking = false
                }
            }

            MSG_CODE_CHECK_CONNECT_RETRY -> {
                if (isGrantedPermission(permissionList)) {
                    nextStep(Step.STEP_MANUAL_CONNECT)
                } else {
                    connectFail()
                }
            }
        }
    }

    override fun registerNetChange(): Boolean {
        return false
    }

    override fun stepCreate() {
        super.stepCreate()
        registerCallback()
        launch = launch {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                delay(1000)
            }
            // 尝试6次
            repeat(COUNT_RETRY) {
                val deviceApName = StepData.deviceApName
                val currentAPName = currentConnectedSsid()
                if (!TextUtils.equals(deviceApName, currentAPName)) {
                    LogUtil.i(TAG, "checkConnect: current: $currentAPName  ,device: $deviceApName  ,次数：$it")
                }
                val obtainMessage = getHandler().obtainMessage(MSG_CODE_CHECK_CONNECT)
                obtainMessage.arg1 = it
                getHandler().sendMessage(obtainMessage)
                delay(1000)
            }
        }
    }

    private fun registerCallback() {
        val builder = NetworkRequest.Builder()
        val request = builder
            .build()
        connectivityManager.registerNetworkCallback(request, networkCallback)
    }

    private val networkCallback = object : ConnectivityManager.NetworkCallback() {
        override fun onCapabilitiesChanged(network: Network, networkCapabilities: NetworkCapabilities) {
            super.onCapabilitiesChanged(network, networkCapabilities)
            //
            if (networkCapabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_VALIDATED)) {
                if (networkCapabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)) {
                    // check 当前连接SSID
                    LogUtil.i(TAG, "onCapabilitiesChanged:  $network  $networkCapabilities")
                    val obtainMessage = getHandler().obtainMessage(MSG_CODE_CHECK_CONNECT)
                    obtainMessage.arg1 = -1
                    getHandler().sendEmptyMessage(MSG_CODE_CHECK_CONNECT)
                }
            }
        }

        override fun onLinkPropertiesChanged(network: Network, linkProperties: LinkProperties) {
            super.onLinkPropertiesChanged(network, linkProperties)
            LogUtil.i(TAG, "onLinkPropertiesChanged:  $network  $linkProperties")
        }
    }

    override fun stepDestroy() {
        try {
            connectivityManager.unregisterNetworkCallback(networkCallback)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun checkConnect(again: Boolean = true) {
        val deviceApName = StepData.deviceApName
        val currentAPName = currentConnectedSsid()
        if (!TextUtils.equals(deviceApName, currentAPName)) {
            if (again) {
                end()
            }
            LogUtil.i(TAG, "checkConnect:currentAPName= $currentAPName  ,deviceApName= $deviceApName")
            return
        }
        val activeNetworkInfo = connectivityManager.activeNetworkInfo
        var isSuccess = false
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
            var checkConfigSuccess = true
            // 荣耀手机会有弹窗权限问题
            if (isGrantedPermission(arrayOf(Manifest.permission.SYSTEM_ALERT_WINDOW))) {
                val targetConfig = if (ActivityCompat.checkSelfPermission(
                        context,
                        Manifest.permission.ACCESS_FINE_LOCATION
                    ) == PackageManager.PERMISSION_GRANTED
                ) {
                    wifiManager.configuredNetworks ?: emptyList()
                } else {
                    emptyList()
                }.singleOrNull {
                    it.SSID?.decodeQuotedSSID() == deviceApName
                }
                checkConfigSuccess =
                    targetConfig != null && (targetConfig.status == WifiConfiguration.Status.ENABLED
                            || targetConfig.status == WifiConfiguration.Status.CURRENT)
                LogUtil.i(TAG, "checkConnect: have permission SYSTEM_ALERT_WINDOW check config: $checkConfigSuccess")
            }
            if (checkConfigSuccess) {
                LogUtil.i(
                    TAG,
                    "checkConnect: check config activeNetworkInfo?.state: ${activeNetworkInfo?.state} ,SSID: ${wifiManager.connectionInfo.ssid}"
                )
                LogUtil.i(
                    TAG,
                    "checkConnect: check config typeName: ${activeNetworkInfo?.typeName}  subtypeName: ${activeNetworkInfo?.subtypeName}  extraInfo: ${activeNetworkInfo?.extraInfo}"
                )
                if (activeNetworkInfo?.state == NetworkInfo.State.DISCONNECTED) {
                    // 设备可能会主动断开连接
                    isSuccess = false
                } else {
                    val connectionInfo = wifiManager.connectionInfo
                    LogUtil.i(
                        TAG, "checkConnect: check config activeNetworkInfo?.state: ${activeNetworkInfo?.state} " +
                                ",activeNetworkInfo?.detailedState: ${activeNetworkInfo?.detailedState} " +
                                ",activeNetworkInfo?.isConnected: ${activeNetworkInfo?.isConnected} " +
                                ",activeNetworkInfo?.isAvailable: ${activeNetworkInfo?.isAvailable}" +
                                ",connectionInfo?.supplicantState: ${connectionInfo?.supplicantState}"
                    )

                    if (activeNetworkInfo?.detailedState == NetworkInfo.DetailedState.CONNECTED
                        && activeNetworkInfo.isConnected
                        && connectionInfo?.supplicantState == SupplicantState.COMPLETED
                    ) {
                        isSuccess = true
                    }
                }

            }
        } else {
            isSuccess = true
        }
        if (isSuccess) {
            launch.cancel(CancellationException("checkConnect success"))
            LogUtil.i(TAG, "checkConnect: success $this")
            getHandler().sendMessage(Message.obtain().apply {
                obj = StepResult(StepName.STEP_CONNECT, StepState.SUCCESS)
            })
            resetRetryCount(stepName())
            nextStep(Step.STEP_SEND_DATA_WIFI)
        } else if (again) {
            end()
        }
    }

    private fun end() {
        LogUtil.i(TAG, "checkConnect: fail")
        if (canRetryStep(stepName())) {
            updateRetryCount(stepName())
            // 重试
            disconnectWifi()
            getHandler().sendEmptyMessageDelayed(MSG_CODE_CHECK_CONNECT_RETRY, 5000)
        } else {
            connectFail()
        }
    }

    private fun connectFail() {
        getHandler().sendMessage(Message.obtain().apply {
            obj = StepResult(StepName.STEP_CONNECT, StepState.FAILED, stepId = StepId.STEP_CONNECT_CHECK, reason = "connect fail")
        })
        resetRetryCount(stepName())
        nextStep(Step.STEP_MANUAL_CONNECT)
    }
}