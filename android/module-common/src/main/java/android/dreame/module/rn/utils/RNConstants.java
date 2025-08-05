package android.dreame.module.rn.utils;

import android.dreame.module.BuildConfig;
import android.dreame.module.LocalApplication;
import android.dreame.module.bean.DeviceListBean;
import android.dreame.module.bean.OAuthBean;
import android.dreame.module.bean.UserInfoBean;
import android.dreame.module.constant.Constants;
import android.dreame.module.manager.AccountManager;
import android.dreame.module.manager.DeviceManager;
import android.dreame.module.manager.LanguageManager;
import android.dreame.module.rn.load.BasicRNHost;
import android.dreame.module.rn.load.RnLoaderCache;
import android.dreame.module.util.LogUtil;
import android.dreame.module.util.SPUtil;
import android.text.TextUtils;
import android.text.format.DateFormat;

import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;

public class RNConstants {
    public static Map<String, Object> getDevice(ReactContext context) {
        HashMap<String, Object> constants = new HashMap<>();
        DeviceListBean.Device currentDevice = RnLoaderCache.getCurrentDevice(context);
        LogUtil.i("RNConstants getDevice " + context + " ,currentDevice: " + currentDevice);
        final WritableMap loadDevice = getLoadDevice(currentDevice);
        constants.put("device", loadDevice);
        return constants;
    }

    public static WritableMap getLoadDevice(DeviceListBean.Device currentDevice) {
        WritableMap writableMap = new WritableNativeMap();
        writableMap.putBoolean("isOnline", currentDevice.isOnline());
        writableMap.putString("model", currentDevice.getModel());
        writableMap.putString("deviceID", currentDevice.getDid());
        writableMap.putString("iotId", currentDevice.getIotId());
        writableMap.putString("customName", currentDevice.getCustomName());
        writableMap.putString("displayName", currentDevice.getDeviceInfo().getDisplayName());
        writableMap.putBoolean("isOwner", currentDevice.isMaster());
        writableMap.putString("lastVersion", currentDevice.getVer());
        writableMap.putString("masterUid", (TextUtils.isEmpty(currentDevice.getMasterUid())) ? "" : currentDevice.getMasterUid());
        writableMap.putInt("featureCode", currentDevice.getFeatureCode());
        writableMap.putString("permissions", currentDevice.getPermissions());
        writableMap.putString("feature", currentDevice.getDeviceInfo().getFeature());
        writableMap.putString("vendor", currentDevice.getVendor());
        writableMap.putBoolean("videoDynamicVendor", currentDevice.getDeviceInfo().isVideoDynamicVendor());
        String property = currentDevice.getProperty();
        String mac = "";
        try {
            JSONObject propertyJson = new JSONObject(property);
            mac = propertyJson.optString("mac", "");
        } catch (JSONException e) {
            e.printStackTrace();
        }
        writableMap.putString("mac", mac);
        writableMap.putString("property", property);
        return writableMap;
    }

    public static Map<String, Object> getAccount() {
        HashMap<String, Object> constants = new HashMap<>();
        OAuthBean oAuthBean = AccountManager.getInstance().getAccount(LocalApplication.getInstance().getApplicationContext());
        WritableMap writableMap = new WritableNativeMap();
        writableMap.putString("ID", oAuthBean.getUid());
        writableMap.putString("userName", oAuthBean.getUser_name());
        writableMap.putString("accessToken", oAuthBean.getAccess_token());
        UserInfoBean userInfo = AccountManager.getInstance().getUserInfo();
        writableMap.putString("nickName", userInfo.getName());
        writableMap.putString("avatarURL", userInfo.getAvatar());
        writableMap.putString("birth", userInfo.getBirthday());
        writableMap.putString("email", userInfo.getEmail());
        writableMap.putString("phone", userInfo.getPhone());
        writableMap.putInt("sex", userInfo.getSex());
        constants.put("account", writableMap);
        return constants;
    }

    public static Map<String, Object> getHost() {
        HashMap<String, Object> constants = new HashMap<>();
        WritableMap writableMap = new WritableNativeMap();
        writableMap.putBoolean("isDebug", (boolean) SPUtil.get(LocalApplication.getInstance(), Constants.DEBUGEABLE, false));
        WritableMap systemInfo = new WritableNativeMap();
        systemInfo.putString("mobileModel", android.os.Build.MODEL);
        systemInfo.putString("sysVersion", android.os.Build.VERSION.SDK_INT + "");
        writableMap.putMap("systemInfo", systemInfo);
        writableMap.putString("tenantId", LocalApplication.getInstance().getTenantId());
        writableMap.putString("env", Host.INSTANCE.getEnv());
        constants.put("host", writableMap);
        return constants;
    }

    public static Map<String, Object> getLocale() {
        HashMap<String, Object> constants = new HashMap<>();
        WritableMap writableMap = new WritableNativeMap();
        String systemLanguage = "zh_CN";
        Locale locale = LocalApplication.getInstance().getResources().getConfiguration().locale;
        if (locale != null) {
            String country = locale.getCountry();
            if (TextUtils.isEmpty(country)) {
                systemLanguage = locale.getLanguage();
            } else {
                systemLanguage = locale.getLanguage() + "_" + locale.getCountry();
            }
        }
        String appLanguage = LanguageManager.getInstance().getLangTag(LocalApplication.getInstance());
        writableMap.putString("systemLanguage", systemLanguage);
        writableMap.putString("language", appLanguage.replace("-", "_").toLowerCase());
        writableMap.putString("timeZone", TimeZone.getDefault().getID());
        boolean is24Hour = false;
        try {
            is24Hour = DateFormat.is24HourFormat(LocalApplication.getInstance());
        } catch (Exception e) {

        }
        writableMap.putBoolean("is24HourTime", is24Hour);
        constants.put("locale", writableMap);
        return constants;
    }

    public static Map<String, Object> getSDKConfig() {
        HashMap<String, Object> constants = new HashMap<>();
        constants.put("isDreame", true);
        return constants;
    }

    public static Map<String, Object> getPackage(ReactContext context) {
        DeviceListBean.Device currentDevice = RnLoaderCache.getCurrentDevice(context);
        HashMap<String, Object> constants = new HashMap<>();
        constants.put("packageName", context.getPackageName());
        constants.put("isDebug", false);
        constants.put("models", "models");
        // PluginDataInfo pluginDataInfo = ProcessShareDataStore.getInstance().getPluginData(currentDevice.getModel());
        // String versionLasted = pluginDataInfo.getPluginVersion();
        String inUsePluginVersion = "0";
        if (currentDevice != null) {
            BasicRNHost basicRNHost = RnLoaderCache.getReactNativeHost(currentDevice.getDid());
            if (basicRNHost != null) {
                inUsePluginVersion = basicRNHost.getInUsePluginVersion();
            }
        }
        constants.put("version", inUsePluginVersion);
        constants.put("isVideo", DeviceManager.getInstance().isVideo());
        if (!TextUtils.isEmpty(DeviceManager.getInstance().getDeviceWarning())) {
            constants.put("entrance", DeviceManager.getInstance().getDeviceWarning());
        }
        return constants;
    }

}
