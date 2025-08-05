package android.dreame.module.data.entry.ad

data class AdModelConfig(
    val adModel: AdModel,
    var popShowTime: Long = 0,
    var isClicked: Boolean = false
)

data class AdModel(
    val id: String,
    val picture: String,
    val jumpType: String?,
    val androidJumpLink: String = "",
    val iosJumpLink: String = "",
    val orderNo: Long?,
    val ext: String?,
    val type: Int,
    val nextShowDay: Long,
    val showAgain: Int, // 1: 点击后下次扔展示，0：点击后不再展示
    val endDateTimeStamp: Long,
    val picFilePath: String? = null
)
