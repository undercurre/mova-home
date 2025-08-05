package android.dreame.module.manager;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.dreame.module.LocalApplication;
import android.dreame.module.bean.LanguageBean;
import android.dreame.module.util.DarkThemeUtils;
import android.dreame.module.util.GsonUtils;
import android.dreame.module.util.LogUtil;
import android.os.Build;
import android.os.LocaleList;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.util.Log;
import android.util.Pair;

import com.dreame.hacklibrary.HackJniHelper;
import com.google.gson.Gson;
import com.tencent.mmkv.MMKV;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Objects;

public class LanguageManager {

    private static String LANGUAGE_INFO = "LANGUAGE";
    private static String FILENAME = "LANGUAGE";
    private MMKV languageKv;
    private SharedPreferences languageSp;

    private static LanguageManager mInstance;

    private LanguageManager() {
        languageKv = MMKV.mmkvWithID(FILENAME, MMKV.SINGLE_PROCESS_MODE, HackJniHelper.getCryptKey());
        languageSp = LocalApplication.getInstance().getSharedPreferences(FILENAME, Context.MODE_PRIVATE);
    }

    public static LanguageManager getInstance() {
        if (mInstance == null) {
            synchronized (LanguageManager.class) {
                if (mInstance == null) {
                    mInstance = new LanguageManager();
                }
            }
        }
        return mInstance;
    }


    private static List<String> supportLanguage = new ArrayList<String>() {
        {
            add("zh");
            add("en");
            add("es");
            add("ru");
            add("ko");
            add("it");
            add("fr");
            add("de");
            add("id");
            add("in");
            add("pl");
            add("vi");
            add("ja");
            add("th");
            add("nl");
            add("pt");
            add("tr");
            add("uk");
            add("da");
            add("sv");
            add("nb");
            add("ms");
            add("ar");
            add("iw");
            add("fi");
            add("cs");
            add("sk");
            add("hu");
            add("ro");
            add("lv");
            add("sl");
            add("lt");
        }
    };

    public void setLanguage(LanguageBean language) {
        languageSp.edit().putString(LANGUAGE_INFO, language == null ? "" : new Gson().toJson(language)).apply();
    }

    public LanguageBean getLanguage(Context context) {
        String languageStr = languageSp.getString(LANGUAGE_INFO, "");
        if (TextUtils.isEmpty(languageStr)) {
            languageStr = languageKv.decodeString(LANGUAGE_INFO, "");
            if (!TextUtils.isEmpty(languageStr)) {
                languageSp.edit().putString(LANGUAGE_INFO, languageStr).apply();
            }
        }
        if (TextUtils.isEmpty(languageStr)) {
            return new LanguageBean("", "default");
        } else {
            return GsonUtils.fromJson(languageStr, LanguageBean.class);
        }
    }

    public void clear() {
        languageSp.edit().clear().commit();
        languageKv.remove(LANGUAGE_INFO);
        languageKv.async();
    }


    /**
     * Application和Activity attachBase时调用
     *
     * @param context
     * @return
     */
    public Context setLocal(Context context) {
        return updateResources(context, getSetLanguageLocale(context));
    }

    /**
     * Application和Activity attachBase时调用
     *
     * @param context
     * @return
     */
    public Context setLocal(Context context, LanguageBean languageBean) {
        return updateResources(context, getSetLanguageLocale(context, languageBean));
    }

    public Context updateResources(Context context, Locale locale) {
        Context ctx = context;
        Locale.setDefault(locale);
        int uiMode = DarkThemeUtils.getThemeSetting(ctx);
        // AppCompatDelegate.setDefaultNightMode(mode);
        Resources res = ctx.getResources();
        Configuration configuration = res.getConfiguration();
        configuration.setLocale(locale);
        if (uiMode > 0) {
            configuration.uiMode = uiMode;
        }
        ctx = ctx.createConfigurationContext(configuration);
        return ctx;
    }

    /**
     * 根据本地sp获得对应的Locale
     *
     * @param context
     * @return
     */
    public Locale getSetLanguageLocale(Context context) {
        if (context == null) {
            return Locale.CHINA;
        }
        LanguageBean languageBean = getLanguage(context);
        return getSetLanguageLocale(context, languageBean);
    }

