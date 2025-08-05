package com.dreame.feature.connect.config.step.bluetooth

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.le.BluetoothLeScanner
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanFilter
import android.bluetooth.le.ScanResult
import android.bluetooth.le.ScanSettings
import android.dreame.module.BuildConfig
import android.dreame.module.feature.connect.bluetooth.BleGattAttributes
import android.dreame.module.util.LogUtil
import android.os.Handler
import android.os.Looper
import android.os.Message
import android.os.ParcelUuid
import android.util.Log
import com.dreame.feature.connect.scan.DeviceScanCache
import com.dreame.smartlife.config.step.callback.IBleScanCallBack
import java.text.MessageFormat
import java.util.concurrent.CopyOnWriteArrayList

object BleDeviceScanner {
    private const val TAG = "BleDeviceScanner"

    private const val SCAN_PERIOD = 20_000L
    private const val SCAN_PERIOD_DELAY = 10_000L
    private const val SCAN_FIRST_DELAY = 2_000L
    private const val SCAN_PERIOD_COUNT = 4

    private const val MSG_WHAT_SCAN = 0x10
    private const val MSG_WHAT_STOP = 0x11
    private const val MSG_WHAT_FINISH = 0x12
    private const val MSG_WHAT_SCAN_CALLBACK = 0x13

    private val parcelUuid by lazy { ParcelUuid(BleGattAttributes.lookup(BleGattAttributes.CLIENT_CHARACTERISTIC_SERVICE)) }

    private var mBluetoothAdapter: BluetoothAdapter? = BluetoothAdapter.getDefaultAdapter()
    private var bluetoothLeScanner: BluetoothLeScanner? = null
    private var scanCallback: DeviceScanCallback? = null

    private var scanFilters: List<ScanFilter> = buildScanFilters()
    private var scanSettings: ScanSettings = buildScanSettings()

    private val mScanCallBacks = CopyOnWriteArrayList<IBleScanCallBack>()

    var mMaxScanCount = SCAN_PERIOD_COUNT

    // 扫描次数
    private var countScan = 0
    private var mScanning = true
    private var mScanStarting = false
    private val mScanHandler = Handler(Looper.getMainLooper()) { msg ->
        when (msg.what) {
            MSG_WHAT_SCAN_CALLBACK -> {
                val callback = msg.obj as? IBleScanCallBack
                if (callback != null) {
                    addScanCallback(callback)
                }
                onScanStart()
            }

            MSG_WHAT_SCAN -> {
                LogUtil.i(TAG, ": ------MSG_WHAT_SCAN ,countScan = $countScan  ,mMaxScanCount = $mMaxScanCount------")
                mScanning = true
                realStartScanBle()
            }

            MSG_WHAT_STOP -> {
                if (countScan < mMaxScanCount) {
                    LogUtil.i(TAG, ": ------MSG_WHAT_STOP ------- stop and rescan,countScan = $countScan  ,mMaxScanCount = $mMaxScanCount------")
                    realStopScanning(false)
                    reScan()
                    countScan++
                } else {
                    LogUtil.i(TAG, ": ------MSG_WHAT_STOP ------- stop ,countScan = $countScan  ,mMaxScanCount = $mMaxScanCount------")
                    realStopScanning()
                    onScanStop(0)
                    mScanning = false

                    onComplete()
                }
            }
            MSG_WHAT_FINISH -> {
                LogUtil.i(TAG, ": ------MSG_WHAT_FINISH ,countScan = $countScan  ,mMaxScanCount = $mMaxScanCount------")
                countScan = Int.MAX_VALUE
                realStopScanning()
                mScanning = false
                onComplete()

            }
        }
        true
    }

