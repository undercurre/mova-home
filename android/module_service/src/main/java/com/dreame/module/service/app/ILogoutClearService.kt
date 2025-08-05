package com.dreame.module.service.app

import android.content.Context


/**
 * 登出，清理操作
 */
interface ILogoutClearService  {

 

    /**
     * 登出清理
     */
    suspend fun prepareLogout()

    /**
     * 登出清理
     */
    fun logoutClear()

    /**
     * 登出推送
     */
    fun deletePushAlias()

}