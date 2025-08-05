package com.dreame.smartlife.config.step

import android.app.Activity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.dreame.module.ext.decodeQuotedSSID
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ModuleCode
import android.dreame.module.trace.PairNetEventCode
import android.dreame.module.util.LogUtil
import android.location.LocationManager
import android.net.ConnectivityManager
import android.net.LinkProperties
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest
import android.net.wifi.SupplicantState
import android.os.Handler
import android.os.Looper
import android.os.Message
import android.provider.Settings
import android.text.TextUtils
import android.util.Log
import androidx.lifecycle.LifecycleOwner
import com.dreame.feature.connect.trace.BuriedConnectHelper
import com.dreame.smartlife.config.step.udp.TestSocketCanConnect
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.asFlow
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.launch
import java.util.concurrent.CancellationException

/**
 * # 手动热点连接
 * 监听网络变化,监听位置信息开启状态,用户手动连接wifi
 * 成功:连接状态二次确认 [StepConnectCheck]
 */
open class StepManualConnect : SmartStepConfig() {
    private val CODE_CHECK_WIFI = 1200
    private val CODE_CHECK_WIFI_RESULT = 1201
    private var gpsStateReceiver: GpsStatusReceiver? = null

    // 是否监听到Wi-Fi变化
    private var isWifiChanged = false

    // 兜底job
    private var guaranteeJob: Job? = null


    private val testSocketCanConnect by lazy {
        val mUIHandler = Handler(Looper.getMainLooper())
        TestSocketCanConnect(mUIHandler)
    }

    override fun stepName(): Step = Step.STEP_MANUAL_CONNECT

    override fun handleMessage(msg: Message) {
        if (msg.what == CLICK_MANUAL_SETTING) {
            LogUtil.i(TAG, "handleMessage: CLICK_MANUAL_SETTING")
            click2Connect()
        } else if (msg.what == CODE_CHECK_WIFI || msg.what == CODE_CHECK_WIFI_RESULT) {
            val connectedSsid = msg.obj as String
            unPeekLiveData.value = connectedSsid
            val deviceWifi = isDeviceWifi(connectedSsid, isManual = true)
            LogUtil.i(
                TAG, "handleMessage: manual connect wifiName: $connectedSsid , state: ${isWifiConnectValid()}, isDeviceWifi: $deviceWifi" +
                        " ,productWifiName: ${StepData.productWifiName} ,productWifiPrefix: ${StepData.productWifiPrefix} ,productWifiName: ${StepData.productWifiName}"
            )
            if (!TextUtils.isEmpty(connectedSsid) && deviceWifi) {
                val boundNetworkForProcess = connectivityManager.boundNetworkForProcess
                val linkProperties = connectivityManager.getLinkProperties(boundNetworkForProcess)
                val networkCapabilities = connectivityManager.getNetworkCapabilities(boundNetworkForProcess)
                LogUtil.i(TAG, "handleMessage: manual connect wifiName $boundNetworkForProcess  $linkProperties $networkCapabilities")

                isWifiChanged = true
                guaranteeJob?.cancel(CancellationException("cancel by myself"))
                getHandler().removeMessages(CODE_CHECK_WIFI)
                getHandler().sendMessage(Message.obtain().apply {
                    obj = StepResult(StepName.STEP_CONNECT, StepState.START)
                })
                StepData.deviceApName = connectedSsid
                nextStep(Step.STEP_CONNECT_CHECK)
            } else {
                var wifiName = wifiManager.connectionInfo?.ssid?.decodeQuotedSSID() ?: ""
                if ("<unknown ssid>" == wifiName) {
                    wifiName = ""
                }
                // 中兴路由器:wifiInfo:  ZTE-4YzXKu  ipaddr 192.168.5.6 gateway 192.168.5.1 netmask 0.0.0.0 dns1 192.168.5.1 dns2 0.0.0.0 DHCP server 192.168.5.1 lease 86400 seconds  true  false
                // 测试一下dhcpInfo: ipaddr 192.168.5.100 gateway 192.168.5.1 netmask 0.0.0.0 dns1 192.168.5.1 dns2 0.0.0.0 DHCP server 192.168.5.1 lease 3600 seconds
                val dhcpInfo = wifiManager.dhcpInfo.toString()
//                val ipaddr = "ipaddr 192.168.5.100"
//                val gateway = "gateway 192.168.5.1"
                val dns1 = "dns1 192.168.5.1"
                val server = "DHCP server 192.168.5.1"
                val isDeviceRouter = dhcpInfo.contains(dns1) || dhcpInfo.contains(server)
                val isDeviceWifiName =
                    (wifiName.startsWith("mova-") || wifiName.startsWith("dreame-") || wifiName.startsWith("trouver-"))
                            && wifiName.contains("_miap")
                LogUtil.i("wifiInfo:  $wifiName  $dhcpInfo  $isDeviceRouter  $isDeviceWifiName")
                if (isDeviceRouter && isDeviceWifiName) {
                    // 初步判断连上的是机器Wi-Fi
                    testSocketConnect()
                } else {
                    if (msg.what == CODE_CHECK_WIFI_RESULT) {
                        getHandler().sendMessage(Message.obtain().apply {
                            obj = StepResult(StepName.STEP_MAUNAL, StepState.FAILED)
                        })
                    }

                }
            }

        }
    }

