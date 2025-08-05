package android.dreame.module.rn.bridge.video;

import android.dreame.module.manager.AccountManager;
import android.dreame.module.rn.net.RNNetRequest;
import android.dreame.module.rn.net.RNNetRequestCallBack;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;


import org.json.JSONException;
import org.json.JSONObject;

import okhttp3.FormBody;

public class AgoraModule extends ReactContextBaseJavaModule {
    private final String RTC = "/dreame-user-iot/token/rtc";
    private final String RTM = "/dreame-user-iot/token/rtm";

    public AgoraModule(@NonNull ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @NonNull
    @Override
    public String getName() {
        return "Agora";
    }

    /**
     * 获取音视频token
     *
     * @param expires
     * @param promise
     */
    @ReactMethod
    public void getRTCToken(String channel, int expires, Promise promise) {
        FormBody.Builder formBody = new FormBody.Builder();
        formBody.add("channel", channel);
        formBody.add("expires", String.valueOf(expires));
        RNNetRequest.request(RTC, formBody.build(), new RNNetRequestCallBack() {
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
     * 获取音频token
     *
     * @param uid
     * @param expires
     * @param promise
     */
    @ReactMethod
    public void getRTMToken(int uid, int expires, Promise promise) {
        JSONObject params = null;
        try {
            params = new JSONObject();
            params.put("uid", AccountManager.getInstance().getAccount().getUid());
            params.put("expires", expires);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        RNNetRequest.request(RTM, RNNetRequest.TYPE.POST, params.toString(), new RNNetRequestCallBack() {
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

    private String strToUid(String str) {
        char[] chars = str.toCharArray();
        StringBuilder stringBuilder = new StringBuilder();
        for (int i = 0; i < chars.length; i++) {
            stringBuilder.append((chars[i] - '0'));
        }
        String result = stringBuilder.toString();
        return result.length() > 9 ? result.substring(0, 8) : result;
    }
}
