package android.dreame.module.data.db

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.Index
import androidx.room.PrimaryKey

@Entity(
    tableName = "event_page_connect"
)
data class EventConnectPageEntity(
    val modelCode: Int, // 模块编码
    val eventCode: Int, // 事件编码
    val pageId: Int, // pageId
    val eventId: String, // eventId
    val stepId: Int, // stepId
    val uid: String,
    val lang: String,
    val appVer: String,
    val region: String,
    val did: String,
    val model: String,
    val scType: Int = 0,
    /**
     * // 配网进入类型
     * @see com.dreame.smartlife.config.event.EnterType
     */
    @ColumnInfo(name = "int1")
    val enterOrigin: Int = 0,    // 配网成功或失败 0 item / 1 scan 2 qr
    @ColumnInfo(name = "int2")
    val result: Int,
    @ColumnInfo(name = "int3")
    val manualConnect: Int, // 手动 0/1
    @ColumnInfo(name = "int4")
    val lastStepId: Int, // 最后步骤Id
    @ColumnInfo(name = "int5")
    val consumeTime: Int, // 配网耗时

    @ColumnInfo(name = "str1")
    val reason: String = "", // 失败原因描述
    @ColumnInfo(name = "str2")
    val desc: String = "", // 补充描述
    @ColumnInfo(name = "str3")
    val remark: String = "", // 补充描述
    @ColumnInfo(name = "rawStr")
    val rawStr: String = "", // 完整信息收集

    val status: Int = 0, // 标记是否上传过

    val remark1: Int = 0, // 冗余字段
    val remark2: String = "", // 冗余字段

    val time: Long = System.currentTimeMillis() / 1000, // 当前时间s
    @PrimaryKey(autoGenerate = true)
    @ColumnInfo(name = "id")
    var id: Long = 0
)