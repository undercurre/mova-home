package com.dreame.smartlife.config.step

import android.Manifest
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.dreame.module.ext.createQuotedSSID
import android.dreame.module.ext.decodeQuotedSSID
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ModuleCode
import android.dreame.module.trace.PairNetEventCode
import android.dreame.module.util.LogUtil
import android.net.*
import android.net.wifi.WifiConfiguration
import android.net.wifi.WifiManager
import android.net.wifi.WifiNetworkSpecifier
import android.os.Build
import android.os.Bundle
import android.os.Message
import android.os.SystemClock
import android.text.TextUtils
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import com.dreame.feature.connect.trace.BuriedConnectHelper

/**
 * # 设备热点连接
 * 1.连接设备热点
 * 成功:连接状态二次确认 [StepConnectCheck]
 * 失败:
 *  1)可以重试:wifi扫描 [StepWifiScan]
 *  2)重试失败:手动连接 [StepManualConnect]
 * 2.监听网络变化,用户可能会手动连接wifi
 * 成功:连接状态二次确认 [StepConnectCheck]
 */
class StepConnectDeviceAP : SmartStepConfig() {
    companion object {
        private const val CONNECT_FAIL = 1002
        private const val CONNECT_SUCCESS = 1003
        private const val CONNECT_RETRY = 1004
        private const val CONNECT_NETWORK = 1005
        private const val CONNECT_MANUAL_FAIL = 1006
        private const val CONNECT_Q_DELAY = 1007

        // 延迟时间
        private const val DELAY_TIME_FAIL = 100L
        private const val DELAY_TIME_SUCCESS = 100L
        private const val CONNECT_Q_TIME_DELAY = 20_000L

    }

    private var wifiLock: WifiManager.WifiLock? = null

    private var isConnecting = false

    override fun maxRetryCount(): Int = 1

    override fun stepName(): Step = Step.STEP_CONNECT_DEVICE_AP

    override fun handleMessage(msg: Message) {
        when (msg.what) {
            CONNECT_SUCCESS -> {
                LogUtil.i(TAG, "handleMessage: CONNECT_SUCCESS")
                connectSuccess()
            }

            CONNECT_FAIL -> {
                retryConnect()
            }

            CONNECT_MANUAL_FAIL -> {
                connectFail()
            }

            CONNECT_RETRY -> {
                if (isGrantedPermission(permissionList)) {
                    nextStep(Step.STEP_MANUAL_CONNECT)
                } else {
                    connectFail()
                }
            }

            CONNECT_NETWORK -> {
                val wifiName = msg.obj?.let { it as String } ?: ""
                val targetConfig = msg.data.getParcelable<WifiConfiguration>("data")
                val isSuccess = targetConfig?.let { realConnectDeviceWifi(it) }
                sendResult(isSuccess == true, wifiName)
            }

            CONNECT_Q_DELAY -> {
                isConnecting = false
                getHandler().sendMessage(Message.obtain().apply {
                    obj = StepResult(StepName.STEP_CONNECT, StepState.FAILED)
                })
                nextStep(Step.STEP_MANUAL_CONNECT)
            }
        }
    }

    override fun stepCreate() {
        super.stepCreate()
        Log.d(TAG, "stepCreate: StepConnectDeviceAP")
        connectDeviceAp()
    }

    override fun stepOnResume() {
        Log.d(TAG, "stepResume: ")
        // 判断当前是否 连接中，延迟
        if (isConnecting && isStepRunning()) {
            getHandler().sendEmptyMessageDelayed(CONNECT_Q_DELAY, CONNECT_Q_TIME_DELAY)
        }

    }

    override fun stepOnPause() {
        Log.d(TAG, "stepOnPause: $isConnecting ${isStepRunning()}")
        if (getHandler().hasMessages(CONNECT_Q_DELAY)) {
            getHandler().removeMessages(CONNECT_Q_DELAY)
        }
    }

    override fun stepDestroy() {
    }

    override fun registerNetChange() = true

    override fun handleNetChangeEvent(connectedSsid: String) {
        if (!TextUtils.isEmpty(connectedSsid) && isDeviceWifi(connectedSsid)) {
            // 自动连接也会触发此回调
            LogUtil.i(TAG, "handleNetChangeEvent: connect success $connectedSsid")
            getHandler().removeCallbacksAndMessages(null)
            StepData.deviceApName = connectedSsid
            getHandler().sendEmptyMessage(CONNECT_SUCCESS)
        }
    }

