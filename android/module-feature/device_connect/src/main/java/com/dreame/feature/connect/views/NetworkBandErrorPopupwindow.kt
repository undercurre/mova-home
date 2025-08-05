package com.dreame.feature.connect.views

import android.dreame.module.LocalApplication
import android.dreame.module.RoutPath
import android.dreame.module.constant.Constants
import android.dreame.module.data.getString
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.manager.LanguageManager
import android.dreame.module.task.RetrofitInitTask
import android.dreame.module.util.DarkThemeUtils
import android.dreame.module.util.ScreenUtils
import android.graphics.Paint
import android.view.Gravity
import android.view.View
import android.widget.TextView
import androidx.core.content.ContextCompat
import androidx.fragment.app.FragmentActivity
import com.dreame.smartlife.connect.R
import com.therouter.TheRouter
import razerdp.basepopup.BasePopupWindow

/**
 * 网络频段错误
 */
class NetworkBandErrorPopupwindow(val context: FragmentActivity) : BasePopupWindow(context) {

    private var cancelListener: (() -> Unit)? = null
    private var confirmListener: (() -> Unit)? = null
    private var sessionID: String = ""

    init {
        setBackgroundColor(ContextCompat.getColor(context, R.color.common_color_bg_dialog))
        setOutSideDismiss(false)
        setBackPressEnable(true)
        popupGravity = Gravity.CENTER
        setContentView(R.layout.popup_network_brand_error)
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
        findViewById<TextView>(R.id.tv_link).paint.apply {
            flags = flags or Paint.UNDERLINE_TEXT_FLAG
        }

        findViewById<View>(R.id.btn_cancel).setOnShakeProofClickListener {
            // 继续配网
            dismiss()
            cancelListener?.invoke()
        }
        findViewById<View>(R.id.btn_confirm).setOnShakeProofClickListener {
            // 切换Wi-Fi
            dismiss()
            confirmListener?.invoke()
        }
        findViewById<View>(R.id.tv_link).setOnShakeProofClickListener {
            // 查看连接指引
            val lang = LanguageManager.getInstance().getLangTag(context)
            val baseUrl = RetrofitInitTask.getAppPrivacyBaseUrl()
            val tenantId = LocalApplication.getInstance().tenantId
            val themeMode = DarkThemeUtils.getThemeSettingString(context)
            val url = "$baseUrl/connectNetwork/connectGuide.html?lang=$lang&tenantId=$tenantId&&themeMode=$themeMode"
            TheRouter.build(RoutPath.WEBVIEW_CONNECT_GUIDE)
                .withString(Constants.KEY_WEB_TITLE, getString(R.string.text_connect_guide))
                .withString(Constants.KEY_WEB_URL, url)
                .withString("sessionID", sessionID)
                .withInt(Constants.KEY_WEB_BG_COLOR, R.color.common_layoutBg)
                .navigation()

        }

    }

    fun setCurrentWifi(currentWifiName: String): NetworkBandErrorPopupwindow {
        findViewById<TextView>(R.id.tv_content).text = context.getString(R.string.text_current_band_error, currentWifiName)
        return this
    }

    fun onCancelClick(listener: () -> Unit): NetworkBandErrorPopupwindow {
        this.cancelListener = listener
        return this
    }

    fun onConfirmClick(listener: () -> Unit): NetworkBandErrorPopupwindow {
        this.confirmListener = listener
        return this
    }

    fun sessionID(sessionID: String): NetworkBandErrorPopupwindow {
        this.sessionID = sessionID
        return this
    }


}


