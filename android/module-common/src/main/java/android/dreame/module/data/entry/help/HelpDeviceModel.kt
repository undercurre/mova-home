package android.dreame.module.data.entry.help


data class HelpDeviceModel(
    val page: HelpDevicePage?,
)

data class HelpDevicePage(
    val records: List<HelpDevice>?,
)

data class HelpDevice(
    val customName: String?,
    val deviceInfo: HelpDeviceInfo?,
    val master: Boolean?,
    val model: String?,
    val did: String?,
    val imageUrl:String?,
    var selected: Boolean = false,
    var ver: String? = null,
)


data class HelpDeviceInfo(
    val displayName: String?,
    val model: String?,
    val categoryPath: String?,
)
