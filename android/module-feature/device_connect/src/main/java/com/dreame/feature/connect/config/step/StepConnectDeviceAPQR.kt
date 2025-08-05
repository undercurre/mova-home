package com.dreame.smartlife.config.step

import android.dreame.module.util.LogUtil
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest
import android.net.wifi.WifiNetworkSpecifier
import android.os.Build
import android.os.Message
import android.os.SystemClock
import android.text.TextUtils
import android.util.Log
import androidx.annotation.RequiresApi

/**
 * # 扫码连接机器热点
 * 1.连接设备热点
 * 成功:发送Udp [StepSendDataWifi]
 * 失败:
 *  手动连接 [StepManualConnect]
 */
class StepConnectDeviceAPQR : SmartStepConfig() {
    companion object {
        private const val CONNECT_SUCCESS = 1003
        private const val CONNECT_MANUAL_FAIL = 1006
        private const val CONNECT_Q_DELAY = 1007

        // 延迟时间
        private const val DELAY_TIME_FAIL = 500L
        private const val DELAY_TIME_SUCCESS = 100L
        private const val CONNECT_Q_TIME_DELAY = 20_000L

    }

    private var isConnecting = false

    override fun stepName(): Step = Step.STEP_CONNECT_DEVICE_AP_QR

    override fun handleMessage(msg: Message) {
        when (msg.what) {
            CONNECT_SUCCESS -> {
                Log.i(TAG, "handleMessage: CONNECT_SUCCESS")
                connectSuccess()
            }

            CONNECT_MANUAL_FAIL -> {
                Log.i(TAG, "handleMessage: CONNECT_MANUAL_FAIL")
                getHandler().sendMessage(Message.obtain().apply {
                    obj = StepResult(StepName.STEP_CONNECT, StepState.FAILED)
                })
                nextStep(Step.STEP_MANUAL_CONNECT_QR)
            }

            CONNECT_Q_DELAY -> {
                Log.i(TAG, "handleMessage: CONNECT_Q_DELAY")
                isConnecting = false
                getHandler().sendMessage(Message.obtain().apply {
                    obj = StepResult(StepName.STEP_CONNECT, StepState.FAILED)
                })
                nextStep(Step.STEP_MANUAL_CONNECT_QR)
            }
        }
    }

    override fun stepCreate() {
        super.stepCreate()
        Log.d(TAG, "stepCreate: StepConnectDeviceAP")
        connectDeviceAp()
    }

    override fun stepOnResume() {
        Log.d(TAG, "stepResume: $isConnecting ${isStepRunning()}")
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


    private fun connectDeviceAp() {
        val productWifiName = StepData.productWifiName
        Log.i(TAG, "connectAp: $productWifiName")
        if (wifiManager.isWifiEnabled) {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
                nextStep(Step.STEP_WIFI_PERMISSION_CHECK)
            } else {
                connectWifiQAfter(productWifiName)
            }
        } else {
            Log.i(TAG, "connectDeviceAp: fail disable wifi")
            connectFail()
        }
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    private fun connectWifiQAfter(wifiName: String) {
        LogUtil.i(TAG, "connectWifiQAfter wifiName: $wifiName")
        StepData.deviceApName = StepData.productWifiName
        StepData.connectStartTime = SystemClock.elapsedRealtime();
        if (TextUtils.isEmpty(wifiName)) {
            connectFail()
            return
        }
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
                isConnecting = false
                Log.i(TAG, "connectWifiQAfter: connect success $network")
                // 数据发送完毕需要置为null
                connectivityManager.bindProcessToNetwork(network)
                // 注意:自动连接也会触发网络变化监听,但是此处会比网络监听回调速度更快,且跳转下一步时会注销网络变化监听,所以没有重复处理回调的风险
                getHandler().sendEmptyMessageDelayed(CONNECT_SUCCESS, DELAY_TIME_SUCCESS)
            }

            override fun onUnavailable() {
                isConnecting = false
                LogUtil.i(TAG, "connectWifiQAfter: onUnavailable")
                try {
                    connectivityManager.unregisterNetworkCallback(this)
                } catch (e: Exception) {
                    e.printStackTrace()
                }
                SmartStepHelper.instance.networkCallback = null
                getHandler().sendEmptyMessageDelayed(CONNECT_MANUAL_FAIL, DELAY_TIME_FAIL)
            }

            override fun onLost(network: Network) {
                super.onLost(network)
                Log.i(TAG, "connectWifiQAfter: onLost")
                isConnecting = false
                try {
                    connectivityManager.unregisterNetworkCallback(this)
                } catch (e: Exception) {
                    e.printStackTrace()
                }
                SmartStepHelper.instance.networkCallback = null

            }
        }
        isConnecting = true
        getHandler().removeMessages(CONNECT_Q_DELAY)
        connectivityManager.requestNetwork(request, SmartStepHelper.instance.networkCallback!!, 60 * 1000)
    }

    private fun connectSuccess() {
        Log.i(TAG, " connectSuccess")
        getHandler().sendMessage(Message.obtain().apply {
            obj = StepResult(StepName.STEP_CONNECT, StepState.SUCCESS)
        })
        nextStep(Step.STEP_SEND_DATA_WIFI_QR)
    }

    private fun connectFail() {
        Log.i(TAG, " connectFail")
        getHandler().sendMessage(Message.obtain().apply {
            obj = StepResult(StepName.STEP_CONNECT, StepState.FAILED)
        })
        nextStep(Step.STEP_MANUAL_CONNECT_QR)
    }


}
