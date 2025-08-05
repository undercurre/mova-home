package android.dreame.module.data.db

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.Index
import androidx.room.PrimaryKey

@Entity(
    tableName = "plugin_info",
    indices = [Index(value = arrayOf("name", "status"))]
)
data class PluginInfoEntity(
    @ColumnInfo(name = "name", index = true)
    val pluginName: String,
    @ColumnInfo(name = "length")
    val pluginLength: Long,
    @ColumnInfo(name = "md5")
    val pluginMd5: String,
    @ColumnInfo(name = "versionCode")
    val pluginVersionCode: Int,
    @ColumnInfo(name = "version")
    val pluginVersion: Int,
    @ColumnInfo(name = "path")
    val pluginPath: String,
    @ColumnInfo(name = "resPackage")
    val realUrl: String,

    /// 资源
    @ColumnInfo(name = "res_id")
    val pluginResId: String,
    @ColumnInfo(name = "res_length")
    val pluginResLength: Long,
    @ColumnInfo(name = "res_version")
    val pluginResVersion: Int,
    @ColumnInfo(name = "res_url")
    val pluginResUrl: String,
    @ColumnInfo(name = "res_md5")
    val pluginResMd5: String,
    @ColumnInfo(name = "res_path")
    val pluginResPath: String,
    @ColumnInfo(name = "common_plugin_version")
    val commonPluginVer: Int,

    /**
     *
     */
    val status: Int,
    val createTime: Long = System.currentTimeMillis(),
    val updateTime: Long = System.currentTimeMillis(),
    val remark: String = "",
    @PrimaryKey(autoGenerate = true)
    @ColumnInfo(name = "id")
    var id: Long = 0
)
