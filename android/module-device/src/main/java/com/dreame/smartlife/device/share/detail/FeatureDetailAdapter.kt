package com.dreame.smartlife.device.share.detail

import android.dreame.module.data.entry.device.DeviceFeatureShareRes
import android.dreame.module.ext.getStringExt
import android.dreame.module.manager.AreaManager
import android.dreame.module.manager.LanguageManager
import android.dreame.module.util.ScreenUtils
import android.text.SpannableStringBuilder
import android.text.Spanned
import android.text.method.LinkMovementMethod
import android.text.style.ClickableSpan
import android.text.style.DynamicDrawableSpan
import android.text.style.ImageSpan
import android.view.View
import android.widget.TextView
import androidx.core.content.ContextCompat
import com.chad.library.adapter.base.BaseQuickAdapter
import com.chad.library.adapter.base.viewholder.BaseViewHolder
import com.dreame.smartlife.device.R

class FeatureDetailAdapter(val onImageClick: ((imageUrl: String?, content: String?) -> Unit)? = null) :
    BaseQuickAdapter<DeviceFeatureShareRes, BaseViewHolder>(R.layout.item_device_feature_status){
    override fun convert(holder: BaseViewHolder, item: DeviceFeatureShareRes) {
        val languageTag = LanguageManager.getInstance().getLangTag(holder.itemView.context)
        var featureName = item.permitInfo?.permitInfoDisplays?.get(languageTag)?.permitTitle
        var permitExplain = item.permitInfo?.permitInfoDisplays?.get(languageTag)?.permitExplain
        if (featureName.isNullOrEmpty()) {
            if ("cn".equals(AreaManager.getCountryCode(), true)) {
                featureName = item.permitInfo?.permitInfoDisplays?.get("zh")?.permitTitle
                permitExplain = item.permitInfo?.permitInfoDisplays?.get("zh")?.permitExplain
            } else {
                featureName = item.permitInfo?.permitInfoDisplays?.get("en")?.permitTitle
                permitExplain = item.permitInfo?.permitInfoDisplays?.get("en")?.permitExplain
            }
        }
        val tvFeatureStatus = holder.getView<TextView>(R.id.tv_status)
        if(item.open){
            tvFeatureStatus.isEnabled = true
            tvFeatureStatus.text = getStringExt(R.string.text_permission_enable)
        }else {
            tvFeatureStatus.isEnabled = false
            tvFeatureStatus.text = getStringExt(R.string.text_permission_disable)
        }

        val text = "${featureName ?: "" }   "
        val builder = SpannableStringBuilder(text)
        val drawable = ContextCompat.getDrawable(
            holder.itemView.context,
            R.drawable.icon_device_feature_description
        )!!
        drawable.setBounds(0, 0, ScreenUtils.dp2px(context,12f), ScreenUtils.dp2px(context,12f))
        val imageSpan = ImageSpan(drawable, DynamicDrawableSpan.ALIGN_BASELINE)
        builder.setSpan(imageSpan, text.length - 2, text.length - 1, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
        val clickSpan = object : ClickableSpan() {
            override fun onClick(widget: View) {
                onImageClick?.invoke(item.permitInfo?.permitImage?.imageUrl, permitExplain)
            }
        }
        builder.setSpan(clickSpan, text.length - 2, text.length - 1, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
        builder.append("\u200b")
        val tvFeatureName = holder.getView<TextView>(R.id.tv_feature_name)
        tvFeatureName.text = builder
        tvFeatureName.movementMethod = LinkMovementMethod.getInstance()
    }
}