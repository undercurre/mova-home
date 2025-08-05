package com.dreame.feature.connect.utils.permission

import android.app.Activity
import androidx.lifecycle.LifecycleOwner
import com.dreame.feature.connect.utils.ObserverActivityLifecycle
import com.dreame.smartlife.config.step.CheckLocationPermission
import com.dreame.smartlife.config.step.ScanType
import com.hjq.permissions.Permission

class CheckLocationPermissionDelegate(val activity: Activity) : ObserverActivityLifecycle(activity as LifecycleOwner) {
    private val checkLocationPermission: CheckLocationPermission by lazy { CheckLocationPermission(activity) }

    init {
        checkLocationPermission.block = {
            if (!it) {
                activity.finish()
            }
        }
    }

    override fun onActivityCreate() {
        super.onActivityCreate()
        checkLocationPermission.checkLocPermission {
            activity.finish()
        }
    }

    override fun onActivityResume() {
        super.onActivityResume()
        checkLocationPermission.onResumeOnce(true, true) {
            activity.finish()
        }
    }

    override fun onActivityStop() {
        super.onActivityStop()
        checkLocationPermission.onStop()
    }

    fun addSkipNeverNecessarilyPermission(scType: String, extendScType: List<String>) {
        if (scType == ScanType.WIFI) {
            // 可以跳过蓝牙扫描
            checkLocationPermission.setRequestPermission(listOf(Permission.ACCESS_COARSE_LOCATION, Permission.ACCESS_FINE_LOCATION))
        }
    }
}