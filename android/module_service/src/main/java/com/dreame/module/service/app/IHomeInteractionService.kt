package com.dreame.module.service.app

import android.content.Context


/**
 * 登出，清理操作
 */
interface IHomeInteractionService {
    
    suspend fun getDeviceStatusByProtocol(
        model: String?,
        property: String = "2.1",
        languageTag: String,
        statusKey: String,
    ): String?

}