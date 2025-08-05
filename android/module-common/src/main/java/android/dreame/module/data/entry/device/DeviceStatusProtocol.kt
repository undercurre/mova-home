package android.dreame.module.data.entry.device

data class DeviceStatusProtocol(
    val keyDefine: Map<String, String>,
    val ver: Int,
    val model: String,
    val hash: String,
    var language: String
)