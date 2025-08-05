package android.dreame.module.data.db

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import kotlinx.coroutines.flow.Flow

@Dao
interface PluginConfigDao {

    @Query("select * from plugin_config where name = :pluginName")
    suspend fun queryConfig(pluginName: String): PluginConfigEntity?

    @Query("select * from plugin_config where name = :pluginName")
    fun queryConfigSync(pluginName: String): PluginConfigEntity?

    @Query("delete from plugin_config where name = :pluginName")
    suspend fun removePluginConfig(pluginName: String): Int

    @Query("delete from plugin_config where name = :pluginName")
    fun removePluginConfigSync(pluginName: String): Int

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun replaceConfig(pluginConfig: PluginConfigEntity)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    fun replaceConfigSync(pluginConfig: PluginConfigEntity)

}