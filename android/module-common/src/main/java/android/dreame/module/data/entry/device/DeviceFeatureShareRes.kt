package android.dreame.module.data.entry.device

data class DeviceFeatureShareRes(
    val permitInfo: PermitInfo?,
    val permitKey: String,
    var open: Boolean
)

data class PermitInfo(
    val permitImage: PermitImage?,
    val permitInfoDisplays: Map<String, LanguageInfo>?
)

data class PermitImage(
    val `as`: String,
    val caption: String,
    val height: Int,
    val imageUrl: String?,
    val smallImageUrl: String,
    val width: Int
)


data class LanguageInfo(
    val permitExplain: String?,
    val permitTitle: String?
)

data class UserFeatureReq(
    val did: String,
    val sharedUid: String?
)

data class ShareFeatureReq(
    val did: String,
    val shareUid: String,
    val permissions:String? = null
)