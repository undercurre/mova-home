package com.dreame.feature.connect.device.mower.prepare

import android.content.Intent
import android.dreame.module.LocalApplication
import android.dreame.module.RoutPath
import android.dreame.module.constant.Constants
import android.dreame.module.manager.LanguageManager
import android.dreame.module.util.ClickableSpanWrapper
import android.text.SpannableString
import android.text.Spanned
import android.text.TextPaint
import android.text.method.LinkMovementMethod
import android.text.style.ClickableSpan
import android.view.View
import android.widget.TextView
import androidx.annotation.LayoutRes
import androidx.core.content.ContextCompat
import com.therouter.TheRouter
import com.chad.library.adapter.base.BaseQuickAdapter
import com.chad.library.adapter.base.viewholder.BaseViewHolder
import com.dreame.smartlife.connect.R

class PrepareConnectAdapter(
    @LayoutRes private val layoutResId: Int = R.layout.item_prepare_connect,
    data: MutableList<String> = mutableListOf()
) : BaseQuickAdapter<String, BaseViewHolder>(layoutResId, data) {

    private val COMMON_WEB_URL: String = "https://cn.iot.dreame.tech:8080/"

    // 割草机配网准备页
    private val MOWER_PREPARE_URL: String = "mowerGuide/mowerGuide.html?lang="

    override fun convert(holder: BaseViewHolder, item: String) {
        if (item == context.getString(R.string.text_mower_pair_desc_1)) {
            var indexString = context.getString(R.string.text_mower_pair_desc_attr)
            if (!indexString.contains(">")) {
                indexString += " >"
            }
            val promptSpan = SpannableString("$item $indexString")
            val indexOf = promptSpan.indexOf(indexString)
            val indexCLS = ClickableSpanWrapper(object : ClickableSpan() {
                override fun onClick(view: View) {
                    val url =
                        COMMON_WEB_URL + MOWER_PREPARE_URL + LanguageManager.getInstance()
                            .getLangTag(context) + "&tenantId=${LocalApplication.getInstance().getTenantId()}"
                    TheRouter.build(RoutPath.MAIN_WEBVIEW)
                        .withString(Constants.KEY_WEB_URL, url)
                        .withString(Constants.KEY_WEB_TITLE, context.getString(R.string.rest_device_wifi))
                        .navigation()
                }

                override fun updateDrawState(ds: TextPaint) {
                    ds.color = ContextCompat.getColor(context, R.color.common_warn1)
                    ds.isFakeBoldText = true
                }
            })
            promptSpan.setSpan(indexCLS, indexOf, indexOf + indexString.length, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
            holder.getView<TextView>(R.id.tv_device_name).apply {
                movementMethod = LinkMovementMethod.getInstance()
                text = promptSpan
            }
        } else {
            holder.setText(R.id.tv_device_name, item)
        }


    }
}