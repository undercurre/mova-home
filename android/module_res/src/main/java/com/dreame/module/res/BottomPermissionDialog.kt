package com.dreame.module.res

import android.content.Context
import android.text.TextUtils
import android.view.Gravity
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import androidx.core.content.ContextCompat
import com.dreame.module.res.ext.setOnShakeProofClickListener
import razerdp.basepopup.BasePopupWindow

/**
 * 权限请求前的确认框
 */
class BottomPermissionDialog(context: Context) : BasePopWindowWrapper(context) {

    private val tvNegative: TextView
    private val tvPositive: TextView
    private val tvContent: TextView
    private val ivIcon: ImageView
    private val tvTitle: TextView
    private val ll_root: View

    init {
        popupGravity = Gravity.CENTER
        setOutSideDismiss(false)
        setBackPressEnable(false)
        setBackgroundColor(ContextCompat.getColor(context, R.color.common_color_bg_dialog))
        setContentView(R.layout.common_dialog_bottom_next)
        tvNegative = findViewById(R.id.tv_negative)
        tvPositive = findViewById(R.id.tv_positive)
        tvContent = findViewById(R.id.tv_content)
        ivIcon = findViewById(R.id.iv_icon)
        tvTitle = findViewById(R.id.tv_title)
        ll_root = findViewById(R.id.ll_root)
    }

//    override fun onCreateShowAnimation(): Animation {
//        return AnimationHelper.asAnimation()
//            .withTranslation(TranslationConfig.FROM_BOTTOM.apply { duration(300) })
//            .toShow()
//    }
//
//    override fun onCreateDismissAnimation(): Animation {
//        return AnimationHelper.asAnimation()
//            .withTranslation(TranslationConfig.TO_BOTTOM.apply { duration(300) })
//            .toDismiss()
//    }


    override fun updateUiModeChanged(isDark: Boolean) {
        // 更新UI
        val ctx = ThemeUtils.createConfigurationContext(context)

        ll_root.setBackground(
            ContextCompat.getDrawable(
                ctx,
                R.drawable.common_shape_white_r20
            )
        )
        tvTitle.setTextColor(ContextCompat.getColor(ctx, R.color.common_textMain))
        tvContent.setTextColor(ContextCompat.getColor(ctx, R.color.common_textNormal))
        tvPositive.setTextColor(ContextCompat.getColor(ctx, R.color.common_selector_btn))
    }

    /**
     * 显示提示对话框
     * @param content 提示内容
     * @param positive 确认按钮文案
     * @param negative 拒绝按钮文案,为空时，隐藏此按钮
     * @param positiveCallback 确认按钮点击回调
     * @param negativeCallback 拒绝按钮点击回调
     */
    fun show(
        content: String,
        positive: String,
        negative: String? = "",
        positiveCallback: (dialog: BottomPermissionDialog) -> Unit,
        negativeCallback: ((dialog: BottomPermissionDialog) -> Unit)? = null
    ) {
        tvContent.text = content
        tvNegative.text = negative
        tvPositive.text = positive
        tvNegative.visibility = if (TextUtils.isEmpty(negative)) View.GONE else View.VISIBLE
        tvNegative.setOnShakeProofClickListener {
            negativeCallback?.invoke(this)
        }
        tvPositive.setOnShakeProofClickListener {
            positiveCallback.invoke(this)
        }

        showPopupWindow()
    }

}