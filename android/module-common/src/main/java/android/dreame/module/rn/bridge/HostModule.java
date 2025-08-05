package android.dreame.module.rn.bridge;

import android.dreame.module.RouteServiceProvider;
import android.dreame.module.rn.utils.RNConstants;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.dreame.module.service.app.flutter.IFlutterBridgeService;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import java.util.Map;

public class HostModule extends ReactContextBaseJavaModule {

    public HostModule(@NonNull ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Nullable
    @Override
    public Map<String, Object> getConstants() {
//        HashMap<String, Object> constants = new HashMap<>();
//        WritableMap writableMap = new WritableNativeMap();
//        writableMap.putString("mobileModel", android.os.Build.MODEL);
//        writableMap.putBoolean("isDebug", (boolean) SPUtil.get(getCurrentActivity(), Constants.DEBUGEABLE, false));
//        constants.put("systemInfo", writableMap);
        return RNConstants.getHost();
    }

    @NonNull
    @Override
    public String getName() {
        return "Host";
    }

    @ReactMethod
    public void dnsRequest(String host, Callback callback) {
        IFlutterBridgeService flutterBridgeService = RouteServiceProvider.INSTANCE.getService(IFlutterBridgeService.class);
        if (flutterBridgeService == null) {
            callback.invoke("");
            return;
        }
        flutterBridgeService.dnsRequest(host, s -> {
            callback.invoke(s);
            return null;
        });
    }

    @ReactMethod
    public void getCachedDns(String host, Callback callback) {
        IFlutterBridgeService flutterBridgeService = RouteServiceProvider.INSTANCE.getService(IFlutterBridgeService.class);
        if (flutterBridgeService == null) {
            callback.invoke("");
            return;
        }
        flutterBridgeService.getCachedDns(host, s -> {
            callback.invoke(s);
            return null;
        });
    }

    @ReactMethod
    public void cleanCachedDns(String host) {
        IFlutterBridgeService flutterBridgeService = RouteServiceProvider.INSTANCE.getService(IFlutterBridgeService.class);
        if (flutterBridgeService == null) {
            return;
        }
        flutterBridgeService.cleanCachedDns(host);
    }

}
