package android.dreame.module.constant;

import android.dreame.module.LocalApplication;

public class Constants {
    public final static String APP_NAME = "MOVAhome";
    public final static String SP_NAME = "MOVAhome";
    public final static String RN_FILE = LocalApplication.getInstance().getPackageName() + "_preferences";
    public final static String PLATFORM = "ANDROID";

    public final static String DEBUGEABLE = "DEBUGEABLE";
    public final static String PATH = "PATH";
    public final static String JSPATH = "JSPATH";
    public final static String CURRENT_COUNTRY = "current_country";
    public final static String DEFAULT_COUNTRY = "{\"short\": \"CN\",\"name\": \"中国\",\"en\": \"China\",\"tel\": \"86\",\"pinyin\": \"zg\"}";
    public final static String CURRENT_LANGUAGE = "current_language";
    public final static String DEFAULT_LANGUAGE = "{\"displayLang\": \"默认\",\"langTag\": \"default\"}";

    public static final String WECHAT_APP_ID = "wx59efb945de8565a0";

    public static final int NET_SUCCESS = 0;
    public static final int NET_ERROR = -1;

    /**
     * 通用key_xxx,避免使用hardcode
     */
    public final static String KEY_WEB_TITLE = "key_web_title";
    public final static String KEY_WEB_URL = "key_web_url";
    public final static String KEY_WEB_HIDE_TITLE = "key_web_hide_title";
    public final static String KEY_WEB_BG_COLOR = "key_web_bg_color";
    public final static String KEY_TYPE = "key_type";
    public final static String KEY_DATA = "key_data";
    public final static String KEY_DEVICE = "key_device";
    public final static String KEY_CODE = "key_code";
    public final static String KEY_STATE = "key_state";
    public final static String KEY_NAME = "key_name";

    public static final String EXTRA_RESULT = "extra_result";

    public static final String NET_BASE_URL = "net_base_url";
    /**
     * React native key
     * <boolean name="js_dev_mode_debug" value="true" />
     * <boolean name="start_sampling_profiler_on_init" value="false" />
     * <string name="debug_http_host"> </string>
     * <boolean name="js_minify_debug" value="false" />
     * <boolean name="animations_debug" value="false" />
     * <boolean name="remote_js_debug" value="false" />
     */
    public final static String debug_http_host = "debug_http_host";


    /**
     * regular expression
     * ^(?![A-Z]*$)(?![a-z]*$)(?![0-9]*$)(?![\W]*$)\S{8,16}$ 中[\W]转为[^A-Za-z0-9]
     */
    public final static String verifyPwd = "^(?![A-Z]*$)(?![a-z]*$)(?![0-9]*$)(?![^A-Za-z0-9]*$)((?![\\s])[\\x00-\\x7F]){8,16}$";
    // [\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?
    // \w android 会匹配到中文，故替换成[A-Za-z0-9_]
    public final static String verifyMail = "^([[A-Za-z0-9_]\\.\\-]+)@([[A-Za-z0-9_]\\-]+)((\\.([A-Za-z0-9_]){2,})+)$";

    /**
     * React Native Config
     */
    public final static String PLUGIN_LIST = "plugin_list";
    public final static String DEVICE = "device";
    public final static String DEVICE_ID = "device_id";

    // 用户名最大长度
    public final static int NICK_NAME_MAX_LENGTH = 20;
    // email 最大长度
    public final static int EMAIL_NAME_MAX_LENGTH = 45;
    /**
     * logan 日志AES加密参数
     */
    public final static String LOGAN_KEY = "0123456789012345";
    public final static String LOGAN_IV = "0123456789012345";

    // 2s
    public final static int MESSAGE_DELAY_DISMISS = 800;

    public static final boolean MODEL_NAME_PREFIX_OTHER_ENABLE = true;
    public static final String MODEL_NAME_PREFIX_DREAME = "dreame-";
    public static final String MODEL_NAME_PREFIX_MOVA = "mova-";
    public static final String MODEL_NAME_PREFIX_TROUVER = "trouver-";

    public static final String MODEL_NAME_PREFIX_DREAME_BT = "dreame";
    public static final String MODEL_NAME_PREFIX_MOVA_BT = "mova";
    public static final String MODEL_NAME_PREFIX_TROUVER_BT = "trouver";

    // action 首页
    public static final String ACTION_ACTIVITY_HOME = "com.dreame.movahome.action.HOME";
    // action 配网
    public static final String ACTION_ACTIVITY_DISTRIBUTION_NETWORK = "com.dreame.movahome.action.DISTRIBUTION_NETWORK";

    public static final String UID_ENCRYPT_KEY = "sXrtbXbO";


    /// 可能是机器的热点
    public static boolean maybeDeviceAp(String name) {
        if (name == null || name.isEmpty()) {
            return false;
        }
        if (MODEL_NAME_PREFIX_OTHER_ENABLE) {
            boolean maybeDeviceAp = name.startsWith(MODEL_NAME_PREFIX_DREAME) || name.startsWith(MODEL_NAME_PREFIX_MOVA) || name.startsWith(MODEL_NAME_PREFIX_TROUVER);
            return maybeDeviceAp && name.contains("_miap");
        } else {
            return name.startsWith(MODEL_NAME_PREFIX_DREAME) && name.contains("_miap");
        }
    }

}
