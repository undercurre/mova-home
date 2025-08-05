package com.dreame.module.res

import android.content.Context
import android.view.View
import com.dreame.module.res.event.EventUiMode
import org.greenrobot.eventbus.EventBus
import org.greenrobot.eventbus.Subscribe
import razerdp.basepopup.BasePopupWindow

open class BasePopWindowWrapper(context: Context) : BasePopupWindow(context) {


    override fun dismiss(animateDismiss: Boolean) {
        super.dismiss(animateDismiss)
    }

    override fun onBeforeShow(): Boolean {
        EventBus.getDefault().register(this)
        return super.onBeforeShow()
    }

    override fun onBeforeDismiss(): Boolean {
        EventBus.getDefault().unregister(this)
        return super.onBeforeDismiss()

    }

    open fun updateUiModeChanged(isDark: Boolean) {

    }

    @Subscribe
    public fun uiModeChanged(event: EventUiMode) {
        updateUiModeChanged(event.isDark)
    }


}