    private fun testSocketConnect() {
        launch(Dispatchers.IO) {
            testSocketCanConnect.testSocketConnect(
                BaseStepSendDataWifi.AP_IP,
                BaseStepSendDataWifi.AP_PORT, true
            ) { ret, msg ->
                if (ret) {
                    // 发送通知
                    getHandler().sendMessage(Message.obtain().apply {
                        obj = StepResult(StepName.STEP_MAUNAL, StepState.START)
                    })
                }
            }
        }
    }

    override fun stepCreate() {
        super.stepCreate()
        Log.d(TAG, "stepCreate: StepManualConnect")
        connectivityManager.bindProcessToNetwork(null)
        getHandler().removeCallbacksAndMessages(null)
        getHandler().sendMessage(Message.obtain().apply {
            obj = StepResult(StepName.STEP_CONNECT, StepState.FAILED)
        })
        gpsStateReceiver = GpsStatusReceiver()
        context.registerReceiver(
            gpsStateReceiver,
            IntentFilter(LocationManager.MODE_CHANGED_ACTION)
        )
        unPeekLiveData.observe(context as LifecycleOwner) {
            val message = getHandler().obtainMessage().apply {
                what = StepData.CODE_CURRENT_WIFI
                obj = it
            }
            getHandler().sendMessage(message)
        }
        connectivityManager.registerNetworkCallback(
            NetworkRequest.Builder()
                .build(), networkCallback!!
        )
    }

    private var networkCallback: ConnectivityManager.NetworkCallback? = object : ConnectivityManager.NetworkCallback() {

        override fun onCapabilitiesChanged(network: Network, networkCapabilities: NetworkCapabilities) {
            super.onCapabilitiesChanged(network, networkCapabilities)
            LogUtil.i(TAG, "onCapabilitiesChanged: ${networkCapabilities} ,network: $network")
            if (networkCapabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)
            ) {
                /// wifi
                val linkProperties = connectivityManager.getLinkProperties(network)
                val dnsServers = linkProperties?.dnsServers
                val linkAddresses = linkProperties?.linkAddresses
                val routes = linkProperties?.routes

                val dnsServer = dnsServers?.firstOrNull {
                    it.hostName == "192.168.5.1"
                }

                val route = routes?.firstOrNull {
                    it.gateway?.hostName == "192.168.5.1"
                }
                LogUtil.i(TAG, "onCapabilitiesChanged: ${dnsServer} ${linkAddresses} ${route}")
                if (dnsServer != null && route != null) {
                    connectivityManager.bindProcessToNetwork(network)
                    getHandler().removeMessages(CODE_CHECK_WIFI)
                    getHandler().sendMessageDelayed(
                        Message.obtain().apply {
                            what = CODE_CHECK_WIFI
                            obj = currentConnectedSsid()
                        }, 1000
                    )
                }
            }
        }

        override fun onLinkPropertiesChanged(network: Network, linkProperties: LinkProperties) {
            super.onLinkPropertiesChanged(network, linkProperties)
            LogUtil.i(TAG, "onLinkPropertiesChanged: ${linkProperties} network:$network")

        }

