package android.dreame.module.data.entry.message

data class AckShareFromMessageReq(
    val accept: Boolean
)

data class AckShareFromDeviceReq(
    val accept: Boolean,
    val deviceId: String,
    val model: String,
    val ownUid: String
)