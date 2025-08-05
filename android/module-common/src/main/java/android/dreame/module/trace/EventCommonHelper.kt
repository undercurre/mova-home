package android.dreame.module.trace

import android.dreame.module.BuildConfig
import android.dreame.module.manager.AccountManager
import android.dreame.module.util.LogUtil
import android.os.Process
import android.util.Log
import com.dreame.event_tracker.DefaultEvent
import com.dreame.event_tracker.EventTracker

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.launch

// 模块编码|事件编码|当前时间（秒）|停留时间（秒）|页面（id）|pluginVer|did|model|int1(uint8)|int2(uint8)|int3(unit8)|int4(uint8)|int5(16)|str1|str2|str3|rawStr
object EventCommonHelper : CoroutineScope by MainScope() {

    /**
     * APP日活
     */
    fun eventAppAliveInsert() {
        LogUtil.d("EventCommonHelper", "eventAppAliveInsert:")
        launch(Dispatchers.IO) {
            eventCommonPageInsertSuspend(
                ModuleCode.DailyActive.code,
                DailyActiveEventCode.AppDailyActive.code,
                0,
                0,
                0,
                "",
                "",
                0,
                0,
                0,
                0,
                0
            )
        }
    }

    /**
     * 插件日活
     */
    fun eventPluginAliveInsert(
        moduleName: String,
        did: String,
        moduleVersion: Long,
        sdkVersion: Int
    ) {
        LogUtil.d("EventCommonHelper", "eventPluginAliveInsert:")
        launch(Dispatchers.IO) {
            eventCommonPageInsertSuspend(
                ModuleCode.DailyActive.code,
                DailyActiveEventCode.PluginDailyActive.code,
                0,
                0,
                moduleVersion.toInt(),
                did,
                moduleName,
                sdkVersion,
                BuildConfig.PLUGIN_APP_VERSION,
                0,
                0,
                0
            )
        }
    }

    fun eventCommonPageInsert(
        modelCode: Int, eventCode: Int, pageId: Int
    ) {
        eventCommonPageInsert(
            modelCode, eventCode, pageId, 0, "", "",
            0, 0, 0, 0, 0, "", "", "", ""
        )
    }

    fun eventCommonPageInsert(
        modelCode: Int, eventCode: Int, pageId: Int, int1: Int
    ) {
        eventCommonPageInsert(
            modelCode, eventCode, pageId, 0, "", "",
            int1, 0, 0, 0, 0, "", "", "", ""
        )
    }

    fun eventCommonPageInsert(
        modelCode: Int, eventCode: Int, pageId: Int, int1: Int, deviceToken: String?
    ) {
        eventCommonPageInsert(
            modelCode, eventCode, pageId, 0, "", "",
            int1, 0, 0, 0, 0, "", "", deviceToken, ""
        )
    }

    fun eventCommonPageInsert(
        modelCode: Int, eventCode: Int, pageId: Int, pluginVer: Int, did: String?, module: String?
    ) {
        eventCommonPageInsert(
            modelCode, eventCode, pageId, pluginVer, did, module,
            0, 0, 0, 0, 0, "", "", "", ""
        )
    }

    fun eventCommonPageInsert(
        modelCode: Int,
        eventCode: Int,
        pageId: Int,
        int1: Int = 0,
        int2: Int = 0,
        int3: Int = 0,
        int4: Int = 0,
        int5: Int = 0
    ) {
        eventCommonPageInsert(
            modelCode, eventCode, pageId, 0, "", "",
            int1, int2, int3, int4, int5, "", "", "", ""
        )
    }

    fun eventCommonPageInsert(
        modelCode: Int,
        eventCode: Int,
        pageId: Int,
        did: String?,
        model: String?,
        int1: Int = 0,
        int2: Int = 0,
        int3: Int = 0,
        int4: Int = 0,
        int5: Int = 0,
        str1: String = "",
        str2: String = "",
        str3: String = "",
        rawStr: String = ""
    ) {
        eventCommonPageInsert(
            modelCode, eventCode, pageId, 0, did, model,
            int1, int2, int3, int4, int5, str1, str2, str3, rawStr
        )
    }

    fun eventCommonPageInsert(
        modelCode: Int,
        eventCode: Int,
        pageId: Int,
        pluginVer: Int,
        int1: Int = 0,
        int2: Int = 0,
        int3: Int = 0,
        int4: Int = 0,
        int5: Int = 0
    ) {
        eventCommonPageInsert(
            modelCode, eventCode, pageId, pluginVer, "", "",
            int1, int2, int3, int4, int5, "", "", "", ""
        )
    }

    fun eventCommonPageInsert(
        modelCode: Int, eventCode: Int, pageId: Int, pluginVer: Int, did: String?, model: String?,
        int1: Int = 0, int2: Int = 0, int3: Int = 0, int4: Int = 0, int5: Int = 0
    ) {
        eventCommonPageInsert(
            modelCode, eventCode, pageId, pluginVer, did, model,
            int1, int2, int3, int4, int5, "", "", "", ""
        )
    }

    fun eventCommonPageInsert(
        modelCode: Int,
        eventCode: Int,
        did: String?,
        model: String?,
        int1: Int,
        int2: Int,
        rawStr: String
    ) {
        eventCommonPageInsert(
            modelCode, eventCode, 0, 0, did, model,
            int1, int2, 0, 0, 0, "", "", "", rawStr
        )
    }

