package android.dreame.module.rn.bridge;

import android.dreame.module.rn.utils.RNConstants;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;

import java.util.Map;

public class SDKModule extends ReactContextBaseJavaModule {
    public SDKModule(@NonNull ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Nullable
    @Override
    public Map<String, Object> getConstants() {
        return RNConstants.getSDKConfig();
    }

    @NonNull
    @Override
    public String getName() {
        return "sdk";
    }
}
