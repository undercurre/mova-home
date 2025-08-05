package com.dreame.module.res


import android.app.UiModeManager
import android.content.Context
import android.content.res.Configuration
import android.os.Build

/**
 *    MODE_NIGHT_NO： 使用亮色(light)主题，不使用夜间模式
 *    MODE_NIGHT_YES：使用暗色(dark)主题，使用夜间模式
 *    MODE_NIGHT_AUTO：根据当前时间自动切换 亮色(light)/暗色(dark)主题
 *    MODE_NIGHT_FOLLOW_SYSTEM(默认选项)：设置为跟随系统，通常为 MODE_NIGHT_NO
 *
 */
object ThemeUtils {

    /**
     * 获取当前主题模式
     * @param activity 当前 Activity
     * @return true 为深色模式，false 为亮色模式
     */
    @JvmStatic
    fun isDarkTheme(activity: Context): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val uiModeManager =
                activity.applicationContext.getSystemService(Context.UI_MODE_SERVICE) as UiModeManager
            return uiModeManager.nightMode == UiModeManager.MODE_NIGHT_YES
        } else {
            return activity.applicationContext.resources.configuration.uiMode and Configuration.UI_MODE_NIGHT_MASK == Configuration.UI_MODE_NIGHT_YES
        }
    }

    @JvmStatic
    fun getThemeSetting(context: Context): Int {
        val themeModel = getThemeModeFromSp(context)
        if (themeModel == "light") {
            return Configuration.UI_MODE_NIGHT_NO
        } else if (themeModel == "dark") {
            return Configuration.UI_MODE_NIGHT_YES
        } else if (themeModel == "system") {
            return context.applicationContext.resources.configuration.uiMode
        } else {
            // 不管
            return 0
        }
    }

    @JvmStatic
    fun getThemeSettingString(context: Context): String {
        val themeModel = getThemeModeFromSp(context)
        if (themeModel == "light") {
            return "light"
        } else if (themeModel == "dark") {
            return "dark"
        } else {
            val isDarkTheme = isDarkTheme(context)
            if (isDarkTheme) {
                return "dark"
            } else {
                return "light"
            }
        }
    }

    fun getThemeModeFromSp(context: Context): String {
        val sp = context.getSharedPreferences("app_theme_config", Context.MODE_PRIVATE)
        val themeModel = sp.getString("flutter.app_theme_mode", "light") ?: "light"
        return themeModel
    }

    fun createConfigurationContext(context: Context): Context {
        var ctx: Context = context
        val uiMode: Int = getThemeSetting(ctx)
        val res = ctx.resources
        val configuration = res.configuration
        if (uiMode > 0) {
            configuration.uiMode = uiMode
        }
        ctx = ctx.createConfigurationContext(configuration)
        return ctx
    }
}