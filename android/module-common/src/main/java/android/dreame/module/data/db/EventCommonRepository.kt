package android.dreame.module.data.db

import android.database.sqlite.SQLiteFullException
import android.dreame.module.LocalApplication
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.runBlocking

class EventCommonRepository {
    private val dao by lazy { AppDatabase.getInstance(LocalApplication.getInstance()).eventCommonPaeDao() }

    fun queryEventCommonCount(uid: String, status: Int = 0): Int {
        return dao.queryEventCommonCount(uid, status)
    }

    fun queryEventCommonCount(): Flow<Int> {
        return dao.queryEventCommonCount()
    }

    fun queryEventCommonWithLimit(uid: String, status: Int = 0, limit: Int = 50): Flow<List<EventCommonEntity>> {
        return dao.getEventsWithLimit(uid, status, limit)
    }

    fun queryEventCommonWithLimit2(uid: String, status: Int = 0, limit: Int = 50, offset: Int = 0): List<EventCommonEntity> {
        return dao.getEventsWithLimit2(uid, status, limit, offset)
    }

    fun queryEventCommon(uid: String, status: Int = 0): List<EventCommonEntity> {
        return dao.getEvents2(uid, status)
    }

    fun queryEventCommon(uid: String, modelCode: Int, eventCode: Int, status: Int = 0): Flow<List<EventCommonEntity>> {
        return dao.queryEventsByEvent(uid, modelCode, eventCode, status)
    }

    fun queryEventsByEventIdWithLimit(uid: String, modelCode: Int, eventCode: Int, limit: Int = 1): Flow<List<EventCommonEntity>> {
        return dao.queryEventsByEventIdWithLimit(uid, modelCode, eventCode, limit)
    }

    fun queryEventsByEventIdWithLimit(
        uid: String,
        modelCode: Int,
        eventCode: Int,
        model: String,
        limit: Int = 1
    ): Flow<List<EventCommonEntity>> {
        return dao.queryEventsByEventIdWithLimit(uid, modelCode, eventCode, model, limit)
    }

    fun queryEventCommon(uid: String, modelCode: Int, eventCode: Int): Flow<List<EventCommonEntity>> {
        return dao.queryEventsByEvent(uid, modelCode, eventCode)
    }

    fun queryEventByEventCodeWithLimit(uid: String, modelCode: Int, eventCode: Int, limit: Int = 50): Flow<List<EventCommonEntity>> {
        return dao.queryEventsByEvent(uid, modelCode, eventCode, limit)
    }

    fun queryEventsByPageId(uid: String, modelCode: Int, eventCode: Int, pageId: Int): Flow<EventCommonEntity?> {
        return dao.queryEventsByPageId(uid, modelCode, eventCode, pageId)
    }

    suspend fun updateEventCommonById(ids: List<Long>, status: Int): Int {
        return dao.updateEventStatus(ids, status)
    }

    suspend fun updateEventCommonById(id: Long, status: Int): Int {
        return dao.updateEventStatus(id, status)
    }

    suspend fun updateEventEntity(entity: EventCommonEntity): Int {
        return dao.updateEventStatus(entity)
    }

    suspend fun deleteEventCommon(id: Long): Int {
        return dao.deleteEventById(id)
    }

    suspend fun deleteEventCommonByIds(ids: List<Long>): Int {
        return dao.deleteEventByIds(ids)
    }

    suspend fun insertEventCommon(
        modelCode: Int, // 模块编码
        eventCode: Int, // 事件编码
        offset: Int, // offset
        pageId: Int, // pageId
        uid: String,
        lang: String,
        appVer: Long,
        region: String,
        int1: Int,
        int2: Int,
        int3: Int,
        int4: Int,
        int5: Int,
    ) {
        return insertEventCommon(
            modelCode, eventCode, offset, pageId, uid, lang, appVer, region, 0, "", "",
            int1, int2, int3, int4, int5, "", "", "", "", 0, 0, ""
        )
    }

    suspend fun insertEventCommon(
        modelCode: Int, // 模块编码
        eventCode: Int, // 事件编码
        offset: Int, // offset
        pageId: Int, // pageId
        uid: String,
        lang: String,
        appVer: Long,
        region: String,
        int1: Int,
        int2: Int,
        int3: Int,
        int4: Int,
        int5: Int,
        status: Int = 0, // 标记是否上传过
        remark1: Int = 0, // 冗余字段
        remark2: String = "", // 冗余字段
    ) {
        return insertEventCommon(
            modelCode, eventCode, offset, pageId, uid, lang, appVer, region, 0, "", "",
            int1, int2, int3, int4, int5, "", "", "", "", status, remark1, remark2
        )
    }

    suspend fun insertEventCommon(
        modelCode: Int, // 模块编码
        eventCode: Int, // 事件编码
        offset: Int, // offset
        pageId: Int, // pageId
        uid: String,
        lang: String,
        appVer: Long,
        region: String,
        int1: Int,
        int2: Int,
        int3: Int,
        int4: Int,
        int5: Int,

        str1: String = "",
        str2: String = "",
        str3: String = "",
        rawStr: String = "",
    ) {
        return insertEventCommon(
            modelCode, eventCode, offset, pageId, uid, lang, appVer, region, 0, "", "",
            int1, int2, int3, int4, int5, str1, str2, str3, rawStr, 0, 0, ""
        )
    }

    suspend fun insertEventCommon(
        modelCode: Int, // 模块编码
        eventCode: Int, // 事件编码
        offset: Int, // offset
        pageId: Int, // pageId
        uid: String? = "",
        lang: String? = "",
        appVer: Long,
        region: String? = "",
        pluginVer: Int, // pluginVer
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
        rawStr: String? = "",

        status: Int = 0, // 标记是否上传过
        remark1: Int = 0, // 冗余字段
        remark2: String = "", // 冗余字段
        time: Long = System.currentTimeMillis() / 1000, // 当前时间

    ) {
        val entity = EventCommonEntity(
            modelCode, eventCode, time, offset, pageId, pluginVer, did, model, uid, lang, appVer, region,
            int1, int2, int3, int4, int5, str1, str2, str3, rawStr, status, remark1, remark2
        )
        try {
            dao.insert(entity)
        } catch (e: SQLiteFullException) {
            dao.deleteEventByStatus(ItemStatus.STATUS_DELETE)
            dao.deleteEventAll()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    fun deleteEventByStatus(status: Int): Int {
        return dao.deleteEventByStatus(status);
    }

    suspend fun deleteEventAll() {
        return dao.deleteEventAll();
    }

    suspend fun deleteEventAllSkipModuleCode(skipModuleCode: Int) {
        return dao.deleteEventAllSkipModuleCode(skipModuleCode);
    }


}