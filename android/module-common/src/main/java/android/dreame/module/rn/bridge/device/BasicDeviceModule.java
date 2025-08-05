package android.dreame.module.rn.bridge.device;

import android.dreame.module.bean.DeviceListBean;
import android.dreame.module.rn.load.RnLoaderCache;
import android.dreame.module.rn.utils.RNConstants;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import java.util.Map;

public class BasicDeviceModule extends ReactContextBaseJavaModule {
    public BasicDeviceModule(@NonNull ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @NonNull
    @Override
    public String getName() {
        return "BasicDevice";
    }

    @Nullable
    @Override
    public Map<String, Object> getConstants() {
        return RNConstants.getDevice(getReactApplicationContext());
    }

    @ReactMethod(isBlockingSynchronousMethod = true)
    public String deviceId() {
        DeviceListBean.Device device = RnLoaderCache.getCurrentDevice(getReactApplicationContext());
        if (device != null) {
            return device.getDid();
        } else {
            return "";
        }
    }
}
