package com.dreame.module.mall

interface MallJavaScriptCallback {
    /**
     * 打开新页面
     */
    fun openNewPage(type: String, path: String) {

    }

    fun openPayPage(type: String, path: String) {

    }

    fun closePage(type: String, path: String) {

    }

    /**
     * 打开相册
     */
    fun openGallery(type: String, path: String) {

    }

    /**
     * 刷新session
     */
    fun refreshSession(type: String)

    /**
     * 分享
     */
    fun share(type: String, content: String) {}

    /**
     * navigation
     */
    fun navigation(type: String, content: String) {}

    /**
     * 打开地图导航
     */
    fun mapNavigation(type: String, date: String) {

    }

}