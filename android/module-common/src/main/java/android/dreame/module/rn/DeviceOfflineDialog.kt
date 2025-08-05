package android.dreame.module.rn

import android.content.Context
import android.content.Intent
import android.dreame.module.R
import android.dreame.module.bean.DeviceListBean
import android.dreame.module.constant.Constants
import android.dreame.module.constant.ParameterConstants
import android.dreame.module.ext.dp
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.loader.ImageLoaderProxy
import android.dreame.module.util.ActivityUtil
import android.text.SpannableString
import android.text.Spanned
import android.text.TextPaint
import android.text.method.LinkMovementMethod
import android.text.style.ClickableSpan
import android.text.style.UnderlineSpan
import android.view.Gravity
import android.view.View
import android.view.animation.Animation
import android.widget.ImageView
import android.widget.TextView
import androidx.core.content.ContextCompat
import razerdp.basepopup.BasePopupWindow
import razerdp.util.animation.AnimationHelper
import razerdp.util.animation.TranslationConfig

/**
 * 设备离线弹窗
 */
class DeviceOfflineDialog(context: Context) : BasePopupWindow(context) {

    private var currentDevice: DeviceListBean.Device? = null
    private val ivDevice: ImageView

    init {
        popupGravity = Gravity.BOTTOM
        setOutSideDismiss(false)
        setBackgroundColor(ContextCompat.getColor(context, R.color.common_color_bg_dialog))
        setContentView(R.layout.dialog_device_offline)
        findViewById<ImageView>(R.id.iv_back).setOnClickListener { dismiss() }
        val tvDetail = findViewById<TextView>(R.id.tv_see_detail)
        tvDetail.setOnShakeProofClickListener {
            // 离线详情
        }
        findViewById<TextView>(R.id.tv_back_home).setOnShakeProofClickListener {
            dismiss()
            ActivityUtil.getInstance().currentActivity?.finish()
        }
        ivDevice = findViewById(R.id.iv_device)
        val tvTips = findViewById<TextView>(R.id.tv_tips)
        val agreeTipStr = context.getString(R.string.text_device_offline_tips);
        val userAgreementStr = context.getString(R.string.text_reconnect);
        val promptSpan = SpannableString(agreeTipStr);
        val userAgreementCLS = ClickSpan()
        val start = agreeTipStr.indexOf(userAgreementStr);
        if (start != -1) {
            promptSpan.setSpan(
                userAgreementCLS,
                start,
                start + userAgreementStr.length,
                Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
            )
        }
        tvTips.apply {
            movementMethod = LinkMovementMethod.getInstance()
            highlightColor = ContextCompat.getColor(context, R.color.colorTransparent)
            text = promptSpan
        }
        tvDetail.visibility = View.INVISIBLE
        val detailStr = context.getString(R.string.text_see_details)
        tvDetail.text = SpannableString(detailStr).apply {
            setSpan(UnderlineSpan(), 0, detailStr.length, Spanned.SPAN_INCLUSIVE_EXCLUSIVE)
        }
    }

    override fun onCreateShowAnimation(): Animation {
        return AnimationHelper.asAnimation()
            .withTranslation(TranslationConfig.FROM_BOTTOM)
            .toShow()
    }

    override fun onCreateDismissAnimation(): Animation {
        return AnimationHelper.asAnimation()
            .withTranslation(TranslationConfig.TO_BOTTOM)
            .toDismiss()
    }

    /**
     * 展示弹窗
     * @param device 当前设备
     */
    fun show(device: DeviceListBean.Device?) {
        this.currentDevice = device
        val imageUrl = currentDevice?.deviceInfo?.mainImage?.imageUrl
        ImageLoaderProxy.getInstance().displayImageWithCorners(
            context,
            imageUrl,
            R.drawable.icon_robot_placeholder,
            10.dp(),
            ivDevice
        )
        showPopupWindow()
    }

    private inner class ClickSpan : ClickableSpan() {
        override fun onClick(widget: View) {
            currentDevice?.let {
                context.startActivity(
                    Intent(Constants.ACTION_ACTIVITY_DISTRIBUTION_NETWORK)
                        // .putExtra(ParameterConstants.EXTRA_DOMAIN, currentDevice.getBindDomain())
                        .putExtra(
                            ParameterConstants.EXTRA_PRODUCT_ID,
                            it.deviceInfo.productId
                        )
                        .putExtra(ParameterConstants.EXTRA_PRODUCT_MODEL, it.model)
                        .putExtra(
                            ParameterConstants.EXTRA_PRODUCT_PIC_URL,
                            it.deviceInfo.mainImage.imageUrl
                        )

                )
                ActivityUtil.getInstance().currentActivity?.finish()
            }
        }

        override fun updateDrawState(ds: TextPaint) {
            ds.color = ContextCompat.getColor(context, R.color.common_link)
            ds.isUnderlineText = true
        }
    }

}