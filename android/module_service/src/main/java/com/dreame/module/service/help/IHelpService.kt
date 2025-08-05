package com.dreame.module.service.help

import android.app.Activity


interface IHelpService  {
    fun openZendeskChat()

    /**
     * 打开客服页面
     */
    fun openCustomerServiceChat(activity: Activity, countryCode: String)
}