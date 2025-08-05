package com.dreame.smartlife

import android.app.Activity
import android.content.Intent
import android.dreame.module.trace.EventCommonHelper
import android.net.Uri
import com.dreame.smartlife.help.R

object AfterSaleIntentHandleUtils {

    fun handleIntent(activity: Activity, actionData: String?): Boolean {
        if (actionData.isNullOrEmpty()) {
            return false
        }
        return if (actionData.startsWith("tel:")) {
            callPhone(activity, actionData)
        }else {
            openWithScheme(activity, actionData)
        }
    }

    private fun callPhone(activity: Activity, actionData: String): Boolean {
        EventCommonHelper.eventCommonPageInsert(7, 27, this.hashCode())
        val intent = Intent(Intent.ACTION_DIAL).apply {
            data = Uri.parse(actionData)
        }
        return if (intent.resolveActivity(activity.packageManager) != null) {
            activity.startActivity(intent)
            true
        } else {
            false
        }
    }

    private fun openWithScheme(activity: Activity, actionData: String): Boolean {
        val data: Uri = Uri.parse(actionData)
        val intent = Intent(Intent.ACTION_VIEW, data)
        return if (intent.resolveActivity(activity.packageManager) != null) {
            activity.startActivity(intent)
            true
        } else {
            false
        }
    }
}