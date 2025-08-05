package com.dreame.smartlife.ui.activity.main

import android.app.Activity
import android.dreame.module.bean.device.DreameWifiDeviceBean
import android.dreame.module.data.entry.ProductListBean
import android.dreame.module.util.LogUtil
import android.os.SystemClock
import android.util.Log
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.Observer
import androidx.lifecycle.lifecycleScope
import com.blankj.utilcode.util.TimeUtils
import com.dreame.feature.connect.config.step.bluetooth.BleDeviceScanner
import com.dreame.feature.connect.product.ProductSelectListActivity
import com.dreame.feature.connect.qr.QRDeviceScanActivity
import com.dreame.feature.connect.scan.DeviceScanCache
import com.dreame.feature.connect.scan.DeviceScanModelCache
import com.dreame.feature.connect.scan.DeviceScannerDelegate
import android.dreame.module.util.ThrottleUtils
import com.dreame.smartlife.config.step.DeviceOpenChangeReceiver
import com.dreame.smartlife.config.step.ScanType
import com.dreame.smartlife.config.step.WifiDeviceScanner
import com.dreame.smartlife.config.step.callback.IDeviceScanListener
import com.dreame.smartlife.connect.BuildConfig
import com.hjq.permissions.Permission

/**
 * 发现设备
 */

open class BaseDeviceSannerDelegate(val context: Activity) {
    private val TAG = this.javaClass.simpleName

    private val deviceModelCache by lazy { DeviceScanModelCache() }
    protected val deviceScannerDelegate: DeviceScannerDelegate by lazy { DeviceScannerDelegate(context) }

    protected open val controlPermissionCheck: Boolean = true
    protected open var scanType: Int = DeviceScanCache.TYPE_BOTH
    open var forceShowType: Int = DeviceScanCache.TYPE_BOTH

    protected open val lastNumber: Int = -1

    protected var registerAgain: Boolean = true

    private var beforeOnStart = false

    private val filterModel = mutableListOf<String>()
    private val skipFilterModel = mutableListOf<String>()

    protected var isPageVisiable = false

    /// 是否扫描结束
    private var isScanFinish = false

    fun setFilterModel(list: List<String>) {
        filterModel.clear()
        filterModel.addAll(list)
    }

    fun setSkipFilterModel(list: List<String>) {
        skipFilterModel.clear()
        skipFilterModel.addAll(list)
    }

    /**
     * 初始化
     */
    init {
        (context as LifecycleOwner).lifecycle.addObserver(object : LifecycleEventObserver {
            override fun onStateChanged(source: LifecycleOwner, event: Lifecycle.Event) {
                when (event) {
                    Lifecycle.Event.ON_CREATE -> {
                        if (beforeOnStart) {
                            onCreate()
                        }
                    }

                    Lifecycle.Event.ON_START -> {
                        onStart()
                    }

                    Lifecycle.Event.ON_RESUME -> {
                        isPageVisiable = true
                        if (beforeOnStart) {
                            onResume()
                        }
                    }

                    Lifecycle.Event.ON_PAUSE -> {
                        isPageVisiable = false
                        onPause()
                    }

                    Lifecycle.Event.ON_STOP -> {
                        onStop()
                        if (context is ProductSelectListActivity || context is QRDeviceScanActivity) {
                            // 清理部分缓存
                            deviceModelCache.clear(context.isFinishing)
                        }
                    }

                    Lifecycle.Event.ON_DESTROY -> {
                        onDestroy()
                        deviceModelCache.clear(true)
                    }

                    else -> {}
                }
            }

        })

    }

    private fun unRegisterObservers() {
        if (scanType == DeviceScanCache.TYPE_BLE || scanType == DeviceScanCache.TYPE_BOTH) {
            DeviceScanCache.getBleDeviceScan().removeObservers(context as LifecycleOwner)
        }
        if (scanType == DeviceScanCache.TYPE_WIFI || scanType == DeviceScanCache.TYPE_BOTH) {
            DeviceScanCache.getWifiDeviceScan().removeObservers(context as LifecycleOwner)
        }
        deviceModelCache.deviceScanBleCacheList.removeObservers(context as LifecycleOwner)
    }

