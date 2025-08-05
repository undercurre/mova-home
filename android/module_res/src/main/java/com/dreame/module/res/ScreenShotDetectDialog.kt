package com.dreame.module.res

import android.app.Dialog
import android.content.Context
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.Window
import android.view.WindowManager.LayoutParams
import android.widget.ImageView
import android.widget.RelativeLayout
import android.widget.TextView
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.FragmentActivity
import com.dreame.module.res.ext.setOnShakeProofClickListener

class ScreenShotDetectDialog(
    context: Context,
    private val contactUsCallback: (() -> Unit)? = null,
    private val suggestionCallback: (() -> Unit)? = null,
) : Dialog(context) {


    override fun onCreate(savedInstanceState: Bundle?) {
        window?.requestFeature(Window.FEATURE_NO_TITLE)
        super.onCreate(savedInstanceState)
        setContentView(R.layout.common_dialog_screen_shot_detect)
        val tvFeedback = findViewById<TextView>(R.id.tv_feedback)
        val tvContactUs = findViewById<TextView>(R.id.tv_contact_us)
        val ivCancel = findViewById<ImageView>(R.id.iv_cancel)
        val rlContainer = findViewById<RelativeLayout>(R.id.rl_container)

        rlContainer.setOnShakeProofClickListener {
            dismiss()
        }
        tvFeedback?.setOnShakeProofClickListener {
            suggestionCallback?.invoke()
            dismiss()
        }
        tvContactUs?.setOnShakeProofClickListener {
            contactUsCallback?.invoke()
            dismiss()
        }

        ivCancel?.setOnShakeProofClickListener {
            dismiss()
        }
    }

    override fun onStart() {
        super.onStart()
        this.window?.apply {
            clearFlags(LayoutParams.FLAG_DIM_BEHIND)
            addFlags(LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
            setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
            setDimAmount(0f)
            setLayout(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT)
            setType(LayoutParams.TYPE_APPLICATION_PANEL)
        }
        this.setCancelable(true)
        this.setCanceledOnTouchOutside(true)
    }
}