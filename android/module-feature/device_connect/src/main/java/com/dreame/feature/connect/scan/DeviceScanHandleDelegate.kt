package com.dreame.feature.connect.scan

import android.dreame.module.bean.device.DreameWifiDeviceBean
import android.dreame.module.data.entry.ProductListBean
import android.dreame.module.feature.connect.bluetooth.adrecord.ScanRecordUtil
import android.util.Log
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.MutableLiveData
import com.blankj.utilcode.util.TimeUtils
import com.dreame.feature.connect.scan.DeviceScanCache.isOverDue
import com.dreame.smartlife.connect.BuildConfig

class DeviceScanHandleDelegate(val context: FragmentActivity) {
    private val deviceModelCache by lazy { DeviceScanModelCache() }
    val deviceScanBleCacheList = MutableLiveData<MutableList<DreameWifiDeviceBean>>()


    fun queryDeviceModel(item: DreameWifiDeviceBean) {
        deviceModelCache.queryNearbyDevivceInfo(mutableListOf(item))
    }

    fun addQueryModel(list: List<ProductListBean>) {
        deviceModelCache.addQueryModel(list)
    }

    fun reigsterObserver() {
        deviceModelCache.deviceScanBleCacheList.observe(context) {
            val filter = it?.filter {
                !isOverDue(it, if (it.type == DeviceScanCache.TYPE_WIFI) DeviceScanCache.TYPE_WIFI else DeviceScanCache.TYPE_BLE)
            }?.toMutableList() ?: mutableListOf()
            deviceScanBleCacheList.value = filter
        }
        DeviceScanCache.getWifiDeviceScan().observe(context) {
            Log.d("sunzhibin", "WIFI onChanged: ++++++++++++++++++++++")
            val toList = it.toList()
            if (toList.isNotEmpty()) {
                if (BuildConfig.DEBUG) {
                    for (bean in toList) {
                        val wifiName = bean.wifiName
                        var s: String? = null
                        if (bean.deviceWrapper != null) {
                            s = bean.deviceWrapper?.scanRecord?.let {
                                String(it)
                            } ?: ""

                        }
                        Log.d(
                            "sunzhibin", "WIFI onChanged: wifiName: " + wifiName + " ,SSID: " + bean.ssid + " ,scanRecord: " + s + ", 过期时间："
                                    + TimeUtils.millis2String(bean.timestamp)
                                    + isOverDue(bean)
                        )
                    }
                }
                deviceModelCache.queryNearbyDevivceInfo(toList)
            }
        }
        DeviceScanCache.getBleDeviceScan().observe(context) {
            Log.d("sunzhibin", "BLE onChanged: ++++++++++++++++++++++")
            val toList = it.toList()
            if (toList.isNotEmpty()) {

                if (BuildConfig.DEBUG) {
                    for (bean in toList) {
                        val wifiName = bean.wifiName
                        var s: String? = null
                        if (bean.deviceWrapper != null) {
                            s = bean.deviceWrapper?.result ?: ""
                        }
                        Log.d(
                            "sunzhibin", "BLE onChanged: wifiName: " + wifiName + " ,SSID: " + bean.ssid + " ,scanRecord: " + s + ", 过期时间："
                                    + TimeUtils.millis2String(bean.timestamp)
                                    + isOverDue(bean)
                        )
                    }
                }
                deviceModelCache.queryNearbyDevivceInfo(toList)
            }
        }
    }

}