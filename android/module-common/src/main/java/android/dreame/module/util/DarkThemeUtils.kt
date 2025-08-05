package android.dreame.module.util

import android.app.Activity
import android.app.UiModeManager
import android.content.Context
import android.content.res.Configuration
import android.dreame.module.LocalApplication
import android.dreame.module.RouteServiceProvider
import android.os.Build
import androidx.appcompat.app.AppCompatDelegate
import com.dreame.module.res.ThemeUtils
import com.dreame.module.service.app.flutter.IFlutterBridgeService

/**
 *    MODE_NIGHT_NO： 使用亮色(light)主题，不使用夜间模式
 *    MODE_NIGHT_YES：使用暗色(dark)主题，使用夜间模式
 *    MODE_NIGHT_AUTO：根据当前时间自动切换 亮色(light)/暗色(dark)主题
 *    MODE_NIGHT_FOLLOW_SYSTEM(默认选项)：设置为跟随系统，通常为 MODE_NIGHT_NO
 *
 */
object DarkThemeUtils {

    /**
     * 获取当前主题模式
     * @param activity 当前 Activity
     * @return true 为深色模式，false 为亮色模式
     */
    @JvmStatic
    fun isDarkTheme(activity: Context): Boolean = ThemeUtils.isDarkTheme(activity)

    @JvmStatic
    fun getThemeSetting(context: Context): Int = ThemeUtils.getThemeSetting(context)

    @JvmStatic
    fun getThemeSettingString(context: Context = LocalApplication.getInstance()): String =
        ThemeUtils.getThemeSettingString(context)

    fun getThemeModeFromSp(context: Context): String = ThemeUtils.getThemeModeFromSp(context)

    @JvmStatic
    fun getThemeSettingAppCompat(context: Context): Int {
        val themeModel = ThemeUtils.getThemeModeFromSp(context)
        if (themeModel == "light") {
            return AppCompatDelegate.MODE_NIGHT_NO
        } else if (themeModel == "dark") {
            return AppCompatDelegate.MODE_NIGHT_YES
        } else if (themeModel == "system") {
            return AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM
        } else {
            // 不管
            return AppCompatDelegate.MODE_NIGHT_NO
        }
    }

    @JvmStatic
    fun createConfigurationContext(context: Context): Context =
        ThemeUtils.createConfigurationContext(context)

    fun changeThemeMode(context: Activity) {
        val themeModel = getThemeModeFromSp(context)
        if (themeModel == "system") {
            // 当前页面重建
            // 通知Flutter
            val themeMode = getThemeSettingString(context)
            RouteServiceProvider.getService<IFlutterBridgeService>()
                ?.sendMessage("changeAppTheme", ext = mutableMapOf("themeMode" to themeMode))
        }
    }

    /**
     * 设置深色模式
     */
    fun setDarkMode() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val uiModeManager = LocalApplication.getInstance()
                .getSystemService(Context.UI_MODE_SERVICE) as UiModeManager
            uiModeManager.setApplicationNightMode(UiModeManager.MODE_NIGHT_YES)
        } else {
            AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_YES)
        }
    }

    /**
     * 设置浅色模式
     */
    fun setLightMode() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val uiModeManager = LocalApplication.getInstance()
                .getSystemService(Context.UI_MODE_SERVICE) as UiModeManager
            uiModeManager.setApplicationNightMode(UiModeManager.MODE_NIGHT_NO)
        } else {
            AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO)
        }
    }


    /**
     * 跟随系统
     */
    fun setModeBySystem() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val uiModeManager = LocalApplication.getInstance()
                .getSystemService(Context.UI_MODE_SERVICE) as UiModeManager
            uiModeManager.setApplicationNightMode(UiModeManager.MODE_NIGHT_AUTO)
        } else {
            AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM)
        }
    }

    /**
     * 设置 Activity 的主题模式
     * @param activity 要设置的 Activity
     * @param isDarkMode true 为深色模式，false 为亮色模式
     */
    fun setThemeMode(activity: Activity, isDarkMode: Boolean) {
        val currentNightMode = if (isDarkMode) {
            Configuration.UI_MODE_NIGHT_YES
        } else {
            Configuration.UI_MODE_NIGHT_NO
        }

        val config = activity.resources.configuration
        config.uiMode =
            (config.uiMode and Configuration.UI_MODE_NIGHT_MASK.inv()) or currentNightMode

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            activity.window.decorView.post {
                activity.createConfigurationContext(config)
                activity.recreate()
            }
        } else {
            activity.recreate()
        }
    }

    @JvmStatic
    fun setApplicationDarkThemeStyle(mode: Int) {
        kotlin.runCatching {
            when (mode) {
                0 -> setModeBySystem() // 跟随系统
                Configuration.UI_MODE_NIGHT_NO -> setLightMode()  // 关闭暗黑模式
                Configuration.UI_MODE_NIGHT_YES -> setDarkMode() // 开启暗黑模式
                else -> setModeBySystem() // 跟随系统
            }
        }
    }

}