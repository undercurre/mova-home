package android.dreame.module.rn.bridge.host;

import android.dreame.module.util.SPUtil;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;


public class StorageModule extends ReactContextBaseJavaModule {
    public static final String SPNAME = "RN_STORAGE";

    public StorageModule(@NonNull ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @NonNull
    @Override
    public String getName() {
        return "Storage";
    }

    @ReactMethod
    public void get(String key, Callback callback) {
        if (getReactApplicationContext() != null) {
            String result = (String) SPUtil.defaultGet(getReactApplicationContext(), SPNAME, key, "");
            callback.invoke(result);
        }
    }

    @ReactMethod
    public void set(String key, String value) {
        if (getReactApplicationContext() != null) {
            SPUtil.defaultPut(getReactApplicationContext(), SPNAME, key, value);
        }
    }
}
