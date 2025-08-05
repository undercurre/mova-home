package android.dreame.module.rn.bridge.service;

import android.dreame.module.manager.AccountManager;
import android.dreame.module.rn.utils.RNConstants;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import java.util.Map;

public class AccountModule extends ReactContextBaseJavaModule {

    public AccountModule(@NonNull ReactApplicationContext reactContext) {
        super(reactContext);
        setAccountChangedCallback();
    }

    /**
     * 控制账户变化回调
     */
    private void setAccountChangedCallback() {
        AccountManager.getInstance().setAccountChangedCallback(oAuthBean -> {
            ReactContext reactContext = getReactApplicationContext();
            if (reactContext != null && reactContext.hasActiveCatalystInstance()) {
                reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                        .emit("accessTokenChanged", oAuthBean.getAccess_token());
            }
        });
    }

    @NonNull
    @Override
    public String getName() {
        return "Account";
    }

    @Nullable
    @Override
    public Map<String, Object> getConstants() {
        return RNConstants.getAccount();
    }

    @ReactMethod
    public void getAccountInfoById(String accountId, Callback callback) {

    }

    @ReactMethod
    public void getAccountInfoList(String ids, Callback callback) {

    }


}
