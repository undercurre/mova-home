package android.dreame.module.rn.load;

import android.dreame.module.bean.DeviceListBean;
import android.dreame.module.util.LogUtil;
import android.text.TextUtils;

import androidx.annotation.Nullable;

import com.facebook.react.bridge.ReactContext;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2022/04/26
 *     desc   :
 *     version: 1.0
 * </pre>
 */
public class RnLoaderCache {
    private static final Map<String, BasicRNHost> mReactNativeHost = new LinkedHashMap(4, 0.75f, true);
    private static final Map<ReactContext, DeviceListBean.Device> reactContextDeviceCache = new ConcurrentHashMap();

    private static int count = 0;

    @Nullable
    public static BasicRNHost getReactNativeHost(String deviceId) {
        return mReactNativeHost.get(deviceId);
    }

    public static void cacheReactNativeHost(String deviceId, BasicRNHost reactNativeHost) {
        mReactNativeHost.put(deviceId, reactNativeHost);
    }

    public static DeviceListBean.Device getCurrentDevice(ReactContext reactContext) {
        return reactContextDeviceCache.get(reactContext);
    }

    public static void cacheDevice(ReactContext reactContext, DeviceListBean.Device device) {
        LogUtil.i("RNConstants cacheDevice " + reactContext + " " + device.getDid());
        reactContextDeviceCache.put(reactContext, device);
    }

    public static synchronized void removeRnHost(String deviceId) {
        LogUtil.i("removeRnHost deviceId: " + deviceId);
        if (mReactNativeHost.get(deviceId) != null) {
            BasicRNHost basicRNHost = mReactNativeHost.remove(deviceId);
            if(basicRNHost != null){
                basicRNHost.clear();
            }
            ReactContext context = null;
            for (Map.Entry<ReactContext, DeviceListBean.Device> entry : reactContextDeviceCache.entrySet()) {
                if (TextUtils.equals(deviceId, entry.getValue().getDid())) {
                    context = entry.getKey();
                    break;
                }
            }
            if (context != null) {
                reactContextDeviceCache.remove(context);
            }
        }
    }

    public static void updateDevice(ReactContext reactContext, DeviceListBean.Device device){
        DeviceListBean.Device oldDeviceInfo = reactContextDeviceCache.get(reactContext);
        if(oldDeviceInfo != null){
            reactContextDeviceCache.put(reactContext,device);
        }
    }

    public static void clearCache(){
        for (BasicRNHost basicRNHost : mReactNativeHost.values()) {
            basicRNHost.clear();
        }
        mReactNativeHost.clear();
        reactContextDeviceCache.clear();
    }

    public static void loadTimesIncrement(int maxTimes){
        count++;
        if (count >= maxTimes) {
            count = 0;
            RnLoaderCache.clearCache();
            LogUtil.i("RnLoaderCache", "clearRnCache");
        }
    }
}
