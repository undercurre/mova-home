package com.dreame.smartlife.config.step

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.dreame.module.base.permission.OnPermissionCallback2
import android.dreame.module.util.LogUtil
import android.dreame.module.util.permission.ShowPermissionDialog
import android.location.LocationManager
import android.os.Message
import android.util.Log
import com.dreame.module.res.BottomConfirmDialog
import com.dreame.smartlife.config.event.StepId
import com.dreame.smartlife.connect.R
import com.hjq.permissions.XXPermissions

/**
 * # wifi权限检查
 * 检查定位权限、定位服务是否打开,监听位置信息开启状态
 * 成功:wifi扫描 [StepWifiScan]
 * 失败:手动连接 [StepManualConnect]
 */
class StepWifiPermissionCheck : SmartStepConfig() {

    // 从设置开启权限后返回
    private var fromSettingPage = false
    private var gpsStateReceiver: GpsStatusReceiver? = null

    override fun stepName(): Step = Step.STEP_WIFI_PERMISSION_CHECK

    override fun handleMessage(msg: Message) {
    }

    override fun stepCreate() {
        super.stepCreate()
        Log.d(TAG, "stepCreate: StepWifiPermissionCheck")
        gpsStateReceiver = GpsStatusReceiver()
        context.registerReceiver(
            gpsStateReceiver,
            IntentFilter(LocationManager.MODE_CHANGED_ACTION)
        )
        checkPermission()
    }

    private fun checkPermission() {
        // 9.0之前获取wifi信息不需要开启位置信息
        if (isGrantedPermission(permissionList)) {
            if (locServiceEnable()) {
                // 有定位权限，且 定位服务开启，则启动扫描设备

                if (StepData.nextStepId == StepId.STEP_MANUAL_CONNECT) {
                    // TODO 只支持蓝牙配网则不能进入手动连接
                    nextStep(Step.STEP_MANUAL_CONNECT)
                }
                if (StepData.stepModeDefault == StepData.StepMode.MODE_WIFI) {
                    nextStep(Step.STEP_CONNECT_DEVICE_AP)
                } else if (StepData.stepModeDefault == StepData.StepMode.MODE_BLE) {
                    nextStep(Step.STEP_DEVICE_SCAN_BLE)
                } else {
                    nextStep(Step.STEP_APP_WIFI_SCAN)
                }
            } else {
                // 去设置页开启Gps位置信息 fromSettingPage
                showGpsLocationDialog({ fromSettingPage = true }, { permissionFail() })
            }
        } else {
            requestPermission()
        }
    }

    override fun stepDestroy() {
        gpsStateReceiver?.let {
            context.unregisterReceiver(it)
        }.also { gpsStateReceiver = null }
        if (locationDialog.isShowing) {
            locationDialog.dismiss()
        }
    }

    override fun stepOnResume() {
        if (fromSettingPage) {
            LogUtil.i(TAG, "onResume: from settingPage")
            fromSettingPage = false
            checkPermission()
        }
    }

    private fun requestPermission() {
        ShowPermissionDialog.showPermissionDialog(context, R.string.Toast_SystemServicePermission_Location, {
            Log.d(TAG, "onDialogDenied: permission fail to STEP_MANUAL_CONNECT")
            permissionFail()
        }) {
            XXPermissions.with(context)
                .permission(permissionList)
                .request(object : OnPermissionCallback2 {
                    override fun onGranted(permissions: MutableList<String>, all: Boolean) {
                        if (all) {
                            Log.d(TAG, "onGranted: permission pass to STEP_0_APP_WIFI_SCAN")
                            checkPermission()
                        }
                    }

                    override fun onDenied2(permissions: MutableList<String>, never: Boolean): Boolean {
                        if (never) {
                            showSettingDialog(permissions)
                        } else {
                            Log.d(TAG, "onDenied: permission fail to STEP_MANUAL_CONNECT")
                            permissionFail()
                        }
                        return true
                    }
                })
        }
    }

    private fun showSettingDialog(permissions: MutableList<String>) {
        BottomConfirmDialog(context).show(
            context.getString(
                R.string.common_permission_fail_3,
                context.getString(R.string.common_permission_location)
            ),
            context.getString(R.string.common_permission_goto),
            context.getString(R.string.cancel),
            {
                it.dismiss()
                // 去设置页开启权限
                fromSettingPage = true
                XXPermissions.startPermissionActivity(context, permissions)
            }, {
                Log.d(
                    TAG,
                    "onGranted: permission cancel setting to STEP_MANUAL_CONNECT"
                )
                it.dismiss()
                permissionFail()
            }
        )
    }

    private fun permissionFail() {
        getHandler().sendMessage(Message.obtain().apply {
            obj = StepResult(StepName.STEP_CONNECT, StepState.FAILED)
        })
        // TODO 只支持蓝牙配网则不能进入手动连接
        nextStep(Step.STEP_MANUAL_CONNECT)
    }

    /**
     * 监听位置信息开启状态
     */
    private inner class GpsStatusReceiver : BroadcastReceiver() {

        override fun onReceive(context: Context?, intent: Intent?) {
            // 处理用户从通知栏开启Gps的操作
            if (fromSettingPage) return
            if (LocationManager.MODE_CHANGED_ACTION == intent?.action) {
                val gpsEnabled = locServiceEnable()
                LogUtil.i(TAG, "onReceive: gps status: $gpsEnabled")
                if (locationDialog.isShowing) {
                    locationDialog.dismiss()
                }
                checkPermission()
            }
        }
    }

}