package android.dreame.module.data.entry

data class RouteSchemeDeviceExt(
    val did: String,
    val extra: Extra,
    val model: String
)

data class Extra(
    val source: Source,
    val type: String
)

data class Source(
    val aiid: Int,
    val eiid: Int,
    val siid: Int
)