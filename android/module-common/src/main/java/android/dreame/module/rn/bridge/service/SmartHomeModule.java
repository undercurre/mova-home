package android.dreame.module.rn.bridge.service;

import android.dreame.module.bean.DeviceListBean;
import android.dreame.module.manager.AreaManager;
import android.dreame.module.rn.load.BasicRNHost;
import android.dreame.module.rn.load.RnLoaderCache;
import android.dreame.module.rn.net.RNNetRequest;
import android.dreame.module.rn.net.RNNetRequestCallBack;
import android.dreame.module.trace.EventCommonHelper;
import android.dreame.module.trace.ModuleCode;
import android.dreame.module.trace.PluginEventEventCode;
import android.dreame.module.util.GsonUtils;
import android.dreame.module.util.LogUtil;
import android.text.TextUtils;
import android.util.Base64;
import android.util.Log;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

import okhttp3.Call;
import okhttp3.Headers;
import okhttp3.Response;
import okhttp3.ResponseBody;

public class SmartHomeModule extends ReactContextBaseJavaModule {
    private final String GETINTERIMFILEURL = "/dreame-user-iot/iotfile/getDownloadUrl";
    private final String HISTORY = "/dreame-user-iot/iotstatus/history";
    private final String CHECK_FIRMWARE_VERSION = "/dreame-user-iot/iotuserbind/checkDeviceVersion";
    public static final String FIRMWARE_UPDATE = "/dreame-user-iot/iotuserbind/manualFirmwareUpdate";
    public static final String GET_DEVICE_DATA = "/dreame-user-iot/iotuserdata/getDeviceData";
    public static final String SET_DEVICE_DATA = "/dreame-user-iot/iotuserdata/setDeviceData";

