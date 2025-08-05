package com.dreame.smartlife.config.step

import android.bluetooth.BluetoothAdapter
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.dreame.module.util.LogUtil
import android.net.ConnectivityManager
import android.net.NetworkInfo
import android.net.wifi.WifiManager
import android.util.Log
import com.dreame.feature.connect.scan.DeviceScanCache

/**
 * receiver wifi 或者 蓝牙等 开关状态
 */
object DeviceOpenChangeReceiver {
    private val wifiReceiver: WiFiStateReceiver by lazy { WiFiStateReceiver() }
    private val bleReceiver: BluetoothStateReceiver by lazy { BluetoothStateReceiver() }
    var wifiOpen = false
        private set
    var bleOpen = false
        private set

    @Volatile
    var isWifiRegister = false

    @Volatile
    var isBleRegister = false

    val wifiCallBacks = mutableListOf<(isOpen: Boolean) -> Unit>()
    val bleCallBacks = mutableListOf<(isOpen: Boolean) -> Unit>()

    fun registerAllReceiver(context: Context, type: Int = DeviceScanCache.TYPE_BOTH) {
        registerWiFiOpenReceiver(context)
        registerBleOpenReceiver(context)
    }

    fun unRegisterAllReceiver(context: Context) {
        unRegisterWiFiOpenReceiver(context)
        unRegisterBleOpenReceiver(context)
    }

    private fun registerBleOpenReceiver(context: Context) {
        if (!isBleRegister) {
            val intentFilter = IntentFilter(WifiManager.WIFI_STATE_CHANGED_ACTION)
            intentFilter.addAction(ConnectivityManager.CONNECTIVITY_ACTION)
            isBleRegister = runCatching {
                context.applicationContext.registerReceiver(wifiReceiver, intentFilter)
                true
            }.onFailure {
                LogUtil.e(Log.getStackTraceString(it))
            }.onSuccess {
                LogUtil.d("registerBleOpenReceiver $it")
            }.getOrDefault(isBleRegister)
        }
    }

    private fun registerWiFiOpenReceiver(context: Context) {
        if (!isWifiRegister) {
            val intentFilter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
            isWifiRegister = runCatching {
                context.applicationContext.registerReceiver(bleReceiver, intentFilter)
                true
            }.onFailure {
                LogUtil.e(Log.getStackTraceString(it))
            }.onSuccess {
                LogUtil.d("registerWiFiOpenReceiver $it")
            }.getOrDefault(isWifiRegister)
        }
    }


    private fun unRegisterWiFiOpenReceiver(context: Context) {
        LogUtil.d("unRegisterWiFiOpenReceiver: ")
        if (isWifiRegister) {
            runCatching {
                context.applicationContext.unregisterReceiver(wifiReceiver)
            }.onFailure {
                LogUtil.e(Log.getStackTraceString(it))
            }.onSuccess {
                LogUtil.d("unRegisterWiFiOpenReceiver: $it")
            }
            isWifiRegister = false
        }
        wifiCallBacks.clear()
    }

    private fun unRegisterBleOpenReceiver(context: Context) {
        LogUtil.d("unRegisterBleOpenReceiver: ")
        if (isBleRegister) {
            runCatching {
                context.applicationContext.unregisterReceiver(bleReceiver)
            }.onFailure {
                LogUtil.e(Log.getStackTraceString(it))
            }.onSuccess {
                LogUtil.d("unRegisterBleOpenReceiver: $it")
            }
            isBleRegister = false
        }
        bleCallBacks.clear()
    }

    fun onStop(context: Context) {
        wifiCallBacks.clear()
        bleCallBacks.clear()
    }

