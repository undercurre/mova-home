package android.dreame.module.feature.connect.bluetooth

import java.nio.ByteBuffer
import java.nio.ByteOrder

private val DIGITS_LOWER = charArrayOf(
    '0', '1', '2', '3', '4', '5',
    '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'
)
private val DIGITS_UPPER = charArrayOf(
    '0', '1', '2', '3', '4', '5',
    '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'
)

/**
 * byte转 int
 */
fun ByteArray.byteArrayToInt(bigEndian: Boolean = false): Int =
    ByteBuffer.wrap(this).order(if (bigEndian) ByteOrder.BIG_ENDIAN else ByteOrder.LITTLE_ENDIAN).int

fun ByteArray.encodeHex(toLowerCase: Boolean = false): CharArray {
    return encodeHex(this, if (toLowerCase) DIGITS_LOWER else DIGITS_UPPER)
}

fun encodeHex(data: ByteArray, toDigits: CharArray): CharArray {
    val l = data.size
    val out = CharArray(l shl 1)
    var i = 0
    var j = 0
    while (i < l) {
        out[j++] = toDigits[0xF0 and data[i].toInt() ushr 4]
        out[j++] = toDigits[0x0F and data[i].toInt()]
        i++
    }
    return out
}

fun ByteArray.encodeHexStr(toLowerCase: Boolean = false): String {
    return encodeHexStr(this, if (toLowerCase) DIGITS_LOWER else DIGITS_UPPER)
}

fun encodeHexStr(data: ByteArray, toDigits: CharArray): String {
    return String(encodeHex(data, toDigits))
}

fun ByteArray.formatHexString(addSpace: Boolean = true): String {
    if (this.isEmpty()) return ""
    val sb = StringBuilder()
    for (i in this.indices) {
        var hex = (this[i].toInt() and 0xFF).toString(16).toUpperCase()
        if (hex.length == 1) {
            hex = "0$hex"
        }
        sb.append(hex)
        if (addSpace) sb.append(" ")
    }
    return sb.toString().trim()
}

fun CharArray.decodeHex(): ByteArray {
    val len = size
    if (len and 0x01 != 0) {
        throw RuntimeException("Odd number of characters.")
    }
    val out = ByteArray(len shr 1)

    // two characters form the hex value.
    var i = 0
    var j = 0
    while (j < len) {
        var f = this[j].toDigit(j) shl 4
        j++
        f = f or this[j].toDigit(j)
        j++
        out[i] = (f and 0xFF).toByte()
        i++
    }
    return out
}

fun Char.toDigit(index: Int): Int {
    val digit = Character.digit(this, 16)
    if (digit == -1) {
        throw RuntimeException(
            "Illegal hexadecimal character " + this
                    + " at index " + index
        )
    }
    return digit
}

fun String.hexStringToBytes(): ByteArray {
    var hexString = this
    if (hexString == "") {
        return ByteArray(0)
    }
    hexString = hexString.trim { it <= ' ' }
    hexString = hexString.uppercase()
    val length = hexString.length / 2
    val hexChars = hexString.toCharArray()
    val d = ByteArray(length)
    for (i in 0 until length) {
        val pos = i * 2
        d[i] = (hexChars[pos].charToByte() shl 4 or hexChars[pos + 1].charToByte()).toByte()
    }
    return d
}

fun Char.charToByte(): Int {
    return "0123456789ABCDEF".indexOf(this, 0, true)
}

fun ByteArray.extractData(position: Int): String {
    return byteArrayOf(this[position]).formatHexString()
}
