package android.dreame.module.data.entry.message

data class MessageHomeRecord(
    val serviceMsg: MsgData,
    val systemMsg: MsgData,
    val shareMsg: ShareMsg,
    val deviceMsgs: List<DeviceMsg>
)

data class MsgData(
    val unread: Int?,
    val msgRecord: MsgRecord?
)

data class MsgRecord(
    val id: String,
    val multiLangDisplay: String,
    val msgCategory: String,
    val jumpType: String,
    val readStatus: Int,
    val readTime: String,
    val createTime: String,
    val updateTime: String,
    val ext: String
)

data class ShareMsg(
    val shareMessage: ShareMessage,
    val unread: Int
)

data class ShareMessage(
    val ackResult: Int,
    val deviceId: String,
    val img: String,
    val localizationContents: Map<String, String>,
    val localizationDeviceNames: Map<String, String>,
    val messageId: String,
    val model: String,
    val needAck: Boolean,
    val ownUid: String,
    val read: Boolean,
    val readTime: String,
    val region: String?,
    val sendTime: String,
    val shareUid: String,
    val uid: String,
    val deviceName: String?,
    val ownUsername: String?,
    val shareUsername: String?
)

data class DeviceMsg(
    val deviceId: String?,
    val deviceName: String?,
    val icon: String?,
    val model: String?,
    val message: DeviceMessageContent?,
    val unread: Int
)

data class DeviceMessageContent(
    val deviceId: Int,
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
    val uid: String
)







