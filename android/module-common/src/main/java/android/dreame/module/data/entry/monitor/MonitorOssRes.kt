package android.dreame.module.data.entry.monitor

data class CloudDevBindReq(val did: String, val uids: List<String>, val type: String = "aliiot")

data class CloudDevBindData(val bindCode: Int?, val iotId: String?, val success: Boolean)

data class CheckAliFyDeviceData(val bind: Boolean, val iotId: String?)

