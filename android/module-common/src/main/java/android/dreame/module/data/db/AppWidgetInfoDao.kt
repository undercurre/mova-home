package android.dreame.module.data.db

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import androidx.room.Update

@Dao
interface AppWidgetInfoDao {

    @Query("select * from appwidget_info order by updateTime")
    suspend fun queryWidgetInfoList(): List<AppWidgetInfoEntity>

    @Query("select count(id) from appwidget_info")
    suspend fun queryWidgetInfoCount(): Int

    @Query("select * from appwidget_info where widget_id = :appWidgetId and uid = :uid and domain = :domain")
    suspend fun queryWidgetInfo(uid: String, appWidgetId: Int, domain: String): AppWidgetInfoEntity?

    @Query("select * from appwidget_info where widget_id = :appWidgetId and uid = :uid and domain = :domain")
    fun queryWidgetInfoSync(uid: String, appWidgetId: Int, domain: String): AppWidgetInfoEntity?

    @Query("select * from appwidget_info where type = :appWidgetType and uid = :uid and domain = :domain")
    suspend fun queryWidgetInfoByType(uid: String, appWidgetType: Int, domain: String): List<AppWidgetInfoEntity>

    @Query("select * from appwidget_info where did = :did and uid = :uid and domain = :domain")
    suspend fun queryWidgetInfo(uid: String, did: String, domain: String): List<AppWidgetInfoEntity>

    @Query("select * from appwidget_info where did = :did and uid = :uid and type = :appWidgetType and domain = :domain")
    suspend fun queryWidgetInfo(uid: String, did: String, appWidgetType: Int, domain: String): AppWidgetInfoEntity?

    @Query("select * from appwidget_info where uid = :uid and domain = :domain")
    suspend fun queryWidgetInfo(uid: String, domain: String): List<AppWidgetInfoEntity>

    @Query("select count(id) from appwidget_info where did = :did and uid = :uid and domain = :domain")
    suspend fun queryWidgetInfoCount(uid: String, did: String, domain: String): Int

    @Query("select * from appwidget_info where widget_id in (:widgetIds) and uid = :uid and domain = :domain")
    suspend fun queryWidgetInfoList(uid: String, widgetIds: List<Int>, domain: String): List<AppWidgetInfoEntity>


    @Query("select * from appwidget_info where widget_id = :widgetId and uid = :uid")
    suspend fun queryWidgetInfoWithoutDomain(uid: String, widgetId: Int): AppWidgetInfoEntity?

    @Query("select * from appwidget_info where did = :did and uid = :uid")
    suspend fun queryWidgetInfoWithoutDomain(uid: String, did: String): List<AppWidgetInfoEntity>

    @Query("select * from appwidget_info where uid = :uid")
    suspend fun queryWidgetInfoWithoutDomain(uid: String): List<AppWidgetInfoEntity>

    @Query("select count(id) from appwidget_info where did = :did and uid = :uid")
    suspend fun queryWidgetInfoCountWithoutDomain(uid: String, did: String): Int

    @Query("select type from appwidget_info where widget_id = :appWidgetId")
    suspend fun queryWidgetInfoType(appWidgetId: Int): Int?


    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertWidgetInfo(entity: AppWidgetInfoEntity)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertWidgetInfo(entitys: List<AppWidgetInfoEntity>)

    @Update(onConflict = OnConflictStrategy.NONE)
    suspend fun updateAppWidgetInfo(entity: AppWidgetInfoEntity): Int

    @Update(onConflict = OnConflictStrategy.NONE)
    suspend fun updateAppWidgetInfo(entitys: List<AppWidgetInfoEntity>): Int

    @Query("delete from appwidget_info where uid =:uid")
    suspend fun deleteAppWidget(uid: String): Int

    @Query("delete from appwidget_info where id in (:ids)")
    suspend fun deleteAppWidget(ids: List<Int>): Int

    @Query("delete from appwidget_info where widget_id= :widgetId")
    suspend fun deleteAppWidget(widgetId: Int): Int

    @Query("delete from appwidget_info where widget_id= :widgetId and uid =:uid and domain = :domain")
    suspend fun deleteAppWidget(uid: String, widgetId: Int, domain: String): Int

    @Query("delete from appwidget_info where uid =:uid and domain = :domain and widget_id in (:widgetIds)")
    suspend fun deleteAppWidget(uid: String, widgetIds: List<Int>, domain: String): Int


}