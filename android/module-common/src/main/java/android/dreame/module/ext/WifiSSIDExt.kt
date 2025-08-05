package android.dreame.module.ext

/**
 * SSID
 */
fun String.createQuotedSSID(): String {
    val ssid = this
    return "\"" + ssid + "\""
}
/**
 * SSID
 */
fun String.decodeQuotedSSID(): String {
    val ssid = this
    if (ssid.startsWith("\"") && ssid.endsWith("\"")) {
        return ssid.replaceFirst("\"", "").let {
            it.substring(0, it.length - 1)
        }
    }
    return ssid
}