package android.dreame.module.data.entry.message

data class DeviceMessageRes(
    val content: List<DeviceMessage>
)


data class DeviceInfoReq(val did: String, var lang: String)


data class DeviceMessage(
    val deviceId: String,
    val localizationContents: Map<String, String>,
    val localizationSolutions: Map<String, String>,
    val messageId: String,
    val model: String,
    val read: Boolean,
    val readTime: String,
    val sendTime: String,
    val share: Int,
    val solutionUrl: String,
    val type: Int,
    val uid: String,
    val source: DeviceSource,
)

data class DeviceSource(
    val piid: String?,
    val eiid: String?,
    val value: String?,
    val ssid: String?,
    val aiid: String?,
)

// 消息类型
const val TYPE_NORMAL = 0
const val TYPE_ERROR = 1

data class DeviceMessageContentBean(
    val deviceId: String,
    val messageId: String,
    val source: DeviceSource?,
    val model: String,
    val read: Boolean,
    val readTime: String,
    val sendTime: String,
    val share: Int,
    val solutionUrl: String,
    val type: Int,
    val uid: String,
    val localContents: String,
    val localSolution: String,
    val localContentShow: String,
    val date: String,
    val time: String,
    @Transient
    var isSelect: Boolean,
    @Transient
    var isShowDate: Boolean,

    )
