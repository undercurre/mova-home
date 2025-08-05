package android.dreame.module.rn.bridge.rawdata

import android.dreame.module.BuildConfig
import android.dreame.module.rn.bridge.host.FileModule
import android.dreame.module.util.LogUtil
import android.os.SystemClock
import android.util.Log
import com.blankj.utilcode.util.FileIOUtils
import com.blankj.utilcode.util.ThreadUtils
import com.bumptech.glide.disklrucache.DiskLruCache
import java.io.File
import java.io.IOException

object DiskLruCachePic {
    // 200M
    const val MAX_CACHE_SIZE = 200 * 1024 * 1024L
    private const val TAG = "DiskLruCachePic"
    private const val APP_VERSION = 1
    private const val VALUE_COUNT = 1
    private val writeLocker = DiskCacheWriteLocker()

    private var directory: File = File(FileModule.getPicCachePath())
    private var maxSize: Long = MAX_CACHE_SIZE

    private var diskLruCache: DiskLruCache? = null

    @Synchronized
    fun open(directory: File, maxSize: Long = MAX_CACHE_SIZE) {
        diskLruCache = DiskLruCache.open(directory, APP_VERSION, VALUE_COUNT, maxSize)
    }

    @Synchronized
    @Throws(IOException::class)
    private fun getDiskCache(): DiskLruCache {
        if (diskLruCache == null) {
            diskLruCache = DiskLruCache.open(directory, APP_VERSION, VALUE_COUNT, maxSize)
        }
        return diskLruCache!!
    }

    operator fun get(key: String): File? {
        return runCatching {
            getDiskCache()[key]?.getFile(0)
        }.onFailure {
            LogUtil.e(TAG, "Unable to get from disk cache ${Log.getStackTraceString(it)}")
        }.getOrNull()
    }

    fun put(safeKey: String, byteArray: ByteArray) {
        ThreadUtils.executeBySingle(object : ThreadUtils.SimpleTask<Boolean>() {
            override fun doInBackground(): Boolean {

                val get = get(safeKey)
                putReal(safeKey, byteArray)
                return true
            }

            override fun onSuccess(result: Boolean?) {

            }

        })
    }

    fun put(safeKey: String, content: String) {
        ThreadUtils.executeBySingle(object : ThreadUtils.SimpleTask<Boolean>() {
            override fun doInBackground(): Boolean {
                val realtime = SystemClock.elapsedRealtime()
                putReal(safeKey, content)
                if (BuildConfig.DEBUG) {
                    Log.d("picture", "put onSuccess: 耗时：" + safeKey + "   " + (SystemClock.elapsedRealtime() - realtime))
                }
                return true
            }

            override fun onSuccess(result: Boolean?) {

            }

        })
    }

    /**
     * 需要处理锁问题
     */
    fun putReal(safeKey: String, byteArray: ByteArray) {
        // We want to make sure that puts block so that data is available when put completes. We may
        // actually not write any data if we find that data is written by the time we acquire the lock.
        try {
            writeLocker.acquire(safeKey)
            try {
                // We assume we only need to put once, so if data was written while we were trying to get
                // the lock, we can simply abort.
                val diskCache = getDiskCache()
                val current = diskCache[safeKey]
                if (current != null) {
                    return
                }
                val editor = diskCache.edit(safeKey) ?: throw IllegalStateException("Had two simultaneous puts for: $safeKey")
                try {
                    val file = editor.getFile(0)
                    if (FileIOUtils.writeFileFromBytesByStream(file, byteArray)) {
                        editor.commit()
                    }
                } finally {
                    editor.abortUnlessCommitted()
                }
            } catch (e: IOException) {
                if (Log.isLoggable(TAG, Log.WARN)) {
                    Log.w(TAG, "Unable to put to disk cache", e)
                }
            }
        } finally {
            writeLocker.release(safeKey)
        }
    }

    /**
     * 非主线程，需要处理锁问题
     */
    fun putReal(safeKey: String, content: String) {
        // We want to make sure that puts block so that data is available when put completes. We may
        // actually not write any data if we find that data is written by the time we acquire the lock.
        try {
            // We assume we only need to put once, so if data was written while we were trying to get
            // the lock, we can simply abort.
            val diskCache = getDiskCache()
            val current = diskCache[safeKey]
            if (current != null) {
                return
            }
            val editor = diskCache.edit(safeKey) ?: throw IllegalStateException("Had two simultaneous puts for: $safeKey")
            try {
                val file = editor.getFile(0)
                if (FileIOUtils.writeFileFromString(file, content)) {
                    editor.commit()
                }
            } finally {
                editor.abortUnlessCommitted()
            }
        } catch (e: IOException) {
            if (Log.isLoggable(TAG, Log.WARN)) {
                Log.w(TAG, "Unable to put to disk cache", e)
            }
        }

    }

    fun delete(safeKey: String) {
        try {
            getDiskCache().remove(safeKey)
        } catch (e: IOException) {
            if (Log.isLoggable(TAG, Log.WARN)) {
                Log.w(TAG, "Unable to delete from disk cache", e)
            }
        }
    }

    @Synchronized
    fun clear() {
        try {
            getDiskCache().delete()
        } catch (e: IOException) {
            LogUtil.e("Unable to clear disk cache or disk cache cleared externally ${Log.getStackTraceString(e)}")
        } finally {
            // Delete can close the cache but still throw. If we don't null out the disk cache here, every
            // subsequent request will try to act on a closed disk cache and fail. By nulling out the disk
            // cache we at least allow for attempts to open the cache in the future. See #2465.
            resetDiskCache()
        }
    }

    @Synchronized
    private fun resetDiskCache() {
        diskLruCache = null
    }

}

