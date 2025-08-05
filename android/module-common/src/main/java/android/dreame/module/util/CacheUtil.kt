package android.dreame.module.util;

import android.content.Context
import android.dreame.module.rn.bridge.host.FileModule
import java.util.Arrays

object CacheUtil {

    fun getAppCacheSize(context: Context): Long {
        val externalCacheSize = FileUtil.getDirLength(
            context.applicationContext.externalCacheDir!!.path
        )
        val cacheSize = FileUtil.getDirLengthExcludePath(
            context.applicationContext.cacheDir.path,
            Arrays.asList("plugins")
        )
        // 视频监控
        val cachedPicSize = FileUtil.getDirLength(FileModule.getPluginCachePath())
        val totalSize = externalCacheSize + cacheSize + cachedPicSize
        return if (totalSize < 0) 0 else totalSize
    }

    fun getAppCacheSizeString(context: Context): String {
        val length = getAppCacheSize(context)
        val size = FileUtil.byte2FitMemorySize(length)
        return size ?: "0"
    }

}
