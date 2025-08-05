package com.dreame.feature.connect.views

import android.content.Context
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.util.ScreenUtils
import android.graphics.Bitmap
import android.view.Gravity
import android.view.View
import android.widget.ImageView
import android.widget.LinearLayout
import androidx.core.content.ContextCompat
import com.dreame.smartlife.connect.R
import razerdp.basepopup.BasePopupWindow

class ScaleQrCodeDialog(context: Context?) : BasePopupWindow(context) {

    init {
        setBackgroundColor(ContextCompat.getColor(context!!, R.color.common_bgWhite))
        setOutSideDismiss(true)
        setBackPressEnable(true)
        popupGravity = Gravity.CENTER
        setContentView(R.layout.popup_scale_qr_code)
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
        findViewById<View>(R.id.fl_root).setOnShakeProofClickListener {
            dismiss()
        }
    }

    fun setImageView(bitmap: Bitmap): ScaleQrCodeDialog {
        contentView.findViewById<ImageView>(R.id.iv_device).setImageBitmap(bitmap)
        return this
    }

}