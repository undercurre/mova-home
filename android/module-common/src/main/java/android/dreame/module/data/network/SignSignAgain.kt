package android.dreame.module.data.network

import java.security.MessageDigest


fun signSignAgain(sign: String): String {
    val sign2 = sign + String(sign.toCharArray().reversed().toCharArray())
    val messageDigest: MessageDigest = MessageDigest.getInstance("SHA-384")
    val hash: ByteArray = messageDigest.digest(sign2.toByteArray())
    return bytesToHex(hash)
}

/**
 * 自定义字节到十六进制转换器来获取十六进制的哈希值
 */
private fun bytesToHex(hash: ByteArray): String {
    val hexString = StringBuilder()
    for (b in hash) {
        val hex = Integer.toHexString(0xff and b.toInt())
        if (hex.length == 1) {
            hexString.append('0')
        }
        hexString.append(hex)
    }
    return hexString.toString()
}

private val listOf = listOf(
    "/dreame-user/v2/forgotpass/sms/code",
    "/dreame-user/v2/secure-info/sms/code",
    "/dreame-user/v2/secure-info/sms/code-new",
    "/dreame-user/v2/register/sms",
    "/dreame-auth/v2/oauth/social/register/sms",
    "/dreame-auth/v2/oauth/sms",
    "/dreame-auth/v2/oauth/social/sms",
    "/dreame-auth/v2/oauth/social/register/sms",
    "/dreame-auth/v3/oauth/social/autoregisterbind/sms",
)

fun isSign(api: String): Boolean {
    return listOf.contains(api)
}
