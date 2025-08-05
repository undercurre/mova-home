package com.dreame.feature.connect.utils

import android.dreame.module.util.LogUtil
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import androidx.lifecycle.LifecycleOwner

abstract class ObserverActivityLifecycle(val lifecycleOwner: LifecycleOwner) {

    protected var isStoped = false

    init {
        lifecycleOwner.lifecycle.addObserver(object : LifecycleEventObserver {
            override fun onStateChanged(source: LifecycleOwner, event: Lifecycle.Event) {
                when (event) {
                    Lifecycle.Event.ON_CREATE -> {
                        onActivityCreate()
                    }

                    Lifecycle.Event.ON_START -> {
                        isStoped = false
                        onActivityStart()
                    }

                    Lifecycle.Event.ON_RESUME -> {
                        onActivityResume()
                    }

                    Lifecycle.Event.ON_PAUSE -> {
                        onActivityPause()
                    }

                    Lifecycle.Event.ON_STOP -> {
                        isStoped = true
                        onActivityStop()
                    }

                    Lifecycle.Event.ON_DESTROY -> {
                        onActivityDestroy()
                    }

                    else -> {}
                }
            }

        })

    }

    open fun onActivityCreate() {
        LogUtil.d("sunzhibin", "-------- onActivityCreate -------- $lifecycleOwner")
    }

    open fun onActivityStart() {
        LogUtil.d("sunzhibin", "-------- onActivityStart -------- $lifecycleOwner")
    }

    open fun onActivityResume() {
        LogUtil.d("sunzhibin", "-------- onActivityResume -------- $lifecycleOwner")
    }

    open fun onActivityPause() {
        LogUtil.d("sunzhibin", "-------- onActivityPause -------- $lifecycleOwner")
    }

    open fun onActivityStop() {
        LogUtil.d("sunzhibin", "-------- onActivityStop -------- $lifecycleOwner")
    }

    open fun onActivityDestroy() {
        LogUtil.d("sunzhibin", "-------- onActivityDestroy -------- $lifecycleOwner")
    }

}