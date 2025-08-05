package android.dreame.module.rn.bridge.system

import com.dreame.base.open_setting.dreame_flutter_plugin_open_setting.FlutterOpenSettingAction
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod

class SettingModule(val context: ReactApplicationContext) : ReactContextBaseJavaModule(context) {

    override fun getName(): String {
        return "Setting"
    }

    @ReactMethod
    fun pushToSystemSetting(action: String) {
        FlutterOpenSettingAction.pushToSetting(action)
    }

}