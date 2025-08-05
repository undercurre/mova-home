package com.dreame.feature.connect.scan

import android.Manifest
import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.dreame.module.constant.Constants
import android.dreame.module.util.LogUtil
import android.net.wifi.ScanResult
import android.os.Build
import android.provider.Settings
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.result.ActivityResult
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import androidx.lifecycle.LifecycleOwner
import com.dreame.feature.connect.config.step.bluetooth.BleDeviceScanner
import com.dreame.module.res.BottomConfirmDialog
import com.dreame.smartlife.config.step.CheckLocationPermission
import com.dreame.smartlife.config.step.DeviceOpenChangeReceiver
import com.dreame.smartlife.config.step.WifiDeviceScanner
import com.dreame.smartlife.config.step.callback.IBleScanCallBack
import com.dreame.smartlife.config.step.callback.IDeviceScanListener
import com.dreame.smartlife.config.step.callback.IWiFiScanListener
import com.dreame.smartlife.connect.R
import com.hjq.permissions.Permission
import com.hjq.permissions.XXPermissions

/**
 * 设备扫描类
 */
class DeviceScannerDelegate(val context: Activity) {
    companion object {
        const val TAG = "DeviceScannerDelegate"
    }

    private val checkLocationPermission: CheckLocationPermission by lazy { CheckLocationPermission(context) }

    val wifiPopupWindow by lazy { BottomConfirmDialog(context) }
    val blePopupWindow by lazy { BottomConfirmDialog(context) }

    var deviceScanCallBack: IDeviceScanListener? = null
    var wifiScanCallBack: IWiFiScanListener? = null
    var bleScanCallBack: IBleScanCallBack? = null

    private var scanType = DeviceScanCache.TYPE_BOTH

    private var canBleDialogShow = true
    private var canWifiDialogShow = true

    var callback: ((type: Int, wifi: Boolean, ble: Boolean) -> Unit)? = null

    init {
        (context as LifecycleOwner).lifecycle.addObserver(object : LifecycleEventObserver {
            override fun onStateChanged(source: LifecycleOwner, event: Lifecycle.Event) {
                when (event) {
                    Lifecycle.Event.ON_CREATE -> {

                    }

                    Lifecycle.Event.ON_RESUME -> {

                    }

                    Lifecycle.Event.ON_PAUSE -> {
                        onPause()
                    }

                    Lifecycle.Event.ON_STOP -> {
                        onStop()
                        if (context.isFinishing) {
                            onDestroy()
                        }
                    }

                    Lifecycle.Event.ON_DESTROY -> {
                        onDestroy()
                        // FIXME:
                        // FIXME:
                        // FIXME:
//                        if (context is ProductSelectListActivity) {
//                            // 清理部分缓存
//                            StepData.clear()
//                            DeviceScanCache.clear()
//                        }
                    }

                    else -> {}
                }
            }

        })

    }

    fun startScanDeviceDirect(): Boolean {
        return startScanDeviceDirect(DeviceScanCache.TYPE_BOTH)
    }

    fun startScanDeviceDirect(scanType: Int): Boolean {
        LogUtil.d(TAG, "startScanDeviceDirect: $scanType ")
        return checkLocationPermission.run {
            if (isPermissionGrand()) {
                onStartCallback()
                if (scanType == DeviceScanCache.TYPE_BOTH || scanType == DeviceScanCache.TYPE_WIFI) {
                    WifiDeviceScanner.addScanCallback(scanWifiCallBack)
                    WifiDeviceScanner.startScanDeviceDirect()
                }
                if (scanType == DeviceScanCache.TYPE_BOTH || scanType == DeviceScanCache.TYPE_BLE) {
                    if (BleDeviceScanner.isOpen()) {
                        BleDeviceScanner.startScan(callback = scanBleCallBack)
                    }
                }
                true
            } else {
                false
            }
        }

    }

