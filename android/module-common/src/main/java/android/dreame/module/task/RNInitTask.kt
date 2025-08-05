package android.dreame.module.task

import android.content.Context
import android.content.Intent
import android.dreame.module.rn.RNPluginService
import android.util.Log

/**
 * 插件初始化task
 */
class RNInitTask(var context: Context) : RunInstantTask("RNInitTask", true) {
    override fun run(name: String) {
//        runCatching {
//            context.startService(Intent(context, RNPluginService::class.java))
//        }.onFailure {
//            Log.e("RNInitTask", "start service failed ${Log.getStackTraceString(it)}")
//        }
    }

    /**
     * 第二次进入插件，进程可能会伴随当前activity一起启动，此时不能异步初始化，否则报错
     */
    override fun runInstant() {
        val initList = mutableListOf(
            SoLoaderInitTask("SoLoaderInitTask"),
            ToastInitTask("ToastInitTask"),
            LogModuleInitTask(),
            ImageLoaderInitTask("ImageLoader")
        )
        initList.forEach { it.runInstant() }
    }
}