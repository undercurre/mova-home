package android.dreame.module.data.db

import android.dreame.module.LocalApplication
import android.dreame.module.util.LogUtil
import kotlinx.coroutines.flow.Flow

class EventConnectPageRepository {
    private val dao by lazy { AppDatabase.getInstance(LocalApplication.getInstance()).eventConnectPageDao() }

    suspend fun insertStepEntity(
        eventId: String, // eventId
        stepId: Int, // stepId
        uid: String,
        lang: String,
        appVer: String,
        region: String,
        did: String,
        model: String,
        scType: Int = 0,

        enterOrigin: Int = 0,    // 配网成功或失败 0 item / 1 scan 2 qr
        result: Int,
        manualConnect: Int, // 手动 0/1
        lastStepId: Int, // 最后步骤Id
        consumeTime: Int, // 配网耗时
        reason: String = "", // 失败原因描述
    ) {
        val entity = EventConnectPageEntity(
            8, 1, 0, eventId, stepId, uid, lang, appVer, region, did, model, scType, enterOrigin,
            result, manualConnect, lastStepId, consumeTime, reason, "", "", "", 0, 0, "",
        )
        runCatching {
            dao.insert(entity)
        }
    }

    fun queryStepEntity(uid: String): Flow<List<EventConnectPageEntity>> {
        return dao.getAllEvents(uid)
    }

    fun queryStepEntity2(uid: String): List<EventConnectPageEntity> {
        return dao.getAllEvents2(uid)
    }

    fun queryStepEntity(uid: String, stepId: Int, eventId: String): Flow<List<EventConnectPageEntity>> {
        return dao.getEventsByStepIdAndEventId(uid, stepId, eventId)
    }

    suspend fun updateEventStatus(id: Long, status: Int): Int {
        return dao.updateEventStatus(id, status)
    }

    suspend fun deleteEventById(id: Long): Int {
        return dao.deleteEventById(id)
    }

    suspend fun deleteEventById(ids: List<Long>): Int {
        return dao.deleteEventById(ids)
    }

    suspend fun deleteEventByRegion(region: String): Int {
        return dao.deleteEventByRegion(region)
    }

    suspend fun deleteEventAll(): Int {
        return dao.deleteEventAll()
    }

    suspend fun deleteEventByStatus(status: Int): Int {
        return dao.deleteEventByStatus(status)
    }

    suspend fun updateEventById(ids: List<Long>, status: Int): Int {
        return dao.updateEventById(ids, status)
    }

    suspend fun insertStepEntity(
        eventId: String, // eventId
        stepId: Int, // stepId
        uid: String,
        lang: String,
        appVer: String,
        region: String,
        did: String,
        model: String,
        scType: Int = 0,

        enterOrigin: Int = 0,    // 配网成功或失败 0 item / 1 scan 2 qr
        result: Int,
        manualConnect: Int, // 手动 0/1
        lastStepId: Int, // 最后步骤Id
        consumeTime: Int, // 配网耗时

        reason: String = "", // 失败原因描述
        desc: String = "", // 补充描述
        remark: String = "", // 补充描述
        rawStr: String = "", // 完整信息收集
        status: Int = 0, // 标记是否上传过
        remark1: Int = 0, // 冗余字段
        remark2: String = "", // 冗余字段
    ) {
        val entity = EventConnectPageEntity(
            8, 1, 0, eventId, stepId, uid, lang, appVer, region, did, model, scType, enterOrigin,
            result, manualConnect, lastStepId, consumeTime, reason, desc, remark, rawStr, status, remark1, remark2
        )
        LogUtil.d("--------- insertStepEntity --------- ${entity}")
        runCatching {
            dao.insert(entity)
        }
    }


    suspend fun insertStepErrorEntity(
        stepId: Int, // stepId
        uid: String,
        lang: String,
        appVer: String,
        region: String,
        did: String,
        model: String,
        scType: Int = 0,

        enterOrigin: Int = 0,    // 配网成功或失败 0 item / 1 scan 2 qr
        errorCode: Int,
        dataTraffic: Int,
        errorMsg: String = "", // 失败原因描述
        rawStr: String = "", // 完整信息收集
    ) {
        val entity = EventConnectPageEntity(
            8, 2, 0, "", stepId, uid, lang, appVer, region, did, model, scType, enterOrigin,
            stepId, errorCode, dataTraffic, 0, errorMsg, "", "", rawStr, 0, 0, ""
        )
        LogUtil.d("--------- insertStepErrorEntity --------- ${entity}")
        runCatching {
            dao.insert(entity)
        }
    }

}