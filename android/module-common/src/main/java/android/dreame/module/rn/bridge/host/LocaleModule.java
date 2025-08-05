package android.dreame.module.rn.bridge.host;

import android.dreame.module.rn.utils.RNConstants;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;

import java.util.Map;
import java.util.TimeZone;

public class LocaleModule extends ReactContextBaseJavaModule {
    ReactApplicationContext reactApplicationContext;

    public LocaleModule(@NonNull ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactApplicationContext = reactContext;
    }

    @NonNull
    @Override
    public String getName() {
        return "Locale";
    }

    @Nullable
    @Override
    public Map<String, Object> getConstants() {
        return RNConstants.getLocale();
    }

    @ReactMethod
    public void getSystemTimeZone(Promise promise) {
        WritableMap writableMap = Arguments.createMap();
        writableMap.putString("timeZone", TimeZone.getDefault().getID());
        promise.resolve(writableMap);
    }
}
