package com.dreame.smartlife.device.share

import android.content.Context
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.loader.ImageLoaderProxy
import android.dreame.module.util.ScreenUtils
import android.text.method.ScrollingMovementMethod
import android.view.Gravity
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import androidx.core.content.ContextCompat
import com.dreame.smartlife.device.R
import razerdp.basepopup.BasePopupWindow

class CommonSingleImageDialog(context: Context) : BasePopupWindow(context) {

    private val ivImage: ImageView
    private val tvOk: TextView
    private val tvContent: TextView

    init {
        popupGravity = Gravity.CENTER
        setOutSideDismiss(false)
        setBackPressEnable(false)
        setBackgroundColor(ContextCompat.getColor(context, R.color.common_color_bg_dialog))
        setContentView(R.layout.dialog_common_single_image)
        ivImage = findViewById(R.id.iv_image)
        tvOk = findViewById(R.id.tv_ok)
        tvContent = findViewById(R.id.tv_content)
        tvContent.movementMethod = ScrollingMovementMethod.getInstance()
    }

    fun show(
        imageUrl: String?,
        content: String?,
        iKnow: String,
        okCallback: ((dialog: CommonSingleImageDialog) -> Unit)?
    ) {
        if(imageUrl.isNullOrEmpty()){
            ivImage.visibility = View.GONE
        }else {
            ivImage.visibility = View.VISIBLE
            ImageLoaderProxy.getInstance().displayImageWithCorners(
                context,
                imageUrl,
                ScreenUtils.dp2px(context,6.0f),
                ivImage
            )
        }
        tvContent.text = content ?: ""
        tvOk.text = iKnow
        tvOk.setOnShakeProofClickListener{
            okCallback?.invoke(this)
        }
        showPopupWindow()
    }
}