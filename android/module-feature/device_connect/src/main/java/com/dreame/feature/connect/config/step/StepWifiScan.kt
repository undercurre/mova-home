package com.dreame.smartlife.config.step

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.dreame.module.util.LogUtil
import android.net.wifi.ScanResult
import android.net.wifi.WifiManager
import android.os.Build
import android.os.Message
import android.os.SystemClock
import android.text.TextUtils
import android.util.Log
import com.dreame.feature.connect.scan.DeviceScanCache
import com.dreame.smartlife.config.event.StepId
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.asFlow
import kotlinx.coroutines.flow.flowOn
import kotlinx.coroutines.flow.onEach
import java.util.concurrent.CancellationException

/**
 * # wifi扫描
 * 1.扫描设备热点并连接,5s一次,持续12次(共1min),找到后停止轮询
 * 成功:热点连接 [StepConnectDeviceAP]
 * 失败:手动连接 [StepManualConnect]
 * 2.监听网络变化,用户可能会手动连接wifi
 * 成功:连接状态二次确认 [StepConnectCheck]
 */
class StepWifiScan : SmartStepConfig() {
    private val AP_CHANGED = 1001

    private var apWifiReceiver: ApWifiBroadcastReceiver? = null
    private var scanJob: Job? = null
    private var delayJob: Job? = null

    /**
     * 设备缓存超时时间
     */
    companion object {
        private const val DEVICE_CACHE_TIME = 5 * 60 * 1000
    }

    override fun stepName(): Step = Step.STEP_APP_WIFI_SCAN

    override fun handleMessage(msg: Message) {
        if (msg.what == AP_CHANGED) {
            val scanResults = msg.obj as List<ScanResult>
            LogUtil.d(TAG, "handleMessage: scan wifi list size: ${scanResults.size}")
            val results = scanResults.filter {
                isDeviceWifi(it.SSID)
            }.sortedByDescending { WifiManager.calculateSignalLevel(it.level, 100) }
                .toMutableList()
            LogUtil.d(TAG, "handleMessage: filter wifi list size ${results.size}")
            if (results.size == 0) {
                return
            }
            // wifi列表第一个不一定是用户要绑定的目标设备热点,需要判断productWifiName
            val result = if (TextUtils.isEmpty(StepData.productWifiName)) {
                results[0]
            } else {
                results.firstOrNull {
                    it.SSID == StepData.productWifiName
                }
            }
            if (result == null) return
            LogUtil.i(TAG, "handleMessage: find target wifi connect ssid: ${result.SSID}")
            scanJob?.cancel(CancellationException("find target ap, stop scan. ssid: $result"))
            getHandler().removeMessages(AP_CHANGED);

            LogUtil.i(TAG, "handleMessage: current step mode is : ${StepData.stepMode}")
            if (StepData.stepMode == StepData.StepMode.MODE_SCANNING) {
                StepData.stepMode = StepData.StepMode.MODE_WIFI
                Log.i(TAG, "StepWifiScan handleMessage change current mode is : ${StepData.stepMode}")
                StepData.deviceApName = result.SSID
                nextStep(Step.STEP_CONNECT_DEVICE_AP)
            }
        }
    }

    override fun stepCreate() {
        super.stepCreate()
        Log.d(TAG, "stepCreate: StepWifiScan")
        delayJob = launch {
            // 延迟等待，优先蓝牙连接
            delay(StepData.stepModeDelay.toLong())

            // 尝试连接一次， 如果连接成功，则不开启扫描
            val elapsedRealtime = SystemClock.elapsedRealtime()
            val deviceWrapper = StepData.wifiDeviceWrapper
            val overTime = elapsedRealtime - (deviceWrapper?.timestamp ?: 0)
            LogUtil.d("stepCreate: StepWifiScan  cacheTime: ${deviceWrapper?.timestamp} ,overdue: ${overTime / 1000}  ,deviceApName：${StepData.deviceApName} ,productWifiName: ${StepData.productWifiName}")
            if (StepData.deviceApName.isNotBlank()) {
                if (overTime < DEVICE_CACHE_TIME) {
                    //
                    LogUtil.i(TAG, "stepCreate: current step mode is : ${StepData.stepMode}")
                    if (StepData.stepMode == StepData.StepMode.MODE_SCANNING) {
                        StepData.stepMode = StepData.StepMode.MODE_WIFI
                        Log.i(TAG, "StepWifiScan handleMessage change current mode is : ${StepData.stepMode}")
                        nextStep(Step.STEP_CONNECT_DEVICE_AP)
                        return@launch
                    }
                }
            }

            // 增加确定Wi-Fi设备名，直接尝试连接
            if (StepData.productWifiName.isNotBlank()) {
                if (overTime < DEVICE_CACHE_TIME) {
                    //
                    StepData.deviceApName = StepData.productWifiName
                    LogUtil.i(TAG, "stepCreate: current step mode is : ${StepData.stepMode}")
                    if (StepData.stepMode == StepData.StepMode.MODE_SCANNING) {
                        StepData.stepMode = StepData.StepMode.MODE_WIFI
                        Log.i(TAG, "StepWifiScan handleMessage change current mode is : ${StepData.stepMode}")
                        nextStep(Step.STEP_CONNECT_DEVICE_AP)
                        return@launch
                    }
                }
            }

            registerReceiver()
            startScanApWifi()
        }
    }


