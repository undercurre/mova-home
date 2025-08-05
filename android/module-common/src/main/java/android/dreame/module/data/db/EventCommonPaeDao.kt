package android.dreame.module.data.db

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import androidx.room.Update
import kotlinx.coroutines.flow.Flow

@Dao
interface EventCommonPaeDao {

    @Insert
    suspend fun insertAll(entityList: List<EventCommonEntity>)

    @Insert
    suspend fun insert(entity: EventCommonEntity)

    @Query("select count(id) from event_page_common where uid = :uid and status = :status")
    fun queryEventCommonCount(uid: String, status: Int): Int

    @Query("select count(id) from event_page_common ")
    fun queryEventCommonCount(): Flow<Int>

    @Query("select * from event_page_common where uid = :uid and status = :status and modelCode = :modelCode and eventCode=:eventCode")
    fun queryEventsByEvent(uid: String, modelCode: Int, eventCode: Int, status: Int): Flow<List<EventCommonEntity>>

    @Query("select * from event_page_common where uid = :uid and modelCode = :modelCode and eventCode=:eventCode order by id desc limit :limit offset :offset")
    fun queryEventsByEventIdWithLimit(
        uid: String,
        modelCode: Int,
        eventCode: Int,
        limit: Int,
        offset: Int = 0
    ): Flow<List<EventCommonEntity>>

    @Query("select * from event_page_common where uid = :uid and modelCode = :modelCode and eventCode=:eventCode and model = :model order by id desc limit :limit offset :offset")
    fun queryEventsByEventIdWithLimit(
        uid: String,
        modelCode: Int,
        eventCode: Int,
        model: String,
        limit: Int,
        offset: Int = 0
    ): Flow<List<EventCommonEntity>>

    @Query("select * from event_page_common where uid = :uid and modelCode = :modelCode and eventCode=:eventCode")
    fun queryEventsByEvent(uid: String, modelCode: Int, eventCode: Int): Flow<List<EventCommonEntity>>

    @Query("select * from event_page_common where uid = :uid and modelCode = :modelCode and eventCode=:eventCode and pageId = :pageId")
    fun queryEventsByPageId(uid: String, modelCode: Int, eventCode: Int, pageId: Int): Flow<EventCommonEntity?>

    @Query("SELECT * FROM event_page_common where uid = :uid and status=:status limit :limit")
    fun getEventsWithLimit(uid: String, status: Int = 0, limit: Int = 100): Flow<List<EventCommonEntity>>

    @Query("SELECT * FROM event_page_common where uid = :uid and status=:status limit :limit offset :offset")
    fun getEventsWithLimit2(uid: String, status: Int = 0, limit: Int = 100, offset: Int = 0): List<EventCommonEntity>

    @Query("SELECT * FROM event_page_common where uid = :uid and status=:status and pageId = :pageId limit :limit")
    fun getEventsWithLimit(uid: String, pageId: Int, status: Int = 0, limit: Int = 100): Flow<List<EventCommonEntity>>


    @Query("SELECT * FROM event_page_common where uid = :uid and status=:status ")
    fun getEvents(uid: String, status: Int = 0): Flow<List<EventCommonEntity>>

    @Query("SELECT * FROM event_page_common where uid = :uid and status=:status ")
    fun getEvents2(uid: String, status: Int = 0): List<EventCommonEntity>

    @Query("SELECT * FROM event_page_common where status=:status and pageId = :pageId")
    fun getEvents(pageId: Int, status: Int = 0): Flow<List<EventCommonEntity>>


    @Query("SELECT * FROM event_page_common where status=0 and uid=:uid")
    fun getEventsByUid(uid: String): Flow<List<EventCommonEntity>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertData(entity: EventCommonEntity): Long

    @Query("update event_page_common set status=:status where id = :id")
    suspend fun updateEventStatus(id: Long, status: Int): Int

    @Query("update event_page_common set status=:status where id in (:ids)")
    suspend fun updateEventStatus(ids: List<Long>, status: Int): Int

    @Update
    suspend fun updateEventStatus(entity: EventCommonEntity): Int

    @Query("delete from event_page_common where id = :id")
    suspend fun deleteEventById(id: Long): Int

    @Query("delete from event_page_common where id in (:ids)")
    suspend fun deleteEventByIds(ids: List<Long>): Int

    @Query("delete from event_page_common where status=:status")
    fun deleteEventByStatus(status: Int): Int

    @Query("delete from event_page_common")
    suspend fun deleteEventAll()

    @Query("delete from event_page_common where modelCode != :modelCode")
    suspend fun deleteEventAllSkipModuleCode(modelCode: Int)

}