package android.dreame.module.data.store

import android.content.SharedPreferences
import androidx.core.content.edit
import kotlin.reflect.KProperty

@Suppress("UNCHECKED_CAST", "IMPLICIT_CAST_TO_ANY")
open class SpDelegate<T>(
    private val sp: SharedPreferences,
    private val key: String,
    private val default: T
) {
    operator fun getValue(thisRef: Any?, property: KProperty<*>): T {
        return when (default) {
            is Int -> sp.getInt(key, default)
            is Float -> sp.getFloat(key, default)
            is Long -> sp.getLong(key, default)
            is Boolean -> sp.getBoolean(key, default)
            is String -> sp.getString(key, default)
            else -> throw RuntimeException("SpDelegate parse type failed")
        } as T
    }

    operator fun setValue(thisRef: Any?, property: KProperty<*>, value: T) {
        sp.edit {
            when (default) {
                is Int -> putInt(key, value as Int)
                is Float -> putFloat(key, value as Float)
                is Long -> putLong(key, value as Long)
                is Boolean -> putBoolean(key, value as Boolean)
                is String -> putString(key, value as String)
                else -> throw RuntimeException("SpDelegate parse type failed")
            }
        }
    }
}