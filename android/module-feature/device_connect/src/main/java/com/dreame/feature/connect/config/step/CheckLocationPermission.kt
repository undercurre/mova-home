package com.dreame.smartlife.config.step

import android.app.Activity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.dreame.module.util.LogUtil
import android.location.LocationManager
import android.provider.Settings
import androidx.core.location.LocationManagerCompat
import com.dreame.module.res.BottomConfirmDialog
import com.dreame.smartlife.connect.R

/**
 * 检查位置权限
 */
class CheckLocationPermission(val context: Activity) {
    // 从设置开启权限后返回
    private val TAG = "CheckLocationPermission"
    private var fromSettingPage = false
    private val gpsStateReceiver: GpsStatusReceiver by lazy { GpsStatusReceiver() }
    private var locationDialog: BottomConfirmDialog? = null

    private val requestLocPermission by lazy { RequestLocPermission(context) }

    var block: ((exec: Boolean) -> Unit)? = null
    private var isRunningShow = true

    @Volatile
    private var isReceiverRegister = false

    /**
     * 首次调用
     */
    fun checkLocPermission(cancelBlock: (() -> Unit)? = null) {
        isRunningShow = true
        checkPermission(true, cancelBlock)
    }

    fun onResume() {
        onResumeOnce(true, false)
    }

    /**
     * @param locStateRegister
     * @param cancelBlock 拒绝且不再允许弹框，点击取消
     */
    fun onResumeOnce(locStateRegister: Boolean, requestPermission: Boolean = false, cancelBlock: (() -> Unit)? = null) {
        isRunningShow = true
        if (locStateRegister) {
            registerReceiver()
        }
        if (requestLocPermission.isPermissionGrand()) {
            block?.invoke(true)
        } else if (fromSettingPage) {
            LogUtil.i(TAG, "onResume: from settingPage")
            checkPermission(requestPermission, cancelBlock)
        }
        fromSettingPage = false
    }

    private fun registerReceiver() {
        if (!isReceiverRegister) {
            isReceiverRegister = true
            context.applicationContext.registerReceiver(
                gpsStateReceiver,
                IntentFilter(LocationManager.MODE_CHANGED_ACTION)
            )
        }
    }

    private fun unRegisterReceiver() {
        if (isReceiverRegister) {
            isReceiverRegister = false
            context.applicationContext.unregisterReceiver(gpsStateReceiver)
        }
    }

    private fun checkPermission(requestPermission: Boolean = true, cancelBlock: (() -> Unit)? = null) {
        // 8.0之前获取wifi信息不需要开启位置信息
        if (requestLocPermission.isGrantedPermission()) {
            openGspLocation()
        } else if (requestLocPermission.isGrantedLocPermission() && !requestPermission) {
            openGspLocation()
        } else if (requestPermission) {
            requestLocPermission.requestPermission(block, {
                fromSettingPage = true
            }) {
                if (requestLocPermission.isGrantedLocPermission()) {
                    openGspLocation()
                } else {
                    cancelBlock?.invoke()
                }
            }
        } else {
            cancelBlock?.invoke()
        }
    }

    private fun openGspLocation() {
        val locationManager = context.applicationContext.getSystemService(Context.LOCATION_SERVICE) as LocationManager
        if (LocationManagerCompat.isLocationEnabled(locationManager)) {
            // 有定位权限，且 定位服务开启，则启动扫描设备
            block?.invoke(true)
        } else {
            // 去设置页开启Gps位置信息 fromSettingPage
            showGpsLocationDialog({ fromSettingPage = true }, { block?.invoke(false) })
        }
    }

    private fun showGpsLocationDialog(
        confirmCallback: (() -> Unit)? = null,
        cancelCallback: (() -> Unit)? = null,
    ) {
        if (locationDialog?.isShowing == true) return
        context.let {
            locationDialog = BottomConfirmDialog(context)
            locationDialog?.show(
                it.getString(R.string.text_open_wifi_tips),
                it.getString(R.string.text_goto_open),
                it.getString(R.string.cancel), { dialog ->
                    dialog.dismiss()
                    confirmCallback?.invoke()
                    val intent = Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS)
                    it.startActivity(intent)
                }, { dialog ->
                    dialog.dismiss()
                    cancelCallback?.invoke()
                }
            )
        }
    }

    fun onStop() {
        isRunningShow = false
        unRegisterReceiver()
        if (locationDialog?.isShowing == true) {
            locationDialog?.dismiss()
        }
    }

    fun onDestroy() {
        onStop()
        block = null
    }

    fun isPermissionGrand(): Boolean = requestLocPermission.isPermissionGrand()
    fun isLocPermissionGrand(): Boolean = requestLocPermission.isLocPermissionGrand()

    fun setRequestPermission(permission: List<String>) {
        requestLocPermission.setRequestPermission(permission)
    }

//    fun addSkipNeverNecessarilyPermission(list: List<String>) {
//        requestLocPermission.addSkipNeverNecessarilyPermission(list)
//    }

    /**
     * 监听位置信息开启状态
     */
    private inner class GpsStatusReceiver : BroadcastReceiver() {

        override fun onReceive(context: Context?, intent: Intent?) {
            // 处理用户从通知栏开启Gps的操作
            if (fromSettingPage) return
            if (LocationManager.MODE_CHANGED_ACTION == intent?.action) {
                val locationManager = context?.applicationContext?.getSystemService(Context.LOCATION_SERVICE) as LocationManager
                val gpsEnabled = LocationManagerCompat.isLocationEnabled(locationManager)
                LogUtil.i(TAG, "onReceive: gps status: $gpsEnabled")
                if (locationDialog?.isShowing == true) {
                    locationDialog?.dismiss()
                }
                checkPermission()
            }
        }
    }

}