    /**
     * 扫描前，保证蓝牙已开启， 此处不开蓝牙
     */
    fun startScan(delay: Long = SCAN_FIRST_DELAY, callback: IBleScanCallBack? = null) {
        LogUtil.d(TAG, "startScan  ${Thread.currentThread().name}")
        if ("main" != Thread.currentThread().name) {
            printTrack()
        }
        if (mBluetoothAdapter?.isEnabled != true) {
            // 蓝牙未开启
            LogUtil.i(TAG, "startScan: 蓝牙未开启")
            onScanStop(-1)
            return
        }
        if (mScanning) {
            // 先停止
            if (mScanHandler.hasMessages(MSG_WHAT_SCAN)) {
                mScanHandler.removeMessages(MSG_WHAT_SCAN)
            }
            if (mScanHandler.hasMessages(MSG_WHAT_FINISH)) {
                mScanHandler.removeMessages(MSG_WHAT_FINISH)
            }
            if (mScanHandler.hasMessages(MSG_WHAT_SCAN_CALLBACK)) {
                mScanHandler.removeMessages(MSG_WHAT_SCAN_CALLBACK)
            }
            mScanHandler.sendEmptyMessage(MSG_WHAT_FINISH)

        }
        countScan = 0
        // Checks if Bluetooth is supported on the device.
        if (mBluetoothAdapter?.isEnabled == true) {
            if (mScanHandler.hasMessages(MSG_WHAT_SCAN)) {
                mScanHandler.removeMessages(MSG_WHAT_SCAN)
            }
            mScanHandler.post {
                countScan = 0
            }
            mScanHandler.sendEmptyMessageDelayed(MSG_WHAT_SCAN, delay)

            mScanHandler.sendMessage(Message.obtain().apply {
                what = MSG_WHAT_SCAN_CALLBACK
                obj = callback
            })
        } else {
            LogUtil.i(TAG, "stepCreate: 蓝牙不支持")
            onScanStop(-1)
            return
        }
    }

    fun stopScan() {
        LogUtil.d(TAG, "stopScan")
        mScanHandler.removeCallbacksAndMessages(null)
        mScanHandler.sendEmptyMessage(MSG_WHAT_FINISH)
        mScanCallBacks.clear()
    }

    private fun reScan() {
        LogUtil.i(TAG, "----- reScan ------")
        mScanHandler.sendEmptyMessageDelayed(MSG_WHAT_SCAN, SCAN_PERIOD_DELAY)
    }

    fun isOpen() = mBluetoothAdapter?.isEnabled == true

    private fun realStartScanBle() {
        LogUtil.i(TAG, "realStartScanBle")
        if (mScanStarting) {
            return
        }
        mScanStarting = true
        LogUtil.i(TAG, "realStartScanBle mScanStarting")
        if (!isOpen()) {
            mScanStarting = false
            mScanHandler.sendEmptyMessage(MSG_WHAT_FINISH)
            return
        }
        LogUtil.i(TAG, "realStartScanBle scanning")
        if (scanCallback == null) {
            scanCallback = DeviceScanCallback()
            bluetoothLeScanner = mBluetoothAdapter?.bluetoothLeScanner
        }
        mScanHandler.sendEmptyMessageDelayed(MSG_WHAT_STOP, SCAN_PERIOD)
        LogUtil.i(TAG, "realStartScanBle startScan")
        bluetoothLeScanner?.startScan(scanFilters, scanSettings, scanCallback)

    }

    private fun realStopScanning(removeCallback: Boolean = true) {
        LogUtil.i(TAG, "realStopScanning removeCallback = $removeCallback")
        if (!mScanStarting) {
            return
        }
        mScanStarting = false
        LogUtil.d(TAG, "realStopScanning Stopping Scanning")
        if (!isOpen()) {
            LogUtil.e(TAG, "realStopScanning BLE is close , clear all callback")
            countScan = Int.MAX_VALUE
            mScanning = false
            onComplete()
            scanCallback = null
            bluetoothLeScanner = null
            return
        }
        LogUtil.i(TAG, "realStopScanning stopScan ")
        bluetoothLeScanner?.stopScan(scanCallback)
        if (removeCallback) {
            scanCallback = null
            bluetoothLeScanner = null
        }
    }

    private fun filterDevice(
        device: BluetoothDevice,
        scanRecord: ByteArray,
        rssi: Int,
        result: String
    ) {
        // 过滤
        // dreamebt-10600-1Q:AF
        val ret = result.contains("dreame") || result.contains("mova")
        if (ret) {
            if (BuildConfig.DEBUG) {
                LogUtil.e(TAG, "蓝牙设备: ${device.name} ${device.address}  $result")
            } else {
                LogUtil.d(TAG, "蓝牙设备: ${device.name} ${device.address}  $result")
            }
            onScanResult(device, scanRecord, rssi, result)
        }
    }

