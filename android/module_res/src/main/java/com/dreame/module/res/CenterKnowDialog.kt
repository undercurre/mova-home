package com.dreame.module.res

import android.content.Context
import android.text.TextUtils
import android.view.Gravity
import android.view.View
import android.view.animation.Animation
import android.widget.TextView
import androidx.core.content.ContextCompat
import com.dreame.module.res.ext.setOnShakeProofClickListener
import razerdp.basepopup.BasePopupWindow
import razerdp.util.animation.AlphaConfig
import razerdp.util.animation.AnimationHelper

class CenterKnowDialog(context: Context) : BasePopWindowWrapper(context) {

    private val tvPositive: TextView
    private val tvContent: TextView
    private val ll_root: View

    init {
        this.popupGravity = Gravity.CENTER
        setOutSideDismiss(false)
        setBackPressEnable(false)
        setBackgroundColor(ContextCompat.getColor(context, R.color.common_color_bg_dialog))
        setContentView(R.layout.common_dialog_center_know)
        tvPositive = findViewById(R.id.tv_positive)
        tvContent = findViewById(R.id.tv_content)
        ll_root = findViewById(R.id.ll_root)
    }
    override fun updateUiModeChanged(isDark: Boolean) {
        // 更新UI
        val ctx = ThemeUtils.createConfigurationContext(context)

        ll_root.setBackground(
            ContextCompat.getDrawable(
                ctx,
                R.drawable.common_shape_white_r20
            )
        )


        tvContent.setTextColor(ContextCompat.getColor(ctx, R.color.common_textNormal))
        tvPositive.setTextColor(ContextCompat.getColor(ctx, R.color.common_selector_btn))
    }
    override fun onCreateShowAnimation(): Animation {
        return AnimationHelper.asAnimation()
            .withAlpha(AlphaConfig.IN.apply { duration(300) })
            .toShow()
    }

    override fun onCreateDismissAnimation(): Animation {
        return AnimationHelper.asAnimation()
            .withAlpha(AlphaConfig.OUT.apply { duration(300) })
            .toDismiss()
    }

    /**
     * 显示提示对话框
     * @param content 提示内容
     * @param positive 确认按钮文案
     * @param positiveCallback 确认按钮点击回调
     */
    fun show(
        content: String,
        positive: String,
        positiveCallback: (dialog: CenterKnowDialog) -> Unit,
    ) {
        tvContent.text = content
        tvPositive.text = positive
        tvPositive.setOnShakeProofClickListener {
            positiveCallback.invoke(this)
        }

        showPopupWindow()
    }

}