    /**
     * 检查扫描前是否具备权限
     * @param  type 扫描类型
     * @param  forceShowType 权限弹框类型
     */
    fun checkLocPermission(type: Int = DeviceScanCache.TYPE_WIFI, forceShowType: Int = DeviceScanCache.TYPE_WIFI) {
        Log.d(TAG, "checkLocPermission: $type  $forceShowType")
        scanType = type
        checkLocationPermission.block = {
            if (it && !isLocPermissionGrand()) {
                checkLocationPermission.checkLocPermission()

            } else if (it) {
                when (type) {
                    DeviceScanCache.TYPE_BOTH -> {
                        scanDeviceBoth(
                            forceShowType == DeviceScanCache.TYPE_BOTH || forceShowType == DeviceScanCache.TYPE_WIFI,
                            forceShowType == DeviceScanCache.TYPE_BOTH || forceShowType == DeviceScanCache.TYPE_BLE
                        )
                    }

                    DeviceScanCache.TYPE_BLE -> {
                        scanDeviceBle(forceShowType == DeviceScanCache.TYPE_BLE)
                    }

                    DeviceScanCache.TYPE_WIFI -> {
                        scanDeviceWifi(forceShowType == DeviceScanCache.TYPE_WIFI)
                    }
                }
            } else {
                onStopCallback(-1)
                onCompleteCallback()
                BleDeviceScanner.stopScan()
                WifiDeviceScanner.stopScan(context)
            }
        }
        checkLocationPermission.checkLocPermission()
    }

    fun onResume() {
        onResumeOnce(true)
    }

    fun onResumeOnce(locStateRegister: Boolean) {
        registerStateChange(scanType)
        DeviceScanCache.removeOverdueDevice()
        checkLocationPermission.onResumeOnce(locStateRegister)
        callback?.invoke(DeviceScanCache.TYPE_BOTH, WifiDeviceScanner.isOpen(), BleDeviceScanner.isOpen())
    }

    private fun onPause() {
        // 停止扫描
        Log.d(TAG, "onPause: ")
        BleDeviceScanner.stopScan()
        WifiDeviceScanner.stopScan(context, true)
        // Wi-Fi 和蓝牙开关 receiver 解除注册
        DeviceOpenChangeReceiver.onStop(context)
        // 权限校验， receiver 解除注册
        checkLocationPermission.onStop()
    }

    private fun onStop() {
        onStopCallback()
        onCompleteCallback()
        // 扫描callback取消
        WifiDeviceScanner.removeScanCallback(scanWifiCallBack)
        BleDeviceScanner.removeScanCallback(scanBleCallBack)

    }

    fun isPermissionGrand() = checkLocationPermission.isPermissionGrand()
    fun isLocPermissionGrand() = checkLocationPermission.isLocPermissionGrand()

    fun getScanResultFirst() = WifiDeviceScanner.getScanResultFirst()

    private fun onDestroy() {
        checkLocationPermission.onDestroy()
        deviceScanCallBack = null
        wifiScanCallBack = null
        bleScanCallBack = null
        callback = null
        setScanCount(7)

    }

    fun filterDevice(filter: Boolean) {
        WifiDeviceScanner.mFilterDevice = filter
    }

    private fun scanDeviceBle(forceShow: Boolean) {
        Log.d(TAG, "scanDeviceBle: $scanType $forceShow")
        if (!BleDeviceScanner.isOpen()) {
            if (forceShow && canBleDialogShow)
                showBleClosedDialog(context)
            callback?.invoke(DeviceScanCache.TYPE_BLE, WifiDeviceScanner.isOpen(), BleDeviceScanner.isOpen())
        } else {
            if (XXPermissions.isGranted(context, listOf(Permission.BLUETOOTH_SCAN, Permission.BLUETOOTH_CONNECT))) {
                BleDeviceScanner.startScan(callback = scanBleCallBack)
                onStartCallback()
            }

        }
    }