    private fun buildScanFilters(): List<ScanFilter> {
        val scanFilter = ScanFilter.Builder()
            .setServiceUuid(parcelUuid)
            .build()
        Log.d(TAG, "buildScanFilters")
        return listOf(scanFilter)
    }

    private fun buildScanSettings() = ScanSettings.Builder()
        .setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY)
        .build()
    private class DeviceScanCallback : ScanCallback() {
        override fun onScanResult(callbackType: Int, result: ScanResult) {
            super.onScanResult(callbackType, result)
            try {
                // fix: maybe  ScanRecord.mServiceData = null
                val ret = result.scanRecord?.getServiceData(parcelUuid)?.run {
                    String(this)
                }
                if (BuildConfig.DEBUG) {
                    Log.d(TAG, "蓝牙扫描结果 -----onLeScan-----: ${result.device.name} ${result.device.address}  ${ret}")
                }
                if (!ret.isNullOrEmpty() && (ret.startsWith("dreame", false) ||ret.startsWith("mova", false))) {
                    mScanHandler.post {
                        filterDevice(
                            result.device,
                            result.scanRecord?.bytes ?: byteArrayOf(0),
                            result.rssi,
                            ret
                        )
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }

        override fun onScanFailed(errorCode: Int) {
            super.onScanFailed(errorCode)
            val errorMessage = "Scan failed with error: $errorCode"
            LogUtil.e(TAG, "onScanFailed: $errorMessage")
        }
    }

    @Synchronized
    fun addScanCallback(element: IBleScanCallBack) {
        LogUtil.i(TAG, "addScanCallback $element ")
        if (!mScanCallBacks.contains(element)) {
            mScanCallBacks.add(element)
        }
    }

    @Synchronized
    fun removeScanCallback(element: IBleScanCallBack) {
        LogUtil.i(TAG, "removeScanCallback $element ")
        if (mScanCallBacks.contains(element)) {
            mScanCallBacks.remove(element)
        }
    }

    fun clearScanCallback() {
        LogUtil.i(TAG, "clearScanCallback  ")
        mScanCallBacks.clear()
    }

    @Synchronized
    private fun onScanStart() {
        LogUtil.i(TAG, "onScanStart:  ,callback.Size: ${mScanCallBacks.size}")
        mScanCallBacks.forEach {
            it.onScanStart()
        }
    }

    @Synchronized
    private fun onScanStop(ret: Int) {
        LogUtil.i(TAG, "onScanStop:  ret: $ret  ,callback.Size: ${mScanCallBacks.size}")
        mScanCallBacks.forEach {
            it.onScanStop(ret)
        }
    }

    @Synchronized
    private fun onProgress(progress: Int) {
        LogUtil.i(TAG, "onProgress:  ,callback.Size: ${mScanCallBacks.size}")

        mScanCallBacks.forEach {
            it.onProgress(progress)
        }
    }

    @Synchronized
    private fun onScanResult(device: BluetoothDevice, scanRecord: ByteArray, rssi: Int, result: String) {
        LogUtil.d(TAG, "onScanResult:  ,callback.Size: ${mScanCallBacks.size}")
        DeviceScanCache.createOrUpdateBleDeviceBean(result, device, scanRecord, rssi)
        mScanCallBacks.forEach {
            it.onScanResult(device, scanRecord, rssi, result)
        }
    }

    @Synchronized
    private fun onComplete() {
        LogUtil.i(TAG, "onComplete:  ,callback.Size: ${mScanCallBacks.size}")
        mScanCallBacks.forEach {
            it.onComplete()
        }
    }

    fun closeBle(): Boolean {
        LogUtil.i(TAG, "closeBle  ")
        return mBluetoothAdapter?.runCatching {
            if (isEnabled) {
                disable()
            } else {
                true
            }
        }?.getOrDefault(false) ?: false
    }

    /**
     * 打印当前线程的调用堆栈
     *
     */
    fun printTrack() {
        val st = Thread.currentThread().stackTrace
        val sbf = StringBuffer()
        for (e in st) {
            if (sbf.isNotEmpty()) {
                sbf.append(" <- ")
                sbf.append(System.getProperty("line.separator"))
            }
            sbf.append(
                MessageFormat.format(
                    "{0}.{1}() {2}", e.className, e.methodName, e.lineNumber
                )
            )
        }
        LogUtil.e(sbf.toString())
    }
}
