package com.dreame.smartlife.config.step

import android.app.Activity
import android.os.Handler
import android.os.Message
import java.lang.ref.WeakReference

class WeakHandler(callback: MessageHandleCallback) : Handler() {
    private val weakReference: WeakReference<MessageHandleCallback> = WeakReference(callback)

    interface MessageHandleCallback {
        fun handleMessage(message: Message)
    }

    override fun handleMessage(msg: Message) {
        val callback = weakReference.get()
        if (callback != null && callback is Activity && !(callback as Activity).isFinishing) {
            callback.handleMessage(msg)
        }
    }

}