    private fun scanDeviceWifi(forceShow: Boolean) {
        Log.d(TAG, "scanDeviceWifi: $scanType $forceShow")

        if (!WifiDeviceScanner.isOpen()) {
            if (forceShow && canWifiDialogShow)
                showWifiClosedDialog(context)
            callback?.invoke(DeviceScanCache.TYPE_WIFI, WifiDeviceScanner.isOpen(), BleDeviceScanner.isOpen())
        } else {
            WifiDeviceScanner.addScanCallback(scanWifiCallBack)
            WifiDeviceScanner.startScan(context)
            onStartCallback()
        }
    }

    private fun onStartCallback() {
        deviceScanCallBack?.onScanStart()
        wifiScanCallBack?.onScanStart()
        bleScanCallBack?.onScanStart()
    }

    private fun scanDeviceBoth(forceWifiShow: Boolean, forceBleShow: Boolean) {
        Log.d(TAG, "scanDeviceBoth: $scanType $forceWifiShow $forceBleShow")

        scanDeviceWifi(forceWifiShow)
        scanDeviceBle(forceBleShow)

    }

    private fun onStopCallback(ret: Int = 0) {
        deviceScanCallBack?.onScanStop(ret)
        wifiScanCallBack?.onScanStop(ret)
        bleScanCallBack?.onScanStop(ret)
    }

    private fun onCompleteCallback() {
        deviceScanCallBack?.onComplete()
        wifiScanCallBack?.onComplete()
        bleScanCallBack?.onComplete()
    }

    private fun showWifiClosedDialog(context: Context): Boolean {
        // wifi 关闭
        if (wifiPopupWindow.isShowing) {
            return true
        }
        wifiPopupWindow.show(context.getString(R.string.scanning_wifi_close),
            context.getString(R.string.common_permission_goto),
            context.getString(R.string.cancel), {
                canWifiDialogShow = false
                context.startActivity(Intent(Settings.ACTION_WIFI_SETTINGS))
                wifiPopupWindow.dismiss()
            }
        ) {
            canWifiDialogShow = false
            onStopCallback(-1)
            onCompleteCallback()
            wifiPopupWindow.dismiss()
        }
        return true
    }

    private fun showBleClosedDialog(context: Context): Boolean {
        // 蓝牙 关闭
        if (blePopupWindow.isShowing) {
            return true
        }
        blePopupWindow.show(context.getString(R.string.scanning_bluetooth_close),
            context.getString(R.string.text_goto_open),
            context.getString(R.string.cancel), {
                canBleDialogShow = false
                gotoBleSetting(context)
                blePopupWindow.dismiss()
            }
        ) {
            canBleDialogShow = false
            blePopupWindow.dismiss()
        }
        return true
    }