    private fun startScanApWifi() {

        // android前台app最大支持2分钟4次
        scanJob = launch {
            (0 until 12).asFlow()
                .onEach {
                    delay(DELAY_WIFI_ONLY_TIME.toLong())
                }
                .flowOn(Dispatchers.IO)
                .collect {
                    LogUtil.i(TAG, "startScanApWifi: startScan count $it")
                    //
                    if (StepData.stepMode == StepData.StepMode.MODE_SCANNING) {
                        wifiManager.startScan()
                    }
                }
            // 延迟5s保证最后一次搜索有效
            delay(5000)
            getHandler().sendMessage(Message.obtain().apply {
                obj = StepResult(StepName.STEP_CONNECT, StepState.FAILED, stepId = StepId.STEP_APP_WIFI_SCAN, reason = "scan nothing")
            })
            nextStep(Step.STEP_MANUAL_CONNECT)
        }
    }

    override fun stepDestroy() {
        unRegisterReceiver()
        delayJob?.cancel("step destroy")
        delayJob = null
        scanJob?.cancel("step destroy")
        scanJob = null
        getHandler().removeMessages(AP_CHANGED)
    }

    override fun registerNetChange() = true

    override fun handleNetChangeEvent(connectedSsid: String) {
        if (!isStepRunning()) {
            return
        }
        if (!TextUtils.isEmpty(connectedSsid) && isDeviceWifi(connectedSsid)) {
            LogUtil.i(
                TAG,
                "user manual connect: wifiName: $connectedSsid " +
                        "-- state: ${wifiManager.connectionInfo.supplicantState}"
            )
            getHandler().removeCallbacksAndMessages(null)
            scanJob?.cancel(CancellationException("user manual connect, stop scan. ssid: $connectedSsid"))
            StepData.deviceApName = connectedSsid
            nextStep(Step.STEP_CONNECT_CHECK)
        }
    }

    private fun registerReceiver() {
        apWifiReceiver = ApWifiBroadcastReceiver().also {
            val filter = IntentFilter().apply {
                // 监听wifi列表变化（开启一个热点或者关闭一个热点）
                addAction(WifiManager.SCAN_RESULTS_AVAILABLE_ACTION)
            }
            context.registerReceiver(it, filter)
        }
    }

    private fun unRegisterReceiver() {
        apWifiReceiver?.let {
            try {
                context.unregisterReceiver(it)
                apWifiReceiver = null
            } catch (e: Exception) {
                Log.e(TAG, "unRegisterReceiver: $e")
            }
        }
    }

    private inner class ApWifiBroadcastReceiver : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {

            if (WifiManager.SCAN_RESULTS_AVAILABLE_ACTION == intent.action) {
                var booleanExtra = false
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    booleanExtra = intent.getBooleanExtra(WifiManager.EXTRA_RESULTS_UPDATED, false)
                    if (booleanExtra) {
                        // 有更新
                        Log.d(TAG, "ApWifiBroadcastReceiver: wifi 列表有更新")
                    }
                }
                val scanResults = wifiManager.scanResults
                DeviceScanCache.buildWifiDeviceBean(scanResults)
                LogUtil.i(TAG, "ApWifiBroadcastReceiver onReceive: and send AP_CHANGED ${scanResults.size}")
                val message = getHandler().obtainMessage().apply {
                    obj = scanResults
                    what = AP_CHANGED
                }
                getHandler().sendMessage(message)
            }
        }
    }

}