    private val throttledQuery =
        ThrottleUtils.throttleLatest<MutableList<DreameWifiDeviceBean>>(
            intervalMs = 300,
            coroutineScope = (context as LifecycleOwner).lifecycleScope
        )
        { list ->
            val toList = list.toList()
            if (toList.isNotEmpty()) {
                deviceModelCache.queryNearbyDevivceInfo(toList)
            }
        }
    private val throttledUpdateUi =
        ThrottleUtils.throttleLatest<MutableList<DreameWifiDeviceBean>>(
            intervalMs = 100,
            coroutineScope = (context as LifecycleOwner).lifecycleScope
        )
        { list ->
            extracted(list)
        }

    private fun regiserObservers() {
        if (scanType == DeviceScanCache.TYPE_BLE || scanType == DeviceScanCache.TYPE_BOTH) {
            DeviceScanCache.getBleDeviceScan().observe(context as LifecycleOwner) {
                LogUtil.d(TAG, "delegate regiserObservers: ble ")
                throttledQuery(it)
            }
        }
        if (scanType == DeviceScanCache.TYPE_WIFI || scanType == DeviceScanCache.TYPE_BOTH) {
            DeviceScanCache.getWifiDeviceScan().observe(context as LifecycleOwner) {
                LogUtil.d(TAG, "delegate regiserObservers: wifi ")
                throttledQuery(it)
            }
        }

        deviceModelCache.deviceScanBleCacheList.observe(context as LifecycleOwner, Observer { list ->
            throttledUpdateUi(list)
        })
    }

    private fun extracted(list: MutableList<DreameWifiDeviceBean>) {
        if (list.isEmpty()) {
            showUI(mutableListOf())
            return
        }
        // 控制生命周期
        LogUtil.d(TAG, "delegate regiserObservers deviceScanBleCacheList: ---------- ${list.size}")
        if (BuildConfig.DEBUG) {
            LogUtil.d(TAG, "delegate regiserObservers deviceScanBleCacheList ----------  dump start ---------------- ")
            list.onEach {
                LogUtil.d(TAG, "---------- : $it ")
            }
            LogUtil.d(TAG, "delegate regiserObservers deviceScanBleCacheList  ----------  dump end ---------------- ")
        }
        val toMutableList = list
            ?.filter {
                it.isUpdate && it.deviceProduct != null && (!it.name.equals(it.wifiName, true) || !it.name.equals(it.result, true))
            }?.apply {
                LogUtil.d(TAG, "delegate regiserObservers filter 1 --------- : ${size}")
            }?.filter {
                if (BuildConfig.DEBUG) {
                    val millis2String = TimeUtils.millis2String(it.timestamp)
                    val millis2String2 = TimeUtils.millis2String(it.deviceWrapper?.timestamp ?: 0)
                    val millis2String3 = TimeUtils.millis2String(SystemClock.elapsedRealtime())
                    Log.d(
                        "sunzhibin",
                        "delegate regiserObservers: ${SystemClock.elapsedRealtime() - it.timestamp}  $millis2String  $millis2String2   $millis2String3"
                    )
                }
                !DeviceScanCache.isOverDue(
                    it,
                    if (it.type == DeviceScanCache.TYPE_WIFI) DeviceScanCache.TYPE_WIFI else DeviceScanCache.TYPE_BLE
                )
            }?.apply {
                LogUtil.d(TAG, "delegate regiserObservers filter 2 --------- : ${size}")
            }?.sortedBy {
                it.deviceWrapper?.rssi
            }?.run {
                if (lastNumber > 0) {
                    this.takeLast(lastNumber)
                } else {
                    this
                }
            }
            ?.toMutableList() ?: mutableListOf()
        LogUtil.d(TAG, "delegate regiserObservers filter 3 --------- : ${toMutableList.size}")
        // UI 展示
        if (filterModel.isNotEmpty()) {
            val filterList = toMutableList.filter {
                filterModel.contains(it.product_model)
            }.toMutableList()
            showUI(filterList)
        } else if (skipFilterModel.isNotEmpty()) {
            val filterList = toMutableList.filter {
                !filterModel.contains(it.product_model)
            }.toMutableList()
            showUI(filterList)
        } else {
            showUI(toMutableList)
        }
    }