        override fun onAvailable(network: Network) {
            super.onAvailable(network)
            LogUtil.i(TAG, "onAvailable: ${network}")

        }

        override fun onLost(network: Network) {
            super.onLost(network)
            LogUtil.i(TAG, "onLost: ${network}")

        }

        override fun onUnavailable() {
            super.onUnavailable()
            LogUtil.i(TAG, "onUnavailable: ")

        }
    }

    override fun stepOnResume() {
        val connectedSsid = currentConnectedSsid()
        unPeekLiveData.value = connectedSsid
        LogUtil.i(TAG, "stepResume: $connectedSsid")
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code, PairNetEventCode.NotConnectAp.code, hashCode(),
            StepData.deviceId, StepData.productModel,
            str1 = BuriedConnectHelper.currentSessionID(), str2 = connectedSsid
        )
    }

    /**
     * 用户手动触发
     */
    protected open fun click2Connect() {
        // 9.0之后获取wifi信息需要开启位置信息
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        if (!locServiceEnable()) {
            // 开启Gps定位开关
            showGpsLocationDialog()
            return
        }
//        }
        // 跳转Wi-Fi设置页面
        guaranteeJob?.cancel(CancellationException("cancel by myself"))
        isWifiChanged = false
        (context as Activity).startActivityForResult(Intent(Settings.ACTION_WIFI_SETTINGS), 0x9001)
    }

    /**
     * 跳转WI-FI设置界面
     */
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        Log.d(TAG, "onActivityResult: ")
        if (requestCode == 0x9001) {

            getHandler().removeMessages(CODE_CHECK_WIFI_RESULT)
            getHandler().sendMessage(Message.obtain().apply {
                what = CODE_CHECK_WIFI_RESULT
                obj = currentConnectedSsid()
            })

            // 从Wi-Fi设置页面返回， 执行兜底策略
            // 在设置界面时，监听到的Wi-Fi 获取IP过程中 name 是 ""，所以无法判断
            guaranteeJob = launch {
                if (!isWifiChanged) {
                    // 兜底策略
                    LogUtil.i("保底策略---------1------")
                    (0 until 3).asFlow()
                        .onEach {
                            delay(2 * 1000)
                        }
                        .collect {
                            sendCheckWifi()
                        }
                    LogUtil.i("保底策略---------2 delay 3s------")
                }
            }
        }
    }

    override fun stepDestroy() {
        gpsStateReceiver?.let {
            context.unregisterReceiver(it)
        }.also { gpsStateReceiver = null }
        guaranteeJob?.cancel(CancellationException("cancel by myself"))
        isWifiChanged = false
        networkCallback?.let {
            runCatching {
                connectivityManager.unregisterNetworkCallback(it)
            }
            networkCallback = null
        }
    }

    override fun registerNetChange() = true

    override fun handleNetChangeEvent(connectedSsid: String) {
        getHandler().removeMessages(CODE_CHECK_WIFI)
        getHandler().sendMessage(Message.obtain().apply {
            what = CODE_CHECK_WIFI
            obj = connectedSsid
        })
    }

    private fun isWifiConnectValid(): Boolean {
        return wifiManager.connectionInfo.supplicantState == SupplicantState.COMPLETED
    }

    /**
     * 监听位置信息开启状态
     */
    private inner class GpsStatusReceiver : BroadcastReceiver() {

        override fun onReceive(context: Context?, intent: Intent?) {
            if (LocationManager.MODE_CHANGED_ACTION == intent?.action) {
                val gpsEnabled = locServiceEnable()
                LogUtil.i(TAG, "onReceive: gpsEnabled: $gpsEnabled")
                if (locationDialog.isShowing) {
                    locationDialog.dismiss()
                }
                if (gpsEnabled) {
                    sendCheckWifi()
                }
            }
        }
    }

    private fun sendCheckWifi() {
        getHandler().removeMessages(CODE_CHECK_WIFI)
        getHandler().sendMessage(Message.obtain().apply {
            what = CODE_CHECK_WIFI
            obj = currentConnectedSsid()
        })
    }

}