    public SmartHomeModule(@NonNull ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @NonNull
    @Override
    public String getName() {
        return "Smarthome";
    }

    @ReactMethod
    public void getInterimFileUrl(String args, Promise promise) {
        if (!TextUtils.isEmpty(args)) {
            try {
                JSONObject jsonObject = new JSONObject(args);
                jsonObject.put("region", AreaManager.getRegion());
                args = jsonObject.toString();
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        RNNetRequest.request(GETINTERIMFILEURL, RNNetRequest.TYPE.POST, args, new RNNetRequestCallBack() {
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
    public void getDeviceData(String args, Promise promise) {
        if (!TextUtils.isEmpty(args)) {
            try {
                JSONObject jsonObject = new JSONObject(args);
                jsonObject.put("region", AreaManager.getRegion());
                args = jsonObject.toString();
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        RNNetRequest.request(HISTORY, RNNetRequest.TYPE.POST, args, new RNNetRequestCallBack() {
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
    public void checkDeviceVersion(String did, String pid, Promise promise) {
        if (!TextUtils.isEmpty(did)) {
            JSONObject jsonObject = new JSONObject();
            try {
                jsonObject.put("did", did);
            } catch (JSONException e) {
                e.printStackTrace();
            }
            RNNetRequest.request(CHECK_FIRMWARE_VERSION, RNNetRequest.TYPE.POST, jsonObject.toString(), new RNNetRequestCallBack() {
                @Override
                public void onSuccess(String response) {
                    promise.resolve(response);
                }

                @Override
                public void onError(int code, String error) {
                    promise.reject(String.valueOf(code), error);
                }
            });
        } else {
            promise.reject("-1", "did null");
        }
    }

    @ReactMethod
    public void firmwareUpdate(Promise promise) {
        if (RnLoaderCache.getCurrentDevice(getReactApplicationContext()) != null
                && !TextUtils.isEmpty(RnLoaderCache.getCurrentDevice(getReactApplicationContext()).getDid())) {
            JSONObject jsonObject = new JSONObject();
            try {
                jsonObject.put("did", RnLoaderCache.getCurrentDevice(getReactApplicationContext()).getDid());
            } catch (JSONException e) {
                e.printStackTrace();
            }
            RNNetRequest.request(FIRMWARE_UPDATE, RNNetRequest.TYPE.POST, jsonObject.toString(), new RNNetRequestCallBack() {
                @Override
                public void onSuccess(String response) {
                    promise.resolve(response);
                }

                @Override
                public void onError(int code, String error) {
                    promise.reject(String.valueOf(code), error);
                }
            });
        } else {
            promise.reject("-1", "did null");
        }
    }

    @ReactMethod
    public void batchGetDeviceDatas(String args, Promise promise) {
        RNNetRequest.request(GET_DEVICE_DATA, RNNetRequest.TYPE.POST, args, new RNNetRequestCallBack() {
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
    public void batchSetDeviceDatas(String args, Promise promise) {
        RNNetRequest.request(SET_DEVICE_DATA, RNNetRequest.TYPE.POST, args, new RNNetRequestCallBack() {
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
    public void postJson(String url, String args, Promise promise) {
        RNNetRequest.request(url, RNNetRequest.TYPE.POST, args, new RNNetRequestCallBack() {
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
    public void getJson(String url, String args, Promise promise) {
        RNNetRequest.request(url, RNNetRequest.TYPE.GET, args, new RNNetRequestCallBack() {
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
    public void request(String url, String args, String type, Promise promise) {
        RNNetRequest.TYPE t = RNNetRequest.TYPE.GET;
        if (type.equals("get")) {
            t = RNNetRequest.TYPE.GET;
        } else if (type.equals("post")) {
            t = RNNetRequest.TYPE.POST;
        } else if (type.equals("put")) {
            t = RNNetRequest.TYPE.PUT;
        }
        RNNetRequest.request(url, t, args, new RNNetRequestCallBack() {
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

    /**
     * requestV2
     *
     * @param method
     * @param url
     * @param params
     * @param headers
     * @param promise
     */
    @ReactMethod
    public void requestV2(String method, String url, String params, String headers, Promise promise) {
        RNNetRequest.TYPE t = RNNetRequest.TYPE.GET;
        switch (method) {
            case "get":
                t = RNNetRequest.TYPE.GET;
                break;
            case "post":
                t = RNNetRequest.TYPE.POST;
                break;
            case "put":
                t = RNNetRequest.TYPE.PUT;
                break;
            case "delete":
                t = RNNetRequest.TYPE.DELETE;
                break;
        }
        RNNetRequest.request(url, t, params, headers, new RNNetRequestCallBack() {
            @Override
            public void onSuccess(String responseStr, Response response) {
                Map<String, Object> objectMap = new HashMap<>();
                objectMap.put("data", GsonUtils.parseMaps(responseStr));
                objectMap.put("responseHeader", response.headers().toMultimap());
                promise.resolve(objectMap);
            }

            @Override
            public void onError(int code, String error) {
                promise.reject(String.valueOf(code), error);
            }
        });
    }


    @ReactMethod
    public void fetch(String channelId, String method, String url, String params, String headers, boolean chunked) {
        RNNetRequest.TYPE t = RNNetRequest.TYPE.GET;
        switch (method) {
            case "get":
                break;
            case "post":
                t = RNNetRequest.TYPE.POST;
                break;
            case "put":
                t = RNNetRequest.TYPE.PUT;
                break;
            case "delete":
                t = RNNetRequest.TYPE.DELETE;
                break;
        }
        RNNetRequest.request(url, t, params, headers, new RNNetRequestCallBack() {
            @Override
            public void onResponse(Call call, Response response) throws IOException {
                Headers headers = response.headers();
//                String contentLength = headers.get("Content-Length");
//                String transferEncoding = headers.get("Transfer-Encoding");
                WritableMap writableMap = new WritableNativeMap();
                writableMap.putString("responseHeader", response.headers().toString());
                writableMap.putBoolean("success", true);
                ResponseBody body = response.body();
                if (response.code() < 200 || response.code() >= 300) {
                    writableMap.putBoolean("success", false);
                    writableMap.putString("error", "response code error");
                    writableMap.putInt("errorCode", response.code());
                    getReactApplicationContext()
                            .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(channelId, writableMap);
                    return;
                }
                if (Objects.requireNonNull(headers.get("content-type")).contains("application/json")) {
                    writableMap.putBoolean("stream", false);
                    writableMap.putString("byte", body != null ? Base64.encodeToString(body.bytes(), Base64.NO_WRAP) : "");
                    writableMap.putBoolean("end", true);
                    getReactApplicationContext()
                            .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(channelId, writableMap);
                } else if (Objects.requireNonNull(headers.get("content-type")).contains("text/html; charset=utf-8")) {
                    writableMap.putBoolean("stream", false);
                    writableMap.putString("byte", body != null ? Base64.encodeToString(body.bytes(), Base64.NO_WRAP) : "");
                    writableMap.putBoolean("end", true);
                    getReactApplicationContext()
                            .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(channelId, writableMap);
                } else if (Objects.requireNonNull(headers.get("content-type")).contains("application/octet-stream")) {
                    writableMap.putBoolean("stream", true);
                    writableMap.putBoolean("end", false);
                    if (body != null) {
                        if (chunked) {
                            try (InputStream inputStream = body.byteStream()) {
                                byte[] buffer = new byte[2048];
                                int bytesRead;
                                while ((bytesRead = inputStream.read(buffer)) != -1) {
                                    writableMap.putBoolean("end", false);
                                    writableMap.putString("byte", Base64.encodeToString(buffer, Base64.NO_WRAP));
                                    getReactApplicationContext()
                                            .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                                            .emit(channelId, writableMap);
                                }
                                writableMap.putBoolean("end", true);
                                getReactApplicationContext()
                                        .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                                        .emit(channelId, writableMap);
                            } catch (Exception err) {
                                writableMap.putBoolean("end", true);
                                writableMap.putString("error", err.getMessage());
                                getReactApplicationContext()
                                        .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                                        .emit(channelId, writableMap);
                            }
                        } else {
                            writableMap.putBoolean("end", true);
                            writableMap.putString("byte", Base64.encodeToString(body.bytes(), Base64.NO_WRAP));
                            getReactApplicationContext()
                                    .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                                    .emit(channelId, writableMap);
                        }
                    } else {
                        writableMap.putBoolean("end", true);
                        writableMap.putString("msg", "body is null");
                        getReactApplicationContext()
                                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                                .emit(channelId, writableMap);
                    }
                } else {
                    // 其他类型Header
                    writableMap.putBoolean("stream", false);
                    writableMap.putString("byte", body != null ? Base64.encodeToString(body.bytes(), Base64.NO_WRAP) : "");
                    writableMap.putBoolean("end", true);
                    getReactApplicationContext()
                            .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(channelId, writableMap);
                }
            }

            @Override
            public void onError(int code, String error) {
                WritableMap writableMap = new WritableNativeMap();
                writableMap.putBoolean("success", false);
                writableMap.putString("error", error);
                getReactApplicationContext()
                        .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                        .emit(channelId, writableMap);
            }
        });
    }

    @ReactMethod
    public void reportLog(ReadableMap params, String log) {
        String TAG = "Plugin";
        try {
            String did = params.getString("did");
            String uid = params.getString("uid");
            String version = params.getString("version");
            String model = params.getString("model");
            TAG = model + "_" + version + "_" + did + "_" + uid;
        } catch (Exception e) {
            e.printStackTrace();
        }
        LogUtil.i(TAG, log);
    }

    @ReactMethod
    public void reportEvent(String eventName, String params) {
        String did = "";
        String model = "";
        int pluginRealVersion = 0;
        DeviceListBean.Device currentDevice = RnLoaderCache.getCurrentDevice(getReactApplicationContext());
        if (currentDevice != null) {
            did = currentDevice.getDid();
            model = currentDevice.getModel();
            BasicRNHost basicRNHost = RnLoaderCache.getReactNativeHost(currentDevice.getDid());
            if (basicRNHost != null) {
                String pluginVersion = basicRNHost.getInUsePluginVersion();
                try {
                    pluginRealVersion = Integer.parseInt(pluginVersion);
                } catch (Exception e) {
                    Log.e(getName(), "eventReport: " + e.getMessage());
                }
            }
        }
        EventCommonHelper.INSTANCE.eventCommonPageInsert(ModuleCode.PluginEvent.getCode(), PluginEventEventCode.Custom.getCode(),
                0, pluginRealVersion, did, model,
                0, 0, 0, 0, 0,
                eventName, "", "", params);
    }

    @ReactMethod
    public void eventReport(int modelCode, int eventCode, int int1, int int2, int int3,
                            int int4, int int5, String str1, String str2, String str3, String rawStr) {
        String did = "";
        String model = "";
        int pluginRealVersion = 0;
        DeviceListBean.Device currentDevice = RnLoaderCache.getCurrentDevice(getReactApplicationContext());
        if (currentDevice != null) {
            did = currentDevice.getDid();
            model = currentDevice.getModel();
            BasicRNHost basicRNHost = RnLoaderCache.getReactNativeHost(currentDevice.getDid());
            if (basicRNHost != null) {
                String pluginVersion = basicRNHost.getInUsePluginVersion();
                try {
                    pluginRealVersion = Integer.parseInt(pluginVersion);
                } catch (Exception e) {
                    Log.e(getName(), "eventReport: " + e.getMessage());
                }
            }
        }
        EventCommonHelper.INSTANCE.eventCommonPageInsert(modelCode, eventCode,
                0, pluginRealVersion, did, model,
                int1, int2, int3, int4, int5,
                str1, str2, str3, rawStr);
    }

    @ReactMethod
    public void eventReportV3(int modelCode, int eventCode, int offset, int pageId, int int1,
                              int int2, int int3, int int4, int int5, String str1, String str2, String str3, String rawStr) {
        String did = "";
        String model = "";
        int pluginRealVersion = 0;
        DeviceListBean.Device currentDevice = RnLoaderCache.getCurrentDevice(getReactApplicationContext());
        if (currentDevice != null) {
            did = currentDevice.getDid();
            model = currentDevice.getModel();
            BasicRNHost basicRNHost = RnLoaderCache.getReactNativeHost(currentDevice.getDid());
            if (basicRNHost != null) {
                String pluginVersion = basicRNHost.getInUsePluginVersion();
                try {
                    pluginRealVersion = Integer.parseInt(pluginVersion);
                } catch (Exception e) {
                    Log.e(getName(), "eventReport: " + e.getMessage());
                }
            }
        }
        EventCommonHelper.INSTANCE.eventCommonPageInsert(modelCode, eventCode,
                offset, pageId, pluginRealVersion, did, model,
                int1, int2, int3, int4, int5,
                str1, str2, str3, rawStr);
    }


    @ReactMethod
    public void test(Callback callback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                for (int i = 0; i < 5; i++) {
                    try {
                        Thread.sleep(1000); // 模拟耗时操作
                        callback.invoke("事件 " + i + " 处理完成");
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
            }
        }).start();
    }

}
