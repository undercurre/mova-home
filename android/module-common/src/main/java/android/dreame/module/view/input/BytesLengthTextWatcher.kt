package android.dreame.module.view.input

import android.text.Editable
import android.text.InputFilter
import android.text.TextWatcher
import android.widget.EditText
import java.io.UnsupportedEncodingException
import java.nio.charset.StandardCharsets

/**
 * @Author: sunzhibin
 * @E-mail: sunzhibin@dreame.tech
 * @Desc: 作用描述
 * @Date: 2021/4/30 15:42
 * @Version: 1.0
 */

public inline fun EditText.addBytesLengthTextChangedListener(
    byteLength: Int,
    crossinline beforeTextChanged: (
        text: CharSequence?,
        start: Int,
        count: Int,
        after: Int
    ) -> Unit = { _, _, _, _ -> },
    crossinline onTextChanged: (
        text: CharSequence?,
        start: Int,
        before: Int,
        count: Int
    ) -> Unit = { _, _, _, _ -> },
    crossinline afterTextChanged: (text: Editable?) -> Unit = {}
): TextWatcher {
    val textWatcher = object : TextWatcher {
        override fun afterTextChanged(s: Editable?) {
            afterTextChanged.invoke(s)
        }

        override fun beforeTextChanged(text: CharSequence?, start: Int, count: Int, after: Int) {
            beforeTextChanged.invoke(text, start, count, after)
        }

        override fun onTextChanged(text: CharSequence?, start: Int, before: Int, count: Int) {
            onTextChanged.invoke(text, start, before, count)
        }
    }
    this.filters = arrayOf(InputFilter { source, start, end, dest, dstart, dend ->
        try {
            // 在输入之前检查新的文本长度
            val inputText = dest.toString() + source.toString()
            val bytes = inputText.toByteArray(charset("UTF-8"))
            if (bytes.size > byteLength) {
                // 如果超过了最大字节数，返回空字符串表示不接受新的输入
                return@InputFilter ""
            }
        } catch (e: UnsupportedEncodingException) {
            e.printStackTrace()
        }
        // 否则返回null表示接受新的输入
        return@InputFilter null
    })
    addTextChangedListener(textWatcher)
    return textWatcher
}
