package android.dreame.module.util

import android.text.SpannableStringBuilder
import android.text.Spanned
import android.text.TextPaint
import android.text.style.ClickableSpan
import android.text.style.ForegroundColorSpan
import android.view.View
import android.widget.TextView
import androidx.core.content.ContextCompat

class RichTextUtils(
    private val textView: TextView,
    private val color: Int,
    private val onLinkClick: ((String) -> Unit)? = null,
) {

    fun processRichText(richText: String) {
        val spannableStringBuilder = SpannableStringBuilder(richText)

        processATags(spannableStringBuilder)
        processTagTags(spannableStringBuilder)

        // 将处理后的文本设置到 TextView
        textView.text = spannableStringBuilder
        textView.highlightColor =
            ContextCompat.getColor(textView.context, android.R.color.transparent)
        textView.movementMethod = android.text.method.LinkMovementMethod.getInstance()
    }

    private fun processATags(builder: SpannableStringBuilder) {
        val pattern = Regex("""<a href="([^"]+)">([^<]+)</a>""")
        val matcher = pattern.findAll(builder)

        for (matchResult in matcher) {
            val (linkUrl, linkText) = matchResult.destructured

            val clickableSpan = object : ClickableSpan() {
                override fun onClick(widget: View) {
                    onLinkClick?.invoke(linkUrl)
                }

                override fun updateDrawState(ds: TextPaint) {
                    super.updateDrawState(ds)
                    ds.isUnderlineText = false
                }
            }

            // 移除<a>标签
            builder.replace(matchResult.range.first, matchResult.range.last + 1, linkText)

            builder.setSpan(
                clickableSpan,
                matchResult.range.first,
                matchResult.range.first + linkText.length,
                Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
            )

            builder.setSpan(
                ForegroundColorSpan(color),
                matchResult.range.first,
                matchResult.range.first + linkText.length,
                Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
            )
        }
    }

    private fun processTagTags(builder: SpannableStringBuilder) {
        val pattern = Regex("""<tag>([^<]+)</tag>""")
        val matcher = pattern.findAll(builder)

        for (matchResult in matcher) {
            val tagText = matchResult.groupValues[1]

            // 移除<tag>标签
            builder.replace(matchResult.range.first, matchResult.range.last + 1, tagText)

            builder.setSpan(
                ForegroundColorSpan(color),
                matchResult.range.first,
                matchResult.range.first + tagText.length,
                Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
            )
        }
    }
}