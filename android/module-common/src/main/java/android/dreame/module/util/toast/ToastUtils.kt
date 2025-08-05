package android.dreame.module.util.toast

import android.app.Application
import android.dreame.module.LocalApplication
import android.dreame.module.R
import android.dreame.module.util.ScreenUtils
import android.graphics.drawable.Drawable
import android.view.Gravity
import com.hjq.toast.ToastParams
import com.hjq.toast.Toaster

object ToastUtils {
    @JvmStatic
    fun init(app: Application) {
        Toaster.init(app)
    }

    @JvmStatic
    fun show(text: CharSequence?) {
        val toastParams = ToastParams()
        toastParams.text = text ?: ""
        toastParams.style = DmToastStyle(
            R.layout.layout_toast_custom_view, Gravity.BOTTOM, 0,
            ScreenUtils.dp2px(LocalApplication.getInstance().applicationContext, 155f), null
        )
        Toaster.show(toastParams)
    }

    @JvmStatic
    fun show(text: CharSequence?, drawable: Drawable? = null) {
        val toastParams = ToastParams()
        toastParams.text = text ?: ""
        toastParams.style = DmToastStyle(
            R.layout.layout_toast_custom_view, Gravity.BOTTOM, 0,
            ScreenUtils.dp2px(LocalApplication.getInstance().applicationContext, 155f), drawable
        )
        Toaster.show(toastParams)
    }
}