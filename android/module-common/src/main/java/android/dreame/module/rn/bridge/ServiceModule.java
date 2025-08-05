package android.dreame.module.rn.bridge;

import android.dreame.module.bean.CountryBean;
import android.dreame.module.manager.AreaManager;
import android.dreame.module.util.LogUtil;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;

public class ServiceModule extends ReactContextBaseJavaModule {
    public ServiceModule(@NonNull ReactApplicationContext reactContext) {
        super(reactContext);
    }


    @NonNull
    @Override
    public String getName() {
        return "Service";
    }

    @ReactMethod
    public void getServerName(Promise promise) {
        if (getCurrentActivity() == null) {
            promise.reject(new NullPointerException());
            return;
        }
        CountryBean location = AreaManager.INSTANCE.getCurrentCountry();
        WritableMap writableMap = new WritableNativeMap();
        if (location != null) {
            LogUtil.d(getName(),"countryName:" + location.getEn() + ",countryCode:"
                    + location.getCountryCode() + ",serverCode:"
                    + AreaManager.getRegion());
            writableMap.putString("countryName", location.getEn());
            writableMap.putString("countryCode", location.getCountryCode());
            writableMap.putString("serverCode",  AreaManager.getRegion());
        } else {
            // 默认当前时区
            writableMap.putString("countryName", "中国大陆");
            writableMap.putString("countryCode", "CN");
            writableMap.putString("serverCode", "cn");
        }
        promise.resolve(writableMap);
    }


}
