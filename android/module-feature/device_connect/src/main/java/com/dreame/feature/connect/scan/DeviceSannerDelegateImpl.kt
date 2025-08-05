package com.dreame.smartlife.ui.activity.main

import android.app.Activity
import android.dreame.module.bean.device.DreameWifiDeviceBean
import android.dreame.module.util.LogUtil
import android.os.Handler
import android.os.Looper

/**
 * 发现设备
 */

open class DeviceSannerDelegateImpl(context: Activity) : BaseDeviceSannerDelegate(context) {

    val mHandler by lazy { Handler(Looper.getMainLooper()) }

    override fun isScanOnResume() = true

    var block: ((show: Boolean, bean: DreameWifiDeviceBean?) -> Unit)? = null
    var block2: ((show: Boolean, list: MutableList<DreameWifiDeviceBean>) -> Unit)? = null

    var scanBlock: ((stop: Boolean) -> Unit)? = null

    override fun showUI(toMutableList: MutableList<DreameWifiDeviceBean>) {
        val selector = toMutableList.sortedByDescending {
            it.level
        }
        if (selector.isNotEmpty()) {
            block?.invoke(true, selector[0])
        } else {
            block?.invoke(false, null)
        }
        block2?.invoke(true, toMutableList)
    }

    override fun dismissUI() {
        block?.invoke(false, null)
    }

    override fun onStartScan() {
        scanBlock?.invoke(false)
        LogUtil.d("---------- onStartScan: ---------- ")

        if (scanBlock == null) {
            mHandler.removeCallbacks(runnable)
        }
    }

    override fun onStopScan(ret: Int) {
        scanBlock?.invoke(true)
        LogUtil.d("---------- onStopScan: ---------- ")

        if (scanBlock == null && isPageVisiable && deviceScannerDelegate.isPermissionGrand()) {
            mHandler.postDelayed(runnable, 10_000)
        }
    }

    override fun onPause() {
        super.onPause()
        mHandler.removeCallbacks(runnable)
    }

    private val runnable = Runnable {
        startScanDeviceDirect()
    }

}