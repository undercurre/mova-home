package com.dreame.smartlife.utils.rn;

import android.dreame.module.LocalApplication;
import android.dreame.module.manager.AreaManager;
import android.dreame.module.manager.LanguageManager;
import android.dreame.module.util.LogUtil;
import android.text.TextUtils;

public class VideoLicenseUtil {

    public static String getVideoPolicyUrl() {
        String endFix;
        String countryCode = AreaManager.getCountryCode().toUpperCase();
        String languageTag = LanguageManager.getInstance().getLangTag(LocalApplication.getInstance())
                .replace("-", "_").toLowerCase();
        LogUtil.i("VideoLicenseUtil", "getVideoPolicyUrl: " + countryCode + "==" + languageTag);
        switch (countryCode) {
            case "TR": // 土耳其
                endFix = "/tr/video_privacyPolicy.html";
                break;
            case "TH": // 泰国
                endFix = "/th/video_privacyPolicy.html";
                break;
            case "VN": // 越南
                endFix = "/vi/video_privacyPolicy.html";
                break;
            case "ID": // 印度尼西亚
                endFix = "/id/video_privacyPolicy.html";
                break;
            case "JP": // 日本
                endFix = "/ja/video_privacyPolicy.html";
                break;
            case "ES": // 西班牙
                endFix = "/es/video_privacyPolicy.html";
                break;
            case "DE": // 德国
                endFix = "/de/video_privacyPolicy.html";
                break;
            case "FR": // 法国
                endFix = "/fr/video_privacyPolicy.html";
                break;
            case "IT": // 意大利
                endFix = "/it/video_privacyPolicy.html";
                break;
            case "PL": // 波兰
                endFix = "/pl/video_privacyPolicy.html";
                break;
            case "CZ": // 捷克
                endFix = "/cs/video_privacyPolicy.html";
                break;
            case "SK": // 斯洛伐克
                endFix = "/sk/video_privacyPolicy.html";
                break;
            case "HU": // 匈牙利
                endFix = "/hu/video_privacyPolicy.html";
                break;
            case "FI": // 芬兰
                endFix = "/fi/video_privacyPolicy.html";
                break;
            case "DK": // 丹麦
                endFix = "/da/video_privacyPolicy.html";
                break;
            case "SE": // 瑞典
                endFix = "/sv/video_privacyPolicy.html";
                break;
            case "NO": // 挪威
                endFix = "/no/video_privacyPolicy.html";
                break;
            case "RU": // 俄罗斯
                endFix = "/ru/video_privacyPolicy.html";
                break;
            case "MY": // 马来西亚
                endFix = "/ms/video_privacyPolicy.html";
                break;
            case "IS": // 冰岛
                endFix = "/is/video_privacyPolicy.html";
                break;
            case "CN":
                endFix = "/zh/video_privacyPolicy.html";
                break;
            case "KR": // 韩国
                endFix = "/ko/video_privacyPolicy.html";
                break;
            case "US": // 美国
                endFix = "/en_hw/video_privacyPolicy.html";
                break;
            case "CA": // 加拿大
                endFix = "/fr_ca/video_privacyPolicy.html";
                break;
            case "AR":// 阿根廷
                endFix = "/es_la/video_privacyPolicy.html";
                break;
            default:
                endFix = "/en_hw/video_privacyPolicy.html";
                break;
        }

        if (countryCode.equals("CN")) {
            if (languageTag.equals("en")) {
                endFix = "/en/video_privacyPolicy.html";
            }
        } else {
            if (TextUtils.isEmpty(endFix)) {
                endFix = "/en_hw/video_privacyPolicy.html";
            } else {
                if (languageTag.equals("en")) {
                    endFix = "/en_hw/video_privacyPolicy.html";
                }
            }
        }

        return "https://protocol.dreame.tech/dreame-plugin" + endFix;
    }
}
