package android.dreame.module.data.network

import android.dreame.module.util.MD5Util

object MallSignUtils {

    /**
     * 计算签名
     */
    fun mallCalculateSign(request: MutableMap<String, String>): String {
        val sortArr = mutableListOf<String>()
        val secretKey = "b_m3I6PiPgYX#"
        request["security_key"] = secretKey
        request.keys.sorted().forEach { key ->
            sortArr.add(key + "=" + request[key])
        }
        val joinToString = sortArr.joinToString("&")
        val sign = MD5Util.getMD5Str(joinToString)
        return sign;
    }
}
