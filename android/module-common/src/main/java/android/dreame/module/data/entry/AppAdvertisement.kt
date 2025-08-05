package android.dreame.module.data.entry

import org.json.JSONObject

data class AppAdvertisementRes(
    val androidJumpLink: String,
    val id: String,
    val iosJumpLink: String,
    val jumpType: String,
    val orderNo: Int,
    val picture: String,
    val ext: String?,
)