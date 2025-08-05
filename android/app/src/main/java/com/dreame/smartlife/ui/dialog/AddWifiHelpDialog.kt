package com.dreame.smartlife.ui.dialog

import android.content.Context
import razerdp.basepopup.BasePopupWindow
import android.dreame.module.manager.LanguageManager
import android.view.Gravity
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import androidx.core.content.ContextCompat
import com.dreame.smartlife.R

class AddWifiHelpDialog(context: Context) : BasePopupWindow(context) {

    init {
        popupGravity = Gravity.TOP
        setBackgroundColor(ContextCompat.getColor(context, R.color.common_color_bg_dialog))
        setContentView(R.layout.dialog_add_wifi_help)
        val ivBack = findViewById<View>(R.id.btn_confirm)
        viewShowAdaptive()
        ivBack.setOnClickListener { dismiss() }
    }

    private fun viewShowAdaptive() {
        val textView = findViewById<TextView>(R.id.tv_device_name)
        val lang = LanguageManager.getInstance().getLangTag(context)
        if ("de" == lang) {
            textView.textSize = 20f
        }
    }

}