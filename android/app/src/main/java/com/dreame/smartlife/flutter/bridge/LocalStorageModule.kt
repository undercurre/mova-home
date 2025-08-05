package com.dreame.smartlife.flutter.bridge

import android.content.Context
import android.content.SharedPreferences
import android.dreame.module.util.SPUtil
import android.text.TextUtils
import android.util.Base64
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream
import java.io.ObjectInputStream
import java.io.ObjectOutputStream

/**
 * 相关文档：https://wiki.dreame.tech/pages/viewpage.action?pageId=131991397
 */
class LocalStoragePlugin(val context: Context) : MethodChannel.MethodCallHandler {

    private val keyPrefix = "flutter."
    private val cachedSpMap: HashMap<String, SharedPreferences> = HashMap()

    private fun getSharedPreferences(fileName: String): SharedPreferences {
        var spFileName = fileName
        if (TextUtils.isEmpty(spFileName)) {
            spFileName = "FlutterSharedPreferences"
        }
        var sp: SharedPreferences?
        sp = cachedSpMap[spFileName]
        if (sp == null) {
            sp = context.getSharedPreferences(spFileName, Context.MODE_PRIVATE)
            cachedSpMap[spFileName] = sp
        }
        return sp!!
    }

    private fun encode(list: List<String>?): String? {
        return try {
            val byteStream = ByteArrayOutputStream()
            val stream = ObjectOutputStream(byteStream)
            stream.writeObject(list)
            stream.flush()
            Base64.encodeToString(byteStream.toByteArray(), 0)
        } catch (e: Exception) {
            null
        }
    }

    private fun decode(listString: String?): List<String?>? {
        return try {
            val stream = ObjectInputStream(ByteArrayInputStream(Base64.decode(listString, 0)))
            stream.readObject() as List<String?>
        } catch (e: Exception) {
            null
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "remove" -> {
                val args = call.arguments as Map<*, *>
                val fileName = args["fileName"] as String
                val key = args["key"] as String
                val sp = getSharedPreferences(fileName)
                sp.edit().remove(keyPrefix + key).apply()
                result.success(true)
            }

            "clear" -> {
                val args = call.arguments as Map<*, *>
                val fileName = args["fileName"] as String
                val sp = getSharedPreferences(fileName)
                sp.edit().clear().apply()
                result.success(true)
            }

            "containsKey" -> {
                val args = call.arguments as Map<*, *>
                val fileName = args["fileName"] as String
                val key = args["key"] as String
                val sp = getSharedPreferences(fileName)
                result.success(sp.contains(keyPrefix + key))
            }

            "getKeys" -> {
                val args = call.arguments as Map<*, *>
                val fileName = args["fileName"] as String
                val sp = getSharedPreferences(fileName)
                val keys = sp.all.keys.map {
                    it.replace(keyPrefix, "")
                }
                keys.toList().let {
                    result.success(it)
                }
            }

            "putString" -> {
                val args = call.arguments as Map<*, *>
                val fileName = args["fileName"] as String
                val key = args["key"] as String
                val value = args["value"] as String
                val newKey = keyPrefix + key
                if (fileName == SPUtil.FILE_NAME) {
                    // 特例处理，兼容之前的数据
                    SPUtil.putString(context, fileName, key, value);
                } else {
                    val sp = getSharedPreferences(fileName)
                    sp.edit().putString(newKey, value).apply()
                }
                result.success(true)
            }

            "getString" -> {
                val args = call.arguments as Map<*, *>
                val fileName = args["fileName"] as String
                val key = args["key"] as String
                val newKey = keyPrefix + key
                val value = if (fileName == SPUtil.FILE_NAME) {
                    // 特例处理，兼容之前的数据
                    SPUtil.getString(context, fileName, key, null)
                } else {
                    val sp = getSharedPreferences(fileName)
                    sp.getString(newKey, null)
                }
                result.success(value)
            }

            "putInt" -> {
                val args = call.arguments as Map<*, *>
                val fileName = args["fileName"] as String
                val key = args["key"] as String
                val value = args["value"].toString().toInt()
                val sp = getSharedPreferences(fileName)
                sp.edit().putInt(keyPrefix + key, value).apply()
                result.success(true)
            }

            "getInt" -> {
                val args = call.arguments as Map<*, *>
                val fileName = args["fileName"] as String
                val key = args["key"] as String
                val sp = getSharedPreferences(fileName)
                val value = sp.getInt(keyPrefix + key, 0)
                result.success(value)
            }


            "putLong" -> {
                val args = call.arguments as Map<*, *>
                val fileName = args["fileName"] as String
                val key = args["key"] as String
                val value = args["value"].toString().toLong()
                val sp = getSharedPreferences(fileName)
                sp.edit().putLong(keyPrefix + key, value).apply()
                result.success(true)
            }

            "getLong" -> {
                val args = call.arguments as Map<*, *>
                val fileName = args["fileName"] as String
                val key = args["key"] as String
                val sp = getSharedPreferences(fileName)
                val value = sp.getLong(keyPrefix + key, 0)
                result.success(value)
            }

            "putBool" -> {
                val args = call.arguments as Map<*, *>
                val fileName = args["fileName"] as String
                val key = args["key"] as String
                val value = args["value"] as Boolean
                val sp = getSharedPreferences(fileName)
                sp.edit().putBoolean(keyPrefix + key, value).apply()
                result.success(true)
            }

            "getBool" -> {
                val args = call.arguments as Map<*, *>
                val fileName = args["fileName"] as String
                val key = args["key"] as String
                val sp = getSharedPreferences(fileName)
                val value = sp.getBoolean(keyPrefix + key, false)
                result.success(value)
            }

            "putStringList" -> {
                val args = call.arguments as Map<*, *>
                val fileName = args["fileName"] as String
                val key = args["key"] as String
                val value = args["value"] as List<String>
                val sp = getSharedPreferences(fileName)
                sp.edit().putString(keyPrefix + key, encode(value)).apply()
                result.success(true)
            }

            "getStringList" -> {
                val args = call.arguments as Map<*, *>
                val fileName = args["fileName"] as String
                val key = args["key"] as String
                val sp = getSharedPreferences(fileName)
                val value = sp.getString(keyPrefix + key, "")
                result.success(decode(value))
            }

        }
    }
}


