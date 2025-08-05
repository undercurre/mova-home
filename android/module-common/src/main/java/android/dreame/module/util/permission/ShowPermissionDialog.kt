package android.dreame.module.util.permission

import android.content.Context
import android.dreame.module.R
import android.dreame.module.callback.Callback
import androidx.annotation.StringRes
import com.dreame.module.res.BottomPermissionDialog
import com.hjq.permissions.XXPermissions

object ShowPermissionDialog {
    @JvmStatic
    fun showPermissionDialog(
        context: Context, @StringRes contentId: Int, negativeCallback: Callback? = null, positiveCallback: Callback
    ) {
        context.showPermissionDialog(context.getString(contentId), negativeCallback, positiveCallback)
    }

    @JvmStatic
    fun showPermissionDialog(context: Context, content: String, negativeCallback: Callback? = null, positiveCallback: Callback) {
        context.showPermissionDialog(content, negativeCallback, positiveCallback)
    }

}

fun Context.showPermissionDialog(@StringRes contentId: Int, negativeCallback: Callback? = null, positiveCallback: Callback) {
    showPermissionDialog(getString(contentId), negativeCallback, positiveCallback)
}

fun Context.showPermissionDialog(content: String, negativeCallback: Callback? = null, positiveCallback: Callback) {
    val confirmDialog = BottomPermissionDialog(this)
    confirmDialog.show(
        content,
        getString(R.string.next),
        getString(R.string.cancel),
        { dialog ->
            dialog.dismiss()
            positiveCallback.accept()
        }
    ) { dialog ->
        dialog.dismiss()
        negativeCallback?.accept()
    }
}
