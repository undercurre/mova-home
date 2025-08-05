package android.dreame.module.data.db

import androidx.room.*
import kotlinx.coroutines.flow.Flow

@Dao
interface EventConnectPageDao {
    @Insert
    suspend fun insertAll(entityList: List<EventConnectPageEntity>)

    @Insert
    suspend fun insert(entity: EventConnectPageEntity)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertData(entity: EventConnectPageEntity)

    @Query("SELECT * FROM event_page_connect where uid = :uid and status=0")
    fun getAllEvents(uid: String): Flow<List<EventConnectPageEntity>>

    @Query("SELECT * FROM event_page_connect where  uid = :uid and status=0")
    fun getAllEvents2(uid: String): List<EventConnectPageEntity>

    @Query("SELECT * FROM event_page_connect where  uid = :uid and status=0 limit 1")
    fun getEventOne(uid: String): Flow<List<EventConnectPageEntity>>

    @Query("SELECT * FROM event_page_connect where  uid = :uid and status=0 and uid=:uid")
    fun getEventsByUid(uid: String): Flow<List<EventConnectPageEntity>>

    @Query("SELECT * FROM event_page_connect where  uid = :uid and status=0 and stepId=:stepId and eventId = :eventId")
    fun getEventsByStepIdAndEventId(uid: String, stepId: Int, eventId: String): Flow<List<EventConnectPageEntity>>

    @Query("update event_page_connect set status=:status where id = :id")
    suspend fun updateEventStatus(id: Long, status: Int): Int

    @Update
    suspend fun updateEventStatus(entity: EventConnectPageEntity): Int

    @Query("delete from event_page_connect where id = :id")
    suspend fun deleteEventById(id: Long): Int

    @Query("delete from event_page_connect where id in (:ids)")
    suspend fun deleteEventById(ids: List<Long>): Int

    @Query("delete from event_page_connect where status = :status")
    suspend fun deleteEventByStatus(status: Int): Int

    @Query("update event_page_connect set status=:status where id in (:ids)")
    suspend fun updateEventById(ids: List<Long>, status: Int): Int

    @Query("delete from event_page_connect where region = :region")
    suspend fun deleteEventByRegion(region: String): Int

    @Query("delete from event_page_connect where uid = :uid")
    suspend fun deleteEventByUid(uid: String): Int

    @Query("delete from event_page_connect")
    suspend fun deleteEventAll(): Int

}