package android.dreame.module.data.db

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "plugin_config")
data class PluginConfigEntity(
    @PrimaryKey
    @ColumnInfo(name = "name", index = true)
    val pluginName: String,
    @ColumnInfo(name = "version")
    val pluginVersion: Int,
    @ColumnInfo(name = "path")
    val pluginPath: String,
    @ColumnInfo(name = "length")
    val pluginLength: Long,
    @ColumnInfo(name = "md5")
    val pluginMd5: String
)