package android.dreame.module.ext

import android.text.Editable
import android.text.TextUtils
import androidx.core.text.BidiFormatter
import com.google.gson.Gson
import com.google.gson.JsonSyntaxException
import java.lang.StringBuilder
import java.text.NumberFormat
import java.util.Locale

fun Editable?.toRTL(): String {
    if (this == null) return ""
    val text = this.toString()
    if (BidiFormatter.getInstance().isRtl(text)) {
        val textNew = BidiFormatter.getInstance().unicodeWrap(text)
        return textNew
    } else {
        return text
    }
}


fun String?.toRTL(): String {
    if (this == null) return ""
    val text = this.toString()
    if (BidiFormatter.getInstance().isRtl(text)) {
        val textNew = BidiFormatter.getInstance().unicodeWrap(text)
        return textNew
    } else {
        return text
    }
}

/**
 * 非标准数字，转成标准数字
 * @param replaceEach 是否全部符合才替换
 */
fun String.replaceNonstandardDigits(replaceAllMatch: Boolean = true): String {
    val stringBuilder = StringBuilder()
    fun replace() {
        this.toCharArray().forEach {
            if (it.isNonstandardDigits()) {
                val numericValue = Character.getNumericValue(it)
                stringBuilder.append(numericValue)
            } else {
                stringBuilder.append(it)
            }
        }
    }
    if (replaceAllMatch) {
        if (TextUtils.isDigitsOnly(this)) {
            replace()
        } else {
            return this
        }
    } else {
        replace()
    }
    return stringBuilder.toString()
}

fun Char.isNonstandardDigits(): Boolean {
    return Character.isDigit(this) && !(this >= '0' && this <= '9')
}

fun Int.replaceNonstandardDigits(): Int {
    val instance = NumberFormat.getInstance(Locale.ENGLISH)
    return instance.format(this).toInt()
}

fun String.isValidJson(): Boolean {
    return try {
        Gson().fromJson(this, Any::class.java)
        true
    } catch (e: JsonSyntaxException) {
        false
    }
}
