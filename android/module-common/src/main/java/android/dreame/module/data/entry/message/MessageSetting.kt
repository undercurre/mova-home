package android.dreame.module.data.entry.message

data class SystemMessageSetting(val systemMsgSwitch: Boolean, val serviceMsgSwitch: Boolean)

data class SystemMessageSettingReq(val msgType: String, val msgSwitch: Boolean)

data class MessageSetting(
    val devShare: Boolean,
    val homeShare: Boolean,
    val noDisturb: Boolean,
    val noDisturbFrom: Int,
    val noDisturbTo: Int,
    val devNotify: Boolean,
    val devices: List<MessageSettingDevices>,
)

data class MessageSettingDevices(
    val deviceId: String,
    val deviceName: String,
    val share: Int, // 分享,0为拥有，1为分享
    val notify: Boolean,
    val icon: String,
)

