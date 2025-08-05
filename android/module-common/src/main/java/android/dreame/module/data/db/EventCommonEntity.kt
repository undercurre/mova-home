package android.dreame.module.data.db

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.Index
import androidx.room.PrimaryKey

@Entity(
    tableName = "event_page_common",
)
data class EventCommonEntity(
    val modelCode: Int, // 模块编码
    val eventCode: Int, // 事件编码
    var time: Long = System.currentTimeMillis() / 1000, // 当前时间
    var offset: Int, // offset
    val pageId: Int, // pageId
    val pluginVer: Int, // pluginVer
    val did: String? = "",
    val model: String? = "",

    val uid: String? = "",
    val lang: String? = "",
    val appVer: Long,
    val region: String? = "",

    val int1: Int = 0,
    val int2: Int,
    val int3: Int,
    val int4: Int,
    val int5: Int,

    val str1: String? = "",
    val str2: String? = "",
    val str3: String? = "",
    val rawStr: String? = "",

    val status: Int = 0, // 标记是否上传过
    val remark1: Int = 0, // 冗余字段
    val remark2: String = "", // 冗余字段

    @PrimaryKey(autoGenerate = true)
    @ColumnInfo(name = "id")
    var id: Long = 0
)