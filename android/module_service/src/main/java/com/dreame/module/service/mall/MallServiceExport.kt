package com.dreame.module.service.mall

object MallServiceExport {
    // Uniapp页面
    // 权益
    const val UNIAPP_PAGE_MEMBERSHIP = "/pagesA/memberShip/memberShip"

    // 会员中心
    const val UNIAPP_PAGE_VIPCENTER = "/pagesA/vipCenter/vipCenter"

    // 签到
    const val UNIAPP_PAGE_DALIYCHECKIN = "/pagesA/daliyCheckIn/daliyCheckIn"

    // 优惠券
    const val UNIAPP_PAGE_COUPON = "/pagesA/coupon/coupon"

    // 觅享分
    const val UNIAPP_PAGE_DREAMEPOINT = "/pagesA/dreamePoint/dreamePoint"

    // 积分
    const val UNIAPP_PAGE_POINT = "/pagesA/point/point"

    // 订单
    const val UNIAPP_PAGE_ORDER = "/pages/order/order"

    // 售后
    const val UNIAPP_PAGE_REFUND = "/pages/refund/refund"

    // 收货地址
    const val UNIAPP_PAGE_ADDRESS = "/pages/address/address-list"

    // 产品注册
    const val UNIAPP_PAGE_PRODUCT_REGISTER = "/pages/serve/serve"


    //
    const val UNIAPP_EVENT_NAVIGATION_HOME_H5 = "home/h5"
    const val UNIAPP_EVENT_NAVIGATION_HOME_DEVICE = "home/device"
    const val UNIAPP_EVENT_NAVIGATION_HOME_MINE = "home/mine"
    const val UNIAPP_EVENT_NAVIGATION_MINE_ACCOUNTSETTING = "mine/accountSetting"
    const val UNIAPP_EVENT_NAVIGATION_DEVICE_ADDDEVICE = "device/addDevice"
    const val UNIAPP_EVENT_NAVIGATION_DEVICE_SCAN = "device/barcodeScan"

    const val UNIAPP_EVENT_SHARE_IMAGE = "image"
    const val UNIAPP_EVENT_SHARE_WEB = "web"
    const val UNIAPP_EVENT_SHARE_TEXT = "text"

    @Deprecated("Deprecated by h5", replaceWith = ReplaceWith(H5_EVENT_REFRESH_SESSION2), level = DeprecationLevel.WARNING)
    const val UNIAPP_EVENT_REFRESH_TOKEN = "refreshToken"
    const val UNIAPP_EVENT_NAVIGATION = "navigation"
    const val UNIAPP_EVENT_SHARE = "share"
    const val UNIAPP_EVENT_MAP_NAVIGATION = "mapNavigation"

    @Deprecated("Deprecated by h5", replaceWith = ReplaceWith(H5_EVENT_OPEN_WEBVIEW), level = DeprecationLevel.WARNING)
    const val H5_EVENT_OPEN_PLUGIN = "1"
    const val H5_EVENT_OPEN_WEBVIEW = "openWebview"
    const val H5_EVENT_OPEN_OUTER_WEBVIEW = "openOuterPage"

    const val H5_EVENT_CLOSE_WEBVIEW = "closeWebView"

    const val H5_EVENT_OPEN_WX_WEBVIEW = "openWechatPage"

    @Deprecated("Deprecated by h5", replaceWith = ReplaceWith(H5_EVENT_REFRESH_SESSION2), level = DeprecationLevel.WARNING)
    const val H5_EVENT_REFRESH_SESSION = "2"
    const val H5_EVENT_REFRESH_SESSION2 = "refreshSession"


    /**
     * 相册
     */
    const val H5_EVENT_GALLERY = "gallery"

}