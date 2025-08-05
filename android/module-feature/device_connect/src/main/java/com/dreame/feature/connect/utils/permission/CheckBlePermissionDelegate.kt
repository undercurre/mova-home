package com.dreame.feature.connect.utils.permission

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.dreame.module.base.permission.OnPermissionCallback2
import android.dreame.module.util.LogUtil
import android.location.LocationManager
import android.os.Build
import android.provider.Settings
import androidx.activity.ComponentActivity
import androidx.activity.result.ActivityResult
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.location.LocationManagerCompat
import androidx.lifecycle.LifecycleOwner
import com.dreame.feature.connect.config.step.bluetooth.BleDeviceScanner
import com.dreame.feature.connect.scan.DeviceScannerDelegate
import com.dreame.feature.connect.utils.ObserverActivityLifecycle
import com.dreame.module.res.BottomConfirmDialog
import com.dreame.smartlife.connect.R
import com.hjq.permissions.Permission
import com.hjq.permissions.XXPermissions

class CheckBlePermissionDelegate(val activity: Activity) : ObserverActivityLifecycle(activity as LifecycleOwner) {

    private val locPermission = mutableListOf(Permission.ACCESS_COARSE_LOCATION, Permission.ACCESS_FINE_LOCATION)
    private val blePermission = mutableListOf(Permission.BLUETOOTH_SCAN, Permission.BLUETOOTH_CONNECT)
    private val requestPermission by lazy {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            blePermission
        } else {
            locPermission
        }
    }

    private val locationDialog by lazy { BottomConfirmDialog(activity) }
    private val blePopupWindow by lazy { BottomConfirmDialog(activity) }
    fun init() {

    }

    fun isBleOpen(): Boolean = BleDeviceScanner.isOpen()
    fun isHasBlePermission(): Boolean {
        val permission = requestPermission
        return XXPermissions.isGranted(activity, permission)
    }

    fun showBleOpenDialog(): Boolean {
        if (isBleOpen()) {
            return true
        }
        // 蓝牙 关闭
        if (blePopupWindow.isShowing) {
            return true
        }
        blePopupWindow.show(activity.getString(R.string.scanning_bluetooth_close),
            activity.getString(R.string.text_goto_open),
            activity.getString(R.string.cancel), {
                blePopupWindow.dismiss()
                gotoBleSetting()
            }
        ) {
            blePopupWindow.dismiss()
        }
        return false
    }

    private fun gotoBleSetting() {
        if (!BleDeviceScanner.isOpen()) {
            activity.startActivity(Intent(Settings.ACTION_BLUETOOTH_SETTINGS))
        }
    }

    // BluetoothAdapter.ACTION_REQUEST_ENABLE
    private val bluetoothLauncher: ActivityResultLauncher<Intent> =
        (activity as ComponentActivity).registerForActivityResult(
            ActivityResultContracts.StartActivityForResult()
        ) { result: ActivityResult ->
            if (result.resultCode == Activity.RESULT_OK) {
                //
                LogUtil.d(DeviceScannerDelegate.TAG, "打开蓝牙成功: ${result.resultCode}  ${result.data}")
            } else {
                //
                LogUtil.i(DeviceScannerDelegate.TAG, "打开蓝牙结果: ${result.resultCode}  ${result.data}")
            }
        }

    fun bleGspLocationOpen(): Boolean {
        val locationManager = activity.applicationContext.getSystemService(Context.LOCATION_SERVICE) as LocationManager
        if (LocationManagerCompat.isLocationEnabled(locationManager)) {
            return true
        }
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            return true
        } else {
            LocationManagerCompat.isLocationEnabled(locationManager)
        }
    }

    fun openGspLocationOpen(block: (Boolean) -> Unit) {
        val locationManager = activity.applicationContext.getSystemService(Context.LOCATION_SERVICE) as LocationManager
        if (LocationManagerCompat.isLocationEnabled(locationManager)) {
            // 有定位权限，且 定位服务开启，则启动扫描设备
            block.invoke(true)
        } else {
            // 去设置页开启Gps位置信息 fromSettingPage
            showGpsLocationDialog({ }, { block.invoke(false) })
        }
    }

    private fun showGpsLocationDialog(
        confirmCallback: (() -> Unit)? = null,
        cancelCallback: (() -> Unit)? = null,
    ) {
        if (locationDialog.isShowing == true) return
        locationDialog.show(
            activity.getString(R.string.text_open_wifi_tips),
            activity.getString(R.string.text_goto_open),
            activity.getString(R.string.cancel), { dialog ->
                dialog.dismiss()
                confirmCallback?.invoke()
                val intent = Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS)
                activity.startActivity(intent)
            }, { dialog ->
                dialog.dismiss()
                cancelCallback?.invoke()
            }
        )
    }

    /**
     * 请求位置权限
     * @param block             授权成功，失败回调
     * @param settingBlock      不再提示授权失败回调，跳转设置
     * @param cancelBlock      不再提示授权失败回调，取消按钮回调
     */
    fun requestPermission(
        settingBlock: (() -> Unit)? = null,
        cancelBlock: (() -> Unit)? = null,
        block: ((result: Boolean) -> Unit),
    ) {
        if (XXPermissions.isGranted(activity, requestPermission)) {
            block(true)
            return
        }

        XXPermissions.with(activity)
            .permission(requestPermission)
            .request(object : OnPermissionCallback2 {
                override fun onGranted(permissions: MutableList<String>, all: Boolean) {
                    if (all) {
                        block.invoke(true)
                    }
                }

                override fun onDenied2(
                    permissions: MutableList<String>,
                    never: Boolean
                ): Boolean {
                    if (never) {
                        showSettingDialog(requestPermission, settingBlock, cancelBlock)
                    } else {
                        block.invoke(false)
                    }
                    return true
                }
            })
    }

    /**
     * 请求位置权限
     * @param settingBlock      去设置页开启权限
     */
    private fun showSettingDialog(permission: List<String>, block: (() -> Unit)? = null, cancelBlock: (() -> Unit)? = null) {
        val content = if (permission.containsAll(locPermission.toList())) {
            activity.getString(R.string.common_permission_fail_3, activity.getString(R.string.common_permission_location))
        } else {
            activity.getString(R.string.text_scan_ble_tips)
        }
        BottomConfirmDialog(activity).show(
            content,
            activity.getString(R.string.common_permission_goto),
            activity.getString(R.string.cancel),
            {
                it.dismiss()
                // 去设置页开启权限
                block?.invoke()
                XXPermissions.startPermissionActivity(activity, permission)
            }, {
                it.dismiss()
                cancelBlock?.invoke()
            }
        )
    }
}