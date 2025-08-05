package android.dreame.module.data.store

import android.content.SharedPreferences
import android.dreame.module.util.GsonUtils
import com.tencent.mmkv.MMKV
import kotlin.reflect.KProperty

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/08/02
 *     desc   :
 *     version: 1.0
 * </pre>
 */
open class JsonSpDelegate<T>(
    private val mmkv: MMKV,
    private val androidSp: SharedPreferences,
    private val key: String,
    private val clazz: Class<T>
) {
    operator fun getValue(thisRef: Any?, property: KProperty<*>): T? {
        var value =  androidSp.getString(key, "")
        if (value.isNullOrEmpty()) {
            value = mmkv.decodeString(key, "")
        }
        return GsonUtils.fromJson(value, clazz)
    }

    operator fun setValue(thisRef: Any?, property: KProperty<*>, value: T?) {
        val json = GsonUtils.toJson(value);
        androidSp.edit().putString(key, json).commit()
        mmkv.encode(key, json)
    }
}