    fun gotoBleSetting(context: Context) {
        if (!BleDeviceScanner.isOpen()) {
            val granted = if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) {
                context.checkSelfPermission(Manifest.permission.BLUETOOTH) == PackageManager.PERMISSION_GRANTED
            } else {
                XXPermissions.isGranted(context, Permission.BLUETOOTH_CONNECT, Permission.BLUETOOTH_SCAN, Manifest.permission.BLUETOOTH)
            }
            if (granted) {
                bluetoothLauncher.launch(Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE))
            } else {
                context.startActivity(Intent(Settings.ACTION_BLUETOOTH_SETTINGS))
            }
        }
    }

    private val bluetoothLauncher: ActivityResultLauncher<Intent> =
        (context as ComponentActivity).registerForActivityResult(
            ActivityResultContracts.StartActivityForResult()
        ) { result: ActivityResult ->
            if (result.resultCode == Activity.RESULT_OK) {
                //
                LogUtil.d(TAG, "打开蓝牙成功: ${result.resultCode}  ${result.data}")
            } else {
                //
                LogUtil.i(TAG, "打开蓝牙结果: ${result.resultCode}  ${result.data}")
            }
        }

    /**
     * 注册Wi-Fi 蓝牙 打开关闭 状态变化 receiver
     */
    private fun registerStateChange(type: Int) {
        runCatching {
            if (type == DeviceScanCache.TYPE_BOTH || type == DeviceScanCache.TYPE_WIFI) {
                DeviceOpenChangeReceiver.wifiCallBacks.add { wifiOpen ->
                    Log.d(TAG, "registerStateChange: ")
                    callback?.invoke(DeviceScanCache.TYPE_WIFI, wifiOpen, BleDeviceScanner.isOpen())

                    if (wifiOpen && checkLocationPermission.isPermissionGrand()) {
                        WifiDeviceScanner.addScanCallback(scanWifiCallBack)
                        WifiDeviceScanner.startScan(context)
                        onStartCallback()
                    } else {
                        WifiDeviceScanner.stopScan(context)
                        onStopCallback(-1)
                        onCompleteCallback()
                    }
                }
            }
            if (type == DeviceScanCache.TYPE_BOTH || type == DeviceScanCache.TYPE_BLE) {
                DeviceOpenChangeReceiver.bleCallBacks.add { bleOpen ->
                    callback?.invoke(DeviceScanCache.TYPE_BLE, WifiDeviceScanner.isOpen(), bleOpen)

                    if (bleOpen && checkLocationPermission.isPermissionGrand()) {
                        if (XXPermissions.isGranted(context, listOf(Permission.BLUETOOTH_SCAN, Permission.BLUETOOTH_CONNECT))) {
                            BleDeviceScanner.startScan(callback = scanBleCallBack)
                            onStartCallback()
                        }
                    } else {
                        BleDeviceScanner.stopScan()
                        onStopCallback(-1)
                        onCompleteCallback()
                    }
                }
            }
        }.onFailure {
            LogUtil.e(TAG, Log.getStackTraceString(it))
        }
    }

    /**
     * 注册 callback, 统一处理回调
     */

    private val scanBleCallBack = object : IBleScanCallBack {
        override fun onScanResult(
            device: BluetoothDevice,
            scanRecord: ByteArray,
            rssi: Int,
            result: String
        ) {
            deviceScanCallBack?.let {
                //
            }
            bleScanCallBack?.onScanResult(device, scanRecord, rssi, result)
        }

        override fun onScanStop(ret: Int) {
            super.onScanStop(ret)
            onStopCallback(ret)
        }

        override fun onComplete() {
            onCompleteCallback()
        }
    }
    private val scanWifiCallBack = object : IWiFiScanListener {
        override fun onScanResult(scanResults: List<ScanResult>) {
            val filter = scanResults
                .filter {
                    !it.SSID.isNullOrEmpty() && (it.SSID != "unknown ssid" || it.SSID != "<unknow>" || it.SSID != "< unknow >")
                }
                .filter {
                    it.SSID.startsWith(Constants.MODEL_NAME_PREFIX_DREAME) || it.SSID.startsWith(Constants.MODEL_NAME_PREFIX_MOVA)
                }
            deviceScanCallBack?.let {
                filter.onEach { result ->

                }.run {

                }
            }
            wifiScanCallBack?.onScanResult(scanResults)
        }

        override fun onScanStop(ret: Int) {
            super.onScanStop(ret)
            onStopCallback(ret)
        }

        override fun onComplete() {
            onCompleteCallback()
        }
    }

    fun setScanCount(count: Int = 7) {
        WifiDeviceScanner.mMaxScanCount = count
        BleDeviceScanner.mMaxScanCount = if (count > 1) count / 2 else 1
    }

    fun isBleOpen(): Boolean = BleDeviceScanner.isOpen()
    fun isWifiOpen(): Boolean = WifiDeviceScanner.isOpen()

    fun addSkipNeverNecessarilyPermission(list: List<String>) {
        checkLocationPermission.setRequestPermission(list)
    }

}
