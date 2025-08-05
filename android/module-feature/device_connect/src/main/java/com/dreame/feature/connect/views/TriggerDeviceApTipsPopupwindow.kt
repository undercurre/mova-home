package com.dreame.feature.connect.views

import android.content.Context
import android.dreame.module.RoutPath
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.loader.ImageLoaderProxy
import android.dreame.module.util.ScreenUtils
import android.view.Gravity
import android.view.View
import android.widget.ImageView
import android.widget.LinearLayout
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.content.ContextCompat
import androidx.fragment.app.FragmentActivity
import com.therouter.TheRouter
import com.blankj.utilcode.util.LogUtils
import com.blankj.utilcode.util.NetworkUtils
import com.dreame.smartlife.connect.R
import razerdp.basepopup.BasePopupWindow

/**
 * 网络频段错误
 */
class TriggerDeviceApTipsPopupwindow(val context: FragmentActivity) : BasePopupWindow(context) {

    private var confirmListener: (() -> Unit)? = null
    private var cancelListener: (() -> Unit)? = null

    init {
        setBackgroundColor(ContextCompat.getColor(context, R.color.common_color_bg_dialog))
        setOutSideDismiss(false)
        setBackPressEnable(false)
        popupGravity = Gravity.CENTER
        setContentView(R.layout.popup_trigger_devcie_ap_tips)
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
        findViewById<View>(R.id.btn_cancel).setOnShakeProofClickListener {
            // 继续配网，跳转机器配网
            dismiss()
            cancelListener?.invoke()
        }
        findViewById<View>(R.id.btn_confirm).setOnShakeProofClickListener {
            dismiss()
            confirmListener?.invoke()
        }
    }

    fun url(url: String): TriggerDeviceApTipsPopupwindow {
        val iv_device = findViewById<ImageView>(R.id.iv_device)
        ImageLoaderProxy.getInstance().displayImage(context, url, R.drawable.ic_placeholder_device_ap, iv_device)
        return this
    }

    fun onConfirmClick(listener: () -> Unit): TriggerDeviceApTipsPopupwindow {
        this.confirmListener = listener
        return this
    }

    fun onCancelClick(listener: () -> Unit): TriggerDeviceApTipsPopupwindow {
        this.cancelListener = listener
        return this
    }


}


