package com.dreame.smartlife.config.step

import android.app.Activity
import android.content.Context
import android.dreame.module.base.permission.OnPermissionCallback2
import android.dreame.module.util.permission.ShowPermissionDialog
import android.location.LocationManager
import android.util.Log
import androidx.core.location.LocationManagerCompat
import com.dreame.module.res.BottomConfirmDialog
import com.dreame.smartlife.connect.R
import com.hjq.permissions.Permission
import com.hjq.permissions.XXPermissions

class RequestLocPermission(val context: Activity) {
    private val TAG = "RequestLocPermission"
    private val defaultPermissios =
        mutableListOf(
            Permission.ACCESS_COARSE_LOCATION,
            Permission.ACCESS_FINE_LOCATION,
            Permission.BLUETOOTH_SCAN,
            Permission.BLUETOOTH_CONNECT
        )

    private val locPermission = mutableListOf(Permission.ACCESS_COARSE_LOCATION, Permission.ACCESS_FINE_LOCATION)

    private val requestPermission = defaultPermissios

    //
//    /**
//     * 可以跳过的权限
//     */
//    @Deprecated("never use")
//    private val skipPermission = mutableListOf<String>()
    fun setRequestPermission(permission: List<String>) {
        requestPermission.clear()
        requestPermission.addAll(permission)
    }
//    @Deprecated("never use")
//    fun addSkipNeverNecessarilyPermission(permission: List<String>) {
//        skipPermission.clear()
//        skipPermission.addAll(permission)
//    }

    /**
     * 请求位置权限
     * @param block             授权成功，失败回调
     * @param settingBlock      不再提示授权失败回调，跳转设置
     * @param cancelBlock      不再提示授权失败回调，取消按钮回调
     */
    fun requestPermission(
        block: ((result: Boolean) -> Unit)?,
        settingBlock: () -> Unit,
        cancelBlock: (() -> Unit)? = null,
    ) {
        context.run {
            ShowPermissionDialog.showPermissionDialog(
                this,
                R.string.Toast_SystemServicePermission_Location,
                {
                    Log.d(TAG, "onDialogDenied: permission fail to STEP_MANUAL_CONNECT")
                    block?.invoke(false)
                }) {
                val permission = requestPermission.filter {
                    !XXPermissions.isGranted(context, it)
                }
                XXPermissions.with(this)
                    .permission(permission)
                    .request(object : OnPermissionCallback2 {
                        override fun onGranted(permissions: MutableList<String>, all: Boolean) {
                            if (all) {
                                Log.d(TAG, "onGranted: permission pass to STEP_0_APP_WIFI_SCAN")
                                block?.invoke(true)
                            }
                        }

                        override fun onDenied2(
                            permissions: MutableList<String>,
                            never: Boolean
                        ): Boolean {
                            if (never) {
                                showSettingDialog(permission, settingBlock, cancelBlock)
                            } else {
                                Log.d(TAG, "onDenied: permission fail to STEP_MANUAL_CONNECT")
                                block?.invoke(false)
                            }
                            return true
                        }
                    })
            }
        }
    }

    /**
     * 请求位置权限
     * @param settingBlock      去设置页开启权限
     */
    private fun showSettingDialog(permission: List<String>, block: () -> Unit, cancelBlock: (() -> Unit)? = null) {
        val content = if (permission.contains(Permission.ACCESS_FINE_LOCATION)) {
            context.getString(R.string.common_permission_fail_3, context.getString(R.string.common_permission_location))
        } else {
            context.getString(R.string.text_scan_ble_tips)
        }
        BottomConfirmDialog(context).show(
            content,
            context.getString(R.string.common_permission_goto),
            context.getString(R.string.cancel),
            {
                it.dismiss()
                // 去设置页开启权限
                block()
                XXPermissions.startPermissionActivity(context, permission)
            }, {
                Log.d(
                    TAG,
                    "onGranted: permission cancel setting to STEP_MANUAL_CONNECT"
                )
                it.dismiss()
                cancelBlock?.invoke()
            }
        )
    }

    fun isPermissionGrand(): Boolean = context.isPermissionGrand(defaultPermissios)
    fun isLocPermissionGrand(): Boolean = context.isPermissionGrand(locPermission)

    fun isGrantedPermission(): Boolean = context.isGrantedPermission(defaultPermissios)
    fun isGrantedLocPermission(): Boolean = context.isGrantedPermission(locPermission)

}

/**
 * 定位权限 + 位置服务
 */
fun Activity.isPermissionGrand(permission: List<String>) = isGrantedPermission(permission) && isLocationEnabled()

/**
 * 定位权限
 */
private fun Activity.isGrantedPermission(permission: List<String>): Boolean {
    return XXPermissions.isGranted(this, permission)
}

/**
 * 位置服务 是否打开
 */
fun Context.isLocationEnabled(): Boolean {
    val locationManager = applicationContext.getSystemService(Context.LOCATION_SERVICE) as LocationManager
    return LocationManagerCompat.isLocationEnabled(locationManager)
}

