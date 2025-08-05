package com.dreame.module.res

import android.content.Context
import android.view.Gravity
import android.view.View
import android.view.ViewTreeObserver
import android.view.animation.Animation
import android.widget.ScrollView
import android.widget.TextView
import androidx.core.content.ContextCompat
import com.dreame.module.res.ext.setOnShakeProofClickListener
import razerdp.util.animation.AlphaConfig
import razerdp.util.animation.AnimationHelper


class AlertDialog(context: Context) : BasePopWindowWrapper(context) {

    private val tvTitle: TextView
    private val tvPositive: TextView
    private val tvNegative: TextView
    private val tvContent: TextView
    private val scrollView: ScrollView
    private val ll_root: View

    init {
        this.popupGravity = Gravity.CENTER
        setOutSideDismiss(false)
        setBackPressEnable(false)
        setBackgroundColor(ContextCompat.getColor(context, R.color.common_color_bg_dialog))
        setContentView(R.layout.common_alert_dialog)
        ll_root = findViewById(R.id.ll_root)
        tvTitle = findViewById(R.id.tv_title)
        tvPositive = findViewById(R.id.tv_positive)
        tvContent = findViewById(R.id.tv_content)
        tvNegative = findViewById(R.id.tv_negative)
        scrollView = findViewById(R.id.scrollView)
        val maxHeight = (220 * context.resources.displayMetrics.density + 0.5f).toInt()
        scrollView.viewTreeObserver.addOnGlobalLayoutListener(object :
            ViewTreeObserver.OnGlobalLayoutListener {
            override fun onGlobalLayout() {
                if (scrollView.height > maxHeight) {
                    scrollView.layoutParams.height = maxHeight
                    scrollView.requestLayout()
                }
                scrollView.viewTreeObserver.removeOnGlobalLayoutListener(this)
            }
        })
        updateUiModeChanged(true)
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


        tvTitle.setTextColor(ContextCompat.getColor(ctx, R.color.common_textMain))
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

    fun show(
        title: String,
        content: String,
        positive: String,
        negative: String? = null,
        negativeCallback: ((dialog: AlertDialog) -> Unit)? = null,
        positiveCallback: (dialog: AlertDialog) -> Unit,
    ) {
        tvTitle.text = title
        tvContent.text = content
        tvPositive.text = positive
        tvPositive.setOnShakeProofClickListener {
            positiveCallback.invoke(this)
        }
        if (negative.isNullOrEmpty()) {
            tvNegative.visibility = View.GONE
        } else {
            tvNegative.text = negative
            tvNegative.visibility = View.VISIBLE
            tvNegative.setOnShakeProofClickListener {
                this.dismiss()
                negativeCallback?.invoke(this)
            }
        }
        showPopupWindow()
    }
}