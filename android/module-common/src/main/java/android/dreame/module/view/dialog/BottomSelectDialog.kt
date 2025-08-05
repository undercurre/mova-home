package android.dreame.module.view.dialog

import android.content.Context
import android.dreame.module.R
import android.view.Gravity
import android.view.animation.Animation
import android.widget.TextView
import androidx.core.content.ContextCompat
import android.dreame.module.ext.setOnShakeProofClickListener
import razerdp.basepopup.BasePopupWindow
import razerdp.util.animation.AnimationHelper
import razerdp.util.animation.TranslationConfig

class BottomSelectDialog(context: Context) : BasePopupWindow(context) {

    private val tvFromCamera: TextView
    private val tvFromAlbum: TextView
    private val tvCancel: TextView

    init {
        popupGravity = Gravity.BOTTOM
        setOutSideDismiss(false)
        setBackPressEnable(true)
        setBackgroundColor(ContextCompat.getColor(context, R.color.common_color_bg_dialog))
        setContentView(R.layout.common_dialog_bottom_select)
        tvFromCamera = findViewById(R.id.tv_from_camera)
        tvFromAlbum = findViewById(R.id.tv_from_album)
        tvCancel = findViewById(R.id.tv_cancel)
    }

    override fun onCreateShowAnimation(): Animation {
        return AnimationHelper.asAnimation()
            .withTranslation(TranslationConfig.FROM_BOTTOM.apply { duration(300) })
            .toShow()
    }

    override fun onCreateDismissAnimation(): Animation {
        return AnimationHelper.asAnimation()
            .withTranslation(TranslationConfig.TO_BOTTOM.apply { duration(300) })
            .toDismiss()
    }

    fun show(
        formCameraCallback: (dialog: BottomSelectDialog) -> Unit,
        fromAlbumCallback: (dialog: BottomSelectDialog) -> Unit
    ) {
        tvFromCamera.setOnShakeProofClickListener {
            formCameraCallback.invoke(this)
        }
        tvFromAlbum.setOnShakeProofClickListener {
            fromAlbumCallback.invoke(this)
        }
        tvCancel.setOnShakeProofClickListener {
            dismiss()
        }
        showPopupWindow()
    }

}