    private fun connectDeviceAp() {
        val deviceApName = StepData.deviceApName
        LogUtil.i(TAG, "connectAp: $deviceApName")
        ///
        StepData.connectStartTime = SystemClock.elapsedRealtime()
        if (wifiManager.isWifiEnabled) {
            if (TextUtils.isEmpty(deviceApName)) {
                connectFail()
                return
            }
            try {
                if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
                    connectWifiQBefore(deviceApName)
                } else {
                    connectWifiQAfter(deviceApName)
                }
            } catch (e: Exception) {
                LogUtil.e(TAG, "wifiEnabled connectDeviceAp error: $e")
                connectFail()
            }
        } else {
            LogUtil.i(TAG, "connectDeviceAp: fail disable wifi")
            connectFail()
        }
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    private fun connectWifiQAfter(wifiName: String) {
        val specifier = WifiNetworkSpecifier.Builder()
            .setSsid(wifiName)
            .build()
        val request =
            NetworkRequest.Builder()
                .addTransportType(NetworkCapabilities.TRANSPORT_WIFI)
                .addCapability(NetworkCapabilities.NET_CAPABILITY_TRUSTED)
                .addCapability(NetworkCapabilities.NET_CAPABILITY_NOT_RESTRICTED)
                .removeCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
                .setNetworkSpecifier(specifier)
                .build()
        // 注意,此回调会在子线程中执行
        SmartStepHelper.instance.networkCallback = object : ConnectivityManager.NetworkCallback() {
            override fun onAvailable(network: Network) {
                EventCommonHelper.eventCommonPageInsert(
                    ModuleCode.PairNetNew.code, PairNetEventCode.CancelConnectAp.code, hashCode(),
                    StepData.deviceId, StepData.deviceModel(),
                    int1 = 1, str1 = BuriedConnectHelper.currentSessionID()
                )
                isConnecting = false
                LogUtil.i(
                    TAG,
                    "requestNetwork onAvailable connectWifiQAfter: connect success $network"
                )
                ///
                val capabilities = connectivityManager.getNetworkCapabilities(network)
                LogUtil.i(
                    TAG,
                    "requestNetwork onAvailable connectWifiQAfter: connect success $capabilities"
                )
                val hasTransport = capabilities?.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) == true
                if (hasTransport) {
                    val linkProperties = connectivityManager.getLinkProperties(network)
                    LogUtil.i(
                        TAG,
                        "requestNetwork onAvailable connectWifiQAfter: connect success $linkProperties"
                    )
                    val linkAddresses = linkProperties?.linkAddresses
                    val dnsServers = linkProperties?.dnsServers
                    // 数据发送完毕需要置为null
                    connectivityManager.bindProcessToNetwork(network)
                    // 注意:自动连接也会触发网络变化监听,但是此处会比网络监听回调速度更快,且跳转下一步时会注销网络变化监听,所以没有重复处理回调的风险
                    getHandler().sendEmptyMessageDelayed(CONNECT_SUCCESS, DELAY_TIME_SUCCESS)
                }

            }

            override fun onLinkPropertiesChanged(network: Network, linkProperties: LinkProperties) {
                super.onLinkPropertiesChanged(network, linkProperties)
                LogUtil.i(TAG, "connectWifiQAfter:onCapabilitiesChanged: $network ${linkProperties}")

            }

            override fun onCapabilitiesChanged(network: Network, networkCapabilities: NetworkCapabilities) {
                super.onCapabilitiesChanged(network, networkCapabilities)
                LogUtil.i(TAG, "connectWifiQAfter:onCapabilitiesChanged: $network ${networkCapabilities}")
            }

            override fun onLost(network: Network) {
                super.onLost(network)
                LogUtil.i(TAG, "connectWifiQAfter:onLost: $network ${currentConnectedSsid()}")
            }

            override fun onUnavailable() {
                EventCommonHelper.eventCommonPageInsert(
                    ModuleCode.PairNetNew.code, PairNetEventCode.CancelConnectAp.code, hashCode(),
                    StepData.deviceId, StepData.deviceModel(),
                    str1 = BuriedConnectHelper.currentSessionID()
                )
                isConnecting = false
                LogUtil.i(TAG, "connectWifiQAfter: connect fail ${currentConnectedSsid()}")

                /// 判断当前连接的wifi是否是设备热点
                try {
                    connectivityManager.unregisterNetworkCallback(this)
                } catch (e: Exception) {
                    e.printStackTrace()
                }
                SmartStepHelper.instance.networkCallback = null
                getHandler().sendEmptyMessageDelayed(CONNECT_MANUAL_FAIL, DELAY_TIME_FAIL)
            }
        }
        isConnecting = true
        getHandler().removeMessages(CONNECT_Q_DELAY)
        connectivityManager.requestNetwork(request, SmartStepHelper.instance.networkCallback!!)
    }

    private fun connectWifiQBefore(wifiName: String) {
        var isSuccess = false
        var targetConfig = if (ActivityCompat.checkSelfPermission(
                context,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED
        ) {
            wifiManager.configuredNetworks ?: emptyList()
        } else {
            emptyList()
        }.singleOrNull {
            (it.SSID?.decodeQuotedSSID() ?: "") == wifiName
        }
        if (targetConfig != null && (targetConfig.status == WifiConfiguration.Status.ENABLED
                    || targetConfig.status == WifiConfiguration.Status.CURRENT)
        ) {
            val isDisconnect = wifiManager.disconnect()
            LogUtil.i(
                TAG,
                "connectWifiQBefore: targetConfig is notnull, disconnect result: $isDisconnect"
            )
            val msg = getHandler().obtainMessage()
            msg.what = CONNECT_NETWORK
            msg.obj = wifiName
            val bundle = Bundle()
            bundle.putParcelable("data", targetConfig)
            msg.data = bundle
            getHandler().sendMessageDelayed(msg, 600)
        } else {
            if (targetConfig == null || targetConfig.networkId == -1) {
                targetConfig = createWifiConfig(wifiName.createQuotedSSID())
                val networkId = wifiManager.addNetwork(targetConfig)
                LogUtil.i(TAG, "connectWifiQBefore: createWifiConfig network  netId $networkId")
                if (networkId == -1) {
                    isSuccess = false
                    sendResult(isSuccess, wifiName)
                }
            }
            if (!wifiManager.isWifiEnabled) {
                wifiManager.isWifiEnabled = true
            }
            val isDisconnect = wifiManager.disconnect()
            LogUtil.i(TAG, "connectWifiQBefore: enableNetwork , disconnect result: $isDisconnect")
            val msg = getHandler().obtainMessage()
            msg.what = CONNECT_NETWORK
            msg.obj = wifiName
            val bundle = Bundle()
            bundle.putParcelable("data", targetConfig)
            msg.data = bundle
            getHandler().sendMessageDelayed(msg, 600)
        }
    }

    private fun realConnectDeviceWifi(targetConfig: WifiConfiguration): Boolean {
        var isSuccess1: Boolean
        try {
            wifiLockAcquire()
            isSuccess1 = wifiManager.enableNetwork(targetConfig.networkId, true)
            LogUtil.i(TAG, "realConnectDeviceWifi: enableNetwork result $isSuccess1")
            isSuccess1 = wifiManager.reconnect()
            LogUtil.i(TAG, "realConnectDeviceWifi: reconnect result $isSuccess1")
        } catch (e: Exception) {
            // 再次重试
            isSuccess1 = wifiManager.enableNetwork(targetConfig.networkId, true)
            LogUtil.i(TAG, "realConnectDeviceWifi: enableNetwork result $isSuccess1")
            isSuccess1 = wifiManager.reconnect()
            LogUtil.i(TAG, "realConnectDeviceWifi: reconnect result $isSuccess1")

        } finally {
            wifiLockRelease()
        }
        return isSuccess1
    }

    private fun sendResult(isSuccess: Boolean, wifiName: String) {
        if (isSuccess) {
            LogUtil.i(TAG, "connectWifiQBefore: success wifi is ${currentConnectedSsid()}")
            // 注意:自动连接也会触发网络变化监听,但是此处会比网络监听回调速度更快,且跳转下一步时会注销网络变化监听,所以没有重复处理回调的风险
            getHandler().sendEmptyMessage(CONNECT_SUCCESS)
        } else {
            LogUtil.i(TAG, "connectWifiQBefore: fail wifi is $wifiName")
            getHandler().sendEmptyMessage(CONNECT_FAIL)
        }
    }

    /**
     * Q以下创建wifi配置
     */
    private fun createWifiConfig(wifiName: String?): WifiConfiguration {
        val wifiConfig = WifiConfiguration().apply {
            allowedAuthAlgorithms.clear()
            allowedGroupCiphers.clear()
            allowedKeyManagement.clear()
            allowedPairwiseCiphers.clear()
            allowedProtocols.clear()
            SSID = wifiName
            // 无需密码
            allowedKeyManagement.set(WifiConfiguration.KeyMgmt.NONE)
            status = WifiConfiguration.Status.ENABLED
        }
        // 删除之前配置
        val tempConfig = if (ActivityCompat.checkSelfPermission(
                context,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED
        ) {
            wifiManager.configuredNetworks ?: emptyList()
        } else {
            emptyList()
        }.singleOrNull {
            (it.SSID ?: "") == wifiName
        }
        tempConfig?.let {
            wifiManager.removeNetwork(it.networkId)
            wifiManager.saveConfiguration()
        }

        return wifiConfig
    }

    private fun connectSuccess() {
        resetRetryCount(stepName())
        nextStep(Step.STEP_CONNECT_CHECK)
    }

    private fun retryConnect() {
        if (canRetryStep(stepName())) {
            updateRetryCount(stepName())
            // 重试
            disconnectWifi()
            getHandler().sendEmptyMessageDelayed(CONNECT_RETRY, 5000);
        } else {
            connectFail()
        }
    }

    private fun connectFail() {
        getHandler().sendMessage(Message.obtain().apply {
            obj = StepResult(StepName.STEP_CONNECT, StepState.FAILED)
        })
        resetRetryCount(stepName())
        nextStep(Step.STEP_MANUAL_CONNECT)
    }


    // 增加Wi-Fi锁，连接Wi-Fi
    private fun wifiLockAcquire() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
            if (wifiLock == null) {
                wifiLock = wifiManager.createWifiLock("REAL_CONNECT_WIFI_DEVICE")
                wifiLock?.setReferenceCounted(false)
            }
            wifiLock?.acquire()
        }
    }

    private fun wifiLockRelease() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
            wifiLock?.run {
                if (isHeld) {
                    release()
                }
            }
        }
    }

}
