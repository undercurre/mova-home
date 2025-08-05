package android.dreame.module.data.db

import androidx.lifecycle.LiveData
import androidx.room.*

@Dao
interface PluginInfoDao {

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAll(entityList: List<PluginInfoEntity>)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(entity: PluginInfoEntity)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    fun insertSync(entity: PluginInfoEntity)

    @Query("select * from plugin_info where name = :moduleName and status = :status")
    suspend fun queryPluginInfo(moduleName: String, status: Int): PluginInfoEntity?

    @Query("select * from plugin_info where name = :moduleName and status = :status")
    fun queryPluginInfoSync(moduleName: String, status: Int): PluginInfoEntity?


    @Query("select * from plugin_info where name = :moduleName and version = :version")
    suspend fun queryPluginInfoByVersion(moduleName: String, version: Int): PluginInfoEntity?

    @Query("select * from plugin_info where name = :moduleName and version = :version")
    fun queryPluginInfoByVersionSync(moduleName: String, version: Int): PluginInfoEntity?

    @Query("select * from plugin_info where name = :moduleName and version = :version")
    fun queryPluginInfoByVersionSync2(moduleName: String, version: Int): LiveData<PluginInfoEntity>


    @Update(onConflict = OnConflictStrategy.REPLACE)
    suspend fun updatePluginInfo(entity: PluginInfoEntity): Int

    @Query("update plugin_info set status=:status where id = :id")
    suspend fun updatePluginInfo(id: Long, status: Int): Int

    @Query("update plugin_info set status=:status where id = :id")
    fun updatePluginInfoSync(id: Long, status: Int): Int

    @Update(onConflict = OnConflictStrategy.REPLACE)
    fun updatePluginInfoSync(entity: PluginInfoEntity): Int

    @Query("delete from plugin_info where name = :moduleName and status = :status")
    suspend fun deletePluginInfo(moduleName: String, status: Int): Int

    @Query("delete from plugin_info where status = :status")
    suspend fun deletePluginInfo(status: Int): Int

    @Query("delete from plugin_info where name = :moduleName and status = :status")
    fun deletePluginInfoSync(moduleName: String, status: Int): Int

    @Query("delete from plugin_info where status = :status")
    fun deletePluginInfoSync(status: Int): Int


    @Query("delete from plugin_info where id =:id")
    suspend fun deleteEventStatusById(id: Int): Int


}