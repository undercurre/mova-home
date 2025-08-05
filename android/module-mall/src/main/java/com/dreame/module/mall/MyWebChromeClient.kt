package com.dreame.module.mall

import android.dreame.module.util.LogUtil
import android.webkit.ConsoleMessage
import android.webkit.WebChromeClient

open class MyWebChromeClient : WebChromeClient() {
    override fun onConsoleMessage(consoleMessage: ConsoleMessage): Boolean {
        if (consoleMessage.messageLevel() >= ConsoleMessage.MessageLevel.WARNING) {
            LogUtil.e(
                "onConsoleMessage",
                "messageLevel: ${consoleMessage.messageLevel()} ,message ${consoleMessage.message()} ,sourceId ${consoleMessage.sourceId()}"
            )
        } else {
            LogUtil.d(
                "onConsoleMessage",
                "messageLevel: ${consoleMessage.messageLevel()} ,message ${consoleMessage.message()} ,sourceId ${consoleMessage.sourceId()}"
            )
        }
        return true
    }

}