    class WiFiStateReceiver : BroadcastReceiver() {
        @Override
        override fun onReceive(context: Context, intent: Intent) {
            // 监听wifi的打开与关闭，与wifi的连接无关
            when (intent.action) {
                WifiManager.WIFI_STATE_CHANGED_ACTION -> {
                    val wifiState = intent.getIntExtra(WifiManager.EXTRA_WIFI_STATE, -1)
                    LogUtil.i("wifiState: $wifiState");
                    when (wifiState) {
                        WifiManager.WIFI_STATE_ENABLING -> {
                            LogUtil.e("wifi状态：打开中")
                        }
                        WifiManager.WIFI_STATE_ENABLED -> {
                            //主用：打开状态
                            LogUtil.e("wifi状态：已打开")
                            wifiOpen = true
                            wifiCallBacks.iterator().forEach {
                                it.invoke(wifiOpen)
                            }
                        }
                        WifiManager.WIFI_STATE_DISABLING -> {
                            LogUtil.e("wifi状态：关闭中")
                            wifiOpen = false
                            wifiCallBacks.iterator().forEach {
                                it.invoke(wifiOpen)
                            }
                        }
                        WifiManager.WIFI_STATE_DISABLED -> {//主用：关闭状态
                            LogUtil.e("wifi状态：已关闭")
                            wifiOpen = false
                            wifiCallBacks.iterator().forEach {
                                it.invoke(wifiOpen)
                            }
                        }
                        WifiManager.WIFI_STATE_UNKNOWN -> {
                            LogUtil.e("wifi状态：无法识别")
                        }
                        else -> {
                            LogUtil.e("wifi状态：未知")
                        }

                    }
                }
                ConnectivityManager.CONNECTIVITY_ACTION -> {
                    val networkInfo = intent.getParcelableExtra<NetworkInfo>(ConnectivityManager.EXTRA_NETWORK_INFO)
                    val networkType = intent.getIntExtra(ConnectivityManager.EXTRA_NETWORK_TYPE, -1)
                    val networkReason = intent.getStringExtra(ConnectivityManager.EXTRA_REASON)
                    val extraInfo = intent.getStringExtra(ConnectivityManager.EXTRA_EXTRA_INFO)

                    LogUtil.i("onReceive CONNECTIVITY_ACTION: $networkInfo  $networkType  $networkReason  $extraInfo")

                }
                ConnectivityManager.CONNECTIVITY_ACTION -> {
                    val networkInfo = intent.getParcelableExtra<NetworkInfo>(ConnectivityManager.EXTRA_NETWORK_INFO)
                    val networkType = intent.getIntExtra(ConnectivityManager.EXTRA_NETWORK_TYPE, -1)
                    val networkReason = intent.getStringExtra(ConnectivityManager.EXTRA_REASON)
                    val extraInfo = intent.getStringExtra(ConnectivityManager.EXTRA_EXTRA_INFO)

                    LogUtil.i("onReceive CONNECTIVITY_ACTION: $networkInfo  $networkType  $networkReason  $extraInfo")

                }
            }

        }

    }

    class BluetoothStateReceiver : BroadcastReceiver() {
        @Override
        override fun onReceive(context: Context, intent: Intent) {
            // 监听wifi的打开与关闭，与wifi的连接无关
            if (BluetoothAdapter.ACTION_STATE_CHANGED == intent.action) {
                val wifiState = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, -1)
                LogUtil.e("wifiState: $wifiState");
                when (wifiState) {
                    BluetoothAdapter.STATE_TURNING_ON -> {
                        LogUtil.e("蓝牙状态：打开中")
                    }
                    BluetoothAdapter.STATE_ON -> {
                        LogUtil.e("蓝牙状态：已打开")
                        bleOpen = true
                        bleCallBacks.forEach {
                            it.invoke(bleOpen)
                        }
                    }
                    BluetoothAdapter.STATE_TURNING_OFF -> {
                        LogUtil.e("蓝牙状态：关闭中")
                        bleOpen = false
                        bleCallBacks.forEach {
                            it.invoke(bleOpen)
                        }
                    }
                    BluetoothAdapter.STATE_OFF -> {//主用：关闭状态
                        LogUtil.e("蓝牙状态：已关闭")
                        bleOpen = false
                        bleCallBacks.forEach {
                            it.invoke(bleOpen)
                        }
                    }
                    else -> {
                        LogUtil.e("蓝牙状态：未知")
                    }

                }
            }

        }
    }
}

