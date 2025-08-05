package com.dreame.smartlife.config.step

import android.dreame.module.util.LogUtil

/**
 * # 手动热点连接
 * 监听网络变化,监听位置信息开启状态,用户手动连接wifi
 * 成功:连接状态二次确认 [StepConnectCheck]
 */
class StepManualConnectQR : StepManualConnect() {
    private val checkLocationPermission: CheckLocationPermission by lazy { CheckLocationPermission(context) }

    override fun stepName(): Step = Step.STEP_MANUAL_CONNECT_QR

    /**
     * 用户手动触发
     */
    override fun click2Connect() {
        if (checkLocationPermission.isLocPermissionGrand()) {
            LogUtil.i(TAG, " click2Connect")
            super.click2Connect()
        } else {
            checkLocationPermission.checkLocPermission()
        }
    }

}