    open fun isScanOnResume() = true

    open fun showUI(toMutableList: MutableList<DreameWifiDeviceBean>) {

    }

    open fun dismissUI() {

    }

    private fun onCreate() {
        if (controlPermissionCheck) {
            deviceScannerDelegate.checkLocPermission(scanType, forceShowType)
        }
        DeviceOpenChangeReceiver.registerAllReceiver(context)
    }

    protected open fun onStart() {
        if (registerAgain) {
            regiserObservers()
        }
    }

    private fun onResume(scanDirect: Boolean = true) {
        // 重新扫描
        if (isScanFinish) {
            return
        }
        if (deviceScannerDelegate.isPermissionGrand() && isOpen()) {
            // 支持onresume 重新扫描
            if (isScanOnResume()) {
                this.beforeOnStart = true
                startScanDeviceDirect()
            }
        } else if (scanDirect) {
            deviceScannerDelegate.onResumeOnce(controlPermissionCheck)
        }
    }

    fun isOpen(): Boolean {
        if (scanType == DeviceScanCache.TYPE_BLE) {
            return BleDeviceScanner.isOpen()
        }
        if (scanType == DeviceScanCache.TYPE_WIFI) {
            return WifiDeviceScanner.isOpen()
        }
        if (scanType == DeviceScanCache.TYPE_BOTH) {
            return WifiDeviceScanner.isOpen() || BleDeviceScanner.isOpen()
        }
        return false
    }

    open fun onPause() {


    }

    private fun onStop() {
        dismissUI()

        // do nothing
        unRegisterObservers()
    }


    private fun onDestroy() {
        DeviceOpenChangeReceiver.unRegisterAllReceiver(context)
    }

    fun initScanner(beforeOnStart: Boolean = false) {
        this.beforeOnStart = beforeOnStart
        deviceScannerDelegate.deviceScanCallBack = object : IDeviceScanListener {
            override fun onScanStart() {
                onStartScan()
            }

            override fun onScanStop(ret: Int) {
                onStopScan(ret)
            }

            override fun onComplete() {
                onCompleteScan()
            }
        }
    }

    open fun onStartScan() {

    }

    open fun onStopScan(ret: Int) {

    }

    open fun onCompleteScan() {

    }


    /**
     * 开始扫描设备
     * @param re
     * @param clear 是否清理缓存
     */
    fun startScanDevice(checkLocPermission: Boolean = true, clear: Boolean = true, scanType: Int = DeviceScanCache.TYPE_BOTH) {
        this.scanType = scanType
        if (clear) {
            deviceModelCache.clear()
        }
//        this.beforeOnStart = checkLocPermission
        if (checkLocPermission) {
            onCreate()
            onResume(false)
        }
    }

    fun startScanDeviceDirect(): Boolean {
        return deviceScannerDelegate.startScanDeviceDirect(scanType)
    }

    fun addAllProductList(list: List<ProductListBean>) {
        deviceModelCache.addQueryModel(list)
    }

    fun addSkipNeverNecessarilyPermission(scType: String?, extendScType: List<String>?) {
        if (scType == ScanType.WIFI) {
            // 可以跳过蓝牙扫描
            deviceScannerDelegate.addSkipNeverNecessarilyPermission(
                listOf(
                    Permission.ACCESS_COARSE_LOCATION,
                    Permission.ACCESS_FINE_LOCATION
                )
            )
        }
    }

    fun finishScanDevice() {
        isScanFinish = true
    }

}