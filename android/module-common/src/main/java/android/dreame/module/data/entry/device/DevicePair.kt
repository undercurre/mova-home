package android.dreame.module.data.entry.device


data class DevicePairReq(val did: String)

data class DeviceQRNetPairReq(val pairQRKey: String)

data class DeviceQRNetPairRes(val success: Boolean, val did: String)


data class DeviceBlePairReq(
    val did: String,
    val mac: String,
    val ver: String,
    val secret: String,
    val model: String,
    val property: Map<String, Any>,
    val bindDomain: String
)

data class DeviceBlePairNonceReq(
    val did: String,
    val model: String,
    val nonce: String,
    val bindDomain: String,
    val mac: String,
    val ver: String,
    val encryptUid: String,
    val property: Map<String, Any>,
)

