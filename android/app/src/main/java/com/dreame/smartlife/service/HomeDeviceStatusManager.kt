package com.dreame.smartlife.service

import android.database.sqlite.SQLiteDatabase
import android.dreame.module.LocalApplication
import android.dreame.module.data.entry.device.DeviceStatusProtocol
import android.dreame.module.util.GsonUtils
import android.dreame.module.util.LogUtil
import android.util.Log
import androidx.core.database.getStringOrNull
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

object HomeDeviceStatusManager {

    private const val TAG = "HomeDeviceStatusManager"
    private var time = 0L
    private val sqLiteDatabase by lazy {
        val databasePath = LocalApplication.getInstance().getDatabasePath("dreame_flutter.db").path
        SQLiteDatabase.openDatabase(databasePath, null, SQLiteDatabase.OPEN_READONLY)
    }

    private fun parseDefaultModel(model: String): String? {
        val index = model.indexOf(".")
        if (index != -1) {
            val index2 = model.indexOf(".", index + 1)
            if (index2 != -1) {
                return model.substring(index + 1, index2)
            }
        }
        return null
    }

    /**
     * 方法中有耗时操作
     */
    suspend fun getDeviceStatusByProtocol(
        model: String?,
        languageTag: String,
        statusKey: String,
    ): String? {
        if (model == null) return null
        val defaultModel = parseDefaultModel(model)
        LogUtil.d("sunzhibin", "queryKeyDefineByModel $model $languageTag -----------1-------")
        val deviceProtocolMap = queryKeyDefineByModel(model, defaultModel, languageTag)
        LogUtil.d("sunzhibin", "queryKeyDefineByModel $model $languageTag -----------2-------")
        return deviceProtocolMap?.keyDefine?.get(statusKey)
    }

    /**
     * 查询机器状态
     */
    private suspend fun queryKeyDefineByModel(
        model: String,
        defaultModel: String?,
        lang: String,
        defaultLanguageTag: String = "en"
    ): DeviceStatusProtocol? {
        val columns = arrayOf("id", "key", "language", "version", "model", "define", "tag")
        val selection = "key = ? AND model in (?,?) AND language in (?,?)"
        val selectionArgs = arrayOf("2.1", model, defaultModel, lang, defaultLanguageTag)
        try {
            LogUtil.i(
                "sunzhibin",
                "queryKeyDefineByModel $model $lang $defaultModel $defaultLanguageTag"
            )
            return withContext(Dispatchers.IO) {
                return@withContext sqLiteDatabase.query(
                    "key_define",
                    columns,
                    selection,
                    selectionArgs,
                    "",
                    "",
                    "version DESC"
                ).use { cursor ->
                    if (cursor != null && cursor.moveToFirst()) {
                        var keyDefine = ""
                        var defaultkeyDefine = ""
                        var targetLang = lang
                        do {
                            val define =
                                cursor.getStringOrNull(cursor.getColumnIndexOrThrow("define"))
                            val qmodel = cursor.getString(cursor.getColumnIndexOrThrow("model"))
                            val qmlanguage =
                                cursor.getString(cursor.getColumnIndexOrThrow("language"))
                            if (qmodel == model && qmlanguage == lang) {
                                // 取到对应的语言，替换
                                keyDefine = define ?: ""
                                targetLang = lang
                                break;
                            } else if (qmodel == model && qmlanguage == "en") {
                                // 没有取到对应的语言，预先取英语
                                if (keyDefine.isBlank()) {
                                    keyDefine = define ?: ""
                                    targetLang = "en"
                                }
                            } else if (qmodel == defaultModel && qmlanguage == lang) {
                                // 默认model在第一行，预先取默认model的对应语言
                                defaultkeyDefine = define ?: ""
                                targetLang = lang
                            } else if (qmodel == defaultModel && qmlanguage == "en") {
                                // 默认model在第一行，预先取默认model的英语，当取到对应的语言时，替换
                                if (defaultkeyDefine.isBlank()) {
                                    defaultkeyDefine = define ?: ""
                                    targetLang = "en"
                                }
                            } else {
                                defaultkeyDefine = define ?: ""
                                targetLang = qmlanguage
                            }
                        } while (cursor.moveToNext())
                        return@use pasrseDefine(
                            keyDefine,
                            defaultkeyDefine,
                            version = -1,
                            model,
                            targetLang
                        )
                    } else {
                        return@use null
                    }
                }
            }
        } catch (e: Exception) {
            LogUtil.e(Log.getStackTraceString(e))
        }
        return null
    }

    private fun pasrseDefine(
        content: String,
        defaultkeyDefine: String,
        version: Int,
        model: String,
        lang: String
    ): DeviceStatusProtocol {
        val targetContent = if (content.isBlank()) {
            defaultkeyDefine
        } else {
            content
        }
        LogUtil.i(
            "sunzhibin",
            "queryKeyDefineByModel pasrseDefine $model $lang $targetContent"
        )
        val parseMaps = GsonUtils.parseMaps<String>(targetContent)
        val deviceStatusProtocol = DeviceStatusProtocol(parseMaps, version, model, "", lang)
        deviceStatusProtocol.language = lang
        return deviceStatusProtocol
    }


}
