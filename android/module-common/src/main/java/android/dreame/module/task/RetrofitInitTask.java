package android.dreame.module.task;

import android.dreame.module.BuildConfig;
import android.dreame.module.LocalApplication;
import android.dreame.module.bean.CountryBean;
import android.dreame.module.constant.Constants;
import android.dreame.module.manager.AreaManager;
import android.dreame.module.util.LogUtil;
import android.dreame.module.util.SPUtil;
import android.text.TextUtils;

import okhttp3.HttpUrl;

/**
 * @Author: sunzhibin
 * @E-mail: sunzhibin@dreame.tech
 * @Desc: 作用描述
 * @Date: 2021/4/29 13:34
 * @Version: 1.0
 */
public class RetrofitInitTask {
    static String PRIVACY_PREFIX = "app-privacy-";
    private static String BASE_URL;
    private static final String TAG = RetrofitInitTask.class.getCanonicalName();

    public static String getAppPrivacyBaseUrl() {
        String baseUrlPath = getBaseUrl();
        HttpUrl baseUrl = HttpUrl.parse(baseUrlPath);
        // 在域名前插入 'app-privacy-'
        return "https://" + PRIVACY_PREFIX + baseUrl.host();
    }

    public static String getBaseUrl() {
        // 切换环境
        final String serverUrl = (String) SPUtil.get(LocalApplication.getInstance(), Constants.NET_BASE_URL, "");
        String realBaseUrl = getRealBaseUrl(serverUrl);
        if (serverUrl != null && serverUrl.length() != 0) {
            String env = "";
            if (serverUrl.contains("test")) {
                env = "test";
            } else if (serverUrl.contains("uat")) {
                env = "uat";
            } else if (serverUrl.contains("dev")) {
                env = "dev";
            } else if (serverUrl.contains("pre")) {
                env = "pre";
            }
            realBaseUrl = getFakeBaseUrl(env, realBaseUrl);
        } else if (!BuildConfig.BUILD_TYPE.equals("release") && !realBaseUrl.contains("13267")) {
            realBaseUrl = getFakeBaseUrl(BuildConfig.BUILD_TYPE, realBaseUrl);
        }
        if (realBaseUrl.length() == 0) {
            LogUtil.e("RetrofitInitTask", " getBaseUrl is null, Notice, Notice");
            // FIXME: 7.1.22
            throw new NullPointerException("serverDomain is null, Notice, Notice");
        }
        return realBaseUrl;
    }

    private static String getRealBaseUrl(String changeUrl) {
        CountryBean currentCountry = AreaManager.INSTANCE.getCurrentCountry();
        String serverDomain = currentCountry.getDomain();
        if (BASE_URL == null || BASE_URL.length() == 0) {
            createNewBaseUrl(serverDomain, changeUrl);
            return BASE_URL;
        }
        if (!BASE_URL.contains(serverDomain)) {
            createNewBaseUrl(serverDomain, changeUrl);
            return BASE_URL;
        }
        return BASE_URL;
    }

    /**
     * 创建新的域名
     *
     * @param serverDomain
     */
    private static void createNewBaseUrl(String serverDomain, String changeUrl) {

        HttpUrl newBaseUrl = HttpUrl.parse(TextUtils.isEmpty(changeUrl) ? BuildConfig.API_BASE_URL : changeUrl);
        HttpUrl build = newBaseUrl.newBuilder()
                .scheme(newBaseUrl.scheme())// 更换网络协议
                .host(serverDomain)// 更换主机名
                .port(newBaseUrl.port())// 更换端口
                .build();
        String baseurl = build.url().toString();
        int index = baseurl.lastIndexOf("/");
        baseurl = baseurl.substring(0, index);
        BASE_URL = baseurl;
    }

    /**
     * 测试使用
     *
     * @return
     */
    private static String getFakeBaseUrl(String env, String url) {
        if (TextUtils.isEmpty(env)) {
            return url;
        }
        StringBuilder stringBuffer = new StringBuilder(url);
        int index = stringBuffer.indexOf(".");
        switch (env) {
            case "debug":
                stringBuffer = new StringBuilder(BuildConfig.API_BASE_URL);
                break;
            case "dev":
                env = "-dev";
                stringBuffer.insert(index, env);
                break;
            case "test":
                env = "-test";
                stringBuffer.insert(index, env);
                break;
            case "pre":
                env = "-pre";
                stringBuffer.insert(index, env);
                break;
            case "uat":
                env = "-uat";
                stringBuffer.insert(index, env);
                break;
            default:
                env = "-" + env;
                stringBuffer.insert(index, env);
                break;
        }
        return stringBuffer.toString();
    }

}
