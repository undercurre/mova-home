package com.dreame.feature.connect.device.scan.uiconfig

import android.dreame.module.bean.device.DreameWifiDeviceBean
import com.dreame.feature.connect.device.scan.DevcieScanNearbyActivity
import com.dreame.feature.connect.utils.ObserverActivityLifecycle
import com.dreame.smartlife.connect.databinding.ActivityDevcieScanNearbyBinding

/// 扫附近设备 uiconfig
abstract class DeviceUiConfig(val activity: DevcieScanNearbyActivity, val binding: ActivityDevcieScanNearbyBinding) : ObserverActivityLifecycle(activity) {


    open fun onScanStart() {

    }

    abstract fun onShow()

    abstract fun onHide()

    open fun onScanStop(nothing: Boolean) {

    }

    open fun onScanProgress(progress: Int) {

    }

    open fun onScanUpdateList(list: List<DreameWifiDeviceBean>) {

    }


}