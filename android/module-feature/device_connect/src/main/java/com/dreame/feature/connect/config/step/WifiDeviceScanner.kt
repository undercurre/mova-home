package com.dreame.smartlife.config.step

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.dreame.module.LocalApplication
import android.dreame.module.util.LogUtil
import android.net.wifi.ScanResult
import android.net.wifi.WifiManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import android.util.Log
import com.dreame.feature.connect.config.step.bluetooth.BleDeviceScanner
import com.dreame.feature.connect.scan.DeviceScanCache
import com.dreame.smartlife.config.step.callback.IWiFiScanListener
import java.util.concurrent.CopyOnWriteArrayList

object WifiDeviceScanner {
    private const val TAG = "WifiDeviceScanner"

    private const val SCAN_PERIOD_DELAY = 8_000L
    private const val SCAN_FIRST_DELAY = 3_000L
    private const val SCAN_PERIOD_COUNT = 6

    private const val MSG_WHAT_SCAN = 0x10
    private const val MSG_WHAT_STOP = 0x11
    private const val MSG_WHAT_FINISH = 0x12

    /**
     * 2.4 GHz band frequency of first channel in MHz
     * @hide
     */
    const val BAND_24_GHZ_START_FREQ_MHZ = 2412

    /**
     * 2.4 GHz band frequency of last channel in MHz
     * @hide
     */
    const val BAND_24_GHZ_END_FREQ_MHZ = 2484

    private val wifiManager: WifiManager by lazy {
        LocalApplication.getInstance().applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
    }
    private val wifiReceiver: WifiBroadcastReceiver by lazy { WifiBroadcastReceiver() }
    private val mScanCallBacks = CopyOnWriteArrayList<IWiFiScanListener>()

    var mMaxScanCount = SCAN_PERIOD_COUNT

    @Volatile
    private var mScanning = true

    @Volatile
    var mFilterDevice = true

    @Volatile
    var isRegister = false

    // 扫描次数
    private var countScan = 0

    private val mScanHandler = Handler(Looper.getMainLooper()) { msg ->
        when (msg.what) {
            MSG_WHAT_SCAN -> {
                mScanning = true
                Log.d(TAG, "startScanWiFi MSG_WHAT_SCAN: ")
                realStartScanWifi()
            }

            MSG_WHAT_STOP -> {
                Log.d(TAG, "startScanWiFi MSG_WHAT_STOP: ")
                realStopScanning()
                if (countScan < mMaxScanCount) {
                    reScan()
                    countScan++
                } else {
                    onScanStop(0)
                    mScanning = false
                    onComplete()
                }
            }

            MSG_WHAT_FINISH -> {
                Log.d(TAG, "startScanWiFi MSG_WHAT_FINISH: ")

                mScanning = false
                countScan = Int.MAX_VALUE
                realStopScanning()
                onComplete()
            }
        }
        true
    }

    fun startScanDeviceDirect() {
        Log.d(TAG, "startScanWiFi startScanDeviceDirect: ")

        countScan = 0
        mScanHandler.removeCallbacksAndMessages(null)
        mScanHandler.sendEmptyMessageDelayed(MSG_WHAT_SCAN, SCAN_FIRST_DELAY)
        onScanStart()
    }

    /**
     * start stop context must be sample one
     */
    fun startScan(context: Context, delay: Long = SCAN_FIRST_DELAY) {
        Log.d(TAG, "stepCreate: startScan")
        if ("main" != Thread.currentThread().name) {
            BleDeviceScanner.printTrack()
        }
        if (mScanning) {
            stopScan(context, forceStop = false, clearCallback = false)
        }
        reigsterReceiver(context)
        countScan = 0
        mScanHandler.removeMessages(MSG_WHAT_SCAN)
        mScanHandler.sendEmptyMessageDelayed(MSG_WHAT_SCAN, delay)
        onScanStart()
    }

    private fun reigsterReceiver(context: Context) {
        if (!isRegister) {
            isRegister = true
            // Checks if Bluetooth is supported on the device.
            val filter = IntentFilter(WifiManager.SCAN_RESULTS_AVAILABLE_ACTION)
            runCatching {
                LogUtil.d(TAG, "stepCreate: startScan reigsterReceiver")
                context.applicationContext.registerReceiver(wifiReceiver, filter)
            }
        }
    }

    private fun unReigsterReceiver(context: Context) {
        if (isRegister) {
            isRegister = false
            runCatching {
                LogUtil.d(TAG, "stepCreate: startScan unReigsterReceiver")
                context.applicationContext.unregisterReceiver(wifiReceiver)
            }
        }
    }

    fun stopScan(context: Context, forceStop: Boolean = false, clearCallback: Boolean = true) {
        Log.d(TAG, "startScanWiFi stopScan: ")
        mScanHandler.removeCallbacksAndMessages(null)
        mScanHandler.sendEmptyMessage(MSG_WHAT_FINISH)
        if (forceStop) {
            unReigsterReceiver(context)
        }
        if (clearCallback) {
            clearScanCallback()
        }
    }

    private fun reScan() {
        Log.d(TAG, "startScanWiFi reScan: ")
        mScanHandler.sendEmptyMessageDelayed(MSG_WHAT_SCAN, SCAN_PERIOD_DELAY)
    }

    fun isOpen() = wifiManager.isWifiEnabled
    var time = SystemClock.elapsedRealtime()
    private fun realStartScanWifi() {
        Log.d(TAG, "realStartScanWifi : ")
        val elapsedRealtime = SystemClock.elapsedRealtime()
        if (elapsedRealtime - time > SCAN_FIRST_DELAY) {
            time = elapsedRealtime
            Log.d(TAG, "realStartScanWifi : ---------- real ------")
            val startScan = wifiManager.startScan()
            if (!startScan) {
                Log.e(TAG, "startScanWiFi Scanning $startScan")
            } else {
                Log.d(TAG, "startScanWiFi Scanning $startScan")
            }
            mScanHandler.sendEmptyMessageDelayed(MSG_WHAT_STOP, SCAN_PERIOD_DELAY)
        }

    }

    private fun realStopScanning() {
        Log.d(TAG, "startScanWiFi Stopping Scanning")
        val scanResults = wifiManager.scanResults
        handelScanResults(scanResults)
    }

    private fun filterDevice(scanResults: List<ScanResult>) {
        //
        LogUtil.d(TAG, "handleMessage: scan wifi list size: ${scanResults.size}")
        val results = scanResults
            .filter {
                is24GHz(it.frequency)
            }
//            .filter {
//                !it.SSID.isNullOrEmpty() && (it.SSID != "unknown ssid" || it.SSID != "<unknow>" || it.SSID != "< unknow >")
//            }
            .filter {
                it.SSID.startsWith("dreame-") || it.SSID.startsWith("mova-") || it.SSID.startsWith("trouver-")
            }
            .sortedByDescending { WifiManager.calculateSignalLevel(it.level, 100) }
            .onEach {
                LogUtil.d(TAG, "wifi设备: ${it.SSID} ${it.frequency} ${is24GHz(it.frequency)}")

            }
        LogUtil.d(TAG, "handleMessage: filter wifi list size ${results.size}")
        if (results.isEmpty()) {
            return
        }
        // 回调
        onScanResult(results)

    }

    fun is24GHz(freqMhz: Int): Boolean {
        return freqMhz in 2401..2499
    }

    private class WifiBroadcastReceiver : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            if (WifiManager.SCAN_RESULTS_AVAILABLE_ACTION == intent.action) {
                var booleanExtra = false
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    booleanExtra = intent.getBooleanExtra(WifiManager.EXTRA_RESULTS_UPDATED, false)
                    if (booleanExtra) {
                        // 有更新
                        LogUtil.d(TAG, "wifi 列表有更新")
                    }
                }
                val results = wifiManager.scanResults
                LogUtil.v(TAG, "扫描结果1 ${results.size}")
                handelScanResults(results)
            }
        }
    }

    private fun handelScanResults(results: MutableList<ScanResult>) {
        val scanResults = results
            .filter {
                is24GHz(it.frequency)
            }
            .filter {
                !it.SSID.isNullOrEmpty() && (it.SSID != "unknown ssid" || it.SSID != "<unknow>" || it.SSID != "< unknow >")
            }
        // 过滤设备
        if (mFilterDevice) {
            filterDevice(scanResults)
        } else {
            onScanResult(scanResults)
        }
        LogUtil.v(TAG, "扫描结果2 ${scanResults.size}")
    }

    fun addScanCallback(element: IWiFiScanListener) {
        Log.d(TAG, "addScanCallback: $element")
        if (!mScanCallBacks.contains(element)) {
            mScanCallBacks.add(element)
        }
    }

    fun removeScanCallback(element: IWiFiScanListener) {
        Log.d(TAG, "removeScanCallback: $element")
        if (mScanCallBacks.contains(element)) {
            mScanCallBacks.remove(element)
        }
    }

    fun clearScanCallback() {
        Log.d(TAG, "clearScanCallback:")
        mScanCallBacks.clear()
    }

    @Synchronized
    private fun onScanStart() {
        mScanCallBacks.forEach {
            it.onScanStart()
        }
    }

    @Synchronized
    private fun onScanStop(ret: Int) {
        mScanCallBacks.forEach {
            it.onScanStop(ret)
        }
    }

    @Synchronized
    private fun onProgress(progress: Int) {
        mScanCallBacks.forEach {
            it.onProgress(progress)
        }
    }

    @Synchronized
    private fun onScanResult(scanResults: List<ScanResult>) {
        // 缓存扫描到的Wi-Fi设备
        DeviceScanCache.buildWifiDeviceBean(scanResults)

        LogUtil.d(TAG, "onScanResult: ${mScanCallBacks.size}")
        mScanCallBacks.forEach {
            it.onScanResult(scanResults)
        }
    }

    @Synchronized
    private fun onComplete() {
        mScanCallBacks.forEach {
            it.onComplete()
        }
    }

    /**
     * 权限校验完后，提前调用一次  wifiManager.scanResults
     */
    fun getScanResultFirst(): List<ScanResult> = runCatching {
        wifiManager.scanResults
    }.getOrElse { emptyList() }


}
