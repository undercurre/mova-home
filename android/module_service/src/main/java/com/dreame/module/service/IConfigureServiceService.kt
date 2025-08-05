package com.dreame.module.service

interface IAppConfigureService {

    fun versionCode(): Int

    fun versionName(): String

    fun isCnFlavor(): Boolean

    fun isCnDomain(): Boolean

    fun isDebug(): Boolean

    fun serviceDoamin(): String

    fun serviceAppPrivacyDoamin(): String


}