package com.dreame.smartlife.utils

import android.content.Context
import android.content.pm.PackageManager
import android.os.Build

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2022/02/28
 *     desc   :
 *     version: 1.0
 * </pre>
 */
object AlexaAppUtil {
    private const val ALEXA_PACKAGE_NAME = "com.amazon.dee.app"
    private const val ALEXA_APP_TARGET_ACTIVITY_NAME = "com.amazon.dee.app.ui.main.MainActivity"

    private const val REQUIRED_MINIMUM_VERSION_CODE = 866607211

    /**
     * Check if the Alexa app is installed and supports App Links.
     *
     * @param context Application context.
     */
    @JvmStatic
    fun isAlexaAppSupportAppLink(context: Context): Boolean {
        try {
            val packageManager: PackageManager = context.packageManager
            val packageInfo = packageManager.getPackageInfo(ALEXA_PACKAGE_NAME, 0)

            return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                packageInfo.longVersionCode > REQUIRED_MINIMUM_VERSION_CODE
            } else {
                packageInfo != null
            }

        } catch (e: PackageManager.NameNotFoundException) {
            // The Alexa App is not installed
            return false
        }
    }
}