package com.dreame.smartlife.config.step.callback

import android.bluetooth.BluetoothDevice
import android.dreame.module.bean.device.DreameWifiDeviceBean
import android.net.wifi.ScanResult

interface IProcessListener {
    fun onScanStart()
    fun onScanStop(ret: Int)
    fun onComplete() {}
}

interface IProgressListener : IProcessListener {
    fun onProgress(progress: Int)
}

interface IWiFiScanListener : IProgressListener {
    override fun onProgress(progress: Int) {}
    override fun onScanStart() {}
    override fun onScanStop(ret: Int) {}
    fun onScanResult(scanResults: List<ScanResult>)
}


interface IBleScanCallBack : IProgressListener {
    override fun onProgress(progress: Int) {}
    override fun onScanStart() {}
    override fun onScanStop(ret: Int) {}
    fun onScanResult(device: BluetoothDevice, scanRecord: ByteArray, rssi: Int, result: String)
}


interface IDeviceScanListener : IProgressListener {
    override fun onProgress(progress: Int) {}
    override fun onScanStart() {}
    override fun onScanStop(ret: Int) {}
    fun onScanResult(results: MutableMap<String, DreameWifiDeviceBean>){}
}