    fun eventCommonPageInsertAndKillProcess(
        modelCode: Int,
        eventCode: Int,
        pageId: Int,
        pluginVer: Int,
        did: String,
        model: String,
        int1: Int,
        int2: Int,
        int3: Int,
        int4: Int,
        int5: Int,
        str1: String,
        str2: String,
        str3: String,
        rawStr: String
    ) {
        try {
            val uid = kotlin.runCatching { AccountManager.getInstance().account.uid ?: "" }
                .getOrElse { "" }
            if (uid.isEmpty()) {
                return
            }
            launch(Dispatchers.IO) {
                runCatching {
                    LogUtil.d(
                        "EventCommonHelper",
                        "eventCommonPageInsert: modelCode: $modelCode ,eventCode: $eventCode ,pageId: $pageId " +
                                ",pluginVer: $pluginVer ,did: $did ,model: $model "
                                + ",int1: $int1 ,int2: $int2 ,int3: $int3 ,int4: $int4 ,int5: $int5"
                                + ",str1: $str1 ,str2: $str2 ,str3: $str3 ,rawStr: $rawStr"
                    )
                    val event = DefaultEvent(
                        modelCode,
                        eventCode,
                        System.currentTimeMillis() / 1000,
                        0,
                        pageId,
                        pluginVer,
                        did,
                        model,
                        int1,
                        int2,
                        int3,
                        int4,
                        int5,
                        str1,
                        str2,
                        str3,
                        rawStr
                    )
                    EventTracker.getInstance().trackEvent(event);
                    EventTracker.getInstance().forceUpload()
                }.onFailure {
                    LogUtil.e("EventCommonHelper", "eventCommonPageInsertAndKillProcess: $it")
                }
                Process.killProcess(Process.myPid())
            }
        } catch (e: Exception) {
            e.printStackTrace()
            LogUtil.e("EventCommonHelper", Log.getStackTraceString(e))
            Process.killProcess(Process.myPid())
        }
    }


    fun eventCommonPageInsert(
        modelCode: Int,
        eventCode: Int,
        pageId: Int,
        pluginVer: Int,
        did: String? = "",
        model: String? = "",
        int1: Int,
        int2: Int,
        int3: Int,
        int4: Int,
        int5: Int,
        str1: String? = "",
        str2: String? = "",
        str3: String? = "",
        rawStr: String? = ""
    ) {
        eventCommonPageInsert(
            modelCode, eventCode, 0, pageId, pluginVer, did, model,
            int1, int2, int3, int4, int5, str1, str2, str3, rawStr
        )
    }

    fun eventCommonPageInsert(
        modelCode: Int,
        eventCode: Int,
        offset: Int,
        pageId: Int,
        pluginVer: Int,
        did: String? = "",
        model: String? = "",
        int1: Int,
        int2: Int,
        int3: Int,
        int4: Int,
        int5: Int,
        str1: String? = "",
        str2: String? = "",
        str3: String? = "",
        rawStr: String? = ""
    ) {
        try {
            val uid = kotlin.runCatching { AccountManager.getInstance().account.uid ?: "" }
                .getOrElse { "" }
            if (uid.isEmpty()) {
                return
            }
            launch(Dispatchers.IO) {
                val event = DefaultEvent(
                    modelCode,
                    eventCode,
                    System.currentTimeMillis() / 1000,
                    offset.toLong(),
                    pageId,
                    pluginVer,
                    did,
                    model,
                    int1,
                    int2,
                    int3,
                    int4,
                    int5,
                    str1,
                    str2,
                    str3,
                    rawStr
                )
                EventTracker.getInstance().trackEvent(event)
            }
        } catch (e: Exception) {
            e.printStackTrace()
            LogUtil.e("EventCommonHelper", Log.getStackTraceString(e))
        }
    }

    suspend fun eventCommonPageInsertSuspend(
        modelCode: Int,
        eventCode: Int,
        stayTime: Int,
        pageId: Int,
        pluginVer: Int,
        did: String,
        model: String,
        int1: Int,
        int2: Int,
        int3: Int,
        int4: Int,
        int5: Int,
        str1: String = "",
        str2: String = "",
        str3: String = "",
        rawStr: String = ""
    ) = runCatching {
        val uid =
            kotlin.runCatching { AccountManager.getInstance().account.uid ?: "" }.getOrElse { "" }

        LogUtil.d(
            "EventCommonHelper",
            "eventCommonPageInsertSuspend: modelCode: $modelCode ,eventCode: $eventCode ,pageId: $pageId " +
                    ",pluginVer: $pluginVer ,did: $did ,model: $model "
                    + ",int1: $int1 ,int2: $int2 ,int3: $int3 ,int4: $int4 ,int5: $int5"
                    + ",str1: $str1 ,str2: $str2 ,str3: $str3 ,rawStr: $rawStr"
        )
        if (uid.isEmpty()) {
            return@runCatching
        }
        val event = DefaultEvent(
            modelCode,
            eventCode,
            System.currentTimeMillis() / 1000,
            stayTime.toLong(),
            pageId,
            pluginVer,
            did,
            model,
            int1,
            int2,
            int3,
            int4,
            int5,
            str1,
            str2,
            str3,
            rawStr
        )
        EventTracker.getInstance().trackEvent(event)
    }.onFailure {
        it.printStackTrace()
        Log.e("EventCommonHelper", Log.getStackTraceString(it))
    }
}