    public Locale getSetLanguageLocale(Context context, LanguageBean languageBean) {
        if (context == null) {
            return Locale.CHINA;
        }
        if (languageBean == null) {
            LogUtil.e("getSetLanguageLocale languageBean == null");
            return getSystemLocale();
        }
        String langTag = languageBean.getLangTag();
        if (TextUtils.isEmpty(langTag) || TextUtils.equals("default", langTag)) {
            Locale defaultLocal;
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                try {
                    LocaleList locales = context.getResources().getConfiguration().getLocales();
                    defaultLocal = locales.get(0); // 获取第一个语言
                } catch (Exception e) {
                    e.printStackTrace();
                    defaultLocal = Locale.getDefault(); // 低版本使用默认语言
                }
            } else {
                defaultLocal = Locale.getDefault(); // 低版本使用默认语言
            }
            if (supportLanguage.contains(defaultLocal.getLanguage())) {
                return defaultLocal;
            } else {
                return new Locale("en", "US");
            }
        } else {
            return new Locale(languageBean.getLangTag(), languageBean.getCountry());
        }
    }

    public String getCountryCode(Context context) {
        Locale locale = getSetLanguageLocale(context);
        return locale.getCountry();
    }

    /**
     * 获取当前语言tag
     *
     * @param context
     * @return "zh-CN"
     */
    public String getLangTag(Context context) {
        Locale locale = getSetLanguageLocale(context);

        String languageTag = locale.toLanguageTag();
        String country = locale.getCountry();
        if (TextUtils.equals(locale.getLanguage(), Locale.CHINA.getLanguage())) {
            // 兼容 华为手机语言和地区
            if (languageTag.contains("zh-Hans")) {
                return locale.getLanguage();
            }
            if (languageTag.contains("zh-Hant") && TextUtils.equals("TW", country)) {
                return locale.getLanguage() + "-TW";
            }
            if (languageTag.contains("zh-Hant") && TextUtils.equals("HK", country)) {
                return locale.getLanguage() + "-HK";
            }
            if (languageTag.contains("zh-Hant")) {
                return locale.getLanguage() + "-HK";
            }

            if (TextUtils.equals(locale.getCountry(), Locale.TRADITIONAL_CHINESE.getCountry()) || TextUtils.equals(locale.getCountry(), "HK")) {
                return locale.getLanguage() + "-" + locale.getCountry();
            } else {
                return locale.getLanguage();
            }
        } else {
            if (TextUtils.equals(locale.getLanguage(), "in")) {
                return "id";
            }
            if (TextUtils.equals(locale.getLanguage(), "iw")) {
                return "he";
            }
            return locale.getLanguage();
        }
    }

    /**
     * 获取当前语言tag  带国家码
     *
     * @param context context
     * @return Pair
     */
    public Pair<String, String> getLangTagWithCountyCode(Context context) {
        Locale locale = getSetLanguageLocale(context);
        String language = locale.getLanguage();
        String languageTag = locale.toLanguageTag();
        String country = locale.getCountry();
        Log.d("sunzhibin", "getLangTagWithCountyCode: languageTag: " + languageTag + " ,country: " + country + "  language: " + language);
        if (Objects.equals("in", language)) {
            // 印尼语 规范对应处理
            return new Pair<>("id", locale.getCountry());
        }
        if (Objects.equals("iw", language)) {
            // 希伯来语 规范对应处理
            return new Pair<>("he", locale.getCountry());
        }
        if (TextUtils.equals("zh", language)) {
            //
            if (languageTag.contains("zh-Hans")) {
                return new Pair<>(locale.getLanguage(), "CN");
            }
            if (languageTag.contains("zh-Hant") && TextUtils.equals("TW", country)) {
                return new Pair<>(locale.getLanguage(), locale.getCountry());
            }

            if (languageTag.contains("zh-Hant") && TextUtils.equals("HK", country)) {
                return new Pair<>(locale.getLanguage(), locale.getCountry());
            }
            if (languageTag.contains("zh-Hant")) {
                return new Pair<>(locale.getLanguage(), "HK");
            }
        }
        return new Pair<>(locale.getLanguage(), locale.getCountry());
    }

    /**
     * 获取系统Locale
     *
     * @return
     */
    public Locale getSystemLocale() {
        // 系统默认语言暂时为中文
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            return Resources.getSystem().getConfiguration().getLocales().get(0);
        } else {
            return Locale.getDefault();
        }
    }

    /**
     * 切换语言更新当前语言
     *
     * @param context
     */
    public void setApplicationLanguage(Context context) {
        Resources resources = context.getApplicationContext().getResources();
        DisplayMetrics displayMetrics = resources.getDisplayMetrics();
        Configuration configuration = resources.getConfiguration();
        Locale locale = getSetLanguageLocale(context);
        configuration.setLocale(locale);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            LocaleList localeList = new LocaleList(locale);
            LocaleList.setDefault(localeList);
            configuration.setLocales(localeList);
            context.createConfigurationContext(configuration);
        }
        resources.updateConfiguration(configuration, displayMetrics);
    }
}
