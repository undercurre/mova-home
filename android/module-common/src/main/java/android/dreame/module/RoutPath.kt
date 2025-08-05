package android.dreame.module

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2022/10/28
 *     desc   :
 *     version: 1.0
 * </pre>
 */
object RoutPath {

    /* ------------------------Account begin -------------------- */
    const val PASSWORD_MODIFY = "/account/modifyPassword"
    const val PASSWORD_SETTING = "/account/setPassword"
    /* ------------------------Account end -------------------- */

    const val SPLASH_PAGE = "/app/splash"
    const val MAIN_HOME = "/app/MainActivity2"

    const val MAIN_WEBVIEW = "/app/WebViewActivity"
    const val WEBVIEW_POLICY = "/app/PrivacyPolicyWebView"
    const val WEBVIEW_CONNECT_GUIDE = "/app/ConnectGuideWebView"

    const val ACCOUNT_SETTING = "/app/account/setting"

    const val VOICE_CONTROL = "/app/voiceControl"
    const val VOICE_CONTROL_ALEXA = "/app/voiceControlAlexa"
    const val VOICE_CONTROL_ALEXA_AUTH = "/app/voiceControlAlexaAuth"

    const val APP_LOGOUT_CLEAR_SERVICE = "/app/LogoutClearService"

    const val APP_PDF_PREVIEW = "/app/pdfPreview"


    /*-----------------------消息页面----------------*/
    const val SHARE_DEVICE_SHARE_MESSAGE_SERVICE = "/message/share/device"

    /*-----------------------消息页面----------------*/
    // 商城相关
    const val MALL_SERVICE = "/mall/MallService"
    const val MALL_WEBVIEW = "/mall/MallWebView"
    const val MALL_PAY_WEBVIEW = "/mall/MallPayWebView"

    /* ------------------------appwidget start -------------------- */
    const val WIDGET_APPWIDGET_SERVICE = "/widget/appwidget/service"
    const val WIDGET_APPWIDGET_SELECT = "/widget/appwidget/select"
    const val WIDGET_APPWIDGET_ADD_BIND = "/widget/appwidget/addWidgetAndBind"
    /* ------------------------appwidget end -------------------- */


    /*-----------------------配网界面----------------*/

    const val DEVICE_PRODUCT_SELECT = "/connect/device/productList"
    const val DEVICE_PRODUCT_QR = "/connect/device/productQR"

    const val DEVICE_ROUTER_TIPS = "/connect/device/routerTips"
    const val DEVICE_ROUTER_PASSWORD = "/connect/device/routerPassword"

    const val DEVICE_BOOT_UP = "/connect/device/bootUp"
    const val DEVICE_TRIGGER_AP = "/connect/device/triggerAp"
    const val DEVICE_SCAN_NEARYBY = "/connect/device/scanNearBy"
    const val DEVICE_CONNECT = "/connect/device/connect"
    const val DEVICE_STEP_FAIL_INFO = "/connect/device/stepFailInfo"
    const val DEVICE_QR_NET = "/connect/device/qrNet"
    const val DEVICE_QR_CONNECT_TIPS = "/connect/device/qrConnectTips"

    // 蓝牙设备
    const val PRODUCT_CONNECT_PREPARE_BLE = "/connect/prepare/mowerConnect"
    const val PRODUCT_CONNECT_PREPARE_GUIDE = "/connect/prepare/mowerGuide"
    const val DEVICE_TRIGGER_BLE = "/connect/device/triggerBle"
    const val DEVICE_CONNECT_BLE = "/connect/device/connectBle"
    const val DEVICE_CONNECT_BLE_SOLUTION = "/connect/device/connectBleSolution"
    /*-----------------------配网界面----------------*/


    const val APP_FLUTTER_BRIDGE_SERVICE = "/app/flutterBridgeService"

    //交互·
    const val APP_HOME_INTERACTION_SERVICE = "/app/homeInteractionService"
    const val APP_WIDGET_CLICK_HANDLE_SERVICE = "/app/appWidgetClickHandleService"


    /*-----------------------共享 begin----------------*/

    const val SHARE_DEVICE_MANAGEMENT = "/device/share/management"
    const val SHARE_DEVICE_USER_LIST = "/device/share/userList"
    const val SHARE_DEVICE_FEATURE_UPDATE = "/device/share/featureUpdate"
    const val SHARE_DEVICE_FEATURE_DETAIL = "/device/share/featureDetail"
    const val SHARE_DEVICE_SHARE_CHECK = "/device/share/shareCheck"
    const val SHARE_DEVICE_SHARE_CONFIRM = "/device/share/shareConfirm"

    /*-----------------------共享 end----------------*/


    /*-----------------------帮助中心 begin----------------*/
    const val HELP_CENTER = "/help/HelpCenter"
    const val HELP_FEEDBACK_HOME = "/help/feedback/home"
    const val HELP_FEEDBACK = "/help/feedback"
    const val HELP_FEEDBACK_DETAIL = "/help/feedback/detail"
    const val HELP_SUGGESTION_DETAIL = "/help/suggestion/detail"
    const val HELP_FAQ_SEARCH = "/help/faq/search"
    const val HELP_PRODUCT_LIST = "/help/product/list"
    const val HELP_PRODUCT_FAQ = "/help/product/faq"
    const val HELP_SERVICE = "/help/service"
    const val HELP_BUG_REPORT = "/help/report"

    /*-----------------------帮助中心 end----------------*/

    const val REACT_NATIVE_SERVICE = "/rn/service"
}