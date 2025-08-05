package android.dreame.module.data.entry.log

data class AppLogReq(
    val metadata: AppLogMetadata,
    val events: List<String>
)

data class AppLogMetadata(
    val uid: String,
    val region: String,
    val lang: String,
    val country: String,
    val platform: String,
    val platformVer: String,
    val brand: String,
    val appVer: String,
    val appSource: Int = 1,
)