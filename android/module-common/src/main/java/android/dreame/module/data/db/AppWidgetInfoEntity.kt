package android.dreame.module.data.db

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(
    tableName = "appwidget_info",
)
data class AppWidgetInfoEntity(

    @ColumnInfo(name = "widget_id")
    var appWidgetId: Int,

    @ColumnInfo(name = "type")
    var appWidgetType: Int,

    @ColumnInfo(name = "uid")
    var uid: String,

    @ColumnInfo(name = "did")
    var did: String,

    @ColumnInfo(name = "domain")
    var domain: String,

    @ColumnInfo(name = "host")
    var host: String,

    // 设备名
    @ColumnInfo(name = "device_name")
    var deviceName: String,

    // 共享 -1 未知 0 自己 1分享
    @ColumnInfo(name = "device_share")
    var deviceShare: Int = -1,

    // 设备是否在线
    @ColumnInfo(name = "device_online")
    var deviceOnline: Boolean = true,

    // 设备icon
    @ColumnInfo(name = "device_imagUrl")
    var deviceImagUrl: String = "",

    // 电量
    @ColumnInfo(name = "device_battery")
    var deviceBattery: Int = -1,

    // 设备运行状态
    @ColumnInfo(name = "device_status")
    var deviceStatus: Int = -1,

    // 是否支持实时视频
    @ColumnInfo(name = "support_video")
    var supportVideo: Boolean = false,
  // 是否支持实时视频多任务
    @ColumnInfo(name = "video_task")
    var videoTask: Boolean = false,
  // 是否支持实时视频权限
    @ColumnInfo(name = "video_permission")
    var videoPermission: Boolean = false,

    // 是否支持快捷指令
    @ColumnInfo(name = "support_fast_cmd")
    var supportFastCommand: Boolean = false,

    // 快捷指令 列表
    @ColumnInfo(name = "fast_cmd_list")
    var fastCommandListStr: String = "",

    // 清洁区域
    @ColumnInfo(name = "clean_area")
    var cleanArea: Float = -1f,

    // 清洁时间
    @ColumnInfo(name = "clean_time")
    var cleanTime: Int = -1,
    var category: String = "",
    var model: String = "",

    var status: Int = 0,
    val createTime: Long = System.currentTimeMillis(),
    var updateTime: Long = System.currentTimeMillis(),
    var remark: String = "",

    @PrimaryKey(autoGenerate = true)
    @ColumnInfo(name = "id")
    val id: Int = 0,

    )