package android.dreame.module.rn.bridge;

import android.dreame.module.bean.DeviceListBean;
import android.dreame.module.rn.load.RnLoaderCache;
import android.dreame.module.rn.net.RNNetRequest;
import android.dreame.module.rn.net.RNNetRequestCallBack;
import android.dreame.module.util.LogUtil;
import android.dreame.module.util.mqtt.FlutterMqttManager;
import android.dreame.module.util.mqtt.IMqttMessageListener;
import android.dreame.module.util.mqtt.MqttUtil;
import android.text.TextUtils;

import androidx.annotation.NonNull;

import com.dreame.module.service.app.flutter.IFlutterBridgeService;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.therouter.TheRouter;

import org.json.JSONException;
import org.json.JSONObject;

public class DeviceModule extends ReactContextBaseJavaModule {

    public static final String SENDCOMMOND = "/device/sendCommand";
    public static final String SENDCOMMOND_V2 = "/device/sendCommandV2";

    public static final String SENDCOMMOND_ALL = "/device/sendCommand_all";

    public static final String QUERY_DEVICE_PERMIT = "/dreame-user-iot/iotuserbind/queryDevicePermit";

    public DeviceModule(@NonNull ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @NonNull
    @Override
    public String getName() {
        return "Device";
    }

    @ReactMethod
    public void callMethod(String methodName, String args, String extra, Promise promise) {
//        防止退出插件后一直调用接口
//        getCurrentActivity在onResume时赋值,插件插件会在OnCreate处理一些逻辑,此处不适用
//        if(getCurrentActivity() == null){
//            return;
//        }
        callMethod(SENDCOMMOND, methodName, args, extra, promise);
    }

    @ReactMethod
    public void callMethodV2(String methodName, String args, String extra, Promise promise) {
        callMethod(SENDCOMMOND_V2, methodName, args, extra, promise);
    }

    private void callMethod(String callPath,String methodName, String args, String extra, Promise promise) {
        String host = "";
        DeviceListBean.Device device = RnLoaderCache.getCurrentDevice(getReactApplicationContext());
        if (!TextUtils.isEmpty(device.getBindDomain())) {
            host = "-" + device.getBindDomain().split("\\.")[0];
        }
        RNNetRequest.request("/dreame-iot-com" + host + callPath, RNNetRequest.TYPE.POST, args, new RNNetRequestCallBack() {
            @Override
            public void onSuccess(String response) {
                promise.resolve(response);
            }

            @Override
            public void onError(int code, String error) {
                promise.reject(String.valueOf(code), error);
            }
        });
    }

    @ReactMethod
    public void subscribeMessages(Callback callback) {
        DeviceListBean.Device device = RnLoaderCache.getCurrentDevice(getReactApplicationContext());

        String clientId = MqttUtil.device2ClientId(device);
        String topic = MqttUtil.getDeviceTopic(device);
        FlutterMqttManager.INSTANCE.registerTopicListener(topic, messageListener);

        callback.invoke(true);
    }

    @ReactMethod
    public void unsubscribeMessages() {
//        DeviceListBean.Device device = RnLoaderCache.getCurrentDevice(getReactApplicationContext());
//        String topic = MqttUtil.getDeviceTopic(device);
//        FlutterMqttManager.INSTANCE.unregisterTopicListener(topic);
    }

    IMqttMessageListener messageListener = new IMqttMessageListener() {
        @Override
        public void onMqttMessageArrived(String topic, String message) {
            LogUtil.d("DeviceModule", "onMqttMessageArrived topic: " + topic + ",message:" + message);
            DeviceListBean.Device device = RnLoaderCache.getCurrentDevice(getReactApplicationContext());
            if (getCurrentActivity() != null
                    && !getCurrentActivity().isFinishing()
                    && !getCurrentActivity().isDestroyed() && device != null && topic.contains(device.getDid())) {
                getReactApplicationContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("deviceReceivedMessages", message);
            }
        }
    };

    @ReactMethod
    public void subscribeWillMessages(Callback callback) {
        DeviceListBean.Device device = RnLoaderCache.getCurrentDevice(getReactApplicationContext());

        String willTopic = MqttUtil.getDeviceWillsTopic(device);
        FlutterMqttManager.INSTANCE.registerWillTopicListener(willTopic, (topic, message) -> {
            LogUtil.d("DeviceModule", "onMqttWillMessageArrived topic: " + topic + ",message:" + message);
            DeviceListBean.Device device1 = RnLoaderCache.getCurrentDevice(getReactApplicationContext());
            if (getCurrentActivity() != null
                    && !getCurrentActivity().isFinishing()
                    && !getCurrentActivity().isDestroyed() && device1 != null && topic.contains(device1.getDid())) {
                getReactApplicationContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("deviceReceivedWillMessages", message);
            }
        });

        callback.invoke(true);
    }

    @ReactMethod
    public void unsubscribeWillMessages() {
    }

    @ReactMethod
    public void getPermissions(Promise promise) {
        JSONObject jsonObject = new JSONObject();
        try {
            DeviceListBean.Device device = RnLoaderCache.getCurrentDevice(getReactApplicationContext());
            jsonObject.put("did", device.getDid());
        } catch (JSONException e) {
            e.printStackTrace();
        }
        String params = jsonObject.toString();
        if (!TextUtils.isEmpty(params)) {
            RNNetRequest.request(QUERY_DEVICE_PERMIT, RNNetRequest.TYPE.POST, jsonObject.toString(), new RNNetRequestCallBack() {
                @Override
                public void onSuccess(String response) {
                    promise.resolve(response);
                }

                @Override
                public void onError(int code, String error) {
                    promise.reject(String.valueOf(code), error);
                }
            });
        }
    }

    @ReactMethod
    public void getCachedProtocolData(String did, Promise promise) {
        IFlutterBridgeService flutterBridgeService = TheRouter.get(IFlutterBridgeService.class);
        if (flutterBridgeService != null) {
            flutterBridgeService.getCachedProtocolData(did, result -> {
                promise.resolve(result);
                return null;
            });
        } else {
            promise.reject("0", "getCacheProtocolData failed");
        }
    }
}
