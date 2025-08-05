package android.dreame.module.task

import android.dreame.module.BuildConfig
import android.dreame.module.LocalApplication
import android.dreame.module.util.LogUtil
import android.dreame.module.util.log.JavaCrashHandler
import android.text.TextUtils
import com.dreame.sdk.alify.AliFySdk
import com.tencent.mars.xlog.Log
import com.tencent.mars.xlog.Xlog


class LogModuleInitTask(
    id: String = "XlogModuleInitTask", //是否是异步存在
    isAsyncTask: Boolean = false
) : RunInstantTask(id, isAsyncTask) {
    companion object {
        const val PUB_KEY = "80bdf2f61f247db6992dc16003ec4b79a1a21e2bf3220a2b6ee7ffd6dac591bac1dc94741b1087d742ddbe001f5caa2eefb5d6583ae6ef05d715b66a805aa62f"
        const val TAG = "LogModuleInitTask"
        private val SDCARD = LocalApplication.getInstance().getExternalFilesDir("")?.absolutePath ?: "/sdcard/Android/data/com.dreame.smartlife"
        val logPath = "$SDCARD/xlog/log";

        @JvmStatic
        var LOG_INIT = false
            private set

        /**
         * close write
         */
        fun logClose() {
            Log.appenderClose()
        }

        fun logFlush() {
            Log.appenderFlush()
        }
    }

    override fun run(name: String) {
        initXlog()
        initJavaCrashHandler()
        AliFySdk.getInstance().setLogDispatcher { tag, message -> LogUtil.i(tag, message) }
    }

    private fun initXlog() {
        //init xlog
        if (LOG_INIT) {
            return
        }
        val xlog = Xlog()
        Log.setLogImp(xlog);
        val processName = LocalApplication.getCurrentProcessName()
        val packageName: String = LocalApplication.getInstance().packageName
        val nameprefix = if (TextUtils.equals(packageName, processName)) {
            // 主进程
            "main"
        } else if (processName != null && processName.startsWith(packageName)) {
            // 私有进程
            "plugin"
        } else {
            // 其他进程
            "other"
        }
        if (BuildConfig.DEBUG) {
//            Log.appenderOpen(Xlog.LEVEL_DEBUG, Xlog.AppednerModeAsync, "", logPath, nameprefix, 0);
            Xlog.open(true, Xlog.LEVEL_DEBUG, Xlog.AppednerModeAsync, "", logPath, nameprefix, PUB_KEY)
            Log.setConsoleLogOpen(true);

        } else {
            Xlog.open(true, Xlog.LEVEL_INFO, Xlog.AppednerModeAsync, "", logPath, nameprefix, PUB_KEY)
            Log.setConsoleLogOpen(LocalApplication.isLogHttpBODY);
        }
        LOG_INIT = true
    }

    private fun initJavaCrashHandler() {
        Log.d(TAG, "Crash Handler init: start ${android.os.Process.myPid()}")
        JavaCrashHandler.getInstance().initialize()
        Log.d(TAG, "Crash Handler init: end")
    }

}