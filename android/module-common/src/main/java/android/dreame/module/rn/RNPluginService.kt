package android.dreame.module.rn

import android.content.Intent
import android.util.Log
import androidx.core.app.JobIntentService

/**
 * 启动plugin进程,伴随主进程启动,调用plugin进程 Application.onCreate方法,提前初始化SoLoader
 */
open class RNPluginService : JobIntentService() {

    protected var count = 0

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.i(TAG, "onStartCommand: ${intent?.action}")
        return START_REDELIVER_INTENT
    }

    override fun onHandleWork(intent: Intent) {
    }

    companion object {
        private const val TAG = "RNPluginService"
    }
}