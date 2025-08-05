package com.dreame.feature.connect.views

import android.content.Context
import android.dreame.module.data.getString
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.util.ScreenUtils
import android.view.Gravity
import android.view.View
import android.widget.TextView
import androidx.annotation.RawRes
import androidx.core.content.ContextCompat
import com.airbnb.lottie.LottieAnimationView
import com.dreame.smartlife.connect.R
import razerdp.basepopup.BasePopupWindow

class ManualConnectTipsDialog(context: Context) : BasePopupWindow(context) {

    init {
        setBackgroundColor(ContextCompat.getColor(context, R.color.common_color_bg_dialog))
        setOutSideDismiss(false)
        setBackPressEnable(false)
        popupGravity = Gravity.CENTER
        setContentView(R.layout.popup_manual_connect_tips)
        val iv_device = findViewById<LottieAnimationView>(R.id.iv_device)
        val iv_play = findViewById<View>(R.id.iv_play)
        val btn_confirm = findViewById<View>(R.id.btn_confirm)

        val contentView = contentView
        contentView.apply {
            val fl_root = findViewById<View>(R.id.fl_root)
            fl_root.measure(View.MeasureSpec.UNSPECIFIED, View.MeasureSpec.UNSPECIFIED)
            var height = fl_root.measuredHeight
            val dp2px = ScreenUtils.dp2px(getContext(), 500f)
            if (height > dp2px) {
                height = dp2px
                val layoutParams = fl_root.layoutParams
                layoutParams.height = height
                fl_root.layoutParams = layoutParams
            }
        }
        findViewById<TextView>(R.id.tv_content).text = context.getString(R.string.text_connect_robot_hotspot, "mova-vacuum-xxx")

        btn_confirm.setOnShakeProofClickListener {
            dismiss()
        }
        iv_play.setOnShakeProofClickListener {
            if (!iv_device.isAnimating) {
                iv_device.playAnimation()
            }
        }
    }

    fun setApName(apName: String): ManualConnectTipsDialog {
        findViewById<TextView>(R.id.tv_content).text = context.getString(R.string.text_connect_robot_hotspot, apName)
        return this
    }

    fun setAnimation(@RawRes rawRes: Int): ManualConnectTipsDialog {
        findViewById<LottieAnimationView>(R.id.iv_device).setAnimation(rawRes)
        return this
    }


}