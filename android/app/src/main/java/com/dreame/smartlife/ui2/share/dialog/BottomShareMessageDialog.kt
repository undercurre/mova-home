package com.dreame.smartlife.ui2.share.dialog

import android.app.Activity
import android.app.Dialog
import android.content.Context
import android.dreame.module.event.EventCode
import android.dreame.module.event.EventMessage
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.loader.ImageLoaderProxy
import android.dreame.module.util.toast.ToastUtils
import android.dreame.module.view.dialog.CustomProgressDialog
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.util.DisplayMetrics
import android.view.View
import android.view.Window
import android.view.WindowManager.LayoutParams
import android.widget.ImageView
import android.widget.TextView
import androidx.core.content.ContextCompat
import com.dreame.smartlife.R
import com.zj.mvi.core.observeEvent
import com.zj.mvi.core.observeState
import org.greenrobot.eventbus.EventBus


class BottomShareMessageDialog(
    val mContext: Context,
    val formMessage: Boolean,
    val title: String?,
    val deviceName: String?,
    val deviceDes: String?,
    val devicePic: String?,
    val messageId: String?,
    val ackResult: Int?,
    val did: String?,
    val model: String?,
    val ownUid: String?,
) : Dialog(mContext) {

    private var loading: CustomProgressDialog? = null

    private lateinit var ivCancel: ImageView
    private lateinit var ivDeviceIcon: ImageView
    private lateinit var tvDeviceName: TextView
    private lateinit var tvMessageContent: TextView
    private lateinit var tvReject: TextView
    private lateinit var tvAccept: TextView

    private val viewModel = ShareMessageDialogViewModelV2()

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

    override fun onCreate(savedInstanceState: Bundle?) {
        window?.requestFeature(Window.FEATURE_NO_TITLE)
        super.onCreate(savedInstanceState)
        val display = (mContext as Activity).windowManager.defaultDisplay
        val metrics = DisplayMetrics()
        display.getRealMetrics(metrics)
        val screenH = metrics.heightPixels
        val screenW = metrics.widthPixels
        if (screenW > screenH) {
            setContentView(R.layout.dialog_bottom_share_message_detail_land)
        } else {
            setContentView(R.layout.dialog_bottom_share_message_detail)
        }
        ivCancel = findViewById(R.id.iv_cancel)
        ivDeviceIcon = findViewById(R.id.iv_device_icon)
        tvDeviceName = findViewById(R.id.tv_device_name)
        tvMessageContent = findViewById(R.id.tv_message_content)
        tvReject = findViewById(R.id.tv_reject)
        tvAccept = findViewById(R.id.tv_accept)

        tvMessageContent.text = title
        tvDeviceName.text = deviceName
        ImageLoaderProxy.getInstance().displayImage(
            mContext,
            devicePic,
            R.drawable.icon_robot_placeholder,
            ivDeviceIcon
        )
        ivCancel.setOnShakeProofClickListener {
            dismiss()
        }
        if (formMessage == true) {
            when (ackResult) {
                0 -> { //待接收
                    tvReject.visibility = View.VISIBLE
                    tvAccept.visibility = View.VISIBLE

                    tvReject.isEnabled = true
                    tvReject.setBackgroundResource(R.drawable.common_shape_btn_second_r8)
                    tvReject.setTextColor(
                        ContextCompat.getColor(
                            mContext,
                            R.color.common_text_main
                        )
                    )
                    tvReject.text = mContext.getString(R.string.reject)
                    tvReject.setOnShakeProofClickListener {
                        viewModel.dispatchAction(
                            ShareMessageDialogUiAction.AckShareFromMessageAction
                                (messageId = messageId ?: "", false)
                        )
                    }

                    tvAccept.isEnabled = true
                    tvAccept.setBackgroundResource(R.drawable.common_shape_btn_enable_r24)
                    tvAccept.setTextColor(
                        ContextCompat.getColor(
                            mContext,
                            R.color.common_btnText
                        )
                    )
                    tvAccept.text = mContext.getString(R.string.accept)
                    tvAccept.setOnShakeProofClickListener {
                        viewModel.dispatchAction(
                            ShareMessageDialogUiAction.AckShareFromMessageAction
                                (messageId = messageId ?: "", true)
                        )
                        ///TODO
                    }
                }

                1 -> {//已接收
                    tvReject.visibility = View.VISIBLE
                    tvAccept.visibility = View.GONE

                    tvReject.isEnabled = false
                    tvReject.setBackgroundResource(R.drawable.common_shape_btn_second_r8)
                    tvReject.setTextColor(
                        ContextCompat.getColor(
                            mContext,
                            R.color.common_green1
                        )
                    )
                    tvReject.text = mContext.getString(R.string.already_accept)
                }

                2 -> {//已拒绝
                    tvReject.visibility = View.VISIBLE
                    tvAccept.visibility = View.GONE

                    tvReject.isEnabled = false
                    tvReject.setBackgroundResource(R.drawable.common_shape_btn_second_r8)
                    tvReject.setTextColor(
                        ContextCompat.getColor(
                            mContext,
                            R.color.common_red1
                        )
                    )
                    tvReject.text = mContext.getString(R.string.already_reject)
                }

                3 -> {//已过期
                    tvReject.visibility = View.VISIBLE
                    tvAccept.visibility = View.GONE

                    tvReject.isEnabled = false
                    tvReject.setBackgroundResource(R.drawable.common_shape_btn_second_r8)
                    tvReject.setTextColor(
                        ContextCompat.getColor(
                            mContext,
                            R.color.common_textDisable
                        )
                    )
                    tvReject.text = mContext.getString(R.string.already_invalid)
                }
            }
            viewModel.dispatchAction(ShareMessageDialogUiAction.ReadMessageByIdAction(messageId = messageId))
        } else {
            tvReject.visibility = View.VISIBLE
            tvAccept.visibility = View.VISIBLE


            tvReject.isEnabled = true
            tvReject.setBackgroundResource(R.drawable.common_shape_btn_second_r8)
            tvReject.setTextColor(ContextCompat.getColor(mContext, R.color.common_text_main))
            tvReject.text = mContext.getString(R.string.reject)

            tvAccept.isEnabled = true
            tvAccept.setBackgroundResource(R.drawable.common_shape_btn_enable_r24)
            tvAccept.setTextColor(ContextCompat.getColor(mContext, R.color.common_btnText))
            tvAccept.text = mContext.getString(R.string.accept)

            tvAccept.setOnShakeProofClickListener {
                viewModel.dispatchAction(
                    ShareMessageDialogUiAction.AckShareFromDeviceAction(
                        true,
                        did ?: "",
                        model ?: "",
                        ownUid ?: ""
                    )
                )
            }
            tvReject.setOnShakeProofClickListener {
                viewModel.dispatchAction(
                    ShareMessageDialogUiAction.AckShareFromDeviceAction(
                        false,
                        did ?: "",
                        model ?: "",
                        ownUid ?: ""
                    )
                )
            }
        }
        observe()
    }

    private fun observe() {
        viewModel.showLoading = {
            if (it) {
                showLoading()
            } else {
                dismissLoading()
            }
        }
        viewModel.uiEvents = {
            if (it is ShareMessageDialogUiEvent.ShowToast) {
                ToastUtils.show(it.message)
            } else if (it is ShareMessageDialogUiEvent.DismissDialog) {
                EventBus.getDefault().post(EventMessage<Any?>(EventCode.ACCEPT_OR_REJECT_DEVICE))
                dismiss()
            }
        }
    }

    protected fun showLoading() {
        loading?.apply {
            dismiss()
        }
        loading = null
        loading = CustomProgressDialog(mContext)
        loading?.show()
    }

    protected fun dismissLoading() {
        loading?.dismiss()